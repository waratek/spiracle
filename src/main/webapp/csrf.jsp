<%@ page language="java" contentType="text/html; charset=UTF-8"
	pageEncoding="UTF-8"%>

	<%@ include file="header.jsp" %>
    <div class="container">
      <h1>CSRF</h1>

		<div class="panel panel-default">
        	<div class="panel-heading">Form tags for method attribute: post</div>
			<div class="panel-body">

				<p>
					<br/><i>method attribute is: method="post"</i>
				</p>
				<form id="csrfForm" action="CSRFServlet" method="post">
					Name: <input type="text" name="name">
					<input type="submit" value=Submit>
				</form>
				<p>
					<br/><i>method attribute is: method="POST"</i>
				</p>
				<form id="csrfForm" action="CSRFServlet" method="POST">
					Name: <input type="text" name="name">
					<input type="submit" value=Submit>
				</form>
				<p>
					<br/><i>method attribute is: method="Post"</i>
				</p>
				<form id="csrfForm" action="CSRFServlet" method="Post">
					Name: <input type="text" name="name">
					<input type="submit" value=Submit>
				</form>
				<p>
					<br/><i>method attribute is: method="pOSt"</i>
				</p>
				<form id="csrfForm" action="CSRFServlet" method="pOSt">
					Name: <input type="text" name="name">
					<input type="submit" value=Submit>
				</form>
				<p>
					<br/><i>method attribute is: method='post'</i>
				</p>
				<form id="csrfForm" action="CSRFServlet" method='post'>
					Name: <input type="text" name="name">
					<input type="submit" value=Submit>
				</form>
				<p>
					<br/><i>method attribute is: method=post</i>
				</p>
				<form id="csrfForm" action="CSRFServlet" method=post>
					Name: <input type="text" name="name">
					<input type="submit" value=Submit>
				</form>
				<p>
					<br/><i>method attribute is: method &nbsp;&nbsp; ="post"</i>
				</p>
				<form id="csrfForm" action="CSRFServlet" method    ="post">
						Name: <input type="text" name="name">
						<input type="submit" value=Submit>
				</form>
				<p>
					<br/><i>method attribute is: method = "post"</i>
				</p>
				<form id="csrfForm" action="CSRFServlet" method = "post">
					Name: <input type="text" name="name">
					<input type="submit" value=Submit>
				</form>
				<p>
					<br/><i>method attribute is: METHOD="post"</i>
				</p>
				<form id="csrfForm" action="CSRFServlet" METHOD="post">
					Name: <input type="text" name="name">
					<input type="submit" value=Submit>
				</form>
			</div>


        	<div class="panel-heading">Form tags for method attribute: get</div>
			<div class="panel-body">

				<p>
					<br/><i>method attribute is: method="get"</i>
				</p>
				<form id="csrfForm" action="CSRFServlet" method="get">
					Name: <input type="text" name="name">
					<input type="submit" value=Submit>
				</form>
				<p>
					<br/><i>method attribute is: method="GET"</i>
				</p>
				<form id="csrfForm" action="CSRFServlet" method="GET">
					Name: <input type="text" name="name">
					<input type="submit" value=Submit>
				</form>
				<p>
					<br/><i>method attribute is: method="Get"</i>
				</p>
				<form id="csrfForm" action="CSRFServlet" method="Get">
					Name: <input type="text" name="name">
					<input type="submit" value=Submit>
				</form>
				<p>
					<br/><i>method attribute is: method="gEt"</i>
				</p>
				<form id="csrfForm" action="CSRFServlet" method="gEt">
					Name: <input type="text" name="name">
					<input type="submit" value=Submit>
				</form>
				<p>
					<br/><i>method attribute is: method='get'</i>
				</p>
				<form id="csrfForm" action="CSRFServlet" method='get'>
					Name: <input type="text" name="name">
					<input type="submit" value=Submit>
				</form>
				<p>
					<br/><i>method attribute is: method=get</i>
				</p>
				<form id="csrfForm" action="CSRFServlet" method=get>
					Name: <input type="text" name="name">
					<input type="submit" value=Submit>
				</form>
				<p>
					<br/><i>method attribute is: method &nbsp;&nbsp; ="get"</i>
				</p>
				<form id="csrfForm" action="CSRFServlet" method    ="get">
						Name: <input type="text" name="name">
						<input type="submit" value=Submit>
				</form>
				<p>
					<br/><i>method attribute is: method = "get"</i>
				</p>
				<form id="csrfForm" action="CSRFServlet" method = "get">
					Name: <input type="text" name="name">
					<input type="submit" value=Submit>
				</form>
				<p>
					<br/><i>method attribute is: METHOD="get"</i>
				</p>
				<form id="csrfForm" action="CSRFServlet" METHOD="get">
					Name: <input type="text" name="name">
					<input type="submit" value=Submit>
				</form>
			</div>


			<div class="panel-heading">Form tags for misc combinations of method attributes</div>
			<div class="panel-body">
				<p>
					<br/><i>Method attribute "post" is 1/1 attributes</i>
				</p>
				<form method="post">
					Name: <input type="text" name="name">
					<input type="submit" value=Submit>
				</form>
				<p>
					<br/><i>Method attribute "post" is 2/2 attributes</i>
				</p>
				<form foo=bar method="post">
					Name: <input type="text" name="name">
					<input type="submit" value=Submit>
				</form>
				<p>
					<br/><i>Method attribute "post" is 2/3 attributes</i>
				</p>
				<form foo=bar method="post" action=foobar>
					Name: <input type="text" name="name">
					<input type="submit" value=Submit>
				</form>
				<p>
					<br/><i>Method attribute "post" is 3/4 attributes</i>
				</p>
				<form foo=bar blah=blah method="post" action=foobar>
					Name: <input type="text" name="name">
					<input type="submit" value=Submit>
				</form>
				<p>
					<br/><i>Method attribute for "post" then "get"</i>
				</p>
				<form id="csrfForm" action="CSRFServlet" method="post" method="get">
					Name: <input type="text" name="name">
					<input type="submit" value=Submit>
				</form>
				<p>
					<br/><i>Method attribute for "get" then "post"</i>
				</p>
				<form id="csrfForm" action="CSRFServlet" method="get" method="post">
					Name: <input type="text" name="name">
					<input type="submit" value=Submit>
				</form>
				<p>
					<br/><i>No method attributes</i>
				</p>
				<form id="csrfForm" action="CSRFServlet">
					Name: <input type="text" name="name">
					<input type="submit" value=Submit>
				</form>
			</div>
		</div>


		<div class="panel panel-default">

			<div class="panel-heading">a href tags</div>
			<div class="panel-body">
				<a href="index.jsp">a href="index.jsp"</a><br/>
				<a href='index.jsp'>a href='index.jsp'</a><br/>
				<a href=index.jsp>a href=index.jsp</a><br/>
				<a href = "index.jsp">a href = "index.jsp"</a><br/>
				<a HREF="index.jsp">A HREF="index.jsp"</a><br/>
				<a href="http://www.google.com">a href="http://www.google.com"</a><br/>
				<a href="google.com">a href="google.com"</a><br/>
				<a href="#">a href="#"</a><br/>
			</div>
		</div>


		<div class="panel panel-default">
			<div class="panel-heading">iframe tags</div>
			<div class="panel-body">
		  		<iframe src="index.jsp"></iframe>
		  		<iframe src='index.jsp'></iframe>
		  		<iframe src=index.jsp></iframe>
		  		<iframe src = "index.jsp"></iframe>
		  		<IFRAME src="index.jsp"></iframe>
		  		<iframe src="http://www.google.com"></iframe>
		  		<iframe src='http://www.google.com'></iframe>
		  		<iframe src=http://www.google.com></iframe>
		  		<iframe src = "http://www.google.com"></iframe>
		  		<IFRAME src="http://www.google.com"></iframe>
		  	</div>
		</div>


		<div class="panel panel-default">
			<div class="panel-heading">Parameter Pollution</div>
			<div class="panel-body">
				<p>
					<br/><i>Form tag, method attribute is: method="post"</i>
				</p>
				<form id="csrfForm" action="CSRFServlet" method="post">
					Name: <input type="text" name="name">
					<input type="submit" value=Submit>
					<input type="hidden" name="_WARATEK_CSRF_TOKEN" value="notACsrfToken_onlyUsedForParamPollutionTest=" />
				</form>
		  	</div>
		</div>
	</div>

	<%@ include file="footer.jsp" %>
