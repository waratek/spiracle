<%@ page language="java" contentType="text/html; charset=UTF-8"
	pageEncoding="UTF-8"%>
<%@ page import="com.waratek.spiracle.sql.util.Constants" %>
<!DOCTYPE html>
<html>
<head>
<meta http-equiv="Content-Type" content="text/html; charset=UTF-8">
<link rel="stylesheet" type="text/css" href="css/bootstrap.min.css">
<link rel="stylesheet" type="text/css"
	href="css/bootstrap-theme.min.css">
<link rel="stylesheet" type="text/css" href="css/style.css">
<title>Spiracle - SQL</title>
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
					<li class="active"><a href="sql.jsp">SQL</a></li>
                    <li><a href="xss.jsp">XSS</a></li>
                    <li><a href="misc.jsp">Misc</a></li>
				</ul>
			</div>
		</div>
	</div>

	<div class="container">
		<h1>SQL Injection</h1>
		<div class="panel panel-default">
			<div class="panel-heading">
                <h5>Oracle C3P0 Connection Pool</h54>
			</div>
			<%
				String oracleConnectionData = (String) application
						.getAttribute(Constants.ORACLE_CONNECTION_DATA);				
				if (oracleConnectionData == null) {
					oracleConnectionData = "";
				}
			%>
			<div class="panel-footer">
				Connection Information
				<pre><%=oracleConnectionData%></pre>
			</div>
		</div>
		<div class="panel panel-default">
			<div class="panel-heading">
                <h5>MySQL C3P0 Connection Pool</h5>
			</div>
			<%
				String mySqlConnectionData = (String) application
						.getAttribute(Constants.MYSQL_CONNECTION_DATA);				
				if (mySqlConnectionData == null) {
					mySqlConnectionData = "";
				}
			%>
			<div class="panel-footer">
				Connection Information
				<pre><%=mySqlConnectionData%></pre>
			</div>
		</div>
		<div class="panel panel-default">
			<div class="panel-heading">
                <h5>MsSQL C3P0 Connection Pool</h5>
			</div>
			<%
				String msSqlConnectionData = (String) application
						.getAttribute(Constants.MSSQL_CONNECTION_DATA);				
				if (msSqlConnectionData == null) {
					msSqlConnectionData = "";
				}
			%>
			<div class="panel-footer">
				Connection Information
				<pre><%=msSqlConnectionData%></pre>
			</div>
		</div>
		<div class="panel panel-default">
			<div class="panel-heading">Injectable URLS</div>
			<div class="panel-body">
				<h3>Oracle</h3>
				<table class="table table-hover">
					<thead>
						<tr>
							<th>Request</th>
							<th>SQL Statement</th>
						</tr>
					</thead>
					<tbody>
						<tr>
							<td><a href="Get_int?id=1">Get_int?id=1</a></td>
							<td><code>"SELECT * FROM users WHERE id = '" + id +
									"'";</code></td>
						</tr>
						<tr>
							<td><a href="Get_int_no_quote?id=1">Get_int_no_quote?id=1</a></td>
							<td><code>"SELECT * FROM users WHERE id = " + id;</code></td>
						</tr>
						<tr>
							<td><a href="Get_int_orderby?id=name">Get_int_orderby?id=name</a></td>
							<td><code>"SELECT * FROM users ORDER BY '" + id +
									"'";</code></td>
						</tr>
						<tr>
							<td><a href="Get_int_groupby?id=name">Get_int_groupby?id=name</a></td>
							<td><code>"SELECT count(name), name FROM users GROUP
									BY " + id;</code></td>
						</tr>
						<tr>
							<td><a href="Get_int_partialunion?id=1">Get_int_partialunion?id=1</a></td>
							<td><code>"SELECT * FROM users WHERE id = '" + id +
									"'";</code></td>
						</tr>
						<tr>
							<td><a href="Get_int_nooutput?id=1">Get_int_nooutput?id=1</a></td>
							<td><code>"SELECT * FROM users WHERE id = '" + id +
									"'";</code></td>
						</tr>
						<tr>
							<td><a href="Get_int_having?id=1">Get_int_having?id=1</a></td>
							<td><code>"SELECT MIN(name) from users GROUP BY id
									HAVING id = " + id;</code></td>
						</tr>
						<tr>
							<td><a href="Get_int_inline?id=SELECT%20*%20FROM%20users">Get_int_inline?id=SELECT
									* FROM users</a></td>
							<td><code>id;</code></td>
						</tr>
						<tr>
							<td><a href="Get_string?name=wu">Get_string?name=wu</a></td>
							<td><code>"SELECT * FROM users WHERE name = '" + name
									+ "'";</code></td>
						</tr>
						<tr>
							<td><a href="Get_string_no_quote?name='wu'">Get_string_no_quote?name='wu'</a></td>
							<td><code>"SELECT * FROM users WHERE name = " + name;</code></td>
						</tr>
						<tr>
							<td><a href="Get_string_sanitised?name=wu">Get_string_sanitised?name=wu</a></td>
							<td><code>"SELECT * FROM users WHERE name = '" + name
									+ "'";</code></td>
						</tr>
						<tr>
							<td><a href="Get_string_no_quote_sanitised?name='wu'">Get_string_no_quote_sanitised?name='wu'</a></td>
							<td><code>"SELECT * FROM users WHERE name = " + name;</code></td>
						</tr>
						<tr>
							<td><a href="Update_User?id=1&amp;name=Joe&amp;surname=Soap">Update
									User</a></td>
							<td><code>"UPDATE users SET name = '" + name + "',
									surname = '" + surname + "' WHERE id = " + id;</code></td>
						</tr>
						<tr>
							<td><a href="Delete_User?id=1&amp;name=Joe">Delete User</a></td>
							<td><code>"DELETE FROM users WHERE id = " + id + " OR
									name = '" + name + "'";</code></td>
						</tr>
						<tr>
							<td><a
								href="Insert_User?id=101&amp;name=Joe&amp;surname=Soap&amp;dob=01-Jan-1970&amp;credit_card=1111-1111-1111-1111&amp;cvv=999">Insert
									User</a></td>
							<td><code>"INSERT INTO users VALUES (" + id + ", '" +
									name + "', '" + surname + "', '" + dob + "', '" + credit_card +
									"', '" + cvv + "')";</code></td>
						</tr>
						<tr>
							<td><a href="Get_Implicit_Join?id=1">Get_Implicit_Join?id=1</a></td>
							<td><code>"SELECT * FROM users, address WHERE
									users.id = " + id + " AND users.id = address.id";</code></td>
						</tr>
						<tr>
							<td><a href="Get_Full_Outer_Join?id=1">Get_Full_Outer_Join?id=1</a></td>
							<td><code>"SELECT * FROM users FULL OUTER JOIN
									address ON users.id = address.id AND users.id = " + id;</code></td>
						</tr>
						<tr>
							<td><a href="Get_Union?id=1">Get_Union?id=1</a></td>
							<td><code>"SELECT name, surname, TO_CHAR(dob) FROM
									users WHERE id = " + id + " UNION SELECT address_1, address_2,
									address_3 FROM address WHERE id = " + id;</code></td>
						</tr>
						<tr>
							<td><a href="Insert_Raw_Text&amp;id=1;text=...">Insert_Raw_Text?id=1&amp;text=...</a></td>
							<td><code>"INSERT INTO TEXT_STORE VALUES (" + id + ",
									'" + text + "')";</code></td>
						</tr>
						<tr>
							<td><a href="Insert_Raw_Text_Sanitised?id=1&amp;text=...">Insert_Raw_Text_Sanitised?id=1&amp;text=...</a></td>
							<td><code>"INSERT INTO TEXT_STORE VALUES (" + id + ",
									'" + text + "')";</code></td>
						</tr>
					</tbody>
				</table>
			</div>
			<div class="panel-body">
				<h3>MySQL</h3>
				<table class="table table-hover">
					<thead>
						<tr>
							<th>Request</th>
							<th>SQL Statement</th>
						</tr>
					</thead>
					<tbody>
						<tr>
							<td><a href="MySql_Get_int?id=1">MySql_Get_int?id=1</a></td>
							<td><code>"SELECT * FROM users WHERE id = '" + id + "
									'";</code></td>
						</tr>
						<tr>
							<td><a href="MySql_Get_string?name=wu">MySql_Get_string?name=wu</a></td>
							<td><code>"SELECT * FROM users WHERE name = '" + name
									+ " '";</code></td>
						</tr>
						<tr>
							<td><a href="MySql_Get_Union?id=1">MySql_Get_Union?id=1</a></td>
							<td><code>"SELECT name, surname, dob FROM users WHERE
									id = " + id + " UNION SELECT address_1, address_2, address_3
									FROM address WHERE id = " + id;</code></td>
						</tr>
						<tr>
							<td><a href="MySql_Get_Implicit_Join?id=1">MySql_Get_Implicit_Join?id=1</a></td>
							<td><code>"SELECT * FROM users, address WHERE
									users.id = " + id + " AND users.id = address.id";</code></td>
						</tr>
						<tr>
							<td><a href="MySql_Implicit_Join_Namespace?id=1">MySql_Implicit_Join_Namespace?id=1</a></td>
							<td><code>"SELECT * FROM test.users, test.address
									WHERE test.users.id = " + id + " AND test.users.id =
									test.address.id";</code></td>
						</tr>
					</tbody>
				</table>
			</div>
			<div class="panel-body">
				<h3>MsSQL</h3>
				<table class="table table-hover">
					<thead>
						<tr>
							<th>Request</th>
							<th>SQL Statement</th>
						</tr>
					</thead>
					<tbody>
						<tr>
							<td><a href="MsSql_Get_int?id=1">MsSql_Get_int?id=1</a></td>
							<td><code>"SELECT * FROM users WHERE id = '" + id +
									"'";</code></td>
						</tr>
						<tr>
							<td><a href="MsSql_Get_string?name=wu">MsSql_Get_string?name=wu</a></td>
							<td><code>"SELECT * FROM users WHERE name = '" + name
									+ "'";</code></td>
						</tr>
						<tr>
							<td><a href="MsSql_Get_Union?id=1">MsSql_Get_Union?id=1</a></td>
							<td><code>"SELECT name, surname, CONECRT(varchar(500), dod, 3)dob FROM users WHERE
									id = " + id + " UNION SELECT address_1, address_2, address_3
									FROM address WHERE id = " + id;</code></td>
						</tr>
						<tr>
							<td><a href="MsSql_Get_Implicit_Join?id=1">MsSql_Get_Implicit_Join?id=1</a></td>
							<td><code>"SELECT * FROM users, address WHERE
									users.id = " + id + " AND users.id = address.id";</code></td>
						</tr>
						<tr>
							<td><a href="MsSql_Implicit_Join_Namespace?id=1">MsSql_Implicit_Join_Namespace?id=1</a></td>
							<td><code>"SELECT * FROM dbo.users, dbo.address WHERE
									dbo.users.id = " + id + " AND dbo.users.id = dbo.address.id";</code></td>
						</tr>
					</tbody>
				</table>
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
