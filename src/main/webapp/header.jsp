
<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ taglib uri="http://java.sun.com/jsp/jstl/core" prefix="c" %>
<%@ page import="java.util.Map"%>
<%@ page import="java.util.LinkedHashMap"%>
<%
  Map<String,String> namesMap = new LinkedHashMap<String,String>();
   namesMap.put("Overview", "index");
   namesMap.put("File", "file");
   namesMap.put("Network", "network");
   namesMap.put("SQL", "sql");
   namesMap.put("XSS", "xss");
   namesMap.put("CSRF", "csrf");
   namesMap.put("Path Traversal", "pathTraversal");
   namesMap.put("Deserialization", "deserial");
   namesMap.put("Misc", "misc");
   namesMap.put("Cookie", "cookie");
   request.setAttribute("pageNameMap", namesMap);
%>
<!DOCTYPE html>
<html>
    <head>
        <meta http-equiv="Content-Type" content="text/html; charset=UTF-8">
        <link rel="stylesheet" type="text/css" href="css/bootstrap.min.css">
        <link rel="stylesheet" type="text/css"
              href="css/bootstrap-theme.min.css">
        <link rel="stylesheet" type="text/css" href="css/style.css">
        <title>Spiracle - ${param.pageName}</title>
    </head>

    <body>
		<div class="navbar navbar-default navbar-fixed-top" role="navigation">
		  <div class="container">
		    <div class="navbar-header">
		      <button type="button" class="navbar-toggle collapsed" data-toggle="collapse" data-target=".navbar-collapse">
		      <span class="sr-only">Toggle navigation</span>
		      <span class="icon-bar"></span>
		      <span class="icon-bar"></span>
		      <span class="icon-bar"></span>
		      </button>
		      <a class="navbar-brand" href="index.jsp">Spiracle</a>
		    </div>
		    <div class="navbar-collapse collapse">
		      <ul class="nav navbar-nav">

            <c:forEach items="${pageNameMap}" var="mapItem">
                <c:choose>
                  <c:when test="${mapItem.key ==  param.pageName}">
                    <li class="active"><a href="${mapItem.value}.jsp"> ${mapItem.key}</a></li>
                  </c:when>
                  <c:otherwise>
                      <li><a href="${mapItem.value}.jsp"> ${mapItem.key}</a></li>
                  </c:otherwise>
              </c:choose>
            </c:forEach>

		      </ul>
		    </div>
		  </div>
		</div>
