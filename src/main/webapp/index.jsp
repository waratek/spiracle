<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>

  <jsp:include page="header.jsp" >
    <jsp:param name="pageName" value="Overview" />
  </jsp:include>

    <div class="container">
      <h1>Overview</h1>
        <p class="lead">Spiracle is an insecure web application used to test system security controls.</p>
        <p>It can be used to read/write arbitrary files and open network connections.</p>
         The application is also vulnerable to numerous other vulnerabilities such as: <ul>
         <li> SQL Injection (CWE-89)</li>
         <li> XSS (CWE-79)</li>
         <li> CSRF (CWE-352)</li>
         <li> Path Traversal (CWE-22)</li>
         <li> Deserialization (CWE-502)</li>
         <li> and many more...</li>
         </ul>
        <p>Due to its insecure design, this application should NOT be deployed on an unsecured network or system.</p>
    </div>

    <%@ include file="footer.jsp" %>
