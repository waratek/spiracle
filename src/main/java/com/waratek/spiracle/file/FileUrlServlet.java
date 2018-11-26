package com.waratek.spiracle.file;

import org.apache.log4j.Logger;

import javax.servlet.ServletException;
import javax.servlet.http.HttpServlet;
import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;
import javax.servlet.http.HttpSession;
import java.io.BufferedReader;
import java.io.IOException;
import java.io.InputStream;
import java.io.InputStreamReader;
import java.net.MalformedURLException;
import java.net.URL;
import java.net.URLConnection;

/**
 * Servlet implementation class FileUrlServlet
 */

public class FileUrlServlet extends HttpServlet {
	private static final Logger logger = Logger.getLogger(FileUrlServlet.class);
	private static final long serialVersionUID = 1L;

	/**
	 * @see HttpServlet#HttpServlet()
	 */
	public FileUrlServlet() {
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
		HttpSession session = request.getSession();

		String path = request.getParameter("filePath");

		InputStream inStream = getUrlInputStream(path);
		if(inStream == null) {
			String errorMessage = "Unable to resolve path: '" + path + "'";
			logger.error(errorMessage);
			session.setAttribute("fileContents", "Unable to resolve path: '" + path + "'");
			response.setStatus(500);
			response.sendRedirect("file.jsp");
		} else {
			logger.info("Found path: '" + path + "'");
			session.setAttribute("fileContents", read(inStream));
			response.sendRedirect("file.jsp");
		}
	}

	private InputStream getUrlInputStream(String path) throws IOException {
		URL url = new URL(path);
		URLConnection con = url.openConnection();
		return con.getInputStream();
	}

	private String read(InputStream inStream) throws IOException {
		BufferedReader br = null;
		String out = "";

		String line;
		try {

			br = new BufferedReader(new InputStreamReader(inStream));
			while ((line = br.readLine()) != null) {
				out += line;
			}

		} finally {
			if (br != null) {
				try {
					br.close();
				} catch (IOException e) {
					e.printStackTrace();
				}
			}
		}

		return out;
	}
}
