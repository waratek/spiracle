package com.waratek.spiracle.sql.servlet.misc;

import java.io.IOException;
import java.util.HashMap;
import java.util.Map;

import javax.servlet.ServletException;
import javax.servlet.annotation.WebServlet;
import javax.servlet.http.Cookie;
import javax.servlet.http.HttpServlet;
import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;
import javax.servlet.http.HttpSession;

import org.apache.log4j.Logger;

/**
 * Servlet implementation class HttpRequestMethod
 */
@WebServlet("/HttpRequestMethod")
public class HttpRequestMethod extends HttpServlet {
	private static final Logger logger = Logger.getLogger(HttpRequestMethod.class);
	private static final long serialVersionUID = 1L;

	private final String GET_HEADER = "getHeader";
	private final String GET_HEADERS = "getHeaders";
	private final String GET_METHOD = "getMethod";
	private final String GET_PATH_INFO = "getPathInfo";
	private final String GET_PATH_TRANSLATED = "getPathTranslated";
	private final String GET_QUERY_STRING = "getQueryString";
	private final String GET_REQUEST_URI = "getRequestURI";
	private final String GET_REQUEST_URL = "getRequestURL";
	private final String GET_SERVLET_PATH = "getServletPath";

	private final String GET_COMMENT = "getComment";
	private final String GET_NAME = "getName";
	private final String GET_DOMAIN = "getDomain";
	private final String GET_PATH = "getPath";
	private final String GET_VALUE = "getValue";

	private Map<String, Integer> methodMap;

	/**
	 * @see HttpServlet#HttpServlet()
	 */
	public HttpRequestMethod() {
		super();
		methodMap = new HashMap<String, Integer>();

		methodMap.put(GET_HEADER, 0);
		methodMap.put(GET_HEADERS, 1);
		methodMap.put(GET_METHOD, 2);
		methodMap.put(GET_PATH_INFO, 3);
		methodMap.put(GET_PATH_TRANSLATED, 4);
		methodMap.put(GET_QUERY_STRING, 5);
		methodMap.put(GET_REQUEST_URI, 6);
		methodMap.put(GET_REQUEST_URL, 7);
		methodMap.put(GET_SERVLET_PATH, 8);

		methodMap.put(GET_COMMENT, 9);
		methodMap.put(GET_NAME, 10);
		methodMap.put(GET_DOMAIN, 11);
		methodMap.put(GET_PATH, 12);
		methodMap.put(GET_VALUE, 13);
	}

	/**
	 * @see HttpServlet#doGet(HttpServletRequest request, HttpServletResponse response)
	 */
	@Override
	protected void doGet(HttpServletRequest request, HttpServletResponse response) throws ServletException, IOException {
		invoke(request, response);
	}

	/**
	 * @see HttpServlet#doPost(HttpServletRequest request, HttpServletResponse response)
	 */
	@Override
	protected void doPost(HttpServletRequest request, HttpServletResponse response) throws ServletException, IOException {
		invoke(request, response);
	}

	public void invoke(HttpServletRequest request, HttpServletResponse response) throws IOException {
		HttpSession session = request.getSession();
		Cookie [] cookies = request.getCookies();
		String method = request.getParameter("method");
		String arg = request.getParameter("arg");

		String methodReturn = "";

		if(method != null && method.length() != 0) {
			int invokeVar = methodMap.get(method);
			switch (invokeVar) {
			case 0:
				if(arg != null && arg.length() != 0) {
					System.out.println(arg);
					methodReturn = request.getHeader(arg);
					session.setAttribute("methodReturn", methodReturn);
					logger.info(method + " - " + request.getHeader(arg));
				}
				break;
			case 1:
				if(arg != null && arg.length() != 0) {
					methodReturn = request.getHeaders(arg).toString();
					session.setAttribute("methodReturn", methodReturn);
					logger.info(method + " - " + request.getHeaders(arg));
				}
				break;
			case 2:
				methodReturn = request.getMethod();
				session.setAttribute("methodReturn", methodReturn);
				logger.info(method + " - " + request.getMethod());
				break;
			case 3:
				methodReturn = request.getPathInfo();
				session.setAttribute("methodReturn", methodReturn);
				logger.info(method + " - " + request.getPathInfo());
				break;
			case 4:
				methodReturn = request.getPathTranslated();
				session.setAttribute("methodReturn", methodReturn);
				logger.info(method + " - " + request.getPathTranslated());
				break;
			case 5:
				methodReturn = request.getQueryString();
				session.setAttribute("methodReturn", methodReturn);
				logger.info(method + " - " + request.getQueryString());
				break;
			case 6:
				methodReturn = request.getRequestURI();
				session.setAttribute("methodReturn", methodReturn);
				logger.info(method + " - " + request.getRequestURI());
				break;
			case 7:
				methodReturn = request.getRequestURL().toString();
				session.setAttribute("methodReturn", methodReturn);
				logger.info(method + " - " + request.getRequestURL());
				break;
			case 8:
				methodReturn = request.getServletPath();
				session.setAttribute("methodReturn", methodReturn);
				logger.info(method + " - " + request.getServletPath());
				break;
			case 9:
				if(cookies.length > 0) {
					methodReturn = cookies[0].getComment();
					session.setAttribute("methodReturn", methodReturn);
					logger.info(method + " - " + cookies[0].getComment());
				}
				break;
			case 10:
				if(cookies.length > 0) {
					methodReturn = cookies[0].getName();
					session.setAttribute("methodReturn", methodReturn);
					logger.info(method + " - " + cookies[0].getName());
				}
				break;
			case 11:
				if(cookies.length > 0) {
					methodReturn = cookies[0].getDomain();
					session.setAttribute("methodReturn", methodReturn);
					logger.info(method + " - " + cookies[0].getDomain());
				}
				break;
			case 12:
				if(cookies.length > 0) {
					methodReturn = cookies[0].getPath();
					session.setAttribute("methodReturn", methodReturn);
					logger.info(method + " - " + cookies[0].getPath());
				}
				break;
			case 13:
				if(cookies.length > 0) {
					methodReturn = cookies[0].getValue();
					session.setAttribute("methodReturn", methodReturn);
					logger.info(method + " - " + cookies[0].getValue());
				}
				break;
			default:
				break;
			}
		}
		response.sendRedirect("misc.jsp");
	}
}
