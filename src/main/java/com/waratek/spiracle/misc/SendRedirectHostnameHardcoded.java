package com.waratek.spiracle.misc;

import java.io.IOException;

import javax.servlet.ServletException;
import javax.servlet.annotation.WebServlet;
import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;

@WebServlet("/SendRedirectHostnameHardcoded")
public class SendRedirectHostnameHardcoded extends SendRedirect {

    private static final String HOSTNAME = "https://www.google.com/#q=";

    public SendRedirectHostnameHardcoded() {
        super();
        // TODO Auto-generated constructor stub
    }

    protected void doGet(HttpServletRequest request, HttpServletResponse response) throws ServletException, IOException {
        executeRequest(request, response, HOSTNAME);
    }

    protected void doPost(HttpServletRequest request, HttpServletResponse response) throws ServletException, IOException {
        executeRequest(request, response, HOSTNAME);
    }
}
