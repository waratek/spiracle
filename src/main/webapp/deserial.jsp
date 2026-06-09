<%@ taglib uri="http://java.sun.com/jsp/jstl/core" prefix="c" %>
<%@ page import="java.io.*,java.util.*" %>
<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>

<jsp:include page="header.jsp" >
 <jsp:param name="pageName" value="Deserialization" />
</jsp:include>

     <div class="container">
         <div class="panel panel-default">
             <div class="panel-heading">
                 <h4>Test Java deserialization vulnerability</h4>
             </div>
             <div class="panel-body">
               <%
                    if (request.getMethod().equals("POST")) {
                         out.println("Performing Java deserialization of the HTTP request input stream.<br/>");

                         // get the request's input stream
                         ServletInputStream untrusted = request.getInputStream();

                         // pass it to a new ObjectInputStream instance
                         ObjectInputStream ois = new ObjectInputStream(untrusted);

                         // deserialize it
                         Object deserialized = ois.readObject();

                         out.println("Completed the deserialization of the HTTP request input stream.<br/>");
                    }
                    else {
                         out.println("Please send a POST request with the serialized input.<br/>");
                    }
               %>
             </div>
         </div>
     </div>
     
     <div class="container">
         <div class="panel panel-default">
             <div class="panel-heading">
                 <h4>Test XML deserialization vulnerability</h4>
             </div>
             <div class="panel-body">
             
             <%
                 String attack = (String) request.getAttribute("attack");
                 String name = (String) request.getAttribute("name");
                 
                 if (name == null) {
                     name = "";
                 }
                 
                 Integer age = (Integer) request.getAttribute("age");
                 
                 if (age == null) {
                     age = 0;
                 }

                 if (attack != null) {
                     if ("xss".equals(attack)) {
                         out.println("<h4>Deserialized User</h4><br/>");
                         out.println("Name: " + name + "<br/>");
                         out.println("Age: " + age + "<br/>");
                         out.println("<hr/>");
                     }
                     request.setAttribute("attack", null);
                 }
             %>

               <form action="XSSviaXMLDeserialization" method="GET">
                    <table border="0">
                        <tr>
                            <td>Name: </td>
                            <td><input name="name" type="text" value="Test User" /></td>
                        </tr>
                        <tr>
                            <td>Age: </td>
                            <td><input name="age" type="text" value="36" /></td>
                        </tr>
                        <tr>
                            <td colspan="2"><input name="submit" type="submit"
                                value="XSS via XML Deserialization"/></td>
                        </tr>
                    </table>
               </form>
               
             </div>
         </div>
     </div>

<%@ include file="footer.jsp" %>
