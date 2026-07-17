package com.waratek.spiracle.reflect;

import org.apache.log4j.Logger;

import javax.servlet.ServletException;

import javax.servlet.annotation.WebServlet;
import javax.servlet.http.HttpServlet;
import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;
import javax.servlet.http.HttpSession;
import java.io.BufferedWriter;
import java.io.File;
import java.io.FileWriter;
import java.io.IOException;
import java.lang.reflect.Field;
import java.lang.reflect.Method;
import java.util.Scanner;

@WebServlet("/ReflectServlet")
public class ReflectServlet extends HttpServlet {

	public String field1; 
	protected static final Logger logger = Logger.getLogger(ReflectServlet.class);
	private static final long serialVersionUID = 1L;
	private static final String REFLECT_SERVLET_FQCN = "com.waratek.spiracle.reflect.ReflectServlet";

	/**
	 * @see HttpServlet#HttpServlet()
	 */
	public ReflectServlet() {
		super();
	}

	/**
	 * @see HttpServlet#doGet(HttpServletRequest request, HttpServletResponse response)
	 */
	protected void doGet(HttpServletRequest request, HttpServletResponse response) throws ServletException, IOException{
		executeRequest(request, response);
	}

	/**
	 * @see HttpServlet#doPost(HttpServletRequest request, HttpServletResponse response)
	 */
	protected void doPost(HttpServletRequest request, HttpServletResponse response) throws ServletException, IOException{
		executeRequest(request, response);
	}

	protected void executeRequest(HttpServletRequest request, HttpServletResponse response) throws IOException{
		final String userProvidedInput = request.getParameter("testInput");
		final String reflectionOperation = request.getParameter("reflectArg");
		final String inputSource = request.getParameter("inputSource");
		final String taintedInput = com.waratek.spiracle.filepaths.FilePathUtil.forcePathSource(userProvidedInput, inputSource, request);

		try{
			performReflection(request, taintedInput, reflectionOperation);
		}
		catch (Exception e){
			logger.info("Exception occured during reflection call " + e);
		}
		response.sendRedirect("reflect.jsp");
	}

	protected void performReflection(HttpServletRequest request, String testInput, String reflectionOperation) throws ClassNotFoundException, NoSuchMethodException, NoSuchFieldException
	{
		final HttpSession session = request.getSession();
		session.setAttribute("textPanelContents", "");

		if (reflectionOperation.equals("classForName")) {
		    Class myClass = Class.forName(testInput);
		}
		else if (reflectionOperation.equals("classLoaderLoadClass")) {
		    Class<?> clazz = ClassLoader.getSystemClassLoader().loadClass(testInput);
		}
		else if (reflectionOperation.equals("classGetMethod")) {
		    Class myClass = Class.forName(REFLECT_SERVLET_FQCN);
		    Method myMethod = myClass.getMethod(testInput);
		}
		else if (reflectionOperation.equals("classGetDeclaredMethod")) {
		    Class myClass = Class.forName(REFLECT_SERVLET_FQCN);
		    Method myMethod = myClass.getDeclaredMethod(testInput, new Class[0]);
		}
		else if (reflectionOperation.equals("classGetDeclaredMethod_StringArg")) {
		    Class myClass = Class.forName(REFLECT_SERVLET_FQCN);
		    Method myMethod = myClass.getDeclaredMethod(testInput, String.class);
		}
		else if (reflectionOperation.equals("classGetField")) {
		    Class myClass = Class.forName(REFLECT_SERVLET_FQCN);
		    Field myField = myClass.getField(testInput);
		}
		else if (reflectionOperation.equals("classGetDeclaredField")) {
		    Class myClass = Class.forName(REFLECT_SERVLET_FQCN);
		    Field myField = myClass.getDeclaredField(testInput);
		}
		else {
			throw new RuntimeException("Unknown reflectionOperation: " + reflectionOperation);
		}

		session.setAttribute("textPanelContents", "Finished reflection operation " + reflectionOperation);
	}

	public void method1() {}

	public static int method2() {
        return 1;
    }

	private String method3(String s1) {
        return "Hello " + s1;
    }
}
