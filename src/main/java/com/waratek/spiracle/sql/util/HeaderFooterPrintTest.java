package com.waratek.spiracle.sql.util;
import java.io.BufferedReader;
import java.io.FileReader;
import java.io.IOException;

import java.io.File;

public class HeaderFooterPrintTest {

	/**
	 * @param args
	 */
	public static void main(String[] args) {
		System.out.println("hello world");
		String filePath = new File("").getAbsolutePath();
		String header = (filePath + "/src/main/webapp/header.jsp");
		String footer = ("src/main/webapp/footer.jsp");
		System.out.println(footer);
		
		
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
