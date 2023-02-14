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

import java.io.BufferedWriter;
import java.io.File;
import java.io.FileWriter;
import java.io.IOException;
import java.util.Scanner;

import javax.servlet.ServletException;
import javax.servlet.annotation.WebServlet;
import javax.servlet.http.HttpServlet;
import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;
import javax.servlet.http.HttpSession;

import okhttp3.Call;
import okhttp3.FormBody;
import okhttp3.OkHttpClient;
import okhttp3.Request;
import okhttp3.RequestBody;
import okhttp3.Response;
import org.apache.log4j.Logger;

/**
 * Servlet implementation class FileServlet
 */
@WebServlet("/FileServlet")
public class FileServlet extends HttpServlet {
	private static final Logger logger = Logger.getLogger(FileServlet.class);
	private static final long serialVersionUID = 1L;

	/**
	 * @see HttpServlet#HttpServlet()
	 */
	public FileServlet() {
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
		logger.info("DEBUG: Making HTTP GET request at start of FileServlet request handling");
		okHttpGet("http://www.google.com/");
		logger.info("DEBUG: Making HTTPS GET request at start of FileServlet request handling");
		okHttpGet("https://www.google.com/");
		logger.info("DEBUG: Making HTTP POST request at start of FileServlet request handling");
		okHttpPost("http://www.google.com/");
		logger.info("DEBUG: Making HTTPS POST request at start of FileServlet request handling");
		okHttpPost("https://www.google.com/");
		HttpSession session = request.getSession();

		String method = request.getParameter("fileArg");
		String path = request.getParameter("filePath");
		String textData = request.getParameter("fileText");

		if(method.equals("read")) {
			read(session, path);
		} else if(method.equals("write")) {
			write(session, path, textData);
		} else if(method.equals("delete")) {
			delete(session, path);
		}

		logger.info(method + " " + path + " " + textData);

		response.sendRedirect("file.jsp");
	}

	private void okHttpGet(String url) throws IOException
	{
		logger.info("DEBUG: GET URL: " + url);
		OkHttpClient client = new OkHttpClient.Builder().build();
		Request okhttpRequest = new Request.Builder()
				.url(url)
				.build();

		Call call = client.newCall(okhttpRequest);
		Response okHttpResponse = call.execute();
		logger.info("DEBUG: Response code: " + okHttpResponse.code());
	}

	private void okHttpPost(String url) throws IOException
	{
		logger.info("DEBUG: POST URL: " + url);
		OkHttpClient client = new OkHttpClient.Builder().build();
		RequestBody formBody = new FormBody.Builder()
				.add("username", "test")
				.add("password", "test")
				.build();

		Request okhttpRequest = new Request.Builder()
				.url(url)
				.post(formBody)
				.build();

		Call call = client.newCall(okhttpRequest);
		Response okHttpResponse = call.execute();
		logger.info("DEBUG: Response code: " + okHttpResponse.code());
	}

	private void delete(HttpSession session, String path) {
		File f = new File(path);
		f.delete();
		session.setAttribute("fileContents", "");
	}

	private void read(HttpSession session, String path) {
		session.setAttribute("fileContents", readFile(path));
	}

	private void write(HttpSession session, String path, String textData)
			throws IOException {
		File f = new File(path);
		FileWriter fw = new FileWriter(f);
		BufferedWriter bw = new BufferedWriter(fw);
		bw.write(textData);
		bw.close();
		fw.close();

		read(session, path);
	}

	private String readFile(String pathname) {
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
}
