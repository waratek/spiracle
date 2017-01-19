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
import java.sql.ResultSet;
import java.sql.ResultSetMetaData;
import java.sql.SQLException;

import javax.servlet.ServletContext;
import javax.servlet.ServletOutputStream;
import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;

import org.apache.log4j.Logger;

public class SelectUtil {
	private static final Logger logger = Logger.getLogger(SelectUtil.class);


	public static void executeQuery(String sql, ServletContext application, HttpServletRequest request, HttpServletResponse response, Boolean showErrors, Boolean allResults, Boolean showOutput) throws IOException {
		response.setHeader("Content-Type", "text/html;charset=UTF-8");
		ServletOutputStream out = response.getOutputStream();
		String connectionType = null;
		Connection con = null;
		int fetchSize = (Integer) application.getAttribute(Constants.JDBC_FETCH_SIZE);
		String defaultConnection = (String) application.getAttribute(Constants.DEFAULT_CONNECTION);

		PreparedStatement stmt = null;
		ResultSet rs = null;

		TagUtil.printPageHead(out);
		TagUtil.printPageNavbar(out);
		TagUtil.printContentDiv(out);

		try {
			//Checking if connectionType is set, defaulting it to c3p0 if not set.
			if(request.getParameter("connectionType") == null) {
				connectionType = defaultConnection;
			} else {
				connectionType = request.getParameter("connectionType");
			}
			con = ConnectionUtil.getConnection(application, connectionType);
			out.println("<div class=\"panel-body\">");
			out.println("<h1>SQL Query:</h1>");
			out.println("<pre>");
			out.println(sql);
			out.println("</pre>");

			logger.info(sql);

			stmt = con.prepareStatement(sql);
			logger.info("Created PreparedStatement: " + sql);
			stmt.setFetchSize(fetchSize);
			rs = stmt.executeQuery();
			logger.info("Executed: " + sql);

			writeToResponse(allResults, showOutput, out, rs);
		} catch(SQLException e) {
			if(e.getMessage().equals("Attempted to execute a query with one or more bad parameters.")) {
                int error = Integer.parseInt((String) application.getAttribute("defaultError"));
				response.setStatus(error);
			} else {
				response.setStatus(500);
			}
			out.println("<div class=\"alert alert-danger\" role=\"alert\">");
			out.println("<strong>SQLException:</strong> " + e.getMessage() + "<BR>");
			if(logger.isDebugEnabled()) {
				logger.debug(e.getMessage(), e);
			} else {
				logger.error(e);
			}
			while((e = e.getNextException()) != null) {
				out.println(e.getMessage() + "<BR>");
			}
		} finally {
			try {
				if(rs != null) {
					logger.info("Closing ResultSet " + rs);
					rs.close();
					logger.info("Closed ResultSet " + rs);
				}
			} catch (SQLException rsCloseException) {
				if(logger.isDebugEnabled()) {
					logger.debug(rsCloseException.getMessage(), rsCloseException);
				} else {
					logger.error(rsCloseException);
				}
			}
			try {
				if(stmt != null) {
					logger.info("Closing PreparedStatement " + stmt);
					stmt.close();
					logger.info("Closed PreparedStatement " + stmt);
				}
			} catch (SQLException stmtCloseException) {
				if(logger.isDebugEnabled()) {
					logger.debug(stmtCloseException.getMessage(), stmtCloseException);
				} else {
					logger.error(stmtCloseException);
				}
			}
			try {
				if(con != null) {
					logger.info("Closing Connection " + con);
					con.close();
					logger.info("Closed Connection " + con);
				}
			} catch (SQLException conCloseException) {
				if(logger.isDebugEnabled()) {
					logger.debug(conCloseException.getMessage(), conCloseException);
				} else {
					logger.error(conCloseException);
				}
			}
			TagUtil.printPageFooter(out);
			out.close();
		}
	}

	private static void writeToResponse(Boolean allResults, Boolean showOutput, ServletOutputStream out, ResultSet rs) throws SQLException, IOException {
		ResultSetMetaData metaData = rs.getMetaData();

		out.println("<h1>Results:</h1>");
		out.println("<TABLE CLASS=\"table table-bordered table-striped\">");
		out.println("<TR>");
		for(int i = 1; i <= metaData.getColumnCount(); i++) {
			String colName = metaData.getColumnName(i);
			out.print("<TH>" + colName + "</TH>");
		}
		out.println("</TR>");

		//Matching sqlmap's testenv option to suppress output
		if(showOutput) {
			//Matching sqlmap's testenv partial output option.
			if(allResults) {
				while(rs.next()) {
					writeRow(out, rs, metaData);
				}
			} else {
				rs.next();
				writeRow(out, rs, metaData);
			}
		}

		out.println("</TABLE>");
		TagUtil.printPageFooter(out);
	}

	private static void 	(ServletOutputStream out, ResultSet rs, ResultSetMetaData metaData) throws IOException, SQLException {
		out.println("<TR>");
		for(int i = 1; i <= metaData.getColumnCount(); i++) {
			Object content = rs.getObject(i);
			if(content != null) {
				out.println("<TD>" + content.toString() + "</TD>");
			} else {
				out.println("<TD></TD>");
			}
		}
		out.println("</TR>");
	}
}
