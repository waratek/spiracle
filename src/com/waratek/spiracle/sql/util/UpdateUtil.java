package com.waratek.spiracle.sql.util;

import java.io.IOException;
import java.sql.Connection;
import java.sql.PreparedStatement;
import java.sql.SQLException;

import javax.servlet.ServletContext;
import javax.servlet.ServletOutputStream;
import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;

public class UpdateUtil {
    
    public static void executeUpdate(String sql, ServletContext application, HttpServletRequest request, HttpServletResponse response) throws IOException{
        ServletOutputStream out = response.getOutputStream();
        String connectionType = null;
        Connection con = null;

        out.println("<!DOCTYPE html>");
        out.println("<html>");
        out.println("<head>");
        out.println("<meta http-equiv=\"Content-Type\" content=\"text/html; charset=UTF-8\">");
        out.println("<link rel=\"stylesheet\" type=\"text/css\" href=\"css/bootstrap.min.css\">");
        out.println("<link rel=\"stylesheet\" type=\"text/css\"");
        out.println("   href=\"css/bootstrap-theme.min.css\">");
        out.println("<link rel=\"stylesheet\" type=\"text/css\" href=\"css/style.css\">");
        out.println("<script src=\"js/jquery-2.1.1.min.js\"></script>");
        out.println("<script src=\"js/bootstrap.min.js\"></script>");
        out.println("<title>JAF Test App</title>");
        out.println("</head>");

        out.println("<body>");
        out.println("<div class=\"container\">");
        out.println("<div class=\"page-header\">");
        out.println("<img src=\"img/waratek.png\" alt=\"Waratek\">");
        out.println("</div>");
        
        out.println("<ul class=\"nav nav-tabs\" role=\"tablist\">");
        out.println("<li><a href=\"index.jsp\">Home</a></li>");
        out.println("<li><a href=\"file.jsp\">File</a></li>");
        out.println("<li><a href=\"network.jsp\">Network</a></li>");
        out.println("<li class=\"active\"><a href=\"sql.jsp\">SQL Injection</a></li>");
        out.println("</ul>");

        try {
            //Checking if connectionType is not, defaulting it to c3p0 if not set.
            if(request.getParameter("connectionType") == null) {
                connectionType = "c3p0";
            } else {
                connectionType = request.getParameter("connectionType");
            }
            con = ConnectionUtil.getConnection(application, connectionType);            
            
            out.println("<h1>SQL Query:</h1>");
            out.println("<pre>");
            out.println(sql);
            out.println("</pre>");

            System.out.println(sql);

            PreparedStatement stmt = con.prepareStatement(sql);
            int result = stmt.executeUpdate();
            out.print("<pre>" + result + "</pr>");
            out.println("</TABLE>");
            out.println("</div>");
            out.println("</BODY></HTML>");
            out.close();
            stmt.close();
            con.close();
            
        } catch(SQLException e) {
            if(e.getMessage().contains("ORA")) {
                response.setStatus(500);
            } else {
                response.setStatus(550);
            }
            out.println("<div class=\"alert alert-danger\" role=\"alert\">");
            out.println("<strong>SQLException:</strong> " + e.getMessage() + "<BR>");
            while((e = e.getNextException()) != null) {
                out.println(e.getMessage() + "<BR>");
            }
            try {
                con.rollback();
                con.close();
            } catch (SQLException e1) {
                // TODO Auto-generated catch block
                e1.printStackTrace();
            }
            out.println("</div>");
            out.println("</div>");
            out.println("</BODY></HTML>");
        }
    }
}
