package com.waratek.spiracle.sql.servlet;

import java.io.IOException;
import java.util.ArrayList;
import java.util.List;
import java.util.Map;

import javax.servlet.ServletContext;
import javax.servlet.ServletException;
import javax.servlet.annotation.WebServlet;
import javax.servlet.http.HttpServlet;
import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;

import com.waratek.spiracle.sql.servlet.util.ParameterNullFix;
import com.waratek.spiracle.sql.util.UpdateUtil;

/**
 * Servlet implementation class Delete_User
 */
@WebServlet("/Delete_User")
public class Delete_User extends HttpServlet {
    private static final long serialVersionUID = 1L;
       
    /**
     * @see HttpServlet#HttpServlet()
     */
    public Delete_User() {
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
        List<String> queryStringList = new ArrayList<String>();     
        queryStringList.add("id");
        queryStringList.add("name");
        
        Map<String, String> nullSanitizedMap = ParameterNullFix.sanitizeNull(queryStringList, request);

        String id = nullSanitizedMap.get("id");     
        String name = nullSanitizedMap.get("name");

        String sql = "DELETE FROM users WHERE id = " + id  + " OR name = '" + name + "'";

        UpdateUtil.executeUpdate(sql, application, request, response);
    }

}
