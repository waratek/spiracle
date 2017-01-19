package com.waratek.spiracle.sql.util;

import java.io.BufferedReader;
import java.io.FileReader;
import java.io.IOException;

public class HeaderFooterClassTest {

	/**
	 * @param args
	 */
	public static void main(String[] args) {
		insertStyle("header");
		insertStyle("footer");
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

}
