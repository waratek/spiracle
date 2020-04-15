package com.waratek.spiracle.deserial;

import java.beans.ExceptionListener;
import java.beans.XMLDecoder;
import java.beans.XMLEncoder;
import java.io.FileInputStream;
import java.io.FileOutputStream;
import java.io.IOException;
import javax.servlet.RequestDispatcher;
import javax.servlet.ServletException;
import javax.servlet.annotation.WebServlet;
import javax.servlet.http.HttpServlet;
import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;

@WebServlet("/XSSviaXMLDeserialization")
public class XSSviaXMLDeserialization  extends HttpServlet {
    
    private static final long serialVersionUID = 1L;
    private static final String XML_FILE = "user.xml";
    
    public XSSviaXMLDeserialization() {
    }
    
    protected void doGet(HttpServletRequest request, HttpServletResponse response) throws ServletException, IOException {
        String name = request.getParameter("name");
        String ageStr = request.getParameter("age");
        int age = 0;
        
        if (ageStr != null && !ageStr.trim().isEmpty()) {
            age = Integer.parseInt(ageStr);
        }
        
        User user = new User(name, age);
        
        serializeToXML(user, XML_FILE);
        
        User decodedUser = deserializeFromXML(XML_FILE);
        
        request.setAttribute("attack", "xss");
        request.setAttribute("name", decodedUser.getName());
        request.setAttribute("age", decodedUser.getAge());
        
        RequestDispatcher rd = request.getRequestDispatcher("/deserial.jsp");
        rd.forward(request, response);
    }
    
    private static void serializeToXML (User settings, String path) throws IOException
    {
        FileOutputStream fos = new FileOutputStream(path);
        XMLEncoder encoder = new XMLEncoder(fos);
        encoder.setExceptionListener(new ExceptionListener() {
                public void exceptionThrown(Exception e) {
                    System.out.println("Exception! :"+e.toString());
                }
        });
        encoder.writeObject(settings);
        encoder.close();
        fos.close();
    }
    
    private static User deserializeFromXML(String path) throws IOException {
        FileInputStream fis = new FileInputStream(path);
        XMLDecoder decoder = new XMLDecoder(fis);
        User decodedUser = (User) decoder.readObject();
        decoder.close();
        fis.close();
        return decodedUser;
    }
}
