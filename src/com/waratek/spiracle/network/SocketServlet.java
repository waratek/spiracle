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
package com.waratek.spiracle.network;

import java.io.IOException;
import java.io.OutputStreamWriter;
import java.io.PrintWriter;
import java.net.InetSocketAddress;
import java.net.Socket;

import javax.servlet.ServletException;
import javax.servlet.annotation.WebServlet;
import javax.servlet.http.HttpServlet;
import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;
import javax.servlet.http.HttpSession;

/**
 * Servlet implementation class SocketServlet
 */
@WebServlet("/SocketServlet")
public class SocketServlet extends HttpServlet {
	private static final long serialVersionUID = 1L;
	private static Socket s;

	/**
	 * @see HttpServlet#HttpServlet()
	 */
	public SocketServlet() {
		super();
	}

	/**
	 * @see HttpServlet#doGet(HttpServletRequest request, HttpServletResponse response)
	 */
	protected void doGet(HttpServletRequest request, HttpServletResponse response) throws ServletException, IOException {
		executeRequest(request, response);
	}

	/**
	 * @throws IOException
	 * @see HttpServlet#doPost(HttpServletRequest request, HttpServletResponse response)
	 */
	protected void doPost(HttpServletRequest request, HttpServletResponse response) throws ServletException, IOException {
		executeRequest(request, response);
	}

	private void executeRequest(HttpServletRequest request, HttpServletResponse response) throws IOException {
		if(s != null) {
			s.close();
		}

		HttpSession session = request.getSession();
		try {
			String bindHost = request.getParameter("bindHost");
			String remoteHost = request.getParameter("remoteHost");

			Integer bindPort = 0;
			Integer remotePort = 0;

			String bindPortRaw = request.getParameter("bindPort");
			String remotePortRaw = request.getParameter("remotePort");
			String textToSend = request.getParameter("textToSend");

			if(bindPortRaw.length() > 0) {
				bindPort = Integer.parseInt((String)bindPortRaw);
			} else {
				bindPort = null;
			}
			if(remotePortRaw.length() > 0) {
				remotePort = Integer.parseInt((String)remotePortRaw);
			} else {
				remotePort = null;
			}

			s = new Socket();
			if(bindHost.length() == 0 || bindHost.length() == 0) {
				s.bind(null);
			} else {
				s.bind(new InetSocketAddress(bindHost, bindPort.intValue()));
			}

			s.connect(new InetSocketAddress(remoteHost, remotePort.intValue()));

			if ( ( textToSend != null ) && ( textToSend.length() > 0 ) ) {
			    PrintWriter pw = new PrintWriter(new OutputStreamWriter(s.getOutputStream()));
			    pw.println( textToSend );
			    pw.flush();
			    pw.close();
			}
			
			session.setAttribute("socketInfo", s.toString());

			response.sendRedirect("network.jsp");
		} catch (Throwable e) {
			if(s !=  null) {
				s.close();
			}
			e.printStackTrace();
			session.setAttribute("socketInfo", e.getMessage());
			response.sendRedirect("network.jsp");

		}
	}

}
