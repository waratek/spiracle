# Spiracle smoke suite.
#
# Purpose: prove the app is up, DB round-trips work, and that SQLi is
# not blocked: Tomcat returns 200 for valid SQL injections and 500 for
# malformed ones.

# ── 1. App root is reachable ─────────────────────────────────────────
GET http://{{host}}:{{port}}/spiracle/

HTTP 200

# ── 2. Benign query returns the expected row ─────────────────────────
# Patrick Moss is id=1, name='Patrick' in the seed data.
# MySql_Get_string queries by name and returns the surname.
GET http://{{host}}:{{port}}/spiracle/MySql_Get_string?name=Patrick

HTTP 200
[Asserts]
body contains "Moss"

# ── 3. SQL injection succeeds unprotected ───────────────────────────
# The injection is NOT blocked.
# The payload ' OR '1'='1 widens the WHERE clause to match all rows.
# Margaret Thomas (id=2) is NOT in the result set for name='Patrick',
# but WILL appear when the injection succeeds.  Asserting her surname
# proves more rows were returned than the benign query would give.
GET http://{{host}}:{{port}}/spiracle/MySql_Get_string?name=Patrick'%20OR%20'1'='1

HTTP 200
[Asserts]
body contains "Thomas"
