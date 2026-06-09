# xss.hurl — reflected XSS demonstration (unprotected).
#
# Source: src/main/webapp/customTag.jsp
# The JSP reads request.getParameter("name") and passes it to HelloUserTag,
# which writes:  Hello Spiracle user: <b>NAME</b>!
# No escaping is applied, so a script payload in "name" is reflected verbatim.
#
# Note: the ReadHTML-based XSS servlets (XSSWebAppHSRPW, XSSWebAppSRPW etc.)
# do NOT reflect the param because xss.html contains no literal "XSS" token
# to substitute — they are not reflection endpoints.
# customTag.jsp is the cleanest GET-accessible reflected-XSS endpoint.

# ── 1. Benign name: confirm normal reflection ────────────────────────
GET http://{{host}}:{{port}}/spiracle/customTag.jsp?name=Alice

HTTP 200
[Asserts]
body contains "Hello Spiracle user"
body contains "Alice"

# ── 2. XSS payload reflected unescaped ──────────────────────────────
# %3Cscript%3Ealert%281%29%3C%2Fscript%3E = <script>alert(1)</script>
# Without sanitisation the raw tag appears in the HTML body.
GET http://{{host}}:{{port}}/spiracle/customTag.jsp?name=%3Cscript%3Ealert%281%29%3C%2Fscript%3E

HTTP 200
[Asserts]
body contains "<script>alert(1)</script>"
