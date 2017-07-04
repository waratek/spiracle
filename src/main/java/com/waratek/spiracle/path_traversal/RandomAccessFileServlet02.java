/*
 *  Copyright 2016 Waratek Ltd.
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
package com.waratek.spiracle.path_traversal;

import java.io.File;
import java.io.RandomAccessFile;
import java.io.IOException;

import javax.servlet.ServletException;
import javax.servlet.annotation.WebServlet;
import javax.servlet.http.HttpServlet;
import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;
import javax.servlet.http.HttpSession;

/**
 * Servlet implementation class RandomAccessFileServlet02
 */
@WebServlet("/RandomAccessFileServlet02")
public class RandomAccessFileServlet02 extends HttpServlet {
	private static final long serialVersionUID = 1L;

	/**
	 * @see HttpServlet#HttpServlet()
	 */
	public RandomAccessFileServlet02() {
		super();
		// TODO Auto-generated constructor stub
	}

	/**
	 * @see HttpServlet#doGet(HttpServletRequest request, HttpServletResponse response)
	 */
	protected void doGet(HttpServletRequest request, HttpServletResponse response) throws ServletException, IOException {
		doPost(request, response);
	}

	/**
	 * @see HttpServlet#doPost(HttpServletRequest request, HttpServletResponse response)
	 */
	protected void doPost(HttpServletRequest request, HttpServletResponse response) throws ServletException, IOException {

        HttpSession session = request.getSession();
        String newLine = System.getProperty("line.separator");

        String relativePathToTestFilesParentDir = File.separator + "pathTraversal" + File.separator + "testFilesParent";
        String relativePathToTestFilesChildDir = relativePathToTestFilesParentDir + File.separator  + "testFilesChild" + File.separator;
        String absolutePathToTestFilesChildDir = getServletContext().getRealPath(relativePathToTestFilesChildDir);
        String testFileName = request.getParameter("RandomAccessFile02");
        String absolutePathToTestFile = absolutePathToTestFilesChildDir + File.separator + "." + testFileName;
        String s = "";

        try {

            RandomAccessFile fileTarget = new RandomAccessFile(absolutePathToTestFile, "rw");
            s = "Random access file stream opened for file:" + newLine + "'" + absolutePathToTestFile + "'";

            if (fileTarget.length() > 0) {
                s = s + newLine + "And file is not empty.";
            }
            else {
        	    s = s + newLine + "And file is empty.";
            }

        } catch (Exception e) {

            s = "Couldn't open random access file stream for file:" + newLine + "'" + absolutePathToTestFile + "'";

        } finally {

            System.out.println(newLine + getClass().getSimpleName() + newLine + s);
            session.setAttribute("outputRandomAccessFile", s.toString());
            response.sendRedirect("pathTraversal.jsp");
        }
    }
}
