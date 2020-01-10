<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ page import="com.waratek.spiracle.sql.util.Constants" %>

  <jsp:include page="header.jsp" >
    <jsp:param name="pageName" value="SQL" />
  </jsp:include>

        <div class="container">
            <h1>SQL Injection</h1>
            <div class="panel panel-default">
                <div class="panel-heading">
                    <h5>Oracle C3P0 Connection Pool</h5>
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
                <div class="panel-heading">
                    <h5>DB2 C3P0 Connection Pool</h5>
                </div>
                <%
                    String db2SqlConnectionData = (String) application
                            .getAttribute(Constants.DB2_CONNECTION_DATA);
                    if (db2SqlConnectionData == null) {
                        db2SqlConnectionData = "";
                    }
                %>
                <div class="panel-footer">
                    Connection Information
                    <pre><%=db2SqlConnectionData%></pre>
                </div>
            </div>
            <div class="panel panel-default">
                <div class="panel-heading">
                    <h5>Sybase C3P0 Connection Pool</h5>
                </div>
                <%
                    String sybaseSqlConnectionData = (String) application
                            .getAttribute(Constants.SYBASE_CONNECTION_DATA);
                    if (sybaseSqlConnectionData == null) {
                        sybaseSqlConnectionData = "";
                    }
                %>
                <div class="panel-footer">
                    Connection Information
                    <pre><%=sybaseSqlConnectionData%></pre>
                </div>
            </div>
            <div class="panel panel-default">
                <div class="panel-heading">
                    <h5>Postgres C3P0 Connection Pool</h5>
                </div>
                <%
                    String postgresSqlConnectionData = (String) application
                            .getAttribute(Constants.POSTGRES_CONNECTION_DATA);
                    if (postgresSqlConnectionData == null) {
                        postgresSqlConnectionData = "";
                    }
                %>
                <div class="panel-footer">
                    Connection Information
                    <pre><%=postgresSqlConnectionData%></pre>
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
                                <td><a href="Get_string_param_question_mark?name=wu">Get_string_param_question_mark?name='wu'</a></td>
                                <td><code>"SELECT * FROM users where name <> ? and name = '" + name + "'";</code></td>
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
                                <td><a href="MySql_Get_string_param_question_mark?name=wu">MySql_Get_string_param_question_mark?name='wu'</a></td>
                                <td><code>"SELECT top 5 id, name, surname FROM users where name <> ? and name = '" + name + "'";</code></td>
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
                                <td><a href="MsSql_Get_string_param_question_mark?name=wu">MsSql_Get_string_param_question_mark?name='wu'</a></td>
                                <td><code>"SELECT top 5 id, name, surname FROM users where name <> ? and name = '" + name + "'";</code></td>
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
                <div class="panel-body">
                    <h3>IBM DB2</h3>
                    <table class="table table-hover">
                        <thead>
                            <tr>
                                <th>Request</th>
                                <th>SQL Statement</th>
                            </tr>
                        </thead>
                        <tbody>
                            <tr>
                                <td><a href="Db2_Get_int?id=1">Db2_Get_int?id=1</a></td>
                                <td><code>"SELECT * FROM SPIRACLE.USERS WHERE id = '" + id + "'";</code></td>
                            </tr>
                            <tr>
                                <td><a href="Db2_Get_int_quote_id?id=1">Db2_Get_int_quote_id?id=1</a></td>
                                <td><code>""SELECT * FROM \"SPIRACLE\".\"USERS\" WHERE id = '" + id + "'"</code></td>
                            </tr>
                            <tr>
                                <td><a href="Db2_Get_string?name=wu">Db2_Get_string?name=wu</a></td>
                                <td><code>"SELECT * FROM spiracle.users WHERE name = '" + name + "'";</code></td>
                            </tr>
                            <tr>
                                <td><a href="Db2_Get_string_quote_id?name=wu">Db2_Get_string_quote_id?name=wu</a></td>
                                <td><code>"SELECT * FROM \"SPIRACLE\".\"USERS\" WHERE name = '" + name + "'";</code></td>
                            </tr>
                            <tr>
                                <td><a href="Db2_Get_string_param_question_mark?name=wu">Db2_Get_string_param_question_mark?name='wu'</a></td>
                                <td><code>"SELECT * FROM spiracle.users where name <> ? and name = '" + name + "'";</code></td>
                            </tr>
                            <tr>
                                <td><a href="Db2_Implicit_Join_Namespace?id=1">Db2_Implicit_Join_Namespace?id=1</a></td>
                                <td><code>"SELECT * FROM SPIRACLE.USERS, SPIRACLE.ADDRESS where SPIRACLE.USERS.ID = " + id + " AND SPIRACLE.ADDRESS.ID = SPIRACLE.USERS.ID";</code></td>
                            </tr>
                            <tr>
                                <td><a href="Db2_Implicit_Join_Namespace_quote_id?id=1">Db2_Implicit_Join_Namespace_quote_id?id=1</a></td>
                                <td><code>"SELECT * FROM \"SPIRACLE\".\"USERS\", SPIRACLE.ADDRESS where SPIRACLE.USERS.ID = " + id + " AND SPIRACLE.ADDRESS.ID = SPIRACLE.USERS.ID";</code></td>
                            </tr>
                            <tr>
                                <td><a href="Db2_Get_Union?id=1">Db2_Get_Union?id=1</a></td>
                                <td><code>"SELECT name, surname FROM spiracle.users WHERE id = " + id + " UNION SELECT address_1, address_2 FROM spiracle.address WHERE id = " + id;</code></td>
                            </tr>
                            <tr>
                                <td><a href="Db2_Get_Union_quote_id?id=1">Db2_Get_Union_quote_id?id=1</a></td>
                                <td><code>"SELECT name, surname FROM \"SPIRACLE\".\"USERS\" WHERE id = " + id + " UNION SELECT address_1, address_2 FROM spiracle.address WHERE id = " + id;</code></td>
                            </tr>
                        </tbody>
                    </table>
                </div>
                <div class="panel-body">
                    <h3>Sybase</h3>
                    <table class="table table-hover">
                        <thead>
                            <tr>
                                <th>Request</th>
                                <th>SQL Statement</th>
                            </tr>
                        </thead>
                        <tbody>
                            <tr>
                                <td><a href="Sybase_Get_int_no_quote?id=1">Sybase_Get_int_no_quote?id=1</a></td>
                                <td><code>"SELECT * FROM users WHERE id = " + id;</code></td>
                            </tr>
                            <tr>
                                <td><a href="Sybase_Get_string?name=wu">Sybase_Get_string?name=wu</a></td>
                                <td><code>"SELECT * FROM users WHERE name = '" + name
                                        + "'";</code></td>
                            </tr>
                            <tr>
                                <td><a href="Sybase_Get_string_no_quote?name=wu">Sybase_Get_string_no_quote?name=wu</a></td>
                                <td><code>"SELECT * FROM users WHERE name = " + name;</code></td>
                            </tr>
                            <tr>
                                <td><a href="Sybase_Get_string_param_question_mark?name=wu">Sybase_Get_string_param_question_mark?name='wu'</a></td>
                                <td><code>"SELECT top 5 id, name, surname FROM users where name <> ? and name = '" + name + "'";</code></td>
                            </tr>
                            <tr>
                                <td><a href="Sybase_Get_Union?id=1">Sybase_Get_Union?id=1</a></td>
                                <td><code>"SELECT name, surname, CONECRT(varchar(500), dod, 3)dob FROM users WHERE
                                        id = " + id + " UNION SELECT address_1, address_2, address_3
                                        FROM address WHERE id = " + id;</code></td>
                            </tr>
                            <tr>
                                <td><a href="Sybase_Get_Implicit_Join?id=1">Sybase_Get_Implicit_Join?id=1</a></td>
                                <td><code>"SELECT * FROM users, address WHERE
                                        users.id = " + id + " AND users.id = address.id";</code></td>
                            </tr>
                            <tr>
                                <td><a href="Sybase_Implicit_Join_Namespace?id=1">Sybase_Implicit_Join_Namespace?id=1</a></td>
                                <td><code>"SELECT * FROM dbo.users, dbo.address WHERE
                                        dbo.users.id = " + id + " AND dbo.users.id = dbo.address.id";</code></td>
                            </tr>
                        </tbody>
                    </table>
                </div>
                <div class="panel-body">
                    <h3>Postgres</h3>
                    <table class="table table-hover">
                        <thead>
                            <tr>
                                <th>Request</th>
                                <th>SQL Statement</th>
                            </tr>
                        </thead>
                        <tbody>
                            <tr>
                                <td><a href="Postgres_Get_string_unicode_identifier?name=wu">Postgres_Get_string_unicode_identifier?name=wu</a></td>
                                <td><code>"SELECT * FROM U&"\0075\0073\0065\0072\0073" WHERE name = '" + name
                                        + "'";</code></td>
                            </tr>
                            <tr>
                                <td><a href="Postgres_Get_Union?id=1">Postgres_Get_Union?id=1</a></td>
                                <td><code>"SELECT name, surname, CAST (dob AS VARCHAR(500)) FROM users WHERE
                                        id = " + id + " UNION SELECT address_1, address_2, address_3
                                        FROM address WHERE id = " + id;</code></td>
                            </tr>
                            <tr>
                                <td><a href="Postgres_Implicit_Join_Namespace?id=1">Postgres_Implicit_Join_Namespace?id=1</a></td>
                                <td><code>"SELECT * FROM public.users, public.address WHERE
                                        public.users.id = " + id + " AND public.users.id = public.address.id";</code></td>
                            </tr>
                        </tbody>
                    </table>
                </div>
            </div>
        </div>

    <%@ include file="footer.jsp" %>
