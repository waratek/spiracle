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
                        <li><a href="csrf.jsp">CSRF</a></li>
                        <li><a href="pathTraversal.jsp">Path Traversal</a></li>
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
                <div class="panel-heading">
                    <h4>Reflected Parameters</h4>
                </div>
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

        <div class="container">
            <div class="panel panel-default">
                <div class="panel-heading">
                    <h4>Trapped Methods</h4>
                </div>
                <div class="panel-body">
                    <form method="get" action="XSSWebAppHSRPW">
                        HttpServletResponse PrintWriter<br/>
                        <input name="taintedtext" size=50>
                        <input type="submit" value="submit">
                    </form>
                    <form method="get" action="XSSWebAppHSRPWDelay">
                        HttpServletResponse PrintWriter with a 10 second delay<br/>
                        <input name="taintedtext" size=50>
                        <input type="submit" value="submit">
                    </form>

                    <form method="get" action="XSSWebAppHSRSOS">
                        HttpServletResponse ServletOutputStream<br/>
                        <input name="taintedtext" size=50>
                        <input type="submit" value="submit">
                    </form>
                    <form method="get" action="XSSWebAppHSRSOSDelay">
                        HttpServletResponse ServletOutputStream with a 10 second delay<br/>
                        <input name="taintedtext" size=50>
                        <input type="submit" value="submit">
                    </form>

                    <form method="get" action="XSSWebAppSRPW">
                        ServletResponse PrintWriter<br/>
                        <input name="taintedtext" size=50>
                        <input type="submit" value="submit">
                    </form>
                    <form method="get" action="XSSWebAppSRPWDelay">
                        ServletResponse PrintWriter with a 10 second delay<br/>
                        <input name="taintedtext" size=50>
                        <input type="submit" value="submit">
                    </form>

                    <form method="get" action="XSSWebAppSRSOS">
                        ServletResponse ServletOutputStream<br/>
                        <input name="taintedtext" size=50>
                        <input type="submit" value="submit">
                    </form>
                    <form method="get" action="XSSWebAppSRSOSDelay">
                        ServletResponse ServletOutputStream with a 10 second delay<br/>
                        <input name="taintedtext" size=50>
                        <input type="submit" value="submit">
                    </form>

                    <form action="print.jsp" method="GET">
                        JspWriter PrintWriter<br/>
                        <input name="taintedtext" name="param"/>
                        <input type="submit" value="Submit" />
                    </form>
                    <form action="printDelay.jsp" method="GET">
                        JspWriter PrintWriter with a 10 second delay<br/>
                        <input name="taintedtext" name="param"/>
                        <input type="submit" value="Submit" />
                    </form>

                    <form action="write.jsp" method="GET">
                        JspWriter PrintWriter.write(...)<br/>
                        <input name="taintedtext" name="param"/>
                        <input type="submit" value="Submit" />
                    </form>
                    <form action="writeDelay.jsp" method="GET">
                        JspWriter PrintWriter.write(...) with a 10 second delay<br/>
                        <input name="taintedtext" name="param"/>
                        <input type="submit" value="Submit" />
                    </form>
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
