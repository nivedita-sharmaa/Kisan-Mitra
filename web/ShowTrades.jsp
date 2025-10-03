
<%@ page import="db.DBConnector" %>
<%@ page import="java.sql.*" %>
<%@ page import="java.util.*" %>
<!DOCTYPE html>
<html lang="en">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>Farmer's Marketplace - Crop Listings</title>
    <link href="https://cdnjs.cloudflare.com/ajax/libs/font-awesome/6.0.0-beta3/css/all.min.css" rel="stylesheet">
    <style>
        :root {
            --primary-color: #2e7d32;
            --secondary-color: #81c784;
            --accent-color: #f9a825;
            --danger-color: #f44336;
            --text-color: #333;
            --light-bg: #f5f5f5;
            --white: #fff;
            --shadow: 0 4px 6px rgba(0, 0, 0, 0.1);
            --card-radius: 12px;
        }
        
        * {
            margin: 0;
            padding: 0;
            box-sizing: border-box;
            font-family: 'Segoe UI', Tahoma, Geneva, Verdana, sans-serif;
        }
        
        body {
            background: linear-gradient(135deg, #f5f7fa 0%, #e4e9f2 100%);
            color: var(--text-color);
            line-height: 1.6;
            padding: 0;
            margin: 0;
        }
        
        .container {
            max-width: 1200px;
            margin: 0 auto;
            padding: 20px;
        }
        
        header {
            background: linear-gradient(135deg, #1a2a6c, #b21f1f, #fdbb2d);
            color:white;
            padding: 20px 0;
            text-align: center;
            margin-bottom: 30px;
            box-shadow: var(--shadow);
            position: relative;
            overflow: hidden;
        }
        
        header h1 {
            margin: 0;
            font-size: 2.5rem;
            animation: fadeInDown 1s ease-out;
        }
        
        header p {
            font-size: 1.2rem;
            opacity: 0.9;
            margin-top: 10px;
            animation: fadeInUp 1s ease-out;
        }
        
        .header-graphic {
            position: absolute;
            width: 100%;
            height: 100%;
            top: 0;
            left: 0;
            overflow: hidden;
            z-index: 0;
        }
        
        .header-graphic svg {
            position: absolute;
            bottom: -20px;
            left: 0;
            width: 100%;
            height: auto;
            opacity: 0.1;
        }
        
        .header-content {
            position: relative;
            z-index: 1;
        }
        
        .grid-container {
            display: grid;
            grid-template-columns: repeat(auto-fill, minmax(280px, 1fr));
            gap: 25px;
            margin-top: 20px;
        }
        
        .card {
            background: var(--white);
            border-radius: var(--card-radius);
            box-shadow: var(--shadow);
            overflow: hidden;
            transition: transform 0.3s ease, box-shadow 0.3s ease;
            animation: fadeIn 0.6s ease-out forwards;
            opacity: 0;
            transform: translateY(20px);
            position: relative;
        }
        
        .card:hover {
            transform: translateY(-10px);
            box-shadow: 0 12px 24px rgba(0, 0, 0, 0.15);
        }
        
        .card-image {
            height: 180px;
            overflow: hidden;
            position: relative;
            background-color: #f0f0f0;
        }
        
        .card-image img {
            width: 100%;
            height: 100%;
            object-fit: cover;
            transition: transform 0.5s ease;
        }
        
        .card:hover .card-image img {
            transform: scale(1.1);
        }
        
        .no-image {
            display: flex;
            justify-content: center;
            align-items: center;
            height: 100%;
            color: #aaa;
            font-size: 3rem;
        }
        
        .card-content {
            padding: 20px;
        }
        
        .card-title {
            font-size: 1.5rem;
            font-weight: bold;
            margin-bottom: 5px;
            color: var(--primary-color);
        }
        
        .card-origin {
            color: #666;
            font-size: 0.9rem;
            display: flex;
            align-items: center;
            margin-bottom: 15px;
        }
        
        .card-origin i {
            margin-right: 5px;
            color: var(--accent-color);
        }
        
        .card-details {
            display: flex;
            justify-content: space-between;
            margin-top: 15px;
            padding-top: 15px;
            border-top: 1px solid #eee;
        }
        
        .detail-item {
            display: flex;
            flex-direction: column;
            align-items: center;
        }
        
        .detail-label {
            font-size: 0.8rem;
            color: #888;
        }
        
        .detail-value {
            font-weight: bold;
            font-size: 1.1rem;
            color: var(--text-color);
        }
        
        .badge {
            background-color: var(--accent-color);
            color: white;
            padding: 4px 10px;
            border-radius: 20px;
            font-size: 0.85rem;
            font-weight: 600;
            display: inline-block;
        }
        
        .badge-unavailable {
            background-color: #aaa;
        }
        
        .filters {
            display: flex;
            justify-content: space-between;
            align-items: center;
            margin-bottom: 20px;
            padding: 15px 20px;
            background: var(--white);
            border-radius: var(--card-radius);
            box-shadow: var(--shadow);
            animation: fadeIn 0.6s ease-out;
        }
        
        .search-container {
            flex: 1;
            max-width: 400px;
            position: relative;
        }
        
        .search-container input {
            width: 100%;
            padding: 12px 20px;
            padding-left: 40px;
            border: 1px solid #ddd;
            border-radius: 30px;
            font-size: 0.9rem;
            transition: all 0.3s ease;
        }
        
        .search-container input:focus {
            outline: none;
            border-color: var(--primary-color);
            box-shadow: 0 0 0 2px rgba(46, 125, 50, 0.2);
        }
        
        .search-container i {
            position: absolute;
            left: 15px;
            top: 50%;
            transform: translateY(-50%);
            color: #888;
        }
        
        .filter-options {
            display: flex;
            gap: 10px;
        }
        
        .filter-btn {
            padding: 8px 15px;
            background: var(--light-bg);
            border: none;
            border-radius: 20px;
            cursor: pointer;
            font-size: 0.9rem;
            transition: all 0.3s ease;
        }
        
        .filter-btn:hover, .filter-btn.active {
            background: var(--primary-color);
            color: white;
        }
        
        .filter-btn i {
            margin-right: 5px;
        }
        
        .placeholder {
            min-height: 400px;
            display: flex;
            justify-content: center;
            align-items: center;
            color: #aaa;
            font-size: 1.2rem;
        }
        
        footer {
            text-align: center;
            padding: 30px 0;
            margin-top: 50px;
            color: #777;
            font-size: 0.9rem;
        }
        
        /* Card Actions */
        .card-actions {
            display: flex;
            justify-content: space-between;
            padding: 10px 20px;
            background-color: #f9f9f9;
            border-top: 1px solid #eee;
        }
        
        .btn {
            padding: 8px 15px;
            border: none;
            border-radius: 4px;
            cursor: pointer;
            font-weight: 600;
            font-size: 0.9rem;
            transition: all 0.3s ease;
            display: inline-flex;
            align-items: center;
            justify-content: center;
        }
        
        .btn i {
            margin-right: 5px;
        }
        
        .btn-danger {
            background-color: var(--danger-color);
            color: white;
        }
        
        .btn-danger:hover {
            background-color: #d32f2f;
        }
        
        .btn-toggle {
            background-color: var(--primary-color);
            color: white;
        }
        
        .btn-toggle:hover {
            background-color: #1b5e20;
        }
        
        .btn-toggle.unavailable {
            background-color: #aaa;
        }
        
        /* Modal Styles */
        .modal {
            display: none;
            position: fixed;
            z-index: 1000;
            left: 0;
            top: 0;
            width: 100%;
            height: 100%;
            overflow: auto;
            background-color: rgba(0,0,0,0.4);
            animation: fadeIn 0.3s ease-out;
        }
        
        .modal-content {
            background-color: white;
            margin: 15% auto;
            padding: 30px;
            border-radius: 8px;
            box-shadow: 0 5px 15px rgba(0,0,0,0.3);
            width: 400px;
            max-width: 90%;
            animation: slideDown 0.3s ease-out;
            text-align: center;
        }
        
        .modal-title {
            font-size: 1.4rem;
            margin-bottom: 15px;
            color: #333;
        }
        
        .modal-message {
            margin-bottom: 30px;
            color: #555;
            font-size: 1.1rem;
        }
        
        .modal-buttons {
            display: flex;
            justify-content: center;
            gap: 15px;
        }
        
        /* Loading indicator */
        .loading-overlay {
            display: none;
            position: fixed;
            top: 0;
            left: 0;
            width: 100%;
            height: 100%;
            background: rgba(255, 255, 255, 0.8);
            z-index: 1001;
            justify-content: center;
            align-items: center;
        }
        
        .spinner {
            width: 50px;
            height: 50px;
            border: 5px solid var(--primary-color);
            border-top: 5px solid transparent;
            border-radius: 50%;
            animation: spin 1s linear infinite;
        }
        
        @keyframes spin {
            0% { transform: rotate(0deg); }
            100% { transform: rotate(360deg); }
        }
        
        /* Animations */
        @keyframes fadeIn {
            from {
                opacity: 0;
                transform: translateY(20px);
            }
            to {
                opacity: 1;
                transform: translateY(0);
            }
        }
        
        @keyframes fadeInDown {
            from {
                opacity: 0;
                transform: translateY(-20px);
            }
            to {
                opacity: 1;
                transform: translateY(0);
            }
        }
        
        @keyframes fadeInUp {
            from {
                opacity: 0;
                transform: translateY(20px);
            }
            to {
                opacity: 1;
                transform: translateY(0);
            }
        }
        
        @keyframes slideDown {
            from {
                opacity: 0;
                transform: translateY(-50px);
            }
            to {
                opacity: 1;
                transform: translateY(0);
            }
        }
        
        /* Responsiveness */
        @media (max-width: 768px) {
            .grid-container {
                grid-template-columns: repeat(auto-fill, minmax(220px, 1fr));
            }
            
            .filters {
                flex-direction: column;
                gap: 15px;
            }
            
            .search-container {
                max-width: 100%;
            }
            
            header h1 {
                font-size: 2rem;
            }
            
            .card-actions {
                flex-direction: column;
                gap: 10px;
            }
            
            .btn {
                width: 100%;
            }
        }
        
        @media (max-width: 480px) {
            .grid-container {
                grid-template-columns: 1fr;
            }
            
            .filter-options {
                width: 100%;
                overflow-x: auto;
                padding-bottom: 10px;
            }
            
            .card-content {
                padding: 15px;
            }
        }
    </style>
</head>
<body>
    <%
        // Process delete request
        String deleteId = request.getParameter("delete");
        if (deleteId != null && !deleteId.isEmpty()) {
            try {
                Connection conn = DBConnector.getConnection();
                PreparedStatement ps = conn.prepareStatement("DELETE FROM tradecreation WHERE id = ?");
                ps.setInt(1, Integer.parseInt(deleteId));
                int result = ps.executeUpdate();
                if (result > 0) {
                    // Success message will be shown
                    session.setAttribute("message", "Trade deleted successfully");
                    session.setAttribute("messageType", "success");
                } else {
                    // Error message
                    session.setAttribute("message", "Failed to delete trade");
                    session.setAttribute("messageType", "error");
                }
                response.sendRedirect("ShowTrades.jsp");
                return;
            } catch (Exception e) {
                // Handle error
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
                PreparedStatement ps = conn.prepareStatement("UPDATE tradecreation SET available = ? WHERE id = ?");
                ps.setBoolean(1, availabilityStatus.equals("true"));
                ps.setInt(2, Integer.parseInt(toggleId));
                int result = ps.executeUpdate();
                if (result > 0) {
                    // Success message
                    session.setAttribute("message", "Availability status updated");
                    session.setAttribute("messageType", "success");
                } else {
                    // Error message
                    session.setAttribute("message", "Failed to update availability");
                    session.setAttribute("messageType", "error");
                }
                response.sendRedirect("ShowTrades.jsp");
                return;
            } catch (Exception e) {
                // Handle error
                session.setAttribute("message", "Error: " + e.getMessage());
                session.setAttribute("messageType", "error");
                response.sendRedirect("ShowTrades.jsp");
                return;
            }
        }
        
        // Get trades from database - note that we need to add available column to the query
        List<Map<String, Object>> trades = new ArrayList<>();
        try {
            Statement st = DBConnector.getStatement();
            // Note: if available column doesn't exist yet, you'll need to add it to your database
            String query = "SELECT id, commodity, origin, quantity, buyingprice, image, available FROM tradecreation ORDER BY id DESC";
            ResultSet rs = st.executeQuery(query);
            while (rs.next()) {
                Map<String, Object> trade = new HashMap<>();
                trade.put("id", rs.getInt("id"));
                trade.put("commodity", rs.getString("commodity"));
                trade.put("origin", rs.getString("origin"));
                trade.put("quantity", rs.getInt("quantity"));
                trade.put("buyingprice", rs.getDouble("buyingprice"));
                
                // Attempt to get availability status - if the column doesn't exist yet, set to true by default
                boolean isAvailable = true;
                try {
                    isAvailable = rs.getBoolean("available");
                } catch (SQLException e) {
                    // Column might not exist yet - we'll assume all items are available
                }
                trade.put("available", isAvailable);
                
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
        }
    %>

    <!-- Display messages if any -->
    <% 
        String message = (String) session.getAttribute("message");
        String messageType = (String) session.getAttribute("messageType");
        if (message != null && !message.isEmpty()) {
            String alertColor = messageType.equals("success") ? "#4caf50" : "#f44336";
    %>
    <div id="alertMessage" style="position: fixed; top: 20px; left: 50%; transform: translateX(-50%); 
         background-color: <%= alertColor %>; color: white; padding: 15px 20px; 
         border-radius: 4px; box-shadow: 0 2px 10px rgba(0,0,0,0.1); z-index: 1000;
         animation: fadeInDown 0.5s ease-out;">
        <%= message %>
    </div>
    <script>
        setTimeout(function() {
            document.getElementById('alertMessage').style.opacity = '0';
            document.getElementById('alertMessage').style.transition = 'opacity 0.5s ease';
            setTimeout(function() {
                document.getElementById('alertMessage').style.display = 'none';
            }, 500);
        }, 3000);
    </script>
    <% 
        session.removeAttribute("message");
        session.removeAttribute("messageType");
    } 
    %>

    <header>
        <div class="header-graphic">
            <svg xmlns="http://www.w3.org/2000/svg" viewBox="0 0 1440 320">
                <path fill="#ffffff" fill-opacity="1" d="M0,96L48,112C96,128,192,160,288,186.7C384,213,480,235,576,224C672,213,768,171,864,165.3C960,160,1056,192,1152,202.7C1248,213,1344,203,1392,197.3L1440,192L1440,320L1392,320C1344,320,1248,320,1152,320C1056,320,960,320,864,320C768,320,672,320,576,320C480,320,384,320,288,320C192,320,96,320,48,320L0,320Z"></path>
            </svg>
        </div>
        <div class="header-content">
            <h1><i class="fas fa-leaf"></i> Farmer's Marketplace</h1>
            <p>Manage your crop listings</p>
        </div>
    </header>

    <div class="container">
        <div class="filters">
            <div class="search-container">
                <i class="fas fa-search"></i>
                <input type="text" id="searchInput" placeholder="Search commodities...">
            </div>
            
            <div class="filter-options">
                <button class="filter-btn active" data-filter="all"><i class="fas fa-border-all"></i> All</button>
                <button class="filter-btn" data-filter="available"><i class="fas fa-check-circle"></i> Available</button>
                <button class="filter-btn" data-filter="unavailable"><i class="fas fa-times-circle"></i> Unavailable</button>
            </div>
        </div>

        <div class="grid-container">
            <% 
                int delay = 0;
                for (Map<String, Object> trade : trades) {
                    String base64Image = (String) trade.get("base64Image");
                    String commodity = (String) trade.get("commodity");
                    String origin = (String) trade.get("origin");
                    int quantity = (Integer) trade.get("quantity");
                    double price = (Double) trade.get("buyingprice");
                    int id = (Integer) trade.get("id");
                    boolean isAvailable = (Boolean) trade.get("available");
                    delay += 100;
            %>
            <div class="card" style="animation-delay: <%= delay %>ms;" data-available="<%= isAvailable %>">
                <div class="card-image">
                    <% if (!base64Image.isEmpty()) { %>
                        <img src="data:image/jpeg;base64,<%= base64Image %>" alt="<%= commodity %>" loading="lazy">
                    <% } else { %>
                        <div class="no-image">
                            <i class="fas fa-seedling"></i>
                        </div>
                    <% } %>
                </div>
                <div class="card-content">
                    <div class="card-title"><%= commodity %></div>
                    <div class="card-origin">
                        <i class="fas fa-map-marker-alt"></i>
                        <%= origin %>
                    </div>
                    <div class="badge <%= isAvailable ? "" : "badge-unavailable" %>">
                        <%= isAvailable ? "Available Now" : "Currently Unavailable" %>
                    </div>
                    <div class="card-details">
                        <div class="detail-item">
                            <div class="detail-label">QUANTITY</div>
                            <div class="detail-value"><%= quantity %> MT</div>
                        </div>
                        <div class="detail-item">
                            <div class="detail-label">PRICE</div>
                            <div class="detail-value">$<%= String.format("%,.2f", price) %></div>
                        </div>
                    </div>
                </div>
                <div class="card-actions">
                    <button class="btn btn-toggle <%= isAvailable ? "" : "unavailable" %>" 
                            onclick="toggleAvailability(<%= id %>, <%= !isAvailable %>)">
                        <i class="fas fa-<%= isAvailable ? "toggle-on" : "toggle-off" %>"></i>
                        <%= isAvailable ? "Mark Unavailable" : "Mark Available" %>
                    </button>
                    <button class="btn btn-danger" onclick="confirmDelete(<%= id %>, '<%= commodity %>')">
                        <i class="fas fa-trash"></i> Delete
                    </button>
                </div>
            </div>
            <% } %>
            
            <% if (trades.isEmpty()) { %>
            <div class="placeholder">
                <p>No crop listings available at the moment.</p>
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
                <button class="btn" onclick="closeModal()">Cancel</button>
                <button class="btn btn-danger" id="confirmDeleteBtn">Delete</button>
            </div>
        </div>
    </div>
    
    <!-- Loading overlay -->
    <div class="loading-overlay" id="loadingOverlay">
        <div class="spinner"></div>
    </div>

    <footer>
        <p>&copy; <%= new java.util.Date().getYear() + 1900 %> Farmer's Marketplace. Supporting local farmers and sustainable agriculture.</p>
    </footer>

    <script src="https://cdnjs.cloudflare.com/ajax/libs/jquery/3.6.0/jquery.min.js"></script>
    <script>
        $(document).ready(function() {
            // Search functionality
            $("#searchInput").on("keyup", function() {
                var value = $(this).val().toLowerCase();
                $(".card").filter(function() {
                    var matches = $(this).text().toLowerCase().indexOf(value) > -1;
                    $(this).toggle(matches);
                });
            });
            
            // Filter buttons
            $(".filter-btn").click(function() {
                $(".filter-btn").removeClass("active");
                $(this).addClass("active");
                
                var filter = $(this).data("filter");
                if (filter === "all") {
                    $(".card").show();
                } else if (filter === "available") {
                    $(".card").hide();
                    $(".card[data-available='true']").show();
                } else if (filter === "unavailable") {
                    $(".card").hide();
                    $(".card[data-available='false']").show();
                }
            });
            
            // Apply random animation delays for a staggered effect
            $(".card").each(function(index) {
                $(this).css("animation-delay", (index * 100) + "ms");
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
            showLoading();
            window.location.href = 'ShowTrades.jsp?delete=' + id;
        }
        
        function toggleAvailability(id, newStatus) {
            showLoading();
            window.location.href = 'ShowTrades.jsp?toggle=' + id + '&status=' + newStatus;
        }
        
        function showLoading() {
            document.getElementById('loadingOverlay').style.display = 'flex';
        }
        
        // Close modal if clicking outside of it
        window.onclick = function(event) {
            var modal = document.getElementById('deleteModal');
            if (event.target == modal) {
                closeModal();
            }
        }
    </script>
</body>
</html>
