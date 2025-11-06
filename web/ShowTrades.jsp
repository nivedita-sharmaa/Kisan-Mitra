<%@ include file="SessionValidator.jsp" %>
<%@ page import="db.DBConnector" %>
<%@ page import="java.sql.*" %>
<%@ page import="java.util.*" %>
<%
    response.setHeader("Cache-Control", "no-cache, no-store, must-revalidate");
    response.setHeader("Pragma", "no-cache");
    response.setDateHeader("Expires", 0);
    
    String farmerEmail = (String) session.getAttribute("email");
    
    if (farmerEmail == null || farmerEmail.isEmpty()) {
        response.sendRedirect("Login.jsp");
        return;
    }
    
    // Process delete request
    String deleteId = request.getParameter("delete");
    if (deleteId != null && !deleteId.isEmpty()) {
        try {
            Connection conn = DBConnector.getConnection();
            PreparedStatement ps = conn.prepareStatement("DELETE FROM tradecreation WHERE id = ? AND farmer_email = ?");
            ps.setInt(1, Integer.parseInt(deleteId));
            ps.setString(2, farmerEmail);
            int result = ps.executeUpdate();
            if (result > 0) {
                session.setAttribute("message", "Trade deleted successfully");
                session.setAttribute("messageType", "success");
            } else {
                session.setAttribute("message", "Failed to delete trade");
                session.setAttribute("messageType", "error");
            }
            ps.close();
            conn.close();
            response.sendRedirect("ShowTrades.jsp");
            return;
        } catch (Exception e) {
            session.setAttribute("message", "Error: " + e.getMessage());
            session.setAttribute("messageType", "error");
            response.sendRedirect("ShowTrades.jsp");
            return;
        }
    }
    
    // Process availability toggle request
    String toggleId = request.getParameter("toggle");
    String availabilityStatus = request.getParameter("status");
    if (toggleId != null && !toggleId.isEmpty() && availabilityStatus != null) {
        try {
            Connection conn = DBConnector.getConnection();
            PreparedStatement ps = conn.prepareStatement("UPDATE tradecreation SET available = ? WHERE id = ? AND farmer_email = ?");
            ps.setBoolean(1, availabilityStatus.equals("true"));
            ps.setInt(2, Integer.parseInt(toggleId));
            ps.setString(3, farmerEmail);
            int result = ps.executeUpdate();
            if (result > 0) {
                session.setAttribute("message", "Availability status updated");
                session.setAttribute("messageType", "success");
            } else {
                session.setAttribute("message", "Failed to update availability");
                session.setAttribute("messageType", "error");
            }
            ps.close();
            conn.close();
            response.sendRedirect("ShowTrades.jsp");
            return;
        } catch (Exception e) {
            session.setAttribute("message", "Error: " + e.getMessage());
            session.setAttribute("messageType", "error");
            response.sendRedirect("ShowTrades.jsp");
            return;
        }
    }
    
    // Get trades from database
    List<Map<String, Object>> trades = new ArrayList<>();
    Connection conn = null;
    PreparedStatement ps = null;
    ResultSet rs = null;
    try {
        conn = DBConnector.getConnection();
        String query = "SELECT id, commodity, category, origin, quantity, buyingprice, image, available FROM tradecreation WHERE farmer_email = ? ORDER BY created_at DESC";
        ps = conn.prepareStatement(query);
        ps.setString(1, farmerEmail);
        rs = ps.executeQuery();
        
        while (rs.next()) {
            Map<String, Object> trade = new HashMap<>();
            trade.put("id", rs.getInt("id"));
            trade.put("commodity", rs.getString("commodity"));
            trade.put("category", rs.getString("category"));
            trade.put("origin", rs.getString("origin"));
            trade.put("quantity", rs.getInt("quantity"));
            trade.put("buyingprice", rs.getDouble("buyingprice"));
            trade.put("available", rs.getBoolean("available"));
            
            byte[] imageBytes = rs.getBytes("image");
            String base64Image = "";
            if (imageBytes != null && imageBytes.length > 0) {
                base64Image = java.util.Base64.getEncoder().encodeToString(imageBytes);
            }
            trade.put("base64Image", base64Image);
            trades.add(trade);
        }
    } catch (SQLException e) {
        out.println("<p style='color:red;'>SQL Error: " + e.getMessage() + "</p>");
    } finally {
        try {
            if (rs != null) rs.close();
            if (ps != null) ps.close();
            if (conn != null) conn.close();
        } catch (SQLException e) {
            out.println("<p style='color:red;'>Error closing connection: " + e.getMessage() + "</p>");
        }
    }
