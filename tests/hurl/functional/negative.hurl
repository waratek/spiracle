# negative.hurl — boundary and error cases.
#
# These cases verify that the app responds deterministically to invalid
# or missing inputs, providing a stable baseline for regression.

# ── 1. Non-existent servlet path → 404 ───────────────────────────────
GET http://{{host}}:{{port}}/spiracle/NoSuchServletXYZ

HTTP 404

# ── 2. MySql_Get_string with unknown name → 200, empty results ───────
# No rows match name='NoSuchUser99'; the app still returns 200 with an
# empty result table (no error, no crash).
GET http://{{host}}:{{port}}/spiracle/MySql_Get_string?name=NoSuchUser99

HTTP 200
[Asserts]
body contains "Results"
# App echoes param in SQL query preview but no <TD> rows should appear
body not contains "<TD>NoSuchUser99</TD>"

# ── 3. MySql_Get_int with no param → 200, empty results ─────────────
# ParameterNullFix sanitises null to empty string; the SQL query
# WHERE id = '' returns zero rows — app handles gracefully.
GET http://{{host}}:{{port}}/spiracle/MySql_Get_int

HTTP 200
[Asserts]
body contains "Results"
