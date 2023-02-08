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
package com.waratek.spiracle.file;

import com.waratek.spiracle.sql.util.SelectUtil;
import com.waratek.spiracle.sql.util.UpdateUtil;

import javax.servlet.ServletContext;
import javax.servlet.annotation.WebServlet;
import javax.servlet.http.HttpServlet;
import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;
import javax.servlet.http.HttpSession;
import java.io.IOException;
import java.sql.SQLException;
import java.util.ArrayList;

/**
 * Servlet for performing read/write operations on a filepath from a database source.
 * To achieve this, the filepath is first written to a database, then read back out.
 */
@WebServlet("/FileFromDatabaseServlet")
public class FileFromDatabaseServlet extends AbstractFileServlet {

	/**
	 * @see HttpServlet#HttpServlet()
	 */
	public FileFromDatabaseServlet() {
		super();
	}


	protected void executeRequest(HttpServletRequest request, HttpServletResponse response) throws IOException	{
		putFilePathInDatabase(request);
		final String pathFromDatabase = retrieveFilePathFromDatabase(request);

		performFileAction(request, pathFromDatabase);
		response.sendRedirect("file.jsp");
	}

	private void putFilePathInDatabase(HttpServletRequest request)
	{
		final ServletContext application = this.getServletConfig().getServletContext();
		final String filePath = request.getParameter("fileFromDatabasePath");
		dropFilePathTableIfExists(application, request);
		final String sqlCreateTable = "CREATE TABLE FilePath (path varchar(255));";
		final String sqlInsertPath = "INSERT INTO FilePath VALUES('" + filePath + "');";
		try	{
			UpdateUtil.executeUpdateWithoutNewPage(sqlCreateTable, application, request);
			UpdateUtil.executeUpdateWithoutNewPage(sqlInsertPath, application, request);
		}
		catch (SQLException e)
		{
			logger.error(e.getMessage());
			throw new RuntimeException(e);
		}
	}

	private String retrieveFilePathFromDatabase(HttpServletRequest request) throws IOException
	{
		final ServletContext application = this.getServletConfig().getServletContext();
		final String sqlSelect = "SELECT * FROM FilePath";
		ArrayList<ArrayList<Object>> resultList;
		try
		{
			resultList = SelectUtil.executeQueryWithoutNewPage(sqlSelect, application, request);
		}
		catch (SQLException e)
		{
			logger.error(e.getMessage());
			throw new RuntimeException(e);
		}
		return resultList.get(0).get(0).toString();
	}

	private static void dropFilePathTableIfExists(ServletContext application, HttpServletRequest request)
	{
		final String sqlDropTable = "DROP TABLE FilePath;";
		try {
			UpdateUtil.executeUpdateWithoutNewPage(sqlDropTable, application, request);
		}
		catch (SQLException e)
		{
			logger.info("'" + sqlDropTable + "' failed, probably the table doesn't exist. Error msg = " + e.getMessage());
		}
	}
}
