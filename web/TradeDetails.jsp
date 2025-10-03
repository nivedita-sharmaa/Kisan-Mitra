
<%@ page import="db.DBConnector" %>
<%@ page import="java.sql.*" %>
<%@ page import="java.util.*" %>
<!DOCTYPE html>
<html lang="en">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>Farmer's Marketplace - Trade Details</title>
    <link href="https://cdnjs.cloudflare.com/ajax/libs/font-awesome/6.0.0-beta3/css/all.min.css" rel="stylesheet">
    <style>
        :root {
            --primary-color: #2e7d32;
            --secondary-color: #81c784;
            --accent-color: #f9a825;
            --accent-hover: #f57f17;
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
            color: var(--white);
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
        
        .navigation {
            background-color: var(--white);
            padding: 15px 0;
            box-shadow: var(--shadow);
            margin-bottom: 30px;
        }
        
        .nav-container {
            display: flex;
            justify-content: space-between;
            align-items: center;
            max-width: 1200px;
            margin: 0 auto;
            padding: 0 20px;
        }
        
        .nav-links {
            display: flex;
            list-style: none;
            gap: 20px;
        }
        
        .nav-links a {
            text-decoration: none;
            color: var(--text-color);
            font-weight: 500;
            transition: color 0.3s;
            padding: 8px 12px;
            border-radius: 4px;
        }
        
        .nav-links a:hover, .nav-links a.active {
            color: var(--primary-color);
            background-color: rgba(46, 125, 50, 0.1);
        }
        
        .user-menu {
            display: flex;
            align-items: center;
            gap: 15px;
        }
        
        .user-menu a {
            text-decoration: none;
            color: var(--text-color);
            display: flex;
            align-items: center;
            gap: 5px;
        }
        
        .user-menu .user-icon {
            background-color: var(--primary-color);
            color: white;
            width: 35px;
            height: 35px;
            border-radius: 50%;
            display: flex;
            align-items: center;
            justify-content: center;
        }

        .back-link {
            display: inline-flex;
            align-items: center;
            gap: 8px;
            color: var(--primary-color);
            text-decoration: none;
            margin-bottom: 20px;
            font-weight: 500;
            transition: all 0.3s ease;
        }
        
        .back-link:hover {
            transform: translateX(-5px);
        }
        
        .trade-container {
            display: grid;
            grid-template-columns: 1fr 1fr;
            gap: 30px;
            background: var(--white);
            border-radius: var(--card-radius);
            box-shadow: var(--shadow);
            overflow: hidden;
            animation: fadeIn 0.8s ease-out forwards;
        }
        
        .trade-image {
            height: 100%;
            overflow: hidden;
            background-color: #f0f0f0;
            display: flex;
            justify-content: center;
            align-items: center;
        }
        
        .trade-image img {
            width: 100%;
            height: 100%;
            object-fit: cover;
        }
        
        .no-image {
            display: flex;
            flex-direction: column;
            justify-content: center;
            align-items: center;
            height: 100%;
            color: #aaa;
            font-size: 5rem;
            padding: 2rem;
        }
        
        .no-image span {
            font-size: 1.2rem;
            margin-top: 1rem;
        }
        
        .trade-details {
            padding: 30px;
        }
        
        .trade-header {
            margin-bottom: 20px;
        }
        
        .trade-title {
            font-size: 2.2rem;
            font-weight: bold;
            color: var(--primary-color);
            margin-bottom: 5px;
        }
        
        .trade-origin {
            color: #666;
            font-size: 1.1rem;
            display: flex;
            align-items: center;
            margin-bottom: 15px;
        }
        
        .trade-origin i {
            margin-right: 8px;
            color: var(--accent-color);
        }
        
        .trade-badge {
            background-color: var(--accent-color);
            color: white;
            padding: 6px 15px;
            border-radius: 20px;
            font-size: 0.95rem;
            font-weight: 600;
            display: inline-block;
        }
        
        .trade-info {
            margin-top: 25px;
        }
        
        .info-row {
            display: flex;
            margin-bottom: 15px;
            padding-bottom: 15px;
            border-bottom: 1px solid #eee;
        }
        
        .info-row:last-child {
            border-bottom: none;
        }
        
        .info-label {
            width: 130px;
            font-weight: 600;
            color: #555;
        }
        
        .info-value {
            flex: 1;
            color: var(--text-color);
        }
        
        .price-section {
            margin-top: 30px;
            background-color: rgba(129, 199, 132, 0.1);
            padding: 20px;
            border-radius: 10px;
        }
        
        .price-row {
            display: flex;
            justify-content: space-between;
            margin-bottom: 10px;
        }
        
        .price-label {
            font-weight: 500;
        }
        
        .price-value {
            font-weight: 600;
        }
        
        .total-price {
            font-size: 1.5rem;
            font-weight: 700;
            color: var(--primary-color);
            margin-top: 10px;
            padding-top: 10px;
            border-top: 1px dashed #ccc;
            text-align: right;
        }
        
        .action-buttons {
            display: grid;
            grid-template-columns: 1fr 2fr;
            gap: 15px;
            margin-top: 30px;
        }
        
        .quantity-control {
            display: flex;
            align-items: center;
            border: 1px solid #ddd;
            border-radius: 8px;
            overflow: hidden;
        }
        
        .quantity-btn {
            background: var(--light-bg);
            border: none;
            width: 40px;
            height: 48px;
            font-size: 1.2rem;
            cursor: pointer;
            transition: background 0.3s;
        }
        
        .quantity-btn:hover {
            background: #e0e0e0;
        }
        
        .quantity-input {
            width: 60px;
            border: none;
            text-align: center;
            font-size: 1rem;
            font-weight: 600;
        }
        
        .buy-now-btn {
            background-color: var(--accent-color);
            color: white;
            border: none;
            border-radius: 8px;
            padding: 12px;
            font-weight: 600;
            font-size: 1rem;
            cursor: pointer;
            transition: all 0.3s ease;
            display: flex;
            justify-content: center;
            align-items: center;
            gap: 10px;
            width: 100%;
        }
        
        .buy-now-btn:hover {
            background-color: var(--accent-hover);
            transform: translateY(-2px);
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
        
        /* Responsiveness */
        @media (max-width: 992px) {
            .trade-container {
                grid-template-columns: 1fr;
            }
            
            .trade-image {
                height: 350px;
            }
        }
        
        @media (max-width: 768px) {
            .trade-details {
                padding: 20px;
            }
            
            .nav-container {
                flex-direction: column;
                gap: 15px;
            }
            
            .nav-links {
                flex-wrap: wrap;
                justify-content: center;
            }
        }
        
        @media (max-width: 480px) {
            .action-buttons {
                grid-template-columns: 1fr;
            }
            
            .trade-title {
                font-size: 1.8rem;
            }
        }
    </style>
</head>
<body>
    <%
        // Get user information for the header
        String userName = (String) session.getAttribute("userName");
        if (userName == null) {
            userName = "Guest";
        }
        
        // Get the trade ID from request parameter
        String tradeIdStr = request.getParameter("id");
        int tradeId = 0;
        
        try {
            tradeId = Integer.parseInt(tradeIdStr);
        } catch (NumberFormatException e) {
            // Invalid trade ID
        }
        
        // Trade details
        Map<String, Object> trade = null;
        Map<String, Object> farmer = null;
        
        if (tradeId > 0) {
            try {
                // Get the trade details
                Statement st = DBConnector.getStatement();
                
                // Fixed SQL query to properly get trade details
                String query = "SELECT tc.id, tc.commodity, tc.origin, tc.quantity, tc.buyingprice, tc.image " +
                               "FROM tradecreation tc " +
                               "WHERE tc.id = " + tradeId;
                ResultSet rs = st.executeQuery(query);
                
                if (rs.next()) {
                    trade = new HashMap<>();
                    trade.put("id", rs.getInt("id"));
                    trade.put("commodity", rs.getString("commodity"));
                    trade.put("origin", rs.getString("origin"));
                    trade.put("quantity", rs.getInt("quantity"));
                    trade.put("buyingprice", rs.getDouble("buyingprice"));
                    
                    byte[] imageBytes = rs.getBytes("image");
                    String base64Image = "";
                    if (imageBytes != null && imageBytes.length > 0) {
                        base64Image = java.util.Base64.getEncoder().encodeToString(imageBytes);
                    }
                    trade.put("base64Image", base64Image);
                    
                    // Get farmer details separately (for payment page)
                    String farmerQuery = "SELECT f.fname, f.mobile, f.email, f.state " +
                                         "FROM farmerregistration f " +
                                         "WHERE f.email = " + tradeId;
                    ResultSet farmerRs = st.executeQuery(farmerQuery);
                    
                    if (farmerRs.next()) {
                        farmer = new HashMap<>();
                        farmer.put("fname", farmerRs.getString("fname"));
                        farmer.put("mobile", farmerRs.getString("mobile"));
                        farmer.put("email", farmerRs.getString("email"));
                        farmer.put("state", farmerRs.getString("state"));
                    }
                }
            } catch (SQLException e) {
                out.println("<p style='color:red;'>SQL Error: " + e.getMessage() + "</p>");
            }
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
            <p>Find and purchase fresh produce directly from farmers</p>
        </div>
    </header>
    
    <nav class="navigation">
        <div class="nav-container">
            <ul class="nav-links">
                <li><a href="Home.html"><i class="fas fa-home"></i> Home</a></li>
                <li><a href="marketplace.jsp" class="active"><i class="fas fa-store"></i> Marketplace</a></li>
                
                <li><a href="About.html"><i class="fas fa-info-circle"></i> About</a></li>
                <li><a href="ContactUs.html"><i class="fas fa-envelope"></i> Contact</a></li>
            </ul>
            <div class="user-menu">
                <div class="user-icon">
                    <i class="fas fa-user"></i>
                </div>
                <a href="BuyerProfile.jsp">Welcome, <%= userName %></a>
                <a href="Home.html"><i class="fas fa-sign-out-alt"></i> Logout</a>
            </div>
        </div>
    </nav>

    <div class="container">
        <a href="ShowTrades.jsp" class="back-link">
            <i class="fas fa-arrow-left"></i> Back to Marketplace
        </a>
        
        <% if (trade != null) { %>
            <div class="trade-container">
                <div class="trade-image">
                    <% 
                        String base64Image = (String) trade.get("base64Image");
                        if (base64Image != null && !base64Image.isEmpty()) { 
                    %>
                        <img src="data:image/jpeg;base64,<%= base64Image %>" alt="<%= trade.get("commodity") %>" loading="lazy">
                    <% } else { %>
                        <div class="no-image">
                            <i class="fas fa-seedling"></i>
                            <span>No image available</span>
                        </div>
                    <% } %>
                </div>
                <div class="trade-details">
                    <div class="trade-header">
                        <div class="trade-title"><%= trade.get("commodity") %></div>
                        <div class="trade-origin">
                            <i class="fas fa-map-marker-alt"></i>
                            <%= trade.get("origin") %>
                        </div>
                        <span class="trade-badge">Available Now</span>
                    </div>
                    
                    <div class="trade-info">
                        <div class="info-row">
                            <div class="info-label">Available:</div>
                            <div class="info-value"><%= trade.get("quantity") %> Metric Tons</div>
                        </div>
                        <div class="info-row">
                            <div class="info-label">Description:</div>
                            <div class="info-value">
                                Premium quality <%= trade.get("commodity") %> from <%= trade.get("origin") %>. 
                                Direct from the farmer, ensuring freshness and quality.
                            </div>
                        </div>
                    </div>
                    
                    <div class="price-section">
                        <div class="price-row">
                            <div class="price-label">Price per MT:</div>
                            <div class="price-value">Rs.<%= String.format("%,.2f", trade.get("buyingprice")) %></div>
                        </div>
                        <div class="price-row">
                            <div class="price-label">GST (5%):</div>
                            <div class="price-value">Rs.<%= String.format("%,.2f", (Double)trade.get("buyingprice") * 0.05) %></div>
                        </div>
                        <div class="total-price">Rs.<%= String.format("%,.2f", (Double)trade.get("buyingprice") * 1.05) %> per MT</div>
                    </div>
                    
                    <form action="PaymentGateway.jsp" method="post" id="purchaseForm">
                        <input type="hidden" name="tradeId" value="<%= trade.get("id") %>">
                        <input type="hidden" name="price" value="<%= trade.get("buyingprice") %>">
                        <% if (farmer != null) { %>
                            <input type="hidden" name="fname" value="<%= farmer.get("fname") %>">
                            <input type="hidden" name="mobile" value="<%= farmer.get("mobile") %>">
                            <input type="hidden" name="email" value="<%= farmer.get("email") %>">
                            <input type="hidden" name="state" value="<%= farmer.get("state") %>">
                        <% } %>
                        
                        <div class="action-buttons">
                            <div class="quantity-control">
                                <button type="button" class="quantity-btn" id="decrease">-</button>
                                <input type="number" name="quantity" id="quantity" class="quantity-input" value="1" min="1" max="<%= trade.get("quantity") %>">
                                <button type="button" class="quantity-btn" id="increase">+</button>
                            </div>
                            <button type="submit" class="buy-now-btn">
                                <i class="fas fa-shopping-cart"></i> Buy Now
                            </button>
                        </div>
                    </form>
                </div>
            </div>
            
        <% } else { %>
            <div class="no-trade">
                <p style="color: red;">Trade not found or invalid ID provided.</p>
                <a href="ViewTrades.jsp" class="back-link"><i class="fas fa-store"></i> Return to Marketplace</a>
            </div>
        <% } %>
    </div>

    <footer class="site-footer">
        <div class="footer-content">
            <p>&copy; 2025 Farmer's Marketplace. All rights reserved.</p>
        </div>
    </footer>

    <script>
        document.getElementById('decrease').addEventListener('click', function () {
            var qty = document.getElementById('quantity');
            if (parseInt(qty.value) > 1) qty.value = parseInt(qty.value) - 1;
        });

        document.getElementById('increase').addEventListener('click', function () {
            var qty = document.getElementById('quantity');
            var maxQty = parseInt(qty.getAttribute('max'));
            if (parseInt(qty.value) < maxQty) qty.value = parseInt(qty.value) + 1;
        });
    </script>
</body>
</html>