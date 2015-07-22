<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<!DOCTYPE html>
<html>
  <head>
    <meta http-equiv="Content-Type" content="text/html; charset=UTF-8">
    <link rel="stylesheet" type="text/css" href="css/bootstrap.min.css">
    <link rel="stylesheet" type="text/css" href="css/bootstrap-theme.min.css">
    <link rel="stylesheet" type="text/css" href="css/style.css">
    <title>Spiracle - Network</title>
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
          <li class="active"><a href="network.jsp">Network</a></li>
          <li><a href="sql.jsp">SQL</a></li>
          <li><a href="misc.jsp">Misc</a></li>
          </ul>
        </div>
      </div>
    </div>

    <div class="container">
      <h1>Network</h1>

      <div class="panel panel-default">
        <div class="panel-heading">Socket</div>
        <div class="panel-body">
          <form action="SocketServlet" method="post">
            <%
              String socketInfo = (String) session.getAttribute("socketInfo");
              if (socketInfo == null) {
                socketInfo = "";
              }
            %>
            <p>
              <i>Local Binding Address</i>
            </p>
            Hostname <input type="text" name="bindHost"> Port <input
              type="text" name="bindPort">
            <p>
              <i>Remote Address</i>
            </p>
            Hostname <input type="text" name="remoteHost"> Port <input
              type="text" name="remotePort"> <input type="submit"
              value=Submit>
          </form>
        </div>
        <div class="panel-footer">
          Connection Info:
          <%=socketInfo%></div>
      </div>
      <div class="panel panel-default">
        <div class="panel-heading">Server Socket</div>
        <div class="panel-body">
          <%
            String serverSocketInfo = (String) session
                .getAttribute("serverSocketInfo");
            if (serverSocketInfo == null) {
              serverSocketInfo = "";
            }
          %>
          <h2>Server Socket</h2>
          <form action="ServerSocketServlet" method="post">
            Hostname <input type="text" name="hostname"> Port <input
              type="text" name="port"> <input type="submit" value=Submit>
          </form>
        </div>
        <div class="panel-footer">
          Connection Info:
          <%=serverSocketInfo%></div>
      </div>
      <div class="panel panel-default">
        <div class="panel-heading">URL</div>
        <div class="panel-body">
          <%
            String urlData = (String) session.getAttribute("urlContents");
            if (urlData == null) {
              urlData = "";
            }
          %>
          <form action="UrlServlet" method="post">
            Url: <input type="text" name="urlPath"> <input
              type="submit" value=Submit>
          </form>
        </div>
        <div class="panel-footer">
          <pre><textarea readonly id="network_output"><%=urlData%></textarea></pre>
        </div>
      </div>
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
