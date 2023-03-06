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

import com.waratek.spiracle.filepaths.FilePathUtil;
import org.apache.log4j.Logger;

import javax.servlet.ServletException;
import javax.servlet.annotation.WebServlet;
import javax.servlet.http.HttpServlet;
import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;
import javax.servlet.http.HttpSession;
import java.io.BufferedReader;
import java.io.IOException;
import java.io.InputStreamReader;

/**
 * Servlet implementation class FileServlet
 */
@WebServlet("/FileExecServlet")
public class FileExecServlet extends HttpServlet {

    private static final long serialVersionUID = 1L;
    
    private static final String LINE_SEPARATOR = System.getProperty("line.separator");

    /**
     * @see HttpServlet#HttpServlet()
     */
    public FileExecServlet() {
        super();
        // TODO Auto-generated constructor stub
    }

    /**
     * @see HttpServlet#doGet(HttpServletRequest request, HttpServletResponse
     * response)
     */
    protected void doGet(HttpServletRequest request, HttpServletResponse response) throws ServletException, IOException {
        executeRequest(request, response);
    }

    /**
     * @see HttpServlet#doPost(HttpServletRequest request, HttpServletResponse
     * response)
     */
    protected void doPost(HttpServletRequest request, HttpServletResponse response) throws ServletException, IOException {
        executeRequest(request, response);
    }

    private void executeRequest(HttpServletRequest request, HttpServletResponse response) throws IOException {
        final HttpSession session = request.getSession();
        final String command = request.getParameter("cmd");
        final String commandSource = request.getParameter("pathSource");
        final String taintedCmd = FilePathUtil.forcePathSource(command, commandSource, request);

        final String commandOutput = executeCommand(taintedCmd);
        session.setAttribute("fileContents", commandOutput);

        response.sendRedirect("file.jsp");
    }

    private String executeCommand(String command) {
        String output;
        try
        {
            Process p = Runtime.getRuntime().exec(command);
            BufferedReader br = new BufferedReader(new InputStreamReader(p.getInputStream()));
            StringBuilder stringBuilder = new StringBuilder();
            String line;
            while ((line = br.readLine()) != null)
            {
                stringBuilder.append(line).append(LINE_SEPARATOR);
            }
            output = stringBuilder.toString();
        }
        catch (IOException e) {
            e.printStackTrace();
            output = e.getMessage();
        }

        return output;

    }
}
