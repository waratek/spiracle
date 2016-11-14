package com.waratek.spiracle.misc;

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

import javax.servlet.http.Cookie;
import javax.servlet.annotation.WebServlet;
import javax.servlet.ServletConfig;
import javax.servlet.ServletContext;
import javax.servlet.ServletOutputStream;

@WebServlet("/AddCookies")
public class AddCookies extends HttpServlet {

    public AddCookies() {
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

        ServletConfig config = getServletConfig();
        int servletMajorVersion = config.getServletContext().getMajorVersion();
        int httpOnlyMinServletVersion = 3;

        String secureString = "Secure";
        String httpOnlyString = "HttpOnly";
        String cookiePath = "/";
        int cookieMaxAge = 86400; // 24 hours

        Cookie testCookieDefault1 = new Cookie("TestCookieName1", "TestCookieValue1");
        Cookie testCookieDefault2 = new Cookie("TestCookieName2", "TestCookieValue2");

        Cookie testCookieSecure1 = new Cookie("TestCookieNameSecure1", "TestCookieValueSecure1");
        Cookie testCookieSecure2 = new Cookie("TestCookieNameSecure2", "TestCookieValueSecure2");

        Cookie testCookieHttpOnly1 = new Cookie("TestCookieNameHttpOnly1", "TestCookieValueHttpOnly1");
        Cookie testCookieHttpOnly2 = new Cookie("TestCookieNameHttpOnly2", "TestCookieValueHttpOnly2");

        Cookie testCookieSecureHttpOnly1 = new Cookie("TestCookieNameSecureHttpOnly1", "TestCookieValueSecureHttpOnly1");
        Cookie testCookieSecureHttpOnly2 = new Cookie("TestCookieNameSecureHttpOnly2", "TestCookieValueSecureHttpOnly2");

        Cookie[] cookies = {testCookieDefault1, testCookieDefault2, testCookieSecure1, testCookieSecure2,
                            testCookieHttpOnly1, testCookieHttpOnly2, testCookieSecureHttpOnly1,
                            testCookieSecureHttpOnly2};

        for (int i = 0; i < cookies.length; i++) {
            Cookie newCookie = cookies[i];

            newCookie.setPath(cookiePath);
            newCookie.setMaxAge(cookieMaxAge);

            if(newCookie.getName().contains(secureString)){
                newCookie.setSecure(true);
            }

            if(newCookie.getName().contains(httpOnlyString)){

                if(servletMajorVersion >= httpOnlyMinServletVersion){
                    newCookie.setHttpOnly(true);
                }

            }

            response.addCookie(newCookie);
        }
    }
}
