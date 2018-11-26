package com.waratek.spiracle.sql.servlet.oracle;

import java.io.IOException;
import java.util.ArrayList;
import java.util.List;
import java.util.Map;

import javax.servlet.ServletContext;
import javax.servlet.ServletException;

import javax.servlet.http.HttpServlet;
import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;

import com.waratek.spiracle.sql.servlet.util.ParameterNullFix;
import com.waratek.spiracle.sql.util.SelectUtil;

/**
 * Servlet implementation class Get_string_no_quote
 */

public class Get_string_no_quote_sanitised extends HttpServlet {
    private static final long serialVersionUID = 1L;
       
    /**
     * @see HttpServlet#HttpServlet()
     */
    public Get_string_no_quote_sanitised() {
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

    private void executeRequest(HttpServletRequest request, HttpServletResponse response) throws IOException {          
        ServletContext application = this.getServletConfig().getServletContext();
        List queryStringList = new ArrayList();
        queryStringList.add("name");
        
        Map nullSanitizedMap = ParameterNullFix.sanitizeNull(queryStringList, request);

        String name = (String)nullSanitizedMap.get("name");
        
        String newName = name.replaceAll( "'", "''" );
        
        String sql = "SELECT * FROM users WHERE name = "  + newName;
        
        Boolean showErrors = Boolean.TRUE;
        Boolean allResults = Boolean.TRUE;
        Boolean showOutput = Boolean.TRUE;

        SelectUtil.executeQuery(sql, application, request, response, showErrors, allResults, showOutput);
    }

}
