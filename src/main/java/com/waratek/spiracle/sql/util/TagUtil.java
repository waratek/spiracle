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
package com.waratek.spiracle.sql.util;

import java.io.BufferedReader;
import java.io.File;
import java.io.FileReader;
import java.io.IOException;

import javax.servlet.ServletOutputStream;

public class TagUtil {
	static void printPageHead(ServletOutputStream out) throws IOException {
		out.println("<!DOCTYPE html>");
		out.println("<html>");
		out.println("<head>");
		out.println("<meta http-equiv=\"Content-Type\" content=\"text/html; charset=UTF-8\">");
		out.println("<link rel=\"stylesheet\" type=\"text/css\" href=\"css/bootstrap.min.css\">");
		out.println("<link rel=\"stylesheet\" type=\"text/css\" href=\"css/bootstrap-theme.min.css\">");
		out.println("<link rel=\"stylesheet\" type=\"text/css\" href=\"css/style.css\">");

		out.println("<title>Spiracle - SQL</title>");
		out.println("</head>");
		out.println("<body>");
	}

	static void printPageNavbar(ServletOutputStream out) throws IOException {
		out.println("<div class=\"navbar navbar-default navbar-fixed-top\" role=\"navigation\">");
		out.println("<div class=\"container\">");
		out.println("<div class=\"navbar-header\">");
		out.println("<button type=\"button\" class=\"navbar-toggle collapsed\" data-toggle=\"collapse\" data-target=\".navbar-collapse\">");
		out.println("<span class=\"sr-only\">Toggle navigation</span>");
		out.println("<span class=\"icon-bar\"></span>");
		out.println("<span class=\"icon-bar\"></span>");
		out.println("<span class=\"icon-bar\"></span>");
		out.println("</button>");
		out.println("<a class=\"navbar-brand\" href=\"index.jsp\">Spiracle</a>");
		out.println("</div>");
		out.println("<div class=\"navbar-collapse collapse\">");
		out.println("<ul class=\"nav navbar-nav\">");
		out.println("<li><a href=\"index.jsp\">Overview</a></li>");
		out.println("<li><a href=\"file.jsp\">File</a></li>");
		out.println("<li><a href=\"network.jsp\">Network</a></li>");
		out.println("<li class=\"active\"><a href=\"sql.jsp\">SQL</a></li>");
       out.println("<li><a href=\"xss.jsp\">XSS</a></li>");
       out.println("<li><a href=\"misc.jsp\">Misc</a></li>");
		out.println("</ul>");
		out.println("</div>");
		out.println("</div>");
		out.println("</div>");
	}

	static void printContentDiv(ServletOutputStream out) throws IOException {
		out.println("<div class=\"container\">");
	}

	static void printPageFooter(ServletOutputStream out) throws IOException {
		out.println("</div>");
		out.println("</div>");
		out.println("<script src=\"js/jquery.min.js\"></script>");
		out.println("<script src=\"js/bootstrap.min.js\"></script>");
		out.println("</body></html>");
	}

	static void printStyle(ServletOutputStream out, String style) throws IOException {
		String filePath = new File("").getAbsolutePath();
		String styleJSP=filePath +"/src/main/webapp/"+style+".jsp";
		out.println("foo: "+ styleJSP);
		BufferedReader br = null;
		FileReader fr = null;

		try {
			out.println("</div>");
			fr = new FileReader(styleJSP);
			br = new BufferedReader(fr);

			String sCurrentLine;

			br = new BufferedReader(new FileReader(styleJSP));

			while ((sCurrentLine = br.readLine()) != null) {
				out.println(sCurrentLine);
			}

		} catch (IOException e) {

			e.printStackTrace();

		} finally {

			try {

				if (br != null)
					br.close();

				if (fr != null)
					fr.close();

			} catch (IOException ex) {

				ex.printStackTrace();

			}
		}
	}


//	static void printStyle(ServletOutputStream out,String style) {
//		String styleJSP = ("src/main/webapp/"+style+".jsp");
//		BufferedReader br = null;
//		FileReader fr = null;
//
//		try {
//
//			fr = new FileReader(styleJSP);
//			br = new BufferedReader(fr);
//
//			String sCurrentLine;
//
//			br = new BufferedReader(new FileReader(styleJSP));
//
//			while ((sCurrentLine = br.readLine()) != null) {
//				out.println(sCurrentLine);
//			}
//
//		} catch (IOException e) {
//
//			e.printStackTrace();
//
//		} finally {
//
//			try {
//
//				if (br != null)
//					br.close();
//
//				if (fr != null)
//					fr.close();
//
//			} catch (IOException ex) {
//
//				ex.printStackTrace();
//
//			}
//
//		}
//
//	}

}
