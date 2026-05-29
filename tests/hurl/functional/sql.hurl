# sql.hurl — functional SQL tests against the unprotected MySQL stack.
#
# Sources:
#   MySql_Get_int    → @WebServlet("/MySql_Get_int")    param: id
#   MySql_Get_string → @WebServlet("/MySql_Get_string") param: name
#   MySql_Get_Implicit_Join → @WebServlet("/MySql_Get_Implicit_Join") param: id
#   MySql_Get_Union  → @WebServlet("/MySql_Get_Union")  param: id
#
# Seed data (setupdb_mysql.sql):
#   id=1  → Patrick Moss
#   id=2  → Margaret Thomas
#   address id=1 → 2128 Vestibulum, St. / Dubuisson / San Marino

# ── 1. MySql_Get_int benign: id=1 returns Patrick Moss ───────────────
GET http://{{host}}:{{port}}/spiracle/MySql_Get_int?id=1

HTTP 200
[Asserts]
body contains "Patrick"
body contains "Moss"

# ── 2. MySql_Get_string benign: name=Patrick returns surname Moss ────
GET http://{{host}}:{{port}}/spiracle/MySql_Get_string?name=Patrick

HTTP 200
[Asserts]
body contains "Moss"

# ── 3. MySql_Get_Implicit_Join benign: id=1 returns row + address ────
# Query: SELECT * FROM users, address WHERE users.id = 1 AND users.id = address.id
# Proves the join works for a known row.
GET http://{{host}}:{{port}}/spiracle/MySql_Get_Implicit_Join?id=1

HTTP 200
[Asserts]
body contains "Patrick"
body contains "Dubuisson"

# ── 4. Unprotected SQL injection on MySql_Get_Implicit_Join ──────────
# Payload: id=1 OR 1=1
# Query becomes: SELECT * FROM users, address WHERE users.id = 1 OR 1=1 AND users.id = address.id
# Without the Waratek RASP agent this executes and returns ALL users.
# id=1 only returns Patrick Moss; injection adds Margaret Thomas (id=2).
# Asserting both surnames proves injection executed and widened the result.
GET http://{{host}}:{{port}}/spiracle/MySql_Get_Implicit_Join?id=1%20OR%201%3D1

HTTP 200
[Asserts]
body contains "Moss"
body contains "Thomas"

# ── 5. MySql_Get_Union benign: id=1 returns user + address rows ──────
# Query: SELECT name,surname,dob FROM users ... UNION SELECT address_1,address_2,address_3 FROM address ...
# Both result sets for id=1 are returned.
GET http://{{host}}:{{port}}/spiracle/MySql_Get_Union?id=1

HTTP 200
[Asserts]
body contains "Moss"
body contains "Dubuisson"
