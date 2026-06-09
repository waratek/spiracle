# traversal.hurl — path traversal demonstration (unprotected).
#
# Source: src/main/java/com/waratek/spiracle/path_traversal/FileInputStreamServlet01.java
# @WebServlet("/FileInputStreamServlet01")   param: FileInputStream01
#
# The servlet constructs:
#   absolutePathToTestFile = <webroot>/pathTraversal/testFilesParent/testFilesChild/
#                            + File.separator + FileInputStream01
# No sanitisation is applied.  A "../" sequence traverses up one directory.
# The servlet stores "File input stream opened for file: '<path>'" in the
# session, then redirects to pathTraversal.jsp which renders it.
# Hurl follows the redirect automatically (session cookie carried).
#
# Known test files in the deployment:
#   testFilesChild/TestFile          (the intended target)
#   testFilesParent/TestFile         (one level up — requires traversal)

# ── 1. Benign: access known file in testFilesChild ───────────────────
GET http://{{host}}:{{port}}/spiracle/FileInputStreamServlet01?FileInputStream01=TestFile
[Options]
location: true

HTTP 200
[Asserts]
body contains "File input stream opened for file:"
body contains "testFilesChild"

# ── 2. Path traversal: ../TestFile escapes testFilesChild ────────────
# %2F = /  so ../TestFile URL-encodes to ..%2FTestFile
# The constructed path resolves to testFilesParent/TestFile.
# The traversal is NOT blocked and the stream opens.
GET http://{{host}}:{{port}}/spiracle/FileInputStreamServlet01?FileInputStream01=..%2FTestFile
[Options]
location: true

HTTP 200
[Asserts]
body contains "File input stream opened for file:"
body contains "testFilesParent"
