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

import org.apache.log4j.Logger;

import javax.servlet.ServletException;
import javax.servlet.http.HttpServlet;
import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;
import javax.servlet.http.HttpSession;
import java.io.BufferedWriter;
import java.io.File;
import java.io.FileWriter;
import java.io.IOException;
import java.util.Scanner;

/**
 * Abstract class to contain common functionality of File Servlets
 */
public abstract class AbstractFileServlet extends HttpServlet {
	protected static final Logger logger = Logger.getLogger(AbstractFileServlet.class);
	protected static final long serialVersionUID = 1L;

	/**
	 * @see HttpServlet#HttpServlet()
	 */
	protected AbstractFileServlet() {
		super();
	}

	/**
	 * @see HttpServlet#doGet(HttpServletRequest request, HttpServletResponse response)
	 */
	protected void doGet(HttpServletRequest request, HttpServletResponse response) throws ServletException, IOException {
		executeRequest(request, response);
	}

	/**
	 * @see HttpServlet#doPost(HttpServletRequest request, HttpServletResponse response)
	 */
	protected void doPost(HttpServletRequest request, HttpServletResponse response) throws ServletException, IOException {
		executeRequest(request, response);
	}

	protected abstract void executeRequest(HttpServletRequest request, HttpServletResponse response) throws IOException;

	protected void delete(HttpSession session, String path) {
		File f = new File(path);
		f.delete();
		session.setAttribute("fileContents", "");
	}

	protected void read(HttpSession session, String path) {
		session.setAttribute("fileContents", readFile(path));
	}

	protected void write(HttpSession session, String path, String textData)
			throws IOException {
		logger.info("Attempting to write '" + textData + "'at filepath: " + path);
		File f = new File(path);
		FileWriter fw = null;
		BufferedWriter bw = null;
		try
		{
			fw = new FileWriter(f);
			bw = new BufferedWriter(fw);
			bw.write(textData);
		}
		finally
		{
			if (bw != null) {
				bw.close();
			}
			if (fw != null)
			{
				fw.close();
			}
		}

		read(session, path);
	}

	protected String readFile(String pathname) {
		try {
			File file = new File(pathname);
			StringBuilder fileContents = new StringBuilder((int)file.length());
			Scanner scanner = new Scanner(file);
			String lineSeparator = System.getProperty("line.separator");

			try {
				while(scanner.hasNextLine()) {
					fileContents.append(scanner.nextLine() + lineSeparator);
				}
				return fileContents.toString();
			} finally {
				scanner.close();
			}
		} catch (IOException e) {
			e.printStackTrace();
			return e.getMessage();
		}
	}

	protected void performFileAction(HttpServletRequest request, String path, String method) throws IOException {
		performFileAction(request, path, method, "");
	}

	protected void performFileAction(HttpServletRequest request, String path, String method, String textData) throws IOException
	{
		final HttpSession session = request.getSession();
		if (method.equals("read")) {
			read(session, path);
		} else if (method.equals("write")) {
			write(session, path, textData);
		} else if (method.equals("delete")) {
			delete(session, path);
		} else {
			throw new RuntimeException("Unknown file method: " + method);
		}

		logger.info(method + " " + path + " " + textData);
	}
}
