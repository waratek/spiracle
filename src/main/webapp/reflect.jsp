<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>

	<jsp:include page="header.jsp" >
	<jsp:param name="pageName" value="Reflect" />
	</jsp:include>

	<div class="container">
		<h1>Reflect</h1>

		<div class="panel panel-default">
			<%
				String textData = (String) session.getAttribute("textPanelContents");
				if (textData == null) {
					textData = "";
				}
			%>
			<div class="panel-heading">File</div>
			<div class="panel-body">
				<form id="reflectForm" action="ReflectServlet" method="post">
					Test Input: <input type="text" name="testInput"><br>
					<br>
					Test Input Source: <br>
					&nbsp;&nbsp; <input type="radio" name="inputSource" value="http" checked> HTTP<br>
					&nbsp;&nbsp; <input type="radio" name="inputSource" value="deserialJava"> Deserialization(Java)<br>
					&nbsp;&nbsp; <input type="radio" name="inputSource" value="deserialXml"> Deserialization(XML)<br>
					&nbsp;&nbsp; <input type="radio" name="inputSource" value="database"> Database<br>
					<br>
					ConnectionType (database input only): <input type="text" name="connectionType"><br>
					<br>
					Reflection operation: <br>
					&nbsp;&nbsp; <input type="radio" name="reflectArg" value="classForName" checked> Class.classForName(...) <br>
					&nbsp;&nbsp; <input type="radio" name="reflectArg" value="classLoaderLoadClass" checked> ClassLoader.loadClass(...) <br>
					&nbsp;&nbsp; <input type="radio" name="reflectArg" value="classGetMethod"> Class.getMethod(...) <br>
					&nbsp;&nbsp; <input type="radio" name="reflectArg" value="classGetDeclaredMethod"> Class.getDeclaredMethod(...) <br>
					&nbsp;&nbsp; <input type="radio" name="reflectArg" value="classGetField"> Class.getField(...) <br>
					&nbsp;&nbsp; <input type="radio" name="reflectArg" value="classGetDeclaredField"> Class.getDeclaredField(...) <br>
					<br>
					&nbsp;&nbsp; <input type="submit" value=Submit>
				</form>
			</div>

			<div class="panel-footer">Text Data</div>
			<div class="panel-body">
				<pre>
					<textarea form="reflectForm" name="reflectText"
						style="width: 100%; height: 20em"><%=textData%></textarea>
				</pre>
			</div>
			
		</div>
	</div>

	<%@ include file="footer.jsp" %>
