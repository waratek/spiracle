# redirect.hurl — regression tests for SendRedirect behaviour.
#
# Source: src/main/java/com/waratek/spiracle/misc/SendRedirect.java
# @WebServlet("/SendRedirect")
#
# Regression for #8: when redirectMeTo param is absent the servlet must
# respond 200 with Content-Type: text/plain and explain the missing param.
# If the fix is reverted the Content-Type header will be missing/wrong.

# ── 1. No param → 200 plain text with usage hint ─────────────────────
GET http://{{host}}:{{port}}/spiracle/SendRedirect

HTTP 200
[Asserts]
header "Content-Type" contains "text/plain"
body contains "redirectMeTo"

# ── 2. Valid param → 302 redirect to supplied URL ────────────────────
# Hurl does NOT follow redirects by default; the 302 is directly observable.
GET http://{{host}}:{{port}}/spiracle/SendRedirect?redirectMeTo=https://example.com

HTTP 302
[Asserts]
header "Location" contains "example.com"
