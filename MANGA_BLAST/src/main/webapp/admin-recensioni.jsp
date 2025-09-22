<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%@ page import="model.RecensioneDAO, model.Recensione, java.util.List" %>
<%
    // Verifica se l'utente è admin
    String emailAdmin = (String) session.getAttribute("admin");
    if (emailAdmin == null) {
        response.sendRedirect("login.jsp");
        return;
    }
    
    // Carica tutte le recensioni
    RecensioneDAO recensioneDAO = new RecensioneDAO();
    List<Recensione> recensioni = recensioneDAO.getAllRecensioni();
%>

<!DOCTYPE html>
<html lang="it">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>Gestione Recensioni - Admin</title>
    <link rel="stylesheet" href="${pageContext.request.contextPath}/style/admin-recensioni.css?v=<%= System.currentTimeMillis() %>">
    <link rel="stylesheet" href="${pageContext.request.contextPath}/style/toast.css?v=<%= System.currentTimeMillis() %>">
    <script src="scripts/toast.js" defer></script>
    <script src="scripts/admin-recensioni.js" defer></script>
</head>
<body>
    <jsp:include page="header.jsp" />

    <div class="admin-container">
        <div class="admin-header">
            <h1>Gestione Recensioni</h1>
            <div class="admin-stats">
                <div class="stat-card">
                    <h3>Totale Recensioni</h3>
                    <span class="stat-number" id="totalReviews"><%= recensioni.size() %></span>
                </div>
                <div class="stat-card">
                    <h3>In Attesa</h3>
                    <span class="stat-number" id="pendingReviews">0</span>
                </div>
                <div class="stat-card">
                    <h3>Approvate</h3>
                    <span class="stat-number" id="approvedReviews">0</span>
                </div>
            </div>
        </div>

        <div class="filters-section">
            <div class="filter-group">
                <label for="statusFilter">Stato:</label>
                <select id="statusFilter">
                    <option value="all">Tutte</option>
                    <option value="pending">In Attesa</option>
                    <option value="approved">Approvate</option>
                    <option value="rejected">Rifiutate</option>
                </select>
            </div>
            <div class="filter-group">
                <label for="productTypeFilter">Tipo Prodotto:</label>
                <select id="productTypeFilter">
                    <option value="all">Tutti</option>
                    <option value="manga">Manga</option>
                    <option value="funko">Funko</option>
                </select>
            </div>
            <div class="filter-group">
                <label for="ratingFilter">Valutazione:</label>
                <select id="ratingFilter">
                    <option value="all">Tutte</option>
                    <option value="5">5 stelle</option>
                    <option value="4">4 stelle</option>
                    <option value="3">3 stelle</option>
                    <option value="2">2 stelle</option>
                    <option value="1">1 stella</option>
                </select>
            </div>
        </div>

        <div class="reviews-table-container">
            <table class="reviews-table">
                <thead>
                    <tr>
                        <th>ID</th>
                        <th>Utente</th>
                        <th>Prodotto</th>
                        <th>Tipo</th>
                        <th>Valutazione</th>
                        <th>Commento</th>
                        <th>Data</th>
                        <th>Stato</th>
                        <th>Azioni</th>
                    </tr>
                </thead>
                <tbody id="reviewsTableBody">
                    <% for (Recensione recensione : recensioni) { %>
                    <tr data-review-id="<%= recensione.getId() %>" data-status="<%= recensione.isAttiva() ? "approved" : "pending" %>">
                        <td><%= recensione.getId() %></td>
                        <td><%= recensione.getEmailUtente() %></td>
                        <td><%= recensione.getIdProdotto() %></td>
                        <td><%= recensione.getTipoProdotto() %></td>
                        <td>
                            <div class="rating-display">
                                <% for (int i = 1; i <= 5; i++) { %>
                                    <span class="star <%= i <= recensione.getVoto() ? "filled" : "empty" %>">
                                        <%= i <= recensione.getVoto() ? "★" : "☆" %>
                                    </span>
                                <% } %>
                                <span class="rating-number">(<%= recensione.getVoto() %>)</span>
                            </div>
                        </td>
                        <td class="comment-cell">
                            <div class="comment-preview">
                                <%= recensione.getCommento().length() > 100 ? 
                                    recensione.getCommento().substring(0, 100) + "..." : 
                                    recensione.getCommento() %>
                            </div>
                        </td>
                        <td><%= recensione.getDataCreazione().toString().substring(0, 16) %></td>
                        <td>
                            <span class="status-badge <%= recensione.isAttiva() ? "approved" : "pending" %>">
                                <%= recensione.isAttiva() ? "Approvata" : "In Attesa" %>
                            </span>
                        </td>
                        <td class="actions-cell">
                            <% if (!recensione.isAttiva()) { %>
                                <button class="btn-action btn-approve" onclick="moderateReview(<%= recensione.getId() %>, true)">
                                    Approva
                                </button>
                                <button class="btn-action btn-reject" onclick="moderateReview(<%= recensione.getId() %>, false)">
                                    Rifiuta
                                </button>
                            <% } else { %>
                                <button class="btn-action btn-reject" onclick="moderateReview(<%= recensione.getId() %>, false)">
                                    Rifiuta
                                </button>
                            <% } %>
                            <button class="btn-action btn-delete" onclick="deleteReview(<%= recensione.getId() %>)">
                                Elimina
                            </button>
                        </td>
                    </tr>
                    <% } %>
                </tbody>
            </table>
        </div>
    </div>

    <jsp:include page="footer.jsp" />
</body>
</html>
