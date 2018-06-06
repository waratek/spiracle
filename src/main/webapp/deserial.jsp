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
                         out.println("Performing the deserialization of the HTTP request input stream.<br/>");

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

<%@ include file="footer.jsp" %>
