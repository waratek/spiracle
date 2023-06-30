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
package com.waratek.spiracle.cookie;

import com.waratek.spiracle.file.AbstractFileServlet;

import javax.servlet.annotation.WebServlet;
import javax.servlet.http.Cookie;
import javax.servlet.http.HttpServlet;
import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;
import java.io.IOException;
import java.util.NoSuchElementException;

/**
 * Servlet implementation class CookieFileServlet
 */
@WebServlet("/CookieFileServlet")
public class CookieFileServlet extends AbstractFileServlet
{

	/**
	 * @see HttpServlet#HttpServlet()
	 */
	public CookieFileServlet() {
		super();
	}

	protected void executeRequest(HttpServletRequest request, HttpServletResponse response) throws IOException {
		final String method = request.getParameter("fileArg");
		final String cookieName = request.getParameter("cookieName");
		final String taintedPath = getCookieValue(cookieName, request);

		performFileAction(request, taintedPath, method);
		response.sendRedirect("file.jsp");
	}

	private String getCookieValue(String cookieName, HttpServletRequest request) {
		Cookie[] cookies = request.getCookies();
		for (Cookie cookie : cookies){
			if (cookie.getName().equals(cookieName)){
				return cookie.getValue();
			}
		}
		throw new NoSuchElementException("Could not find cookie with name: " + cookieName);
	}
}
