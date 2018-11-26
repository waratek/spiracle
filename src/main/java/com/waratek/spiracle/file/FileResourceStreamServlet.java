package com.waratek.spiracle.file;

import org.apache.log4j.Logger;

import javax.servlet.ServletContext;
import javax.servlet.ServletException;
import javax.servlet.http.HttpServlet;
import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;
import javax.servlet.http.HttpSession;
import java.io.BufferedReader;
import java.io.IOException;
import java.io.InputStream;
import java.io.InputStreamReader;

/**
 * Servlet implementation class FileResourceStream
 */

public class FileResourceStreamServlet extends HttpServlet {
	private static final Logger logger = Logger.getLogger(FileResourceStreamServlet.class);
	private static final long serialVersionUID = 1L;

	/**
	 * @see HttpServlet#HttpServlet()
	 */
	public FileResourceStreamServlet() {
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
		ServletContext application = this.getServletConfig().getServletContext();
		String filePath = request.getParameter("filePath");
		InputStream inStream = application.getResourceAsStream(filePath);

		if(inStream == null) {
			logger.error("Unable to resolve path: '" + filePath + "'");
			session.setAttribute("fileContents", "Not found");
			response.setStatus(500);
			response.sendRedirect("file.jsp");
		} else {
			logger.info("Found path: '" + filePath + "'");
			session.setAttribute("fileContents", read(inStream));
			response.sendRedirect("file.jsp");
		}
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
