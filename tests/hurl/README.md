# Spiracle Hurl Test Harness

Language-agnostic HTTP tests using [Hurl](https://hurl.dev) (v5+).
Replaces the old `tests/spiracle_sqli_test.py` (Python 2, bespoke `<split>` format).

---

## The 550 status requires the Waratek RASP agent

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

`tests/hurl/` holds three suites:

- `smoke/` and `functional/` — endpoint behaviour on a plain (no-agent) deployment.
- `rasp/` — the RASP-efficacy matrix under `mysql/` and `oracle/`; requires the Waratek agent.

---

## Running the functional suite (plain Docker / CI)

The functional suite validates endpoint behaviour without any RASP agent:

| File             | Requests | What it covers |
|------------------|----------|----------------|
| `redirect.hurl`  | 2        | SendRedirect: no-param→200+text/plain (#8 regression); param→302+Location |
| `sql.hurl`       | 5        | MySql_Get_int, MySql_Get_string, MySql_Get_Implicit_Join (benign + SQLi), MySql_Get_Union |
| `xss.hurl`       | 2        | customTag.jsp benign name; `<script>alert(1)</script>` reflected unescaped |
| `traversal.hurl` | 4        | FileInputStreamServlet01 benign TestFile; `../TestFile` traversal succeeds |
| `negative.hurl`  | 3        | 404 on unknown path; empty result set; no-param graceful 200 |

```sh
# Start the Docker MySQL stack
docker compose -f docker-compose.mysql.yml up -d

# Run functional tests
./tests/hurl/run.sh functional localhost 8080

# Or with hurl directly
hurl --test --variables-file tests/hurl/functional/local.env \
     tests/hurl/functional/*.hurl
```

**XSS note:** The ReadHTML-based servlets (`XSSWebAppHSRPW` etc.) do NOT reflect
the `taintedtext` param because `xss.html` contains no literal `"XSS"` token.
`customTag.jsp` is the GET-accessible reflected-XSS endpoint used here.

---

## Running the smoke suite (plain Docker / CI)

The smoke suite validates:
1. App root responds `200`
2. `GET /spiracle/MySql_Get_string?name=Patrick` → `200`, body contains `Moss`
3. SQLi payload widens the result set (body contains `Thomas`) → `200`
   (documenting that injections are NOT blocked without the agent)

```sh
# Start the Docker MySQL stack
docker compose -f docker-compose.mysql.yml up -d

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

## Hurl assertion form used

`HTTP {{var}}` in the status line is **not** valid in Hurl 5.x.
All files use the `[Asserts]` form:

```
HTTP *
[Asserts]
status == {{block_status}}
```

This was verified against Hurl 5.0.1 before committing.
