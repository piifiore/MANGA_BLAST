<%--
  Created by IntelliJ IDEA.
  User: roman
  Date: 07/07/2025
  Time: 18:35
  To change this template use File | Settings | File Templates.
--%>
<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<html>
<head>
    <title>Admin Dashboard</title>

  <%
    if (session.getAttribute("admin") == null) {
      response.sendRedirect("login.jsp");
      return;
    }
  %>
  <h2>Benvenuto nella dashboard amministratore</h2>


  <form id="LogoutAdminServlet" method="get">
    <button type="submit">Logout Admin</button>
  </form>


</head>
<body>

</body>
</html>
