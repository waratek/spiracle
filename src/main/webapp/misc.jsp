<%@ taglib uri="http://java.sun.com/jsp/jstl/core" prefix="c" %>
<%@page import="java.util.Arrays"%>
<%@page import="java.util.ArrayList"%>
<%@page import="java.util.List"%>
<%@page import="java.lang.reflect.Method"%>
<%@page import="java.util.Collections"%>
<%@page import="java.util.Set"%>

<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>

  <jsp:include page="header.jsp" >
    <jsp:param name="pageName" value="Misc" />
  </jsp:include>

        <div class="container">
            <%
                String methodReturn = (String) session.getAttribute("methodReturn");
                if (methodReturn == null) {
                    methodReturn = "";
                }
            %>
            <h1>Misc</h1>
            <div class="panel panel-default">
                <div class="panel-heading">Diagnostic Self-tests</div>
                <div class="panel-body">
                    <form action="selfTest.jsp" method="get">
                        <input type="submit" class="btn btn-danger btn-lg active" title="This will start the self-tests" value="Run Self-Tests">
                    </form>
                </div>
                <div class="panel-footer">Automatic tests that trigger common web attacks.
                    It can be used as a sanity test to confirm basic appsec protection and configuration of RASP, IAST and WAF products.</div>
            </div>

            <div class="panel panel-default">
                <div class="panel-heading">HttpServletRequest Method Return</div>
                <div class="panel-body">
                    <form action="HttpRequestMethod" method="post">
                        <select name="method">
                            <option value="getHeader">getHeader()</option>
                            <option value="getHeaders">getHeaders()</option>
                            <option value="getMethod">getMethod()</option>
                            <option value="getPathInfo">getPathInfo()</option>
                            <option value="getPathTranslated">getPathTranslated()</option>
                            <option value="getQueryString">getQueryString()</option>
                            <option value="getRequestURI">getRequestURI()</option>
                            <option value="getRequestURL">getRequestURL()</option>
                            <option value="getServletPath">getServletPath()</option>
                            <option value="getComment">getComment()</option>
                            <option value="getName">getName()</option>
                            <option value="getDomain">getDomain()</option>
                            <option value="getPath">getPath()</option>
                            <option value="getValue">getValue()</option>
                        </select>
                        <input type="text" name="arg">
                        <input type="submit">
                    </form>
                </div>
                <div class="panel-footer">
                    Return Value: <%=methodReturn%>
                </div>
            </div>
            <div class="panel panel-default">
                <div class="panel-heading">Crash JVM</div>
                <div class="panel-body">
                    <form action="CrashJvm" method="post">
                        <input type="submit" class="btn btn-danger btn-lg active" title="This will crash your JVM" value="Danger!">
                    </form>
                </div>
                <div class="panel-footer">Use sun.misc.Unsafe to directly address internal JVM address space and hard crash the JVM.</div>
            </div>
            <div class="panel panel-default">
                <div class="panel-heading">Thread Terminate</div>
                <div class="panel-body">
                    <%
                        Set<Thread> threadSet = Thread.getAllStackTraces().keySet();
                        Thread[] threadArray = threadSet.toArray(new Thread[threadSet.size()]);
                        List<Thread> threadList = new ArrayList<Thread>(Arrays.asList(threadArray));
                        pageContext.setAttribute("threadList", threadList);
                    %>
                    <form action="ThreadKill" method="post">
                        <select name="threadNames" multiple size="10">
                            <c:forEach var="thread" items="${threadList}">
                                <option value="${thread.name}">${thread.name}</option>
                            </c:forEach>
                        </select>
                        </br>
                        <input type="submit" class="btn btn-danger active" title="This might crash your application, server or the JVM itself." value="Submit">
                    </form>
                </div>
                <div class="panel-footer">Warning, may cause application server to become unresponsive or crash JVM.</div>
            </div>
            <div class="panel panel-default">
                <div class="panel-heading">Thread Stack Inspector</div>
                <div class="panel-body">
                    <form action="GetThreadStack" method="post">
                        <select name="threadName">
                            <c:forEach var="thread" items="${threadList}">
                                <option value="${thread.name}">${thread.name}</option>
                            </c:forEach>
                        </select>
                        <input type="submit" value="Submit">
                    </form>
                    <%
                        String threadName = (String) session.getAttribute("threadName");
                        if (threadName == null) {
                            threadName = "";
                        }
                    %>
                    <c:if test="${not empty threadName}">
                        <h4>Selected Thread: <%=threadName%></h4>
                        <select multiple size="10">
                            <c:forEach var="stackElement" items="${stackTrace}">
                                <option value="${stackElement}">${stackElement}</option>
                            </c:forEach>
                        </select>
                    </c:if>
                </div>
                <div class="panel-footer">Inspect thread call stack.</div>
            </div>
        </div>

    <%@ include file="footer.jsp" %>
