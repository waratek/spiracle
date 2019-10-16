<%@ taglib prefix = "ex" uri = "WEB-INF/custom.tld"%>

<html>
   <head>
      <title>Custom Tag test</title>
   </head>
   
   <body>
   		<%
            String username = request.getParameter("name");
   		%>
		<ex:HelloUser username="<%=username%>">Can you exploit it?</ex:HelloUser>
   </body>
</html>