<%
if ( request.getRemoteUser() != null )
{
            response.sendRedirect(request.getContextPath() 
                    + "/index.jsp");
}
%>
<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%
String username = request.getRemoteUser();
%>
<!DOCTYPE html>
<html>
  <head>
    <meta http-equiv="Content-Type" content="text/html; charset=UTF-8">
    <link rel="stylesheet" type="text/css" href="css/bootstrap.min.css">
    <link rel="stylesheet" type="text/css" href="css/bootstrap-theme.min.css">
    <link rel="stylesheet" type="text/css" href="css/style.css">
    <title>Spiracle Login Page</title>
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
          <li class="active"><a href="#">Login</a></li>
          </ul>
        </div>
      </div>
    </div>
   
    <div class="container">
      <h1>Login</h1>
            <form action='j_security_check' method='post'>
            <table>
             <tr>
               <td>Name:</td>
               <td><input type='text' name='j_username' size='15'></td>
             </tr>
             <tr>
               <td>Password:</td> 
               <td><input type='password' name='j_password' size='15'></td>
             </tr>
            </table>
            <br>
              <input type='submit' value='Login'> 
            </form>
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