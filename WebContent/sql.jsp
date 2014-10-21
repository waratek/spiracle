<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<!DOCTYPE html>
<html>
  <head>
    <meta http-equiv="Content-Type" content="text/html; charset=UTF-8">
    <link rel="stylesheet" type="text/css" href="css/bootstrap.min.css">
    <link rel="stylesheet" type="text/css" href="css/bootstrap-theme.min.css">
    <link rel="stylesheet" type="text/css" href="css/style.css">
    <title>Spiracle - SQL</title>
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
          <li><a href="index.jsp">Overview</a></li>
          <li><a href="file.jsp">File</a></li>
          <li><a href="network.jsp">Network</a></li>
          <li class="active"><a href="sql.jsp">SQL</a></li>
          </ul>
        </div>
      </div>
    </div>

    <div class="container">
      <h1>SQL Injection</h1>

      <div class="panel panel-default">
        <div class="panel-heading">
          <a class="btn btn-primary" role="button" href="CreateC3p0Connection">Initalize
            C3P0 Connection Pool</a>
        </div>
        <div class="panel-body">
          <form action=CreateC3p0Connection method="post">
            Connection String: <input type="text" name="connectionUrl"><br>
            Username: <input type="text" name="username"><br>
            Password: <input type="password" name="password"><br>
            <input type="submit" value=Submit>
          </form>
        </div>
        <%
          String connectionData = (String) application
              .getAttribute("connectionData");
          String errorMessage = (String) session.getAttribute("error");
          if (connectionData == null) {
            connectionData = "";
          }
          if (errorMessage == null) {
            errorMessage = "";
          }
        %>
        <div class="panel-footer">
          Connection Information
          <pre><%=connectionData%></pre>
        </div>
        <div class="panel-footer">
          Error
          <pre><%=errorMessage%></pre>
        </div>
      </div>
      <div class="panel panel-default">
        <div class="panel-heading">Injectable URLS</div>
        <div class="panel-body">
          <ul class="list-group">
            <script type="text/javascript">
              $(function() {
                $("[rel='tooltip']").tooltip();
              });
            </script>
            <li rel='tooltip' data-toggle="tooltip"
              title="SELECT * FROM users WHERE id = ' ? '"
              class="list-group-item"><a href="Get_int?id=1">Get_int?id=1</a></li>
            <li rel='tooltip' data-toggle="tooltip"
              title="SELECT * FROM users WHERE id = ?" class="list-group-item"><a
              href="Get_int_no_quote?id=1">Get_int_no_quote?id=1</a></li>
            <li rel='tooltip' data-toggle="tooltip"
              title="SELECT * FROM users ORDER BY ' ? '" class="list-group-item"><a
              href="Get_int_orderby?id=name">Get_int_orderby?id=name</a></li>
            <li rel='tooltip' data-toggle="tooltip"
              title="SELECT count(name), name FROM users GROUP BY ?" class="list-group-item"><a
              href="Get_int_groupby?id=name">Get_int_groupby?id=name</a></li>
            <li rel='tooltip' data-toggle="tooltip"
              title="SELECT * FROM users WHERE id = ' ? '"
              class="list-group-item"><a href="Get_int_partialunion?id=1">Get_int_partialunion?id=1</a></li>
            <li rel='tooltip' data-toggle="tooltip"
              title="SELECT * FROM users WHERE id = ' ? '"
              class="list-group-item"><a href="Get_int_nooutput?id=1">Get_int_nooutput?id=1</a></li>
            <li rel='tooltip' data-toggle="tooltip"
              title="SELECT MIN(name) from users GROUP BY id HAVING id = ?"
              class="list-group-item"><a href="Get_int_having?id=1">Get_int_having?id=1</a></li>
            <li rel='tooltip' data-toggle="tooltip"
              title="?"
              class="list-group-item"><a href="Get_int_inline?id=SELECT%20*%20FROM%20users">Get_int_inline?id=SELECT * FROM users</a></li>
            <li rel='tooltip' data-toggle="tooltip"
              title="SELECT * FROM users WHERE name = ' ? '"
              class="list-group-item"><a href="Get_string?name=wu">Get_string?name=wu</a></li>
            <li rel='tooltip' data-toggle="tooltip"
              title="SELECT * FROM users WHERE name = ?"
              class="list-group-item"><a href="Get_string_no_quote?name='wu'">Get_string_no_quote?name='wu'</a></li>
            <li rel='tooltip' data-toggle="tooltip"
              title="UPDATE users SET name = '?', surname = '?' WHERE id = ?"
              class="list-group-item"><a href="Update_User?id=1&amp;name=Joe&amp;surname=Soap">Update_User?id=1&amp;name=Joe&amp;surname=Soap</a></li>
            <li rel='tooltip' data-toggle="tooltip"
              title="DELETE FROM users WHERE id = ? OR name = '?'"
              class="list-group-item"><a href="Delete_User?id=1&amp;name=Joe">Delete_User?id=1&amp;name=Joe</a></li>
            <li rel='tooltip' data-toggle="tooltip"
              title="INSERT INTO users VALUES (?, '?', '?', '?', '?', '?')"
              class="list-group-item"><a href="Insert_User?id=101&amp;name=Joe&amp;surname=Soap&amp;dob=01-Jan-1970&amp;credit_card=1111-1111-1111-1111&amp;cvv=999">Insert_User?id=101&amp;name=Joe&amp;surname=Soap&amp;dob=01-Jan-1970&amp;credit_card=1111-1111-1111-1111&amp;cvv=999</a></li>
            <li rel='tooltip' data-toggle="tooltip"
              title="SELECT * FROM users, address WHERE users.id = ? AND users.id = address.id"
              class="list-group-item"><a href="Get_Implicit_Join?id=1">Get_Implicit_Join?id=1</a></li>
            <li rel='tooltip' data-toggle="tooltip"
              title="SELECT * FROM users FULL OUTER JOIN address ON users.id = address.id AND users.id = ?"
              class="list-group-item"><a href="Get_Full_Outer_Join?id=1">Get_Full_Outer_Join?id=1</a></li>
            <li rel='tooltip' data-toggle="tooltip"
              title="SELECT name, surname, TO_CHAR(dob) FROM users WHERE id = ? UNION SELECT address_1, address_2, address_3 FROM address WHERE id = ?"
              class="list-group-item"><a href="Get_Union?id=1">Get_Union?id=1</a></li>
          </ul>
        </div>
      </div>
    </div>
    <!-- Bootstrap core JavaScript
    ================================================== -->
    <!-- Placed at the end of the document so the pages load faster -->
    <script src="js/jquery.min.js"></script>
    <script src="js/bootstrap.min.js"></script>
  </body>
</html>
