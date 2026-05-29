/*
 *  Copyright 2014 Waratek Ltd.
 *
 *  Licensed under the Apache License, Version 2.0 (the "License");
 *  you may not use this file except in compliance with the License.
 *  You may obtain a copy of the License at
 *
 *      http://www.apache.org/licenses/LICENSE-2.0
 *
 *  Unless required by applicable law or agreed to in writing, software
 *  distributed under the License is distributed on an "AS IS" BASIS,
 *  WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied.
 *  See the License for the specific language governing permissions and
 *  limitations under the License.
 */
package com.waratek.spiracle.sql.util;

import java.io.IOException;
import java.sql.Connection;
import java.sql.PreparedStatement;
import java.sql.SQLException;

import javax.servlet.ServletContext;
import javax.servlet.ServletOutputStream;
import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;

import org.apache.log4j.Logger;

public class UpdateUtil {
	private static final Logger logger = Logger.getLogger(UpdateUtil.class);

	public static void executeUpdate(String sql, ServletContext application, HttpServletRequest request, HttpServletResponse response) throws IOException{
		response.setHeader("Content-Type", "text/html;charset=UTF-8");
		ServletOutputStream out = response.getOutputStream();
		Connection con = null;

		PreparedStatement stmt = null;

		TagUtil.printPageHead(out);
		TagUtil.printPageNavbar(out);
		TagUtil.printContentDiv(out);

		try {
			con = ConnectionUtil.getConnection(application, request);
			out.println("<div class=\"panel-body\">");
			out.println("<h1>SQL Query:</h1>");
			out.println("<pre>");
			out.println(sql);
			out.println("</pre>");

			logger.info(sql);

			stmt = con.prepareStatement(sql);
			logger.info("Created PreparedStatement: " + sql);
			int result = stmt.executeUpdate();
			logger.info("Executed: " + sql);

			out.println("<h1>Altered Rows:</h1>");
			out.print("<pre>" + result + "</pre>");
		} catch(SQLException e) {
			SelectUtil.verifySQLException(e, application, response, out);
		} finally {
			SelectUtil.cleanup(stmt, con);

			out.println("</DIV>");
			TagUtil.printPageFooter(out);
			out.close();
		}
	}

	public static void executeUpdateWithoutNewPage(String sql, ServletContext application, HttpServletRequest request)
			throws SQLException
	{
		PreparedStatement stmt = null;
		Connection con = null;
		try {
			con = ConnectionUtil.getConnection(application, request);
			logger.info(sql);
			stmt = con.prepareStatement(sql);
			logger.info("Created PreparedStatement: " + sql);
			int result = stmt.executeUpdate();
			logger.info("Executed: " + sql);
			logger.info("Query result: " + result);
		} finally {
			SelectUtil.cleanup(stmt, con);
		}
	}
}
