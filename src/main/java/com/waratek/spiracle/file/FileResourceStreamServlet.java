package com.waratek.spiracle.file;

import java.io.IOException;
import java.io.InputStream;
import java.io.UnsupportedEncodingException;
import java.util.ArrayList;
import java.util.List;

import javax.servlet.ServletContext;
import javax.servlet.ServletException;
import javax.servlet.annotation.WebServlet;
import javax.servlet.http.HttpServlet;
import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;
import javax.servlet.http.HttpSession;

import org.apache.log4j.Logger;

/**
 * Servlet implementation class FileResourceStream
 */
@WebServlet("/FileResourceStreamServlet")
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
	@Override
	protected void doGet(HttpServletRequest request, HttpServletResponse response) throws ServletException, IOException {
		executeRequest(request, response);
	}

	/**
	 * @see HttpServlet#doPost(HttpServletRequest request, HttpServletResponse response)
	 */
	@Override
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

	private String read(InputStream inStream) throws IOException, UnsupportedEncodingException {
		List<Byte> byteList = new ArrayList<Byte>();
		int streamBuf = inStream.read();
		while(streamBuf != -1) {
			byteList.add(new Byte((byte) streamBuf));
			streamBuf = inStream.read();
		}
		byte [] byteArr = new byte[byteList.size()];
		for(int i = 0; i < byteList.size(); i++) {
			byteArr[i] = byteList.get(i).byteValue();
		}

		return new String(byteArr, "UTF-8");
	}
}
