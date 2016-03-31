<%@ page language="java" contentType="text/html; charset=UTF-8"
	pageEncoding="UTF-8"%>
<!DOCTYPE html>
<html>
<head>
<meta http-equiv="Content-Type" content="text/html; charset=UTF-8">
<link rel="stylesheet" type="text/css" href="css/bootstrap.min.css">
<link rel="stylesheet" type="text/css"
	href="css/bootstrap-theme.min.css">
<link rel="stylesheet" type="text/css" href="css/style.css">
<title>Spiracle - Misc</title>
</head>

<body>
	<div class="navbar navbar-default navbar-fixed-top" role="navigation">
		<div class="container">
			<div class="navbar-header">
				<button type="button" class="navbar-toggle collapsed"
					data-toggle="collapse" data-target=".navbar-collapse">
					<span class="sr-only">Toggle navigation</span> <span
						class="icon-bar"></span> <span class="icon-bar"></span> <span
						class="icon-bar"></span>
				</button>
				<a class="navbar-brand" href="index.jsp">Spiracle</a>
			</div>
			<div class="navbar-collapse collapse">
				<ul class="nav navbar-nav">
					<li><a href="index.jsp">Overview</a></li>
					<li><a href="file.jsp">File</a></li>
					<li><a href="network.jsp">Network</a></li>
					<li><a href="sql.jsp">SQL</a></li>
                    <li><a href="xss.jsp">XSS</a></li>
                    <li><a href="csrf.jsp">CSRF</a></li>
					<li class="active"><a href="misc.jsp">Misc</a></li>
				</ul>
			</div>
		</div>
	</div>

	<div class="container">
		<%
			String methodReturn = (String) session.getAttribute("methodReturn");
			if (methodReturn == null) {
				methodReturn = "";
			}
		%>
		<h1>Misc</h1>
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