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
 * Servlet implementation class FileServlet
 */
@WebServlet("/FileServlet")
public class FileServlet extends AbstractFileServlet {

	/**
	 * @see HttpServlet#HttpServlet()
	 */
	public FileServlet() {
		super();
		// TODO Auto-generated constructor stub
	}


	protected void executeRequest(HttpServletRequest request, HttpServletResponse response) throws IOException {
		final String userProvidedPath = request.getParameter("filePath");
		final String method = request.getParameter("fileArg");
		final String textData = request.getParameter("fileText");
		final String pathSource = request.getParameter("pathSource");
		final String taintedPath = FilePathUtil.forcePathSource(userProvidedPath, pathSource, request);

		performFileAction(request, taintedPath, method, textData);
		response.sendRedirect("file.jsp");
	}
}
