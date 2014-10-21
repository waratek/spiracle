package com.waratek.spiracle.network;

import java.io.IOException;
import java.net.MalformedURLException;
import java.net.URL;
import java.net.URLConnection;
import java.net.UnknownHostException;
import java.util.Scanner;

import javax.servlet.ServletException;
import javax.servlet.annotation.WebServlet;
import javax.servlet.http.HttpServlet;
import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;
import javax.servlet.http.HttpSession;

/**
 * Servlet implementation class UrlServlet
 */
@WebServlet("/UrlServlet")
public class UrlServlet extends HttpServlet {
    private static final long serialVersionUID = 1L;

    /**
     * @see HttpServlet#HttpServlet()
     */
    public UrlServlet() {
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

    private void executeRequest(HttpServletRequest request,
            HttpServletResponse response) throws IOException {
        HttpSession session = request.getSession();     
        String urlPath = request.getParameter("urlPath");

        session.setAttribute("urlContents", readUrl(urlPath));
        response.sendRedirect("network.jsp");
    }

    private String readUrl(String pathname) throws IOException {
        try {
            URLConnection con = new URL(pathname).openConnection();
            Scanner scanner = new Scanner(con.getInputStream());
            StringBuilder fileContents = new StringBuilder();
            String lineSeparator = System.getProperty("line.separator");

            try {
                while(scanner.hasNextLine()) {        
                    fileContents.append(scanner.nextLine() + lineSeparator);
                }
                return fileContents.toString();
            } finally {
                scanner.close();
            }
        } catch (MalformedURLException e) {
            e.printStackTrace();
            return "Please enter a valid URL";
        } catch (UnknownHostException e) {
            e.printStackTrace();
            return "Please enter a valid URL";          
        }

    }
}
