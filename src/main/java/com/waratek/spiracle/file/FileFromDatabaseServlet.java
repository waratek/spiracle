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

import com.waratek.spiracle.filepaths.FilePathUtil;

import javax.servlet.annotation.WebServlet;
import javax.servlet.http.HttpServlet;
import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;
import java.io.IOException;

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
		final String method = request.getParameter("fileFromDatabaseArg");
		final String filePath = request.getParameter("fileFromDatabasePath");
		final String textData = "Writing text to path from source: Database";

		FilePathUtil.putFilePathInDatabase(filePath, request);
		final String pathFromDatabase = FilePathUtil.retrieveFilePathFromDatabase(request);

		performFileAction(request, pathFromDatabase, method, textData);
		response.sendRedirect("file.jsp");
	}


}
