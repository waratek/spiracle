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

import com.waratek.spiracle.file.AbstractFileServlet;
import org.apache.log4j.Logger;

import java.io.IOException;
import java.net.InetSocketAddress;
import java.net.ServerSocket;
import java.net.Socket;

import javax.servlet.ServletException;
import javax.servlet.annotation.WebServlet;
import javax.servlet.http.HttpServlet;
import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;
import javax.servlet.http.HttpSession;

/**
 * Servlet implementation class ServerSocketServlet
 */
@WebServlet("/ServerSocketServlet")
public class ServerSocketServlet extends HttpServlet {
	protected static final Logger logger = Logger.getLogger(ServerSocketServlet.class);
	private static final long serialVersionUID = 1L;
	private static ServerSocket ss;
	private static Socket s;

	/**
	 * @see HttpServlet#HttpServlet()
	 */
	public ServerSocketServlet() {
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
		if(ss != null && s != null) {
			ss.close();
			s.close();
		}

		HttpSession session = request.getSession();
		try {
			String addr = request.getParameter("hostname");
			int port = Integer.parseInt(request.getParameter("port"));
			if(addr == null) {
				ss = new ServerSocket(port);
			} else {
				ss = new ServerSocket();
				ss.bind(new InetSocketAddress(addr, port));
			}
			ss.setSoTimeout(20000);
			s = ss.accept();
			logger.info("ServerSocket accepted socket: " + s.toString());
			session.setAttribute("serverSocketInfo", ss.toString());
			response.sendRedirect("network.jsp");

		} catch (Throwable e) {
			if(ss != null) {
				ss.close();
			}
			if(s != null) {
				s.close();
			}
			e.printStackTrace();
			session.setAttribute("serverSocketInfo", e.getMessage());
			response.sendRedirect("network.jsp");
		}
	}

}
