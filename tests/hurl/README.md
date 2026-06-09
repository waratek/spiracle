# Spiracle Hurl Test Harness

Language-agnostic HTTP tests using [Hurl](https://hurl.dev) (v5+).
Replaces the old `tests/spiracle_sqli_test.py` (Python 2, bespoke `<split>` format).

---

## Suite layout

`tests/hurl/` holds two suites:

- `smoke/` and `functional/` — endpoint behaviour on a plain deployment.

---

## Running the functional suite (plain Docker / CI)

The functional suite validates endpoint behaviour end-to-end:

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

```sh
# Start the Docker MySQL stack
docker compose -f docker-compose.mysql.yml up -d

# Run smoke tests
./tests/hurl/run.sh smoke localhost 8080

# Or with hurl directly
hurl --test --variables-file tests/hurl/smoke/local.env \
     tests/hurl/smoke/smoke.hurl
```

Reports are written as JUnit XML to `/tmp/spiracle-{smoke,functional}-report/junit.xml`.
Override with `REPORT_DIR=/path/to/dir ./tests/hurl/run.sh ...`.

---

## Hurl assertion form used

`HTTP {{var}}` in the status line is **not** valid in Hurl 5.x.
All files use the `[Asserts]` form:

```
HTTP *
[Asserts]
status == 200
```

This was verified against Hurl 5.0.1 before committing.
