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

        TagUtil.printPageHead(out);
        TagUtil.printPageNavbar(out);
        TagUtil.printContentDiv(out);
        
        try {
            //Checking if connectionType is not, defaulting it to c3p0 if not set.
            if(request.getParameter("connectionType") == null) {
                connectionType = "c3p0";
            } else {
                connectionType = request.getParameter("connectionType");
            }
            con = ConnectionUtil.getConnection(application, connectionType);            
            out.println("<div class=\"panel-body\">");
            out.println("<h1>SQL Query:</h1>");
            out.println("<pre>");
            out.println(sql);
            out.println("</pre>");

            System.out.println(sql);

            PreparedStatement stmt = con.prepareStatement(sql);
            int result = stmt.executeUpdate();
            out.println("<h1>Altered Rows:</h1>");
            out.print("<pre>" + result + "</pre>");
            TagUtil.printPageFooter(out);
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
            TagUtil.printPageFooter(out);
        }
    }
}