%>

<!DOCTYPE html>
<html lang="en">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>My Listings - Kisan Mitra</title>
    <link href="https://cdnjs.cloudflare.com/ajax/libs/font-awesome/6.0.0-beta3/css/all.min.css" rel="stylesheet">
    <style>
        * {
            margin: 0;
            padding: 0;
            box-sizing: border-box;
            font-family: -apple-system, BlinkMacSystemFont, 'Segoe UI', Roboto, sans-serif;
        }
        
        body {
            background: linear-gradient(135deg, #667eea 0%, #764ba2 100%);
            min-height: 100vh;
        }
        
        /* Header */
        .header {
            background: linear-gradient(135deg, #1e3c72 0%, #2a5298 100%);
            position: sticky;
            top: 0;
            z-index: 1000;
            box-shadow: 0 4px 20px rgba(0,0,0,0.2);
        }
        
        .header-content {
            max-width: 1400px;
            margin: 0 auto;
            padding: 18px 30px;
            display: flex;
            justify-content: space-between;
            align-items: center;
        }
        
        .logo {
            font-size: 1.8rem;
            font-weight: 800;
            color: white;
            display: flex;
            align-items: center;
            gap: 10px;
            letter-spacing: -0.5px;
        }
        
        .nav-links {
            display: flex;
            gap: 30px;
            align-items: center;
        }
        
        .nav-item {
            color: white;
            text-decoration: none;
            font-weight: 600;
            font-size: 1rem;
            display: flex;
            align-items: center;
            gap: 8px;
            padding: 10px 20px;
            border-radius: 8px;
            transition: all 0.3s;
            position: relative;
        }
        
        .nav-item:hover {
            background: rgba(255,255,255,0.1);
            transform: translateY(-2px);
        }
        
        .nav-item.active {
            background: rgba(255,255,255,0.15);
        }
        
        /* Main Content */
        .main-content {
            max-width: 1400px;
            margin: 0 auto;
            padding: 40px 30px;
        }
        
        .section-header {
            margin-bottom: 40px;
            text-align: center;
        }
        
        .section-title {
            font-size: 2.5rem;
            font-weight: 900;
            color: white;
            text-shadow: 2px 2px 4px rgba(0,0,0,0.2);
            margin-bottom: 10px;
        }
        
        .section-subtitle {
            color: rgba(255,255,255,0.9);
            font-size: 1.1rem;
        }
        
        /* Search and Filters */
        .filters {
            background: white;
            padding: 20px;
            border-radius: 15px;
            margin-bottom: 30px;
            box-shadow: 0 5px 20px rgba(0,0,0,0.1);
            display: flex;
            gap: 20px;
            align-items: center;
            flex-wrap: wrap;
        }
        
        .search-container {
            flex: 1;
            min-width: 250px;
            position: relative;
        }
        
        .search-container input {
            width: 100%;
            padding: 12px 20px 12px 40px;
            border: 2px solid #e0e0e0;
            border-radius: 25px;
            font-size: 1rem;
            transition: all 0.3s;
        }
        
        .search-container input:focus {
            outline: none;
            border-color: #667eea;
            box-shadow: 0 0 0 3px rgba(102, 126, 234, 0.1);
        }
        
        .search-container i {
            position: absolute;
            left: 15px;
            top: 50%;
            transform: translateY(-50%);
            color: #999;
        }
        
        .filter-buttons {
            display: flex;
            gap: 10px;
        }
        
        .filter-btn {
            padding: 10px 20px;
            border: 2px solid #e0e0e0;
            background: white;
            border-radius: 25px;
            cursor: pointer;
            font-weight: 600;
            transition: all 0.3s;
            font-size: 0.95rem;
            display: flex;
            align-items: center;
            gap: 8px;
        }
        
        .filter-btn:hover {
            border-color: #667eea;
            color: #667eea;
        }
        
        .filter-btn.active {
            background: linear-gradient(135deg, #667eea 0%, #764ba2 100%);
            color: white;
            border-color: transparent;
        }
        
        /* Product Grid */
        .products-grid {
            display: grid;
            grid-template-columns: repeat(auto-fill, minmax(250px, 1fr));
            gap: 25px;
        }
        
        .product-card {
            background: white;
            border-radius: 15px;
            overflow: hidden;
            box-shadow: 0 5px 20px rgba(0,0,0,0.1);
            transition: all 0.4s cubic-bezier(0.175, 0.885, 0.32, 1.275);
            position: relative;
        }
        
        .product-card:hover {
            transform: translateY(-10px);
            box-shadow: 0 15px 40px rgba(0,0,0,0.2);
        }
        
        .product-image-wrapper {
            position: relative;
            height: 200px;
            overflow: hidden;
            background: linear-gradient(135deg, #f5f7fa 0%, #c3cfe2 100%);
        }
        
        .product-image-wrapper img {
            width: 100%;
            height: 100%;
            object-fit: cover;
            transition: transform 0.4s;
        }
        
        .product-card:hover .product-image-wrapper img {
            transform: scale(1.1);
        }
        
        .no-image {
            width: 100%;
            height: 100%;
            display: flex;
            align-items: center;
            justify-content: center;
            color: rgba(0,0,0,0.1);
            font-size: 4rem;
        }
        
        .status-badge {
            position: absolute;
            top: 15px;
            right: 15px;
            padding: 8px 15px;
            border-radius: 20px;
            font-size: 12px;
            font-weight: 700;
            box-shadow: 0 4px 15px rgba(0,0,0,0.2);
        }
        
        .status-available {
            background: #00b894;
            color: white;
        }
        
        .status-unavailable {
            background: #ff7675;
            color: white;
        }
        
        .product-details {
            padding: 20px;
        }
        
        .product-name {
            font-size: 1.3rem;
            font-weight: 700;
            color: #2d3436;
            margin-bottom: 8px;
            overflow: hidden;
            text-overflow: ellipsis;
            white-space: nowrap;
        }
        
        .product-category {
            display: inline-block;
            background: rgba(102, 126, 234, 0.1);
            color: #667eea;
            padding: 4px 12px;
            border-radius: 20px;
            font-size: 12px;
            font-weight: 600;
            margin-bottom: 12px;
        }
        
        .product-meta {
            display: flex;
            justify-content: space-between;
            margin-bottom: 15px;
            font-size: 0.95rem;
            color: #636e72;
        }
        
        .meta-item {
            display: flex;
            align-items: center;
            gap: 6px;
        }
        
        .meta-item i {
            color: #667eea;
        }
        
        .product-footer {
            display: flex;
            justify-content: space-between;
            align-items: center;
            padding-top: 15px;
            border-top: 2px solid #f1f3f5;
            margin-top: 15px;
        }
        
        .product-price {
            font-size: 1.5rem;
            font-weight: 900;
            background: linear-gradient(135deg, #667eea 0%, #764ba2 100%);
            -webkit-background-clip: text;
            -webkit-text-fill-color: transparent;
        }
        
        .action-buttons {
            display: flex;
            gap: 10px;
            margin-top: 15px;
        }
        
        .btn {
            flex: 1;
            padding: 10px;
            border: none;
            border-radius: 8px;
            font-weight: 600;
            cursor: pointer;
            transition: all 0.3s;
            font-size: 0.9rem;
            display: flex;
            align-items: center;
            justify-content: center;
            gap: 8px;
        }
        
        .btn-toggle {
            background: linear-gradient(135deg, #667eea 0%, #764ba2 100%);
            color: white;
            box-shadow: 0 4px 15px rgba(102, 126, 234, 0.3);
        }
        
        .btn-toggle:hover {
            transform: scale(1.05);
            box-shadow: 0 6px 20px rgba(102, 126, 234, 0.5);
        }
        
        .btn-delete {
            background: #ff7675;
            color: white;
            box-shadow: 0 4px 15px rgba(255, 118, 117, 0.3);
        }
        
        .btn-delete:hover {
            background: #d63031;
            transform: scale(1.05);
        }
        
        .empty-state {
            text-align: center;
            padding: 100px 20px;
            color: white;
            grid-column: 1 / -1;
        }
        
        .empty-state i {
            font-size: 5rem;
            margin-bottom: 25px;
            opacity: 0.5;
        }
        
        .empty-state h3 {
            font-size: 2rem;
            margin-bottom: 15px;
            text-shadow: 2px 2px 4px rgba(0,0,0,0.2);
        }
        
        .empty-state a {
            color: #ffd93d;
            text-decoration: none;
            font-weight: 700;
        }
        
        /* Alert Message */
        .alert-message {
            position: fixed;
            top: 20px;
            left: 50%;
            transform: translateX(-50%);
            padding: 15px 25px;
            border-radius: 8px;
            color: white;
            font-weight: 600;
            z-index: 2000;
            box-shadow: 0 4px 20px rgba(0,0,0,0.2);
            animation: slideDown 0.5s ease-out;
        }
        
        .alert-success {
            background: #00b894;
        }
        
        .alert-error {
            background: #ff7675;
        }
        
        /* Modal */
        .modal {
            display: none;
            position: fixed;
            z-index: 1500;
            left: 0;
            top: 0;
            width: 100%;
            height: 100%;
            background-color: rgba(0,0,0,0.5);
            animation: fadeIn 0.3s ease-out;
        }
        
        .modal-content {
            background: white;
            margin: 25% auto;
            padding: 40px;
            border-radius: 15px;
            max-width: 400px;
            width: 90%;
            box-shadow: 0 10px 40px rgba(0,0,0,0.3);
            text-align: center;
            animation: slideDown 0.3s ease-out;
        }
        
        .modal-title {
            font-size: 1.5rem;
            font-weight: 700;
            color: #2d3436;
            margin-bottom: 15px;
        }
        
        .modal-message {
            font-size: 1rem;
            color: #636e72;
            margin-bottom: 30px;
            line-height: 1.6;
        }
        
        .modal-buttons {
            display: flex;
            gap: 15px;
        }
        
        .modal-buttons button {
            flex: 1;
            padding: 12px;
            border: none;
            border-radius: 8px;
            font-weight: 600;
            cursor: pointer;
            transition: all 0.3s;
            font-size: 1rem;
        }
        
        .btn-cancel {
            background: #e0e0e0;
            color: #333;
        }
        
        .btn-cancel:hover {
            background: #d0d0d0;
        }
        
        .btn-confirm {
            background: #ff7675;
            color: white;
        }
        
        .btn-confirm:hover {
            background: #d63031;
        }
        
        /* Animations */
        @keyframes fadeIn {
            from { opacity: 0; }
            to { opacity: 1; }
        }
        
        @keyframes slideDown {
            from {
                opacity: 0;
                transform: translateY(-20px);
            }
            to {
                opacity: 1;
                transform: translateY(0);
            }
        }
        
        @media (max-width: 768px) {
            .header-content {
                flex-direction: column;
                gap: 15px;
            }
            
            .nav-links {
                flex-wrap: wrap;
                gap: 10px;
                justify-content: center;
            }
            
            .products-grid {
                grid-template-columns: repeat(auto-fill, minmax(200px, 1fr));
                gap: 15px;
            }
            
            .section-title {
                font-size: 2rem;
            }
            
            .filters {
                flex-direction: column;
                align-items: stretch;
            }
            
            .filter-buttons {
                width: 100%;
                justify-content: center;
                flex-wrap: wrap;
            }
        }
        
        @media (max-width: 480px) {
            .products-grid {
                grid-template-columns: 1fr;
            }
        }
        .footer {
            text-align: center;
            padding: 20px;
            color: white;
            font-size: 0.9rem;
            background: rgba(26, 42, 108, 0.5);
        }
    </style>
</head>
<body>
    <!-- Header -->
    <div class="header">
        <div class="header-content">
            <div class="logo">
                <i class="fas fa-leaf"></i>
                Kisan Mitra
            </div>
            <div class="nav-links">
                <a href="FarmerDashboard.jsp" class="nav-item">
                    <i class="fas fa-home"></i>
                    Dashboard
                </a>
                <a href="UploadTrade.jsp" class="nav-item">
                    <i class="fas fa-upload"></i>
                    Upload Trade
                </a>
                
                <a href="FarmerSales.jsp" class="nav-item">
                <i class="fas fa-dollar-sign"></i>
                 Sales
                </a>
                
                <a href="FarmerProfile.jsp" class="nav-item">
                    <i class="fas fa-user"></i>
                    Profile
                </a>
<!--                <a href="Logout.jsp" class="nav-item">
                    <i class="fas fa-sign-out-alt"></i>
                    Logout
                </a>-->
            </div>
        </div>
    </div>

    <!-- Alert Message -->
    <% 
        String message = (String) session.getAttribute("message");
        String messageType = (String) session.getAttribute("messageType");
        if (message != null && !message.isEmpty()) {
            String alertClass = messageType.equals("success") ? "alert-success" : "alert-error";
    %>
    <div class="alert-message <%= alertClass %>">
        <%= message %>
    </div>
    <script>
        setTimeout(function() {
            const alert = document.querySelector('.alert-message');
            if (alert) {
                alert.style.opacity = '0';
                alert.style.transition = 'opacity 0.5s ease';
                setTimeout(function() {
                    alert.remove();
                }, 500);
            }
        }, 3000);
    </script>
    <% 
        session.removeAttribute("message");
        session.removeAttribute("messageType");
    } 
    %>

    <!-- Main Content -->
    <div class="main-content">
        <div class="section-header">
            <h1 class="section-title">My Listings</h1>
            <p class="section-subtitle">Manage your crop trades</p>
        </div>

        <!-- Search and Filters -->
        <div class="filters">
            <div class="search-container">
                <i class="fas fa-search"></i>
                <input type="text" id="searchInput" placeholder="Search commodities...">
            </div>
            <div class="filter-buttons">
                <button class="filter-btn active" data-filter="all">
                    <i class="fas fa-border-all"></i> All
                </button>
                <button class="filter-btn" data-filter="available">
                    <i class="fas fa-check-circle"></i> Available
                </button>
                <button class="filter-btn" data-filter="unavailable">
                    <i class="fas fa-times-circle"></i> Unavailable
                </button>
            </div>
        </div>

        <!-- Products Grid -->
        <div class="products-grid">
            <% 
                if (!trades.isEmpty()) {
                    for (Map<String, Object> trade : trades) {
                        String base64Image = (String) trade.get("base64Image");
                        String commodity = (String) trade.get("commodity");
                        String category = (String) trade.get("category");
                        String origin = (String) trade.get("origin");
                        int quantity = (Integer) trade.get("quantity");
                        double price = (Double) trade.get("buyingprice");
                        int id = (Integer) trade.get("id");
                        boolean isAvailable = (Boolean) trade.get("available");
            %>
            <div class="product-card" data-available="<%= isAvailable %>">
                <div class="product-image-wrapper">
                    <% if (!base64Image.isEmpty()) { %>
                        <img src="data:image/jpeg;base64,<%= base64Image %>" alt="<%= commodity %>" loading="lazy">
                    <% } else { %>
                        <div class="no-image">
                            <i class="fas fa-seedling"></i>
                        </div>
                    <% } %>
                    <span class="status-badge <%= isAvailable ? "status-available" : "status-unavailable" %>">
                        <%= isAvailable ? "Available" : "Unavailable" %>
                    </span>
                </div>
                <div class="product-details">
                    <div class="product-name"><%= commodity %></div>
                    <span class="product-category"><%= category %></span>
                    
                    <div class="product-meta">
                        <div class="meta-item">
                            <i class="fas fa-map-marker-alt"></i>
                            <%= origin %>
                        </div>
                        <div class="meta-item">
                            <i class="fas fa-box"></i>
                            <%= quantity %> Kg
                        </div>
                    </div>
                    
                    <div class="product-footer">
                        <div class="product-price">&#8377;<%= String.format("%,.0f", price) %></div>
                    </div>
                    
                    <div class="action-buttons">
                        <button class="btn btn-toggle" onclick="toggleAvailability(<%= id %>, <%= !isAvailable %>)">
                            <i class="fas fa-<%= isAvailable ? "toggle-on" : "toggle-off" %>"></i>
                            <%= isAvailable ? "Unavailable" : "Available" %>
                        </button>
                        <button class="btn btn-delete" onclick="confirmDelete(<%= id %>, '<%= commodity %>')">
                            <i class="fas fa-trash"></i> Delete
                        </button>
                    </div>
                </div>
            </div>
            <% 
                    }
                } else {
            %>
            <div class="empty-state">
                <i class="fas fa-seedling"></i>
                <h3>No Listings Yet</h3>
                <p>Create your first trade to get started - <a href="UploadTrade.jsp">Add Trade</a></p>
            </div>
            <% } %>
        </div>
    </div>

    <!-- Delete Confirmation Modal -->
    <div id="deleteModal" class="modal">
        <div class="modal-content">
            <div class="modal-title">Confirm Deletion</div>
            <div class="modal-message">Are you sure you want to delete <span id="deleteItemName"></span>?</div>
            <div class="modal-buttons">
                <button class="btn-cancel" onclick="closeModal()">Cancel</button>
                <button class="btn-confirm" id="confirmDeleteBtn">Delete</button>
            </div>
        </div>
    </div>

    <script>
        // Search functionality
        document.getElementById('searchInput').addEventListener('keyup', function() {
            const value = this.value.toLowerCase();
            document.querySelectorAll('.product-card').forEach(card => {
                const text = card.textContent.toLowerCase();
                card.style.display = text.includes(value) ? '' : 'none';
            });
        });

        // Filter buttons
        document.querySelectorAll('.filter-btn').forEach(btn => {
            btn.addEventListener('click', function() {
                document.querySelectorAll('.filter-btn').forEach(b => b.classList.remove('active'));
                this.classList.add('active');
                
                const filter = this.dataset.filter;
                document.querySelectorAll('.product-card').forEach(card => {
                    if (filter === 'all') {
                        card.style.display = '';
                    } else if (filter === 'available') {
                        card.style.display = card.dataset.available === 'true' ? '' : 'none';
                    } else if (filter === 'unavailable') {
                        card.style.display = card.dataset.available === 'false' ? '' : 'none';
                    }
                });
            });
        });

        // Delete confirmation
        function confirmDelete(id, itemName) {
            document.getElementById('deleteItemName').textContent = itemName;
            document.getElementById('confirmDeleteBtn').onclick = function() {
                deleteTrade(id);
            };
            document.getElementById('deleteModal').style.display = 'block';
        }

        function closeModal() {
            document.getElementById('deleteModal').style.display = 'none';
        }

        function deleteTrade(id) {
            window.location.href = 'ShowTrades.jsp?delete=' + id;
        }

        function toggleAvailability(id, newStatus) {
            window.location.href = 'ShowTrades.jsp?toggle=' + id + '&status=' + newStatus;
        }

        // Close modal when clicking outside
        window.onclick = function(event) {
            const modal = document.getElementById('deleteModal');
            if (event.target === modal) {
                closeModal();
            }
        }
    </script>
    <div class="footer">
        <p>&copy; 2025 Kisan Mitra. Empowering farmers through technology.</p>
    </div>
</body>
</html>