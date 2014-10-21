package com.waratek.spiracle.sql.spring;

import java.io.FileNotFoundException;
import java.io.IOException;
import java.io.InputStream;
import java.util.Properties;

import javax.servlet.ServletContext;
import javax.servlet.ServletException;
import javax.servlet.annotation.WebServlet;
import javax.servlet.http.HttpServlet;
import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;
import javax.servlet.http.HttpSession;

import org.springframework.context.ApplicationContext;
import org.springframework.context.support.FileSystemXmlApplicationContext;

/**
 * Servlet implementation class CreateSpringContext
 */
@WebServlet("/CreateSpringContext")
public class CreateSpringContext extends HttpServlet {
    private static final long serialVersionUID = 1L;

    private String springContextPath;

    /**
     * @see HttpServlet#HttpServlet()
     */
    public CreateSpringContext() {
        super();
        // TODO Auto-generated constructor stub
    }

    public void init() {
        ServletContext application = this.getServletConfig().getServletContext();
        InputStream propStream = application.getResourceAsStream("conf/Spiracle.properties");
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
        springContextPath = prop.getProperty("spring.path");
    }

    /**
     * @see HttpServlet#doGet(HttpServletRequest request, HttpServletResponse response)
     */
    protected void doGet(HttpServletRequest request, HttpServletResponse response) throws ServletException, IOException {
        createSpringContext(request, response);
    }

    /**
     * @see HttpServlet#doPost(HttpServletRequest request, HttpServletResponse response)
     */
    protected void doPost(HttpServletRequest request, HttpServletResponse response) throws ServletException, IOException {
        createSpringContext(request, response);
    }

    private void createSpringContext(HttpServletRequest request, HttpServletResponse response) throws IOException {
        HttpSession session = request.getSession();
        if(request.getParameter("filePath") == null) {
            
        } else {
            springContextPath = request.getParameter("filePath").toString();
        }
        ServletContext application = this.getServletConfig().getServletContext();       
        ApplicationContext context = new FileSystemXmlApplicationContext("file:" + springContextPath);

        application.setAttribute("springContext", context);
        session.setAttribute("springContextData", context.toString());
        response.sendRedirect("sql.jsp");
    }
}
