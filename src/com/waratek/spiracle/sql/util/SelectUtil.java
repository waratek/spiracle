package com.waratek.spiracle.sql.util;

import java.io.IOException;
import java.sql.Connection;
import java.sql.PreparedStatement;
import java.sql.ResultSet;
import java.sql.ResultSetMetaData;
import java.sql.SQLException;

import javax.servlet.ServletContext;
import javax.servlet.ServletOutputStream;
import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;

public class SelectUtil {

    public static void executeQuery(String sql, ServletContext application, HttpServletRequest request, HttpServletResponse response, Boolean showErrors, Boolean allResults, Boolean showOutput) throws IOException {
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
            ResultSet rs = stmt.executeQuery();

            writeToResponse(allResults, showOutput, out, rs);
            out.close();
            rs.close();
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

    private static void writeToResponse(Boolean allResults, Boolean showOutput, ServletOutputStream out, ResultSet rs) throws SQLException, IOException {
        ResultSetMetaData metaData = rs.getMetaData();

        out.println("<h1>Results:</h1>");
        out.println("<TABLE CLASS=\"table table-bordered table-striped\">");
        out.println("<TR>");
        for(int i = 1; i <= metaData.getColumnCount(); i++) {
            String colName = metaData.getColumnName(i);
            out.print("<TH>" + colName + "</TH>");
        }
        out.println("</TR>");

        //Matching sqlmap's testenv option to suppress output
        if(showOutput) {
            //Matching sqlmap's testenv partial output option.
            if(allResults) {
                while(rs.next()) {
                    writeRow(out, rs, metaData);
                }
            } else {
                rs.next();
                writeRow(out, rs, metaData);
            }
        }

        out.println("</TABLE>");
        TagUtil.printPageFooter(out);
    }

    private static void writeRow(ServletOutputStream out, ResultSet rs, ResultSetMetaData metaData) throws IOException, SQLException {
        out.println("<TR>");
        for(int i = 1; i <= metaData.getColumnCount(); i++) {           
            Object content = rs.getObject(i);
            if(content != null) {
                out.println("<TD>" + content.toString() + "</TD>");
            } else {
                out.println("<TD></TD>");
            }
        }
        out.println("</TR>");
    }
}
