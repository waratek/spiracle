<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<%@page import="java.util.Collections"%>
<%@page import="java.util.Enumeration"%>
<%@page import="java.util.ArrayList"%>
<%@page import="java.util.List"%>
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
                        <li><a href="index.jsp">Overview</a></li>
                        <li><a href="file.jsp">File</a></li>
                        <li><a href="network.jsp">Network</a></li>
                        <li><a href="sql.jsp">SQL</a></li>
                        <li class="active"><a href="xss.jsp">XSS</a></li>
                        <li><a href="misc.jsp">Misc</a></li>
                    </ul>
                </div>
            </div>
        </div>

        <div class="container">
            <%
                List<String> attrList = new ArrayList<String>();
                Enumeration<String> attrs = request.getParameterNames();
                for (String str : Collections.list(attrs)) {
                    String buf = (String) request.getParameter(str);
                    if (buf != null) {
                        attrList.add(buf);
                    }
                }
                pageContext.setAttribute("attrList", attrList);
            %>
            <div class="panel panel-default">
                <div class="panel-body">
                    <table class="table">
                        <thead>
                            <tr>
                                <th>Payload</th>
                            </tr>

                        </thead>
                        <tbody>
                            <c:forEach var="attr" items="${attrList}" varStatus="status">
                                <tr>
                                    <td>${attr}</td>
                                </tr>
                            </c:forEach>
                        </tbody>
                    </table>
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
