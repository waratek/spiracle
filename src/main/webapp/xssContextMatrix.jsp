<%@ taglib uri="http://java.sun.com/jsp/jstl/core" prefix="c" %>
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
       width: 1000px;
       border: 1px solid #ccc;
       padding: 5px;
   }
   th:empty {
       border: 0;
   }
  </style>
        <%
            boolean singlePrint = (request.getParameter("singlePrint") != null && request.getParameter("singlePrint").equals("on"));
            String testcaseParam = (String) request.getParameter("testcase");
            if (testcaseParam == null) {
        %>
               <div class="panel panel-default">
                   <div class="panel-heading">
                       <h4>XSS Context Matrix</h4>
                   </div>
                   <div class="panel-body">
                       <form method="get" action="xssContextMatrix.jsp">
                           <h3>Select test case:</h3>
                           <table>
                           <tr>
                               <th>Context</th>
                               <th>Content&nbsp;</th>
                               <th>Double-quoted Attr&nbsp;</th>
                               <th>Single-quoted Attr&nbsp;</th>
                               <th>Unquoted Attr&nbsp;</th>
                               <th>Attribute Name&nbsp;</th>
                           </tr>
                           <tr>
                               <td>No concatenation</td>
                               <td><input type="radio" name="testcase" value="1"></td>
                               <td><input type="radio" name="testcase" value="2"></td>
                               <td><input type="radio" name="testcase" value="3"></td>
                               <td><input type="radio" name="testcase" value="4"></td>
                               <td><input type="radio" name="testcase" value="5"></td>
                           </tr>
                           <tr>
                               <td>Payload as Prefix</td>
                               <td><input type="radio" name="testcase" value="6"></td>
                               <td><input type="radio" name="testcase" value="7"></td>
                               <td><input type="radio" name="testcase" value="8"></td>
                               <td><input type="radio" name="testcase" value="9"></td>
                               <td><input type="radio" name="testcase" value="10"></td>
                           </tr>
                           <tr>
                               <td>Payload as Suffix</td>
                               <td><input type="radio" name="testcase" value="11"></td>
                               <td><input type="radio" name="testcase" value="12"></td>
                               <td><input type="radio" name="testcase" value="13"></td>
                               <td><input type="radio" name="testcase" value="14"></td>
                               <td><input type="radio" name="testcase" value="15"></td>
                           </tr>
                           </table>
                        Payload: <input type="text" name="payload" style="width:400px"><br/>
                        Single print statement: <input type="checkbox" name="singlePrint" <% if (singlePrint) out.print("checked=\"checked\""); %>><br/>
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
                   <a href="xssContextMatrix.jsp">XSS Context Matrix test cases</a><br/>
                     <%
                        String payload = (String) request.getParameter("payload");
                        int testCase = Integer.parseInt(testcaseParam);
                        if (testCase == 1) {
                           out.println("Test Case #"+testCase+": Content (No concatenation)<br/><br/>");
                           out.println(payload);
                        } else if (testCase == 2) {
                           out.println("Test Case #"+testCase+": Double-quoted Attr (No concatenation)<br/><br/>");
                           if (singlePrint) {
                              out.print("<img src=\""+payload+"\" />");
                           } else {
                              out.print("<img src=\"");
                              out.print(payload);
                              out.print("\" />");
                           }
                        } else if (testCase == 3) {
                           out.println("Test Case #"+testCase+": Single-quoted Attr (No concatenation)<br/><br/>");
                           if (singlePrint) {
                              out.print("<img src=\'"+payload+"\' />");
                           } else {
                              out.print("<img src=\'");
                              out.print(payload);
                              out.print("\' />");
                           }
                        } else if (testCase == 4) {
                           out.println("Test Case #"+testCase+": Unquoted Attr (No concatenation)<br/><br/>");
                           if (singlePrint) {
                              out.print("<img src="+payload+" />");
                           } else {
                              out.print("<img src=");
                              out.print(payload);
                              out.print(" />");
                           }
                        } else if (testCase == 5) {
                           out.println("Test Case #"+testCase+": Attribute Name (No concatenation)<br/><br/>");
                           if (singlePrint) {
                              out.print("<img "+payload+"='100' />");
                           } else {
                              out.print("<img ");
                              out.print(payload);
                              out.print("='100' />");
                           }
                        } else if (testCase == 6) {
                           out.println("Test Case #"+testCase+": Content (Payload as Prefix)<br/><br/>");
                           if (singlePrint) {
                              out.println(payload+"foo");
                           } else {
                              out.print(payload);
                              out.print("foo");
                           }
                        } else if (testCase == 7) {
                           out.println("Test Case #"+testCase+": Double-quoted Attr (Payload as Prefix)<br/><br/>");
                           if (singlePrint) {
                              out.print("<img src=\""+payload+"foo\" />");
                           } else {
                              out.print("<img src=\"");
                              out.print(payload);
                              out.print("foo\" />");
                           }
                        } else if (testCase == 8) {
                           out.println("Test Case #"+testCase+": Single-quoted Attr (Payload as Prefix)<br/><br/>");
                           if (singlePrint) {
                              out.print("<img src=\'"+payload+"foo\' />");
                           } else {
                              out.print("<img src=\'");
                              out.print(payload);
                              out.print("foo\' />");
                           }
                        } else if (testCase == 9) {
                           out.println("Test Case #"+testCase+": Unquoted Attr (Payload as Prefix)<br/><br/>");
                           if (singlePrint) {
                              out.print("<img src="+payload+"foo />");
                           } else {
                              out.print("<img src=");
                              out.print(payload);
                              out.print("foo />");
                           }
                        } else if (testCase == 10) {
                           out.println("Test Case #"+testCase+": Attribute Name (Payload as Prefix)<br/><br/>");
                           if (singlePrint) {
                              out.print("<img "+payload+"foo='100' />");
                           } else {
                              out.print("<img ");
                              out.print(payload);
                              out.print("foo='100' />");
                           }
                        } else if (testCase == 11) {
                           out.println("Test Case #"+testCase+": Content (Payload as Suffix)<br/><br/>");
                           if (singlePrint) {
                              out.println("foo"+payload);
                           } else {
                              out.print("foo");
                              out.print(payload);
                           }
                        } else if (testCase == 12) {
                           out.println("Test Case #"+testCase+": Double-quoted Attr (Payload as Suffix)<br/><br/>");
                           if (singlePrint) {
                              out.print("<img src=\"foo"+payload+"\" />");
                           } else {
                              out.print("<img src=\"foo");
                              out.print(payload);
                              out.print("\" />");
                           }
                        } else if (testCase == 13) {
                           out.println("Test Case #"+testCase+": Single-quoted Attr (Payload as Suffix)<br/><br/>");
                           if (singlePrint) {
                              out.print("<img src=\'foo"+payload+"\' />");
                           } else {
                              out.print("<img src=\'foo");
                              out.print(payload);
                              out.print("\' />");
                           }
                        } else if (testCase == 14) {
                           out.println("Test Case #"+testCase+": Unquoted Attr (Payload as Suffix)<br/><br/>");
                           if (singlePrint) {
                              out.print("<img src=foo"+payload+" />");
                           } else {
                              out.print("<img src=foo");
                              out.print(payload);
                              out.print(" />");
                           }
                        } else if (testCase == 15) {
                           out.println("Test Case #"+testCase+": Attribute Name (Payload as Suffix)<br/><br/>");
                           if (singlePrint) {
                              out.print("<img foo"+payload+"='100' />");
                           } else {
                              out.print("<img foo");
                              out.print(payload);
                              out.print("='100' />");
                           }
                        }
                     %>
                   </div>
               </div>
           </div>
        <%
           }
        %>
    <%@ include file="footer.jsp" %>
