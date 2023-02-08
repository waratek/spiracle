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
import java.util.ArrayList;

import javax.servlet.ServletContext;
import javax.servlet.ServletOutputStream;
import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;

import org.apache.log4j.Logger;

public class SelectUtil {
	private static final Logger logger = Logger.getLogger(SelectUtil.class);


	private static void executeQuery(
			String sql, ServletContext application, HttpServletRequest request, HttpServletResponse response, Boolean showErrors, Boolean allResults, Boolean showOutput, boolean setString)
			throws IOException
	{
		response.setHeader("Content-Type", "text/html;charset=UTF-8");
		ServletOutputStream out = response.getOutputStream();
		Connection con = null;
		int fetchSize = getFetchSize(application);

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
			if (setString){
				stmt.setString(1, "something");
				logger.info("Substituted parameter in PreparedStatement: " + sql);
			}
			executePreparedStatement(stmt, fetchSize, sql, out, allResults, showOutput);
		} catch(SQLException sqlexception) {
			verifySQLException(sqlexception, application, response, out);
		} finally {
			cleanup(stmt, con);
			TagUtil.printPageFooter(out);
			out.close();
		}
	}

	public static void executeQuery(
			String sql, ServletContext application, HttpServletRequest request, HttpServletResponse response, Boolean showErrors, Boolean allResults, Boolean showOutput)
			throws IOException
	{
		boolean setString = false;
		executeQuery(sql, application, request, response, showErrors, allResults, showOutput, setString);
	}

	public static void executeQuerySetString(String sql, ServletContext application, HttpServletRequest request, HttpServletResponse response, Boolean showErrors, Boolean allResults, Boolean showOutput) throws IOException {
		boolean setString = true;
		executeQuery(sql, application, request, response, showErrors, allResults, showOutput, setString);
	}

	public static ArrayList<ArrayList<Object>> executeQueryWithoutNewPage(String sql, ServletContext application, HttpServletRequest request)
			throws IOException, SQLException
	{
		Connection con = null;
		PreparedStatement stmt = null;
		ArrayList<ArrayList<Object>> resultList;
		try {
			con = ConnectionUtil.getConnection(application, request);
			logger.info(sql);
			stmt = con.prepareStatement(sql);
			logger.info("Created PreparedStatement: " + sql);
			ResultSet rs = executePreparedStatementWithoutWriting(stmt, getFetchSize(application), sql);
			resultList = convertResultSetToList(rs);
		} finally {
			cleanup(stmt, con);
		}
		return resultList;
	}

	private static Integer getFetchSize(ServletContext application) {
		return (Integer) application.getAttribute(Constants.JDBC_FETCH_SIZE);
	}

	private static void executePreparedStatement(PreparedStatement stmt, int fetchSize, String sql, ServletOutputStream out, Boolean allResults, Boolean showOutput)
			throws IOException, SQLException
	{
		boolean shouldWriteToResponse = true;
		executePreparedStatement(stmt, fetchSize, sql, out, allResults, showOutput, shouldWriteToResponse);
	}

	private static ResultSet executePreparedStatement(
			PreparedStatement stmt, int fetchSize, String sql, ServletOutputStream out, boolean allResults, boolean showOutput, boolean shouldWriteToResponse)
			throws IOException, SQLException
	{
		stmt.setFetchSize(fetchSize);
		ResultSet rs = stmt.executeQuery();
		logger.info("Executed: " + sql);

		if (shouldWriteToResponse)
		{
			writeToResponse(allResults, showOutput, out, rs);
		}
		return rs;
	}

	private static ResultSet executePreparedStatementWithoutWriting(PreparedStatement stmt, int fetchSize, String sql)
			throws IOException, SQLException
	{
		ServletOutputStream out = null;
		boolean allResults = false;
		boolean showOutput = false;
		boolean shouldWriteToResponse = false;

		return executePreparedStatement(stmt, fetchSize, sql, out, allResults, showOutput, shouldWriteToResponse);
	}

	private static ArrayList<ArrayList<Object>> convertResultSetToList(ResultSet rs) throws SQLException
	{
		ArrayList<ArrayList<Object>> resultList = new ArrayList<ArrayList<Object>>();
		int columnCount = rs.getMetaData().getColumnCount();
		while (rs.next())
		{
			ArrayList<Object> resultRow = new ArrayList<Object>();
			for (int i = 1; i <= columnCount; i++)
			{
				resultRow.add(rs.getObject(i));
			}
			resultList.add(resultRow);
		}
		return resultList;
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
	}

	private static void writeRow(ServletOutputStream out, ResultSet rs, ResultSetMetaData metaData) throws IOException, SQLException {
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

	public static void verifySQLException(SQLException sqlexception, ServletContext application, HttpServletResponse response, ServletOutputStream out) throws IOException{
		if(sqlexception.getMessage().equals("Attempted to execute a query with one or more bad parameters.")) {
			int error = Integer.parseInt((String) application.getAttribute("defaultError"));
			response.setStatus(error);
		} else {
			response.setStatus(500);
		}

		out.println("<div class=\"alert alert-danger\" role=\"alert\">");
		out.println("<strong>SQLException:</strong> " + sqlexception.getMessage() + "<BR>");

		if(logger.isDebugEnabled()) {
			logger.debug(sqlexception.getMessage(), sqlexception);
		} else {
			logger.error(sqlexception);
		}

		while((sqlexception = sqlexception.getNextException()) != null) {
			out.println(sqlexception.getMessage() + "<BR>");
	    }
	}

	public static void cleanup(PreparedStatement stmt, Connection con) {
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
	}
}
