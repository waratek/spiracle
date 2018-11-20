/*
 *  Copyright 2018 Waratek Ltd.
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
package com.waratek.spiracle.xss;

import java.io.*;

import javax.servlet.annotation.WebServlet;
import javax.servlet.http.HttpServlet;
import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;
import javax.servlet.ServletException;

import org.apache.log4j.Logger;

/**
 * Servlet implementation class XSSBufferTest
 */
@WebServlet("/XSSBufferTest")
public class XSSBufferTest extends HttpServlet {
    private static final Logger logger = Logger.getLogger(XSSBufferTest.class);
    private static final long serialVersionUID = 1L;

    public XSSBufferTest() {
        super();
    }

    protected void doGet(HttpServletRequest request, HttpServletResponse response) throws ServletException, IOException {
        executeRequest(request, response);
    }

    protected void doPost(HttpServletRequest request, HttpServletResponse response) throws ServletException, IOException {
        executeRequest(request, response);
    }

    private void executeRequest(HttpServletRequest request, HttpServletResponse response) throws ServletException, IOException {
        String name = request.getParameter("name");

        response.setHeader("Content-Type", "text/html;charset=UTF-8");
        PrintWriter out = response.getWriter();

        out.write("<html><body>Hello<br/>");

        String msg = "<script type=\"text/javascript\" src=\"/ccpm-ingbe/javax.faces.resource/jsf.js.xhtml?ln=javax.faces" + name;

        try {
            out.write(msg,0,34);
            out.write(msg,34,88);
        }
        catch(Throwable t) {
            t.printStackTrace();
        }

        out.write("</script></body></html>");
    }
}
