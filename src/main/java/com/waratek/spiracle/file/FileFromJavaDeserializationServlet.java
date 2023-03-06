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
 * Servlet for performing read/write operations on a filepath from a deserialization source.
 * To achieve this, the filepath is first serialized, then deserialized back out
 */
@WebServlet("/FileFromJavaDeserializationServlet")
public class FileFromJavaDeserializationServlet extends AbstractFileServlet {

	/**
	 * @see HttpServlet#HttpServlet()
	 */
	public FileFromJavaDeserializationServlet() {
		super();
	}


	protected void executeRequest(HttpServletRequest request, HttpServletResponse response) throws IOException {
		final String userProvidedPath = request.getParameter("fileJavaDeserializationPath");
		final String deserializedPath = FilePathUtil.javaSerializeAndDeserializePath(userProvidedPath);
		final String method = request.getParameter("fileJavaDeserializationArg");
		final String textData = "Writing text to path from source: Java deserialization";

		performFileAction(request, deserializedPath, method, textData);
		response.sendRedirect("file.jsp");
	}

}
