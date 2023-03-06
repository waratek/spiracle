<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>

  <jsp:include page="header.jsp" >
    <jsp:param name="pageName" value="Network" />
  </jsp:include>

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
            Hostname <input type="text" name="remoteHost"> Port
            <input type="text" name="remotePort">
            <input type="submit" value=Submit>
              
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
            Url: <input type="text" name="urlPath"> <br>
            ConnectionType (DB only): <input type="text" name="connectionType"><br>
            Path Source: <br>
            &nbsp;&nbsp; <input type="radio" name="urlSource" value="http" checked> HTTP<br>
            &nbsp;&nbsp; <input type="radio" name="urlSource" value="deserialJava"> Deserialization(Java)<br>
            &nbsp;&nbsp; <input type="radio" name="urlSource" value="deserialXml"> Deserialization(XML)<br>
            &nbsp;&nbsp; <input type="radio" name="urlSource" value="database"> Database<br>
            <input type="submit" value=Submit>
          </form>
        </div>
        <div class="panel-footer">
          <pre><textarea readonly id="network_output"><%=urlData%></textarea></pre>
        </div>
      </div>
    </div>

    <%@ include file="footer.jsp" %>
