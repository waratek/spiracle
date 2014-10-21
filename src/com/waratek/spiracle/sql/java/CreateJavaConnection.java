package com.waratek.spiracle.sql.java;

import java.io.FileNotFoundException;
import java.io.IOException;
import java.io.InputStream;
import java.sql.Connection;
import java.sql.DriverManager;
import java.sql.SQLException;
import java.util.Properties;

import javax.servlet.ServletContext;
import javax.servlet.ServletException;
import javax.servlet.annotation.WebServlet;
import javax.servlet.http.HttpServlet;
import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;
import javax.servlet.http.HttpSession;

/**
 * Servlet implementation class CreateConnection
 */
@WebServlet("/CreateJavaConnection")
public class CreateJavaConnection extends HttpServlet {
    private static final long serialVersionUID = 1L;

    private String jdbcDriver;
    private String url;
    private String username;
    private String password;
    /**
     * @see HttpServlet#HttpServlet()
     */
    public CreateJavaConnection() {
        super();
        // TODO Auto-generated constructor stub
    }
    
    public void init() {
        ServletContext application = this.getServletConfig().getServletContext();
        InputStream propStream = application.getResourceAsStream("conf/Spriacle.properties");
        Properties prop = new Properties();
        try {
            prop.load(propStream);
        } catch (FileNotFoundException e) {
            // TODO Auto-generated catch block
            e.printStackTrace();
        } catch (IOException e) {
            // TODO Auto-generated catch block
            e.printStackTrace();
        }
        jdbcDriver = prop.getProperty("java.classname");
        url = prop.getProperty("java.url");
        username = prop.getProperty("java.username");
        password = prop.getProperty("java.password");
    }

    /**
     * @see HttpServlet#doGet(HttpServletRequest request, HttpServletResponse response)
     */
    protected void doGet(HttpServletRequest request, HttpServletResponse response) throws ServletException, IOException {
        createConnection(request, response);
    }

    /**
     * @see HttpServlet#doPost(HttpServletRequest request, HttpServletResponse response)
     */
    protected void doPost(HttpServletRequest request, HttpServletResponse response) throws ServletException, IOException {
        createConnection(request, response);
    }

    private void createConnection(HttpServletRequest request, HttpServletResponse response) throws IOException {
        HttpSession session = request.getSession();
        if(request.getParameter("connectionUrl") == null || request.getParameter("username") == null || request.getParameter("password") == null) {
            
        } else {
            url = request.getParameter("connectionUrl");
            username = request.getParameter("username");
            password = request.getParameter("password");
        }
        try {
            Connection con = createJavaConnection();
            ServletContext application = this.getServletConfig().getServletContext();
            application.setAttribute("unpooledConnection", con);
            session.setAttribute("connectionDataJava", con.toString());
            response.sendRedirect("sql.jsp");
        } catch(ClassNotFoundException e) {
            e.printStackTrace();
            session.setAttribute("errorJava", e.getMessage());
            response.sendRedirect("sql.jsp");
        } catch(SQLException e) {
            e.printStackTrace();
            session.setAttribute("errorJava", e.getMessage());
            response.sendRedirect("sql.jsp");
        }
    }

    private Connection createJavaConnection() throws ClassNotFoundException, SQLException {
        Class.forName(jdbcDriver);
        Connection con = DriverManager.getConnection(url, username, password);
        return con;
    }
}
