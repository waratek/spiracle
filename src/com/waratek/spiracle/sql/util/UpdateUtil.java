package com.waratek.spiracle.sql.util;

import java.io.IOException;
import java.sql.Connection;
import java.sql.PreparedStatement;
import java.sql.SQLException;

import javax.servlet.ServletContext;
import javax.servlet.ServletOutputStream;
import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;

import org.apache.log4j.Logger;

import com.waratek.spiracle.init.SpiracleInit;

public class UpdateUtil {
	private static final Logger logger = Logger.getLogger(UpdateUtil.class);

    public static void executeUpdate(String sql, ServletContext application, HttpServletRequest request, HttpServletResponse response) throws IOException{
    	response.setHeader("Content-Type", "text/html;charset=UTF-8");
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

            logger.info(sql);

            PreparedStatement stmt = con.prepareStatement(sql);
            int result = stmt.executeUpdate();
            out.println("<h1>Altered Rows:</h1>");
            out.print("<pre>" + result + "</pr>");
            out.println("</TABLE>");
            TagUtil.printPageFooter(out);
            out.close();
            stmt.close();
            con.close();
            
        } catch(SQLException e) {
            if(e.getMessage().equals("Attempted to execute a query with one or more bad parameters.")) {
                response.setStatus(550);
            } else {
                response.setStatus(500);
            }
            out.println("<div class=\"alert alert-danger\" role=\"alert\">");
            out.println("<strong>SQLException:</strong> " + e.getMessage() + "<BR>");
			if(logger.isDebugEnabled()) {
				logger.debug(e.getMessage(), e);
			} else {
				logger.error(e);
			}
            while((e = e.getNextException()) != null) {
                out.println(e.getMessage() + "<BR>");
            }
            try {
                con.rollback();
                con.close();
            } catch (SQLException e1) {
    			if(logger.isDebugEnabled()) {
    				logger.debug(e.getMessage(), e);
    			} else {
    				logger.error(e);
    			}
            }
            TagUtil.printPageFooter(out);
        }
    }
}
