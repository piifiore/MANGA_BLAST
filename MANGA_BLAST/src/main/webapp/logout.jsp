<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%@ include file="navbar.jsp" %>
<%
  session.invalidate();
  response.sendRedirect("index.jsp");
%>