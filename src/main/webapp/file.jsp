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

			<div class="panel-heading"> File Exec</div>
			<div class="panel-body">
				<form id="fileExec" action="FileExecServlet"
					method="post">
					Path: <input type="text" name="cmd"> <input
						type="submit" value=Submit>
				</form>
			</div>

			<div class="panel-heading">File From XML-Deserialization</div>
			<div class="panel-body">
				<form id="fileFromXmlDeserializationForm" action="FileFromXmlDeserializationServlet" method="post">
					Path: <input type="text" name="fileXmlDeserializationPath"><br> Read <input
						type="radio" name="fileXmlDeserializationArg" value="read" checked><br>
					Write <input type="radio" name="fileXmlDeserializationArg" value="write"><br>
					Delete <input type="radio" name="fileXmlDeserializationArg" value="delete"><br>
					<input type="submit" value=Submit>
				</form>
			</div>

			<div class="panel-heading">File From Java-Deserialization</div>
			<div class="panel-body">
				<form id="fileFromJavaDeserializationForm" action="FileFromJavaDeserializationServlet" method="post">
					Path: <input type="text" name="fileJavaDeserializationPath"><br> Read <input
						type="radio" name="fileJavaDeserializationArg" value="read" checked><br>
					Write <input type="radio" name="fileJavaDeserializationArg" value="write"><br>
					Delete <input type="radio" name="fileJavaDeserializationArg" value="delete"><br>
					<input type="submit" value=Submit>
				</form>
			</div>

			<div class="panel-heading">File From Database</div>
			<div class="panel-body">
				<form id="fileFromDatabaseForm" action="FileFromDatabaseServlet" method="post">
					Path: <input type="text" name="fileFromDatabasePath"><br>
					connectionType: <input type="text" name="connectionType"><br>
					Read <input type="radio" name="fileFromDatabaseArg" value="read" checked><br>
					Write <input type="radio" name="fileFromDatabaseArg" value="write"><br>
					Delete <input type="radio" name="fileFromDatabaseArg" value="delete"><br>
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
		</div>
	</div>

	<%@ include file="footer.jsp" %>
