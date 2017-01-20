package com.waratek.spiracle.sql.util;

import java.io.BufferedReader;
import java.io.FileReader;
import java.io.IOException;

public class HeaderFooterClassTest {

	/**
	 * @param args
	 */
	public static void main(String[] args) {
		printStyle("test","header");
//		insertStyle("footer");
	}
	
	static void insertStyle(String style) {
		String header = ("src/main/webapp/"+style+".jsp");
		String footer = ("src/main/webapp/"+style+".jsp");
		BufferedReader br = null;
		FileReader fr = null;

		try {

			fr = new FileReader(footer);
			br = new BufferedReader(fr);

			String sCurrentLine;

			br = new BufferedReader(new FileReader(footer));

			while ((sCurrentLine = br.readLine()) != null) {
				System.out.println(sCurrentLine);
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
	
	static void printStyle(String out,String style) {
		String styleJSP = ("src/main/webapp/"+style+".jsp");
		BufferedReader br = null;
		FileReader fr = null;

		try {
			
			fr = new FileReader(styleJSP);
			br = new BufferedReader(fr);

			String sCurrentLine;

			br = new BufferedReader(new FileReader(styleJSP));
//			out.println("<!DOCTYPE html>");
//			out.println("<html>");
//			out.println("<head>");
//			out.println("<meta http-equiv=\"Content-Type\" content=\"text/html; charset=UTF-8\">");
//			out.println("<link rel=\"stylesheet\" type=\"text/css\" href=\"css/bootstrap.min.css\">");
//			out.println("<link rel=\"stylesheet\" type=\"text/css\" href=\"css/bootstrap-theme.min.css\">");
//			out.println("<link rel=\"stylesheet\" type=\"text/css\" href=\"css/style.css\">");
//
//			out.println("<title>Spiracle - SQL</title>");
//			out.println("</head>");
//			out.println("<body>");

			while ((sCurrentLine = br.readLine()) != null) {
				System.out.println(sCurrentLine);
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

}
