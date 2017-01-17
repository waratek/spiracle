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
    <%@ include file="header.jsp" %>

    <div class="container">
      <h1>Overview</h1>
        <p class="lead">Spiracle is an insecure web application used to test system security controls.</p>
        <p>It can be used to read/write arbitrary files and open network connections. The application is also vulnerable to SQL Injection.</p>
        <p>Due to its insecure design, this application should NOT be deployed on an unsecured network.</p>
    </div>

    <%@ include file="footer.jsp" %>

    <!-- Bootstrap core JavaScript
    ================================================== -->
    <!-- Placed at the end of the document so the pages load faster -->
    <script src="js/jquery.min.js"></script>
    <script src="js/bootstrap.min.js"></script>
  </body>
</html>
