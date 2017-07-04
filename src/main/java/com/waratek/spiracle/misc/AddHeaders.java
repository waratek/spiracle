package com.waratek.spiracle.misc;

import java.io.IOException;

import javax.servlet.ServletException;
import javax.servlet.annotation.WebServlet;
import javax.servlet.http.HttpServlet;
import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;

@WebServlet("/AddHeaders")
public class AddHeaders extends HttpServlet {

    public AddHeaders() {
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

        String customHeaderValueParam = "addCustom";

        if(request.getParameter(customHeaderValueParam) != null) {
            String customHeaderValue = request.getParameter(customHeaderValueParam);
            response.addHeader("CustomTestHeader", customHeaderValue);
        }

        response.addHeader("DefaultTestHeader1", "foo");
        response.addHeader("DefaultTestHeader2", "bar");
        response.addHeader("DefaultTestHeader3", "baz");
    }
}
