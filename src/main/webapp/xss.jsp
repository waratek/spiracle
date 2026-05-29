<%@ taglib uri="http://java.sun.com/jsp/jstl/core" prefix="c" %>
<%@page import="java.util.Collections"%>
<%@page import="java.util.Enumeration"%>
<%@page import="java.util.ArrayList"%>
<%@page import="java.util.List"%>
<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>

  <jsp:include page="header.jsp" >
    <jsp:param name="pageName" value="XSS" />
  </jsp:include>

        <div class="container">
            <div class="panel panel-default">
                <div class="panel-heading">
                    <h4>Additional XSS cases</h4>
                </div>
                <div class="panel-body">
                  <a href="xssViaException.jsp">XSS via Exception messages test cases</a><br/>
                  <a href="xssContextMatrix.jsp">XSS Context Matrix test cases</a><br/>
                </div>
            </div>
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
		    <form id="reflectedXSS" action="xss.jsp">
                      <table class="table">
                        <thead>
                            <tr>
                                <th>Set the Payload</th>
                                <th><input type="text" name="payload" /></th>
                            </tr>
                        </thead>
                        <tbody>
                            <tr>
                                <th><input type="submit" name="submit" /></th>
                            </tr>
                        </tbody>
                      </table>
                    </form>

                    <table class="table">
                        <thead>
                            <tr>
                                <th>Reflected Payload</th>
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

    <%@ include file="footer.jsp" %>
