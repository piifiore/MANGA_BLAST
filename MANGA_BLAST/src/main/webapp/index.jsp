
<%@ page import="java.util.List" %>
<%@ page import="model.ProdottoDAO" %>
<%@ page import="model.Prodotto" %>
<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%
  ProdottoDAO dao = new ProdottoDAO();
  List<Prodotto> prodotti = dao.getAllProdotti();

  String utente = (String) session.getAttribute("user");
%>

<!DOCTYPE html>
<html lang="it">
<head>
  <meta charset="UTF-8">

  <title>MangaBlast</title>
  <link rel="stylesheet" href="style/index.css">
  <title>Home - E-Commerce</title>
  <link rel="stylesheet" href="${pageContext.request.contextPath}/style/index.css">
</head>



<body>
<%--<%@ include file="includes/header.jsp" %>--%>
  <header class="header">
    <nav class="nav">
      <a href="index.jsp">Home</a>
      <a href="carrello.jsp">Carrello</a>
      <% if (utente == null) { %>
      <a href="login.jsp">Login</a>
      <a href="signup.jsp">Registrati</a>
      <% } else { %>
      <span>👤 <%= utente %></span>
      <a href="LogoutUserServlet">Logout</a>
      <% } %>
    </nav>
  </header>

  <br>
  <br>
  <br>
  <br>
  <br>


  <div style="display:flex; justify-content: space-between; text-align: center; border:3px solid yellow;">

       <div style="border: 5px solid red; width:250px; height: 300px;"> <%-- div1 --%>
          <img src="img/onepiece_v1" alt="no">
       </div>

       <div style="border: 5px solid orange; width:250px; height: 300px;">      <%-- div2 --%>
          <p>PRODOTTO1</p>
       </div>

       <div  style="border: 5px solid purple; width:250px; height: 300px;">       <%-- div3--%>
          <p>PRODOTTO2</p>
       </div>

      <div  style="border: 5px solid green; width:250px; height: 300px;">       <%-- div4--%>
        <p>PRODOTTO2</p>
      </div>



  </div>



<%--<%@ include file="includes/footer.jsp" %>--%>
</body>
</html>


