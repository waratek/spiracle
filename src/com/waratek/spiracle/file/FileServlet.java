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
        HttpSession session = request.getSession();

        String method = request.getParameter("fileArg");
        String path = request.getParameter("filePath");
        String textData = request.getParameter("fileText");

        logger.info(method + " " + path + " " + textData);

        if(method.equals("read")) {
            session.setAttribute("fileContents", readFile(path));

        } else if(method.equals("write")) {
            File f = new File(path);
            FileWriter fw = new FileWriter(f);
            BufferedWriter bw = new BufferedWriter(fw);
            bw.write(textData);         
            bw.close();
            fw.close();

            session.setAttribute("fileContents", readFile(path));

        } else if(method.equals("delete")) {
            File f = new File(path);
            f.delete();
            session.setAttribute("fileContents", "");
        }
        response.sendRedirect("file.jsp");
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
