<%@ page language="java" import="java.io.*, java.util.*" %>
<html>
<head>
    <title>XSS-JSP</title>
</head>
<body>
  <%
    String taintedInput = request.getParameter("taintedtext");
	String htmlFile = request.getRealPath("/") + "xss.html";
	String XSS = "XSS";
	BufferedReader in = new BufferedReader(new FileReader(htmlFile));
	String line = "";
	while ((line = in.readLine()) != null) {
		if (line.indexOf(XSS) != -1) {
			System.out.println("Transforming:");
			System.out.println(line);
			line = line.replace(XSS, taintedInput);
			System.out.println(line);
		}
		out.println(line);
	}
	in.close();
  %>
</body>
</html>
