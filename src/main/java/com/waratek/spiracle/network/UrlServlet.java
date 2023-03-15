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
package com.waratek.spiracle.network;

import com.waratek.spiracle.filepaths.FilePathUtil;

import javax.servlet.ServletException;
import javax.servlet.annotation.WebServlet;
import javax.servlet.http.HttpServlet;
import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;
import javax.servlet.http.HttpSession;
import java.io.IOException;
import java.io.PrintWriter;
import java.io.StringWriter;
import java.net.MalformedURLException;
import java.net.URL;
import java.net.URLConnection;
import java.net.UnknownHostException;
import java.util.Scanner;

/**
 * Servlet implementation class UrlServlet
 */
@WebServlet("/UrlServlet")
public class UrlServlet extends HttpServlet {
	private static final long serialVersionUID = 1L;

	/**
	 * @see HttpServlet#HttpServlet()
	 */
	public UrlServlet() {
		super();
		// TODO Auto-generated constructor stub
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

	private void executeRequest(HttpServletRequest request, HttpServletResponse response) throws IOException {
		final HttpSession session = request.getSession();
		final String urlPath = request.getParameter("urlPath");
		final String urlSource = request.getParameter("urlSource");
		final String taintedUrlPath = FilePathUtil.forcePathSource(urlPath, urlSource, request);

		session.setAttribute("urlContents", readUrl(taintedUrlPath));
		response.sendRedirect("network.jsp");
	}

	private String readUrl(String pathname) throws IOException {
		try {
			URLConnection con = new URL(pathname).openConnection();
			Scanner scanner = new Scanner(con.getInputStream());
			StringBuilder fileContents = new StringBuilder();
			String lineSeparator = System.getProperty("line.separator");

			try {
				while(scanner.hasNextLine()) {
					fileContents.append(scanner.nextLine() + lineSeparator);
				}
				return fileContents.toString();
			} finally {
				scanner.close();
			}
		} catch (MalformedURLException e) {
			e.printStackTrace();
			return "Please enter a valid URL";
		} catch (UnknownHostException e) {
			e.printStackTrace();
			return "Please enter a valid URL";
		} catch (Exception e) {
			e.printStackTrace();
			return getStackTraceString(e);
		}
	}

	private static String getStackTraceString(Exception e) {
		StringWriter stringWriter = new StringWriter();
		PrintWriter printWriter = new PrintWriter(stringWriter);
		e.printStackTrace(printWriter);
		return stringWriter.toString();

	}
}
