<%@ taglib uri="http://java.sun.com/jsp/jstl/core" prefix="c" %>
<%@page import="java.io.File"%>
<%@page import="java.io.FileOutputStream"%>
<%@page import="java.io.FileInputStream"%>
<%@page import="java.io.FileNotFoundException"%>
<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
  <jsp:include page="header.jsp" >
    <jsp:param name="pageName" value="XSS" />
  </jsp:include>
  <style type="text/css">>
   table {
       border-collapse: collapse;    
       border-spacing: 20px;
   }
   table, td, th {
       width: 900px;
       border: 1px solid #ccc;
       padding: 5px;
   }
   th:empty {
       border: 0;
   }
  </style>
        <%
            String testcaseParam = (String) request.getParameter("testcase");
            if (testcaseParam == null) {
        %>
               <div class="panel panel-default">
                   <div class="panel-heading">
                       <h4>XSS via Exception message</h4>
                   </div>
                   <div class="panel-body">
                       <form method="get" action="xssViaException.jsp">
                           <h3>Select test case:</h3>
                           <table>
                           <tr>
                               <th>Attack Vector</th>
                               <th>New Tag&nbsp;</th>
                               <th>Double-quoted Attr&nbsp;</th>
                               <th>Single-quoted Attr&nbsp;</th>
                               <th>Unquoted Attr&nbsp;</th>
                           </tr>
                           <tr>
                               <td>FNFE.getMessage() via FOS</td>
                               <td><input type="radio" name="testcase" value="1"></td>
                               <td><input type="radio" name="testcase" value="2"></td>
                               <td><input type="radio" name="testcase" value="3"></td>
                               <td><input type="radio" name="testcase" value="4"></td>
                           </tr>
                           <tr>
                               <td>FNFE.getLocalizedMessage() via FOS</td>
                               <td><input type="radio" name="testcase" value="5"></td>
                               <td><input type="radio" name="testcase" value="6"></td>
                               <td><input type="radio" name="testcase" value="7"></td>
                               <td><input type="radio" name="testcase" value="8"></td>
                           </tr>
                           <tr>
                               <td>FNFE.toString() via FOS</td>
                               <td><input type="radio" name="testcase" value="9"></td>
                               <td><input type="radio" name="testcase" value="10"></td>
                               <td><input type="radio" name="testcase" value="11"></td>
                               <td><input type="radio" name="testcase" value="12"></td>
                           </tr>
                           <tr>
                               <td>FNFE.getMessage() via FIS</td>
                               <td><input type="radio" name="testcase" value="13"></td>
                               <td><input type="radio" name="testcase" value="14"></td>
                               <td><input type="radio" name="testcase" value="15"></td>
                               <td><input type="radio" name="testcase" value="16"></td>
                           </tr>
                           <tr>
                               <td>FNFE.getLocalizedMessage() via FIS</td>
                               <td><input type="radio" name="testcase" value="17"></td>
                               <td><input type="radio" name="testcase" value="18"></td>
                               <td><input type="radio" name="testcase" value="19"></td>
                               <td><input type="radio" name="testcase" value="20"></td>
                           </tr>
                           <tr>
                               <td>FNFE.toString() via FIS</td>
                               <td><input type="radio" name="testcase" value="21"></td>
                               <td><input type="radio" name="testcase" value="22"></td>
                               <td><input type="radio" name="testcase" value="23"></td>
                               <td><input type="radio" name="testcase" value="24"></td>
                           </tr>
                           </table>

                        Payload: <input type="text" name="payload" style="width:400px"><br/>
                        <input type="submit" value="Submit"> <br/>
                       </form>
                   </div>
               </div>
           </div>
        <%
           } else {
        %>
           <div class="container">
               <div class="panel panel-default">
                   <div class="panel-body">
                   <a href="xssViaException.jsp">XSS via Exception messages test cases</a><br/>
                     <%
                        String filename = (String) request.getParameter("payload");
                        int testCase = Integer.parseInt(testcaseParam);
                        if (testCase == 1) {
                           try {
                              out.println("Test Case #"+testCase+": FNFE.getMessage() via FOS (New Tag)<br/><br/>");
                              new FileOutputStream(new File(filename));
                           }
                           catch(FileNotFoundException e) {
                              out.print(e.getMessage());
                           }
                        } else if (testCase == 2) {
                           try {
                              out.println("Test Case #"+testCase+": FNFE.getMessage() via FOS (Double-quoted Attr)<br/><br/>");
                              out.print("<img src=\"");
                              new FileOutputStream(new File(filename));
                           }
                           catch(FileNotFoundException e) {
                              out.print(e.getMessage());
                           }
                           out.println("\" />");
                        } else if (testCase == 3) {
                           try {
                              out.println("Test Case #"+testCase+": FNFE.getMessage() via FOS (Single-quoted Attr)<br/><br/>");
                              out.print("<img src=\'");
                              new FileOutputStream(new File(filename));
                           }
                           catch(FileNotFoundException e) {
                              out.print(e.getMessage());
                           }
                           out.println("\' />");
                        } else if (testCase == 4) {
                           try {
                              out.println("Test Case #"+testCase+": FNFE.getMessage() via FOS (Unquoted Attr)<br/><br/>");
                              out.print("<img src=");
                              new FileOutputStream(new File(filename));
                           }
                           catch(FileNotFoundException e) {
                              out.print(e.getMessage());
                           }
                           out.println(" />");
                        } else if (testCase == 5) {
                           try {
                              out.println("Test Case #"+testCase+": FNFE.getLocalizedMessage() via FOS (New Tag)<br/><br/>");
                              new FileOutputStream(new File(filename));
                           }
                           catch(FileNotFoundException e) {
                              out.print(e.getLocalizedMessage());
                           }
                        } else if (testCase == 6) {
                           try {
                              out.println("Test Case #"+testCase+": FNFE.getLocalizedMessage() via FOS (Double-quoted Attr)<br/><br/>");
                              out.print("<img src=\"");
                              new FileOutputStream(new File(filename));
                           }
                           catch(FileNotFoundException e) {
                              out.print(e.getLocalizedMessage());
                           }
                           out.println("\" />");
                        } else if (testCase == 7) {
                           try {
                              out.println("Test Case #"+testCase+": FNFE.getLocalizedMessage() via FOS (Single-quoted Attr)<br/><br/>");
                              out.print("<img src=\'");
                              new FileOutputStream(new File(filename));
                           }
                           catch(FileNotFoundException e) {
                              out.print(e.getLocalizedMessage());
                           }
                           out.println("\' />");
                        } else if (testCase == 8) {
                           try {
                              out.println("Test Case #"+testCase+": FNFE.getLocalizedMessage() via FOS (Unquoted Attr)<br/><br/>");
                              out.print("<img src=");
                              new FileOutputStream(new File(filename));
                           }
                           catch(FileNotFoundException e) {
                              out.print(e.getLocalizedMessage());
                           }
                           out.println(" />");
                        } else if (testCase == 9) {
                           try {
                              out.println("Test Case #"+testCase+": FNFE.toString() via FOS (New Tag)<br/><br/>");
                              new FileOutputStream(new File(filename));
                           }
                           catch(FileNotFoundException e) {
                              out.println(e);
                           }
                        } else if (testCase == 10) {
                           try {
                              out.println("Test Case #"+testCase+": FNFE.toString() via FOS (Double-quoted Attr)<br/><br/>");
                              out.print("<img src=\"");
                              new FileOutputStream(new File(filename));
                           }
                           catch(FileNotFoundException e) {
                              out.println(e);
                           }
                           out.println("\" />");
                        } else if (testCase == 11) {
                           try {
                              out.println("Test Case #"+testCase+": FNFE.toString() via FOS (Single-quoted Attr)<br/><br/>");
                              out.print("<img src=\'");
                              new FileOutputStream(new File(filename));
                           }
                           catch(FileNotFoundException e) {
                              out.println(e);
                           }
                           out.println("\' />");
                        } else if (testCase == 12) {
                           try {
                              out.println("Test Case #"+testCase+": FNFE.toString() via FOS (Unquoted Attr)<br/><br/>");
                              out.print("<img src=");
                              new FileOutputStream(new File(filename));
                           }
                           catch(FileNotFoundException e) {
                              out.println(e);
                           }
                           out.println(" />");
                        } else if (testCase == 13) {
                           try {
                              out.println("Test Case #"+testCase+": FNFE.getMessage() via FIS (New Tag)<br/><br/>");
                              File file = new File(filename);
                              new FileInputStream(file);
                           }
                           catch(FileNotFoundException e) {
                              out.print(e.getMessage());
                           }
                        } else if (testCase == 14) {
                           try {
                              out.println("Test Case #"+testCase+": FNFE.getMessage() via FIS (Double-quoted Attr)<br/><br/>");
                              out.print("<img src=\"");
                              new FileInputStream(new File(filename));
                           }
                           catch(FileNotFoundException e) {
                              out.print(e.getMessage());
                           }
                           out.println("\" />");
                        } else if (testCase == 15) {
                           try {
                              out.println("Test Case #"+testCase+": FNFE.getMessage() via FIS (Single-quoted Attr)<br/><br/>");
                              out.print("<img src=\'");
                              new FileInputStream(new File(filename));
                           }
                           catch(FileNotFoundException e) {
                              out.print(e.getMessage());
                           }
                           out.println("\' />");
                        } else if (testCase == 16) {
                           try {
                              out.println("Test Case #"+testCase+": FNFE.getMessage() via FIS (Unquoted Attr)<br/><br/>");
                              out.print("<img src=");
                              new FileInputStream(new File(filename));
                           }
                           catch(FileNotFoundException e) {
                              out.print(e.getMessage());
                           }
                           out.println(" />");
                        } else if (testCase == 17) {
                           try {
                              out.println("Test Case #"+testCase+": FNFE.getLocalizedMessage() via FIS (New Tag)<br/><br/>");
                              new FileInputStream(new File(filename));
                           }
                           catch(FileNotFoundException e) {
                              out.print(e.getLocalizedMessage());
                           }
                        } else if (testCase == 18) {
                           try {
                              out.println("Test Case #"+testCase+": FNFE.getLocalizedMessage() via FIS (Double-quoted Attr)<br/><br/>");
                              out.print("<img src=\"");
                              new FileInputStream(new File(filename));
                           }
                           catch(FileNotFoundException e) {
                              out.print(e.getLocalizedMessage());
                           }
                           out.println("\" />");
                        } else if (testCase == 19) {
                           try {
                              out.println("Test Case #"+testCase+": FNFE.getLocalizedMessage() via FIS (Single-quoted Attr)<br/><br/>");
                              out.print("<img src=\'");
                              new FileInputStream(new File(filename));
                           }
                           catch(FileNotFoundException e) {
                              out.print(e.getLocalizedMessage());
                           }
                           out.println("\' />");
                        } else if (testCase == 20) {
                           try {
                              out.println("Test Case #"+testCase+": FNFE.getLocalizedMessage() via FIS (Unquoted Attr)<br/><br/>");
                              out.print("<img src=");
                              new FileInputStream(new File(filename));
                           }
                           catch(FileNotFoundException e) {
                              out.print(e.getLocalizedMessage());
                           }
                           out.println(" />");
                        } else if (testCase == 21) {
                           try {
                              out.println("Test Case #"+testCase+": FNFE.toString() via FIS (New Tag)<br/><br/>");
                              new FileInputStream(new File(filename));
                           }
                           catch(FileNotFoundException e) {
                              out.println(e);
                           }
                        } else if (testCase == 22) {
                           try {
                              out.println("Test Case #"+testCase+": FNFE.toString() via FIS (Double-quoted Attr)<br/><br/>");
                              out.print("<img src=\"");
                              new FileInputStream(new File(filename));
                           }
                           catch(FileNotFoundException e) {
                              out.println(e);
                           }
                           out.println("\" />");
                        } else if (testCase == 23) {
                           try {
                              out.println("Test Case #"+testCase+": FNFE.toString() via FIS (Single-quoted Attr)<br/><br/>");
                              out.print("<img src=\'");
                              new FileInputStream(new File(filename));
                           }
                           catch(FileNotFoundException e) {
                              out.println(e);
                           }
                           out.println("\' />");
                        } else if (testCase == 24) {
                           try {
                              out.println("Test Case #"+testCase+": FNFE.toString() via FIS (Unquoted Attr)<br/><br/>");
                              out.print("<img src=");
                              new FileInputStream(new File(filename));
                           }
                           catch(FileNotFoundException e) {
                              out.println(e);
                           }
                           out.println(" />");
                        }
                     %>
                   </div>
               </div>
           </div>
        <%
           }
        %>
    <%@ include file="footer.jsp" %>
