# Spiracle Hurl Test Harness

Language-agnostic HTTP tests using [Hurl](https://hurl.dev) (v5+).
Replaces the old `tests/spiracle_sqli_test.py` (Python 2, bespoke `<split>` format).

---

## The critical semantic: 550 requires the Waratek RASP agent

The number `550` is **not** a standard HTTP status code.
`SelectUtil.verifySQLException` emits it **only** when the SQLException
message is exactly `"Attempted to execute a query with one or more bad
parameters."` — that string is produced by the **Waratek RASP agent**
intercepting the query before it reaches the database.

**Without the Waratek agent** (e.g. plain Tomcat, CI Docker stack):

| Payload type             | Status code |
|--------------------------|-------------|
| Valid-SQL injection       | **200**     |
| Malformed/syntax error   | **500**     |
| Agent-blocked injection  | **550**     |

You will **never** see 550 on a plain deployment.
The RASP suite will fail entirely without the agent — this is expected.

---

## Suite layout

```
tests/hurl/
├── generate.py            # Generator: mysql.txt + oracle.txt → .hurl files
├── run.sh                 # Runner wrapper
├── rasp/                  # RASP-efficacy suite (needs Waratek agent)
│   ├── protected.env      # Variables: host, port, block_status=550
│   ├── mysql/             # MySQL servlet tests (139 cases, 5 files)
│   │   ├── get_int.hurl
│   │   ├── get_string.hurl
│   │   ├── get_union.hurl
│   │   ├── get_implicit_join.hurl
│   │   └── implicit_join_namespace.hurl
│   └── oracle/            # Oracle servlet tests (301 cases, 12 files)
│       ├── get_int.hurl
│       ├── get_string.hurl
│       └── ...
└── smoke/                 # Functional smoke suite (no agent required)
    ├── local.env          # Variables: host=localhost, port=8080
    └── smoke.hurl         # 3 tests: up-check, benign query, SQLi succeeds
```

Source of truth for the RASP payload matrices:
- `tests/mysql.txt` (139 cases)
- `tests/oracle.txt` (301 cases)

---

## Running the smoke suite (plain Docker / CI)

The smoke suite validates:
1. App root responds `200`
2. `GET /spiracle/MySql_Get_string?name=Patrick` → `200`, body contains `Moss`
3. SQLi payload widens the result set (body contains `Thomas`) → `200`
   (documenting that injections are NOT blocked without the agent)

```sh
# Start the Docker MySQL stack (requires docker-compose from feat/docker branch)
docker-compose up -d

# Run smoke tests
./tests/hurl/run.sh smoke localhost 8080

# Or with hurl directly
hurl --test --variables-file tests/hurl/smoke/local.env \
     tests/hurl/smoke/smoke.hurl
```

---

## Running the RASP suite (Waratek agent required)

```sh
# With agent attached to Tomcat:
./tests/hurl/run.sh rasp localhost 8080

# Override host/port:
./tests/hurl/run.sh rasp myserver.internal 9090

# Override expected block status (if agent uses a different code):
BLOCK_STATUS=403 ./tests/hurl/run.sh rasp localhost 8080

# Run a single servlet's cases:
hurl --test \
     --variables-file tests/hurl/rasp/protected.env \
     tests/hurl/rasp/mysql/get_int.hurl
```

Reports are written as JUnit XML to `/tmp/spiracle-{smoke,rasp}-report/junit.xml`.
Override with `REPORT_DIR=/path/to/dir ./tests/hurl/run.sh ...`.

---

## Regenerating the .hurl files

If `mysql.txt` or `oracle.txt` are updated, regenerate:

```sh
python3 tests/hurl/generate.py
```

The generator:
- Reads `tests/mysql.txt` and `tests/oracle.txt` (one case per line, `<split>` delimiter)
- Groups cases by servlet path
- Encodes URL-illegal characters (`space`, `|`, `"`, `<`, `>`) in query strings
- Emits `status == {{block_status}}` for 550-expected cases (variable-driven)
- Emits `status == 200` (literal) for the one benign probe case in mysql.txt
- Overwrites all files under `tests/hurl/rasp/`

Commit the regenerated files — the suite must run without needing to regenerate.

---

## Hurl assertion form used

`HTTP {{var}}` in the status line is **not** valid in Hurl 5.x.
All files use the `[Asserts]` form:

```
HTTP *
[Asserts]
status == {{block_status}}
```

This was verified against Hurl 5.0.1 before committing.
