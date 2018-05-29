package com.waratek.spiracle.misc;

import java.io.IOException;

import javax.servlet.ServletException;
import javax.servlet.annotation.WebServlet;
import javax.servlet.http.HttpServlet;
import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;

@WebServlet("/SendRedirect")
public class SendRedirect extends HttpServlet {

    public SendRedirect() {
        super();
        // TODO Auto-generated constructor stub
    }

    protected void doGet(HttpServletRequest request, HttpServletResponse response) throws ServletException, IOException {
        executeRequest(request, response);
    }

    protected void doPost(HttpServletRequest request, HttpServletResponse response) throws ServletException, IOException {
        executeRequest(request, response);
    }

    private void executeRequest(HttpServletRequest request, HttpServletResponse response) throws ServletException, IOException {
        executeRequest(request, response, "");
    }
    protected void executeRequest(HttpServletRequest request, HttpServletResponse response, String baseUri) throws ServletException, IOException {

        String inputUriParam = "redirectMeTo";

        if(request.getParameter(inputUriParam) != null) {
            String redirectURI =  baseUri + request.getParameter(inputUriParam);
            response.sendRedirect(redirectURI);
        }
        else {
            response.getWriter().println("Parameter '" + inputUriParam + "' not set in the URI.");
            response.getWriter().println("Please update URI to include '?" + inputUriParam + "=URI_TO_REDIRECT_TO'");
        }
    }
}
