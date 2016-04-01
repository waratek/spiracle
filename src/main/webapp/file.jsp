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
<title>Spiracle - File</title>
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
					<li class="active"><a href="file.jsp">File</a></li>
					<li><a href="network.jsp">Network</a></li>
					<li><a href="sql.jsp">SQL</a></li>
                    <li><a href="xss.jsp">XSS</a></li>
                    <li><a href="csrf.jsp">CSRF</a></li>
                    <li><a href="misc.jsp">Misc</a></li>
				</ul>
			</div>
		</div>
	</div>

	<div class="container">
		<h1>File</h1>

		<div class="panel panel-default">
			<%
				String textData = (String) session.getAttribute("fileContents");
				if (textData == null) {
					textData = "";
				}
			%>
			<div class="panel-heading">File</div>
			<div class="panel-body">
				<form id="fileForm" action="FileServlet" method="post">
					Path: <input type="text" name="filePath"><br> Read <input
						type="radio" name="fileArg" value="read" checked><br>
					Write <input type="radio" name="fileArg" value="write"><br>
					Delete <input type="radio" name="fileArg" value="delete"><br>
					<input type="submit" value=Submit>
				</form>
			</div>
			<div class="panel-heading">File URL</div>
			<div class="panel-body">
				<form id="fileUrlForm" action="FileUrlServlet" method="post">
					Path: <input type="text" name="filePath"> <input
						type="submit" value=Submit>
				</form>
			</div>
			<div class="panel-heading">File Resource Stream</div>
			<div class="panel-body">
				<form id="fileResourceStreamForm" action="FileResourceStreamServlet"
					method="post">
					Path: <input type="text" name="filePath"> <input
						type="submit" value=Submit>
				</form>
			</div>
			<div class="panel-footer">Text Data</div>
			<div class="panel-body">
				<pre>
					<textarea form="fileForm" name="fileText"
						style="width: 100%; height: 20em"><%=textData%></textarea>
				</pre>
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
