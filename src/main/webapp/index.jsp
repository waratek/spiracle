<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<!DOCTYPE html>
<html>
  <head>
    <meta http-equiv="Content-Type" content="text/html; charset=UTF-8">
    <link rel="stylesheet" type="text/css" href="css/bootstrap.min.css">
    <link rel="stylesheet" type="text/css" href="css/bootstrap-theme.min.css">
    <link rel="stylesheet" type="text/css" href="css/style.css">
    <title>Spiracle</title>
  </head>

  <body>
    <div class="navbar navbar-default navbar-fixed-top" role="navigation">
      <div class="container">
        <div class="navbar-header">
          <button type="button" class="navbar-toggle collapsed" data-toggle="collapse" data-target=".navbar-collapse">
          <span class="sr-only">Toggle navigation</span>
          <span class="icon-bar"></span>
          <span class="icon-bar"></span>
          <span class="icon-bar"></span>
          </button>
          <a class="navbar-brand" href="index.jsp">Spiracle</a>
        </div>
        <div class="navbar-collapse collapse">
          <ul class="nav navbar-nav">
          <li class="active"><a href="index.jsp">Overview</a></li>
          <li><a href="file.jsp">File</a></li>
          <li><a href="network.jsp">Network</a></li>
          <li><a href="sql.jsp">SQL</a></li>
          <li><a href="xss.jsp">XSS</a></li>
          <li><a href="csrf.jsp">CSRF</a></li>
          <li><a href="pathTraversal.jsp">Path Traversal</a></li>
          <li><a href="misc.jsp">Misc</a></li>
          </ul>
        </div>
      </div>
    </div>

    <div class="container">
      <h1>Overview</h1>
        <p class="lead">Spiracle is an insecure web application used to test system security controls.</p>
        <p>It can be used to read/write arbitrary files and open network connections. The application is also vulnerable to SQL Injection.</p>
        <p>Due to its insecure design, this application should NOT be deployed on an unsecured network.</p>
    </div>

    <footer class="footer">
      <div class="container">
        <ul class="list-inline">
          <li><a href="./LICENSE.html">License</a></li>
          <li>&middot;</li>
          <li><a href="https://github.com/waratek/spiracle">GitHub</a></li>
          <li>&middot;</li>
          <li><a href="https://github.com/waratek/spiracle/releases">Releases</a></li>
        </ul>
      </div>
    </footer>

    <!-- Bootstrap core JavaScript
    ================================================== -->
    <!-- Placed at the end of the document so the pages load faster -->
    <script src="js/jquery.min.js"></script>
    <script src="js/bootstrap.min.js"></script>
  </body>
</html>
