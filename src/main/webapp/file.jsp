<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>

	<jsp:include page="header.jsp" >
	<jsp:param name="pageName" value="File" />
	</jsp:include>

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
					Path: <input type="text" name="filePath"><br>
					ConnectionType (DB only): <input type="text" name="connectionType"><br>
					Path Source: <br>
					&nbsp;&nbsp; <input type="radio" name="pathSource" value="http" checked> HTTP<br>
					&nbsp;&nbsp; <input type="radio" name="pathSource" value="deserialJava"> Deserialization(Java)<br>
					&nbsp;&nbsp; <input type="radio" name="pathSource" value="deserialXml"> Deserialization(XML)<br>
					&nbsp;&nbsp; <input type="radio" name="pathSource" value="database"> Database<br>
					Action: <br>
					&nbsp;&nbsp; <input type="radio" name="fileArg" value="read" checked> Read<br>
					&nbsp;&nbsp; <input type="radio" name="fileArg" value="write"> Write<br>
					&nbsp;&nbsp; <input type="radio" name="fileArg" value="delete"> Delete<br>
					&nbsp;&nbsp; <input type="submit" value=Submit>
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

			<div class="panel-heading"> File Exec</div>
			<div class="panel-body">
				<form id="fileExec" action="FileExecServlet"
					method="post">
					Path: <input type="text" name="cmd"> <br>
					ConnectionType (DB only): <input type="text" name="connectionType"><br>
					Path Source: <br>
					&nbsp;&nbsp; <input type="radio" name="pathSource" value="http" checked> HTTP<br>
					&nbsp;&nbsp; <input type="radio" name="pathSource" value="deserialJava"> Deserialization(Java)<br>
					&nbsp;&nbsp; <input type="radio" name="pathSource" value="deserialXml"> Deserialization(XML)<br>
					&nbsp;&nbsp; <input type="radio" name="pathSource" value="database"> Database<br>
					<input type="submit" value=Submit>
				</form>
			</div>

			<div class="panel-footer">Text Data</div>
			<div class="panel-body">
				<pre>
					<textarea form="fileForm" name="fileText"
						style="width: 100%; height: 20em"><%=textData%></textarea>
				</pre>
			</div>
			
			<div class="panel-heading">File from Cookie</div>
			<div class="panel-body">
				<form id="fileCookieForm" action="CookieFileServlet" method="post">
					Cookie name: <input type="text" name="cookieName"><br>
					Action: <br>
					&nbsp;&nbsp; <input type="radio" name="fileArg" value="read" checked> Read<br>
					&nbsp;&nbsp; <input type="radio" name="fileArg" value="write"> Write<br>
					&nbsp;&nbsp; <input type="radio" name="fileArg" value="delete"> Delete<br>
					&nbsp;&nbsp; <input type="submit" value=Submit>
				</form>
			</div>
		</div>
	</div>

	<%@ include file="footer.jsp" %>
