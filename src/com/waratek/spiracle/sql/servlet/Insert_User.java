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
 * Servlet implementation class Create_User
 */
@WebServlet("/Insert_User")
public class Insert_User extends HttpServlet {
    private static final long serialVersionUID = 1L;

    /**
     * @see HttpServlet#HttpServlet()
     */
    public Insert_User() {
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
        queryStringList.add("surname");
        queryStringList.add("dob");
        queryStringList.add("credit_card");
        queryStringList.add("cvv");
        
        Map<String, String> nullSanitizedMap = ParameterNullFix.sanitizeNull(queryStringList, request);
        
        String id = nullSanitizedMap.get("id");
        String name = nullSanitizedMap.get("name");
        String surname = nullSanitizedMap.get("surname");
        String dob = nullSanitizedMap.get("dob");
        String credit_card = nullSanitizedMap.get("credit_card");
        String cvv = nullSanitizedMap.get("cvv");

        String sql = "INSERT INTO users VALUES (" + id + ", '" + name + "', '" + surname + "', '" + dob + "', '" + credit_card + "', '" + cvv + "')";

        UpdateUtil.executeUpdate(sql, application, request, response);
    }

}
