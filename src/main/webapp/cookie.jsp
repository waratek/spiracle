<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>

  <jsp:include page="header.jsp" >
    <jsp:param name="pageName" value="Cookie" />
  </jsp:include>

	<div class="container">
		<h1>Cookie</h1>

		<div class="panel panel-default">
			<div class="panel-heading">Cookie Requester</div>
			    <div class="panel-body">
                    <h2>Enter desired cookie information</h2>
                    <form action="CookieServlet" method="post">
                    <table align="left">
                        <tr><td>
                            Cookie Name: <input type=text name="cookieName" required="required" pattern="[A-Za-z0-9]{1,20}">
                        </td></tr>

                        <tr><td>
                            Cookie Value: <input type=text name="cookieValue" required="required" pattern="[A-Za-z0-9]{1,20}">
                        </td></tr>

                        <tr><td>
                            Cookie Path (Optional): <input type=text name="cookiePath">
                        </td></tr>

                        <tr><td>
                            <input type="radio" name="secure" value="yes"required/>secure
                            <input type="radio" name="secure" value="no" required/>non-secure
                        </td></tr>

                        <tr><td>
                            <input type="submit" value="Send">
                        </td></tr>
                    </table>
                    </form>
			    </div>
		    </div>
	    </div>
        <div class="panel panel-default">
            <div class="panel-heading">Request Contents</div>
			    <div class="panel-body">
                    Cookie Name: <%= request.getParameter("cookieName") %>
                    <br>
                    Cookie Value: <%= request.getParameter("cookieValue") %>
                    <br>
                    Cookie Path: <%= request.getParameter("cookiePath") %>
                    <br>
                    Secure Cookie: <%= request.getParameter("secure") %>
                    <br>
                </div>
            </div>
        </div>
<%@ include file="footer.jsp" %>




