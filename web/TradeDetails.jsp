<%@ include file="SessionValidator.jsp" %>
<%@ page import="db.DBConnector" %>
<%@ page import="java.sql.*" %>
<%@ page import="java.util.*" %>

<%
    response.setHeader("Cache-Control", "no-cache, no-store, must-revalidate");
    response.setHeader("Pragma", "no-cache");
    response.setDateHeader("Expires", 0);
    
    String buyerEmail = (String) session.getAttribute("email");
    if (buyerEmail == null || buyerEmail.isEmpty()) {
        response.sendRedirect("Login.jsp");
        return;
    }
    
    // Get cart count and total
    int cartCount = 0;
    double cartTotal = 0.0;
    try {
        Connection conn = DBConnector.getConnection();
        String cartQuery = "SELECT c.quantity, t.buyingprice FROM cart c " +
                          "JOIN tradecreation t ON c.trade_id = t.id " +
                          "WHERE c.buyer_email = ?";
        PreparedStatement ps = conn.prepareStatement(cartQuery);
        ps.setString(1, buyerEmail);
        ResultSet rs = ps.executeQuery();
        while (rs.next()) {
            cartCount++;
            cartTotal += rs.getInt("quantity") * rs.getDouble("buyingprice");
        }
        ps.close();
        conn.close();
    } catch (SQLException e) {
        System.out.println(e);
    }
    
    String tradeIdStr = request.getParameter("id");
    int tradeId = 0;
    
    try {
        tradeId = Integer.parseInt(tradeIdStr);
    } catch (NumberFormatException e) {
        // Invalid trade ID
    }
    
    Map<String, Object> trade = null;
    Map<String, Object> farmer = null;
    
    if (tradeId > 0) {
        try {
            Connection conn = DBConnector.getConnection();
            
            String query = "SELECT tc.id, tc.commodity, tc.category, tc.origin, tc.quantity, tc.buyingprice, tc.image, " +
                           "tc.farmer_email, " +
                           "f.fname, f.lname, f.street, f.city, f.state, f.mobile, f.email " +
                           "FROM tradecreation tc " +
                           "JOIN farmerregistration f ON tc.farmer_email = f.email " +
                           "WHERE tc.id = ?";
            PreparedStatement ps = conn.prepareStatement(query);
            ps.setInt(1, tradeId);
            ResultSet rs = ps.executeQuery();
            
            if (rs.next()) {
                trade = new HashMap<>();
                trade.put("id", rs.getInt("id"));
                trade.put("commodity", rs.getString("commodity"));
                trade.put("category", rs.getString("category"));
                trade.put("origin", rs.getString("origin"));
                trade.put("quantity", rs.getInt("quantity"));
                trade.put("buyingprice", rs.getDouble("buyingprice"));
                
                byte[] imageBytes = rs.getBytes("image");
                String base64Image = "";
                if (imageBytes != null && imageBytes.length > 0) {
                    base64Image = java.util.Base64.getEncoder().encodeToString(imageBytes);
                }
                trade.put("base64Image", base64Image);
                
                farmer = new HashMap<>();
                farmer.put("name", rs.getString("fname") + " " + rs.getString("lname"));
                farmer.put("mobile", rs.getString("mobile"));
                farmer.put("email", rs.getString("email"));
                farmer.put("city", rs.getString("city"));
                farmer.put("state", rs.getString("state"));
                farmer.put("street", rs.getString("street"));
            }
            ps.close();
            conn.close();
        } catch (SQLException e) {
            out.println("<p style='color:red;'>SQL Error: " + e.getMessage() + "</p>");
        }
    }
%>

<!DOCTYPE html>
<html lang="en">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>Product Details - Kisan Mitra</title>
    <link href="https://fonts.googleapis.com/css2?family=Poppins:wght@400;600;700&display=swap" rel="stylesheet">
    <link href="https://cdnjs.cloudflare.com/ajax/libs/font-awesome/6.0.0-beta3/css/all.min.css" rel="stylesheet">
    <style>
        * {
            margin: 0;
            padding: 0;
            box-sizing: border-box;
            font-family: 'Poppins', sans-serif;
        }
        
        body {
            background: linear-gradient(135deg, #667eea 0%, #764ba2 100%);
            min-height: 100vh;
        }
        
        /* Navigation Bar - Same as ViewTrades */
        .navbar {
            background: rgba(26, 42, 108, 0.95);
            backdrop-filter: blur(10px);
            padding: 15px 30px;
            box-shadow: 0 2px 15px rgba(0,0,0,0.2);
            position: sticky;
            top: 0;
            z-index: 1000;
        }

        .nav-container {
            max-width: 1400px;
            margin: 0 auto;
            display: flex;
            justify-content: space-between;
            align-items: center;
        }

        .nav-brand {
            color: white;
            font-size: 1.8rem;
            font-weight: bold;
            text-decoration: none;
            display: flex;
            align-items: center;
            gap: 10px;
        }

        .nav-brand:hover {
            opacity: 0.8;
        }

        .nav-menu {
            display: flex;
            list-style: none;
            gap: 30px;
            align-items: center;
        }

        .nav-menu a {
            color: white;
            text-decoration: none;
            font-weight: 500;
            transition: all 0.3s ease;
            display: flex;
            align-items: center;
            gap: 8px;
        }

        .nav-menu a:hover {
            color: #ffd700;
            transform: translateY(-2px);
        }

        .logout-btn {
            background: #f44336;
            padding: 8px 16px;
            border-radius: 20px;
            transition: all 0.3s ease;
        }

        .logout-btn:hover {
            background: #d32f2f;
            transform: scale(1.05);
        }

        .cart-wrapper {
            position: relative;
        }
        
        .cart-button {
            background: #ff6b6b;
            color: white;
            padding: 10px 25px;
            border-radius: 8px;
            display: flex;
            align-items: center;
            gap: 10px;
            cursor: pointer;
            text-decoration: none;
            font-weight: 700;
            font-size: 1rem;
            transition: all 0.3s ease;
            box-shadow: 0 4px 15px rgba(255, 107, 107, 0.3);
        }
        
        .cart-button:hover {
            background: #ff5252;
            transform: translateY(-3px);
            box-shadow: 0 6px 20px rgba(255, 107, 107, 0.4);
        }
        
        .cart-badge {
            background: #ffd93d;
            color: #1e3c72;
            border-radius: 50%;
            min-width: 22px;
            height: 22px;
            display: flex;
            align-items: center;
            justify-content: center;
            font-size: 12px;
            font-weight: 700;
            position: absolute;
            top: -8px;
            right: -8px;
            border: 2px solid white;
        }
        
        /* Main Content */
        .container {
            max-width: 1400px;
            margin: 0 auto;
            padding: 30px;
        }
        
        .back-link {
            display: inline-flex;
            align-items: center;
            gap: 8px;
            color: white;
            text-decoration: none;
            margin-bottom: 25px;
            font-weight: 600;
            transition: all 0.3s ease;
            padding: 10px 20px;
            border-radius: 8px;
            background: rgba(255, 255, 255, 0.1);
        }
        
        .back-link:hover {
            background: rgba(255, 255, 255, 0.2);
            transform: translateX(-5px);
        }
        
        /* Product Container */
        .product-container {
            display: grid;
            grid-template-columns: 1fr 1fr;
            gap: 30px;
            background: white;
            border-radius: 20px;
            box-shadow: 0 10px 40px rgba(0,0,0,0.2);
            overflow: hidden;
            margin-bottom: 30px;
            animation: slideUp 0.8s ease;
        }
        
        .product-image-section {
            background: linear-gradient(135deg, #f5f7fa 0%, #c3cfe2 100%);
            display: flex;
            align-items: center;
            justify-content: center;
            padding: 40px;
            position: relative;
        }
        
        .product-image-section img {
            width: 100%;
            height: 100%;
            max-height: 600px;
            object-fit: cover;
            border-radius: 15px;
            box-shadow: 0 10px 30px rgba(0,0,0,0.2);
        }
        
        .no-image {
            text-align: center;
            color: #95a5a6;
        }
        
        .no-image i {
            font-size: 5rem;
            margin-bottom: 15px;
        }
        
        .product-info-section {
            padding: 40px;
        }
        
        .product-category {
            display: inline-block;
            background: linear-gradient(135deg, #667eea 0%, #764ba2 100%);
            color: white;
            padding: 8px 20px;
            border-radius: 20px;
            font-size: 0.9rem;
            font-weight: 600;
            margin-bottom: 15px;
        }
        
        .product-title {
            font-size: 2.8rem;
            font-weight: 700;
            color: #2c3e50;
            margin-bottom: 15px;
        }
        
        .product-origin {
            display: flex;
            align-items: center;
            gap: 8px;
            color: #7f8c8d;
            font-size: 1.2rem;
            margin-bottom: 20px;
            font-weight: 500;
        }
        
        .product-origin i {
            color: #e74c3c;
        }
        
        .availability-badge {
            display: inline-flex;
            align-items: center;
            gap: 8px;
            background: #27ae60;
            color: white;
            padding: 10px 20px;
            border-radius: 25px;
            font-weight: 600;
            margin-bottom: 30px;
            animation: pulse 2s infinite;
        }
        
        @keyframes pulse {
            0%, 100% { opacity: 1; }
            50% { opacity: 0.8; }
        }
        
        .product-details {
            background: #f8f9fa;
            padding: 25px;
            border-radius: 15px;
            margin-bottom: 25px;
        }
        
        .detail-row {
            display: grid;
            grid-template-columns: 150px 1fr;
            padding: 15px 0;
            border-bottom: 1px solid #ecf0f1;
            gap: 20px;
        }
        
        .detail-row:last-child {
            border-bottom: none;
        }
        
        .detail-label {
            font-weight: 600;
            color: #7f8c8d;
            display: flex;
            align-items: center;
            gap: 8px;
        }
        
        .detail-value {
            color: #2c3e50;
            font-weight: 500;
        }
        
        /* Price Section */
        .price-card {
            background: linear-gradient(135deg, #667eea 0%, #764ba2 100%);
            padding: 30px;
            border-radius: 15px;
            color: white;
            margin-bottom: 30px;
            box-shadow: 0 10px 30px rgba(102, 126, 234, 0.3);
        }
        
        .price-row {
            display: flex;
            justify-content: space-between;
            margin-bottom: 15px;
            font-size: 1.1rem;
        }
        
        .price-total {
            display: flex;
            justify-content: space-between;
            padding-top: 20px;
            margin-top: 20px;
            border-top: 2px solid rgba(255,255,255,0.3);
            font-size: 2rem;
            font-weight: 700;
        }
        
        /* Purchase Controls */
        .purchase-controls {
            display: flex;
            gap: 15px;
            align-items: center;
        }
        
        .quantity-selector {
            display: flex;
            align-items: center;
            border: 2px solid #ecf0f1;
            border-radius: 12px;
            overflow: hidden;
            background: white;
        }
        
        .qty-btn {
            background: #667eea;
            border: none;
            width: 50px;
            height: 55px;
            font-size: 1.5rem;
            cursor: pointer;
            color: white;
            transition: all 0.3s;
            font-weight: bold;
            padding: 0;
        }
        
        .qty-btn:hover {
            background: #5568d3;
        }
        
        .qty-btn:active {
            transform: scale(0.95);
        }
        
        .qty-input {
            width: 80px;
            border: none;
            text-align: center;
            font-size: 1.2rem;
            font-weight: 700;
            color: #2c3e50;
            background: #f8f9fa;
            padding: 0;
        }
        
        .qty-input:focus {
            outline: none;
            background: #ffffff;
        }
        
        .add-to-cart-btn {
            flex: 1;
            background: linear-gradient(135deg, #f39c12 0%, #e67e22 100%);
            color: white;
            border: none;
            border-radius: 12px;
            padding: 18px 35px;
            font-size: 1.15rem;
            font-weight: 700;
            cursor: pointer;
            display: flex;
            align-items: center;
            justify-content: center;
            gap: 12px;
            transition: all 0.3s ease;
            box-shadow: 0 8px 25px rgba(243, 156, 18, 0.3);
        }
        
        .add-to-cart-btn:hover {
            background: linear-gradient(135deg, #e67e22 0%, #d35400 100%);
            transform: translateY(-3px);
            box-shadow: 0 10px 30px rgba(243, 156, 18, 0.5);
        }
        
        /* Farmer Info Card */
        .farmer-card {
            background: white;
            border-radius: 20px;
            box-shadow: 0 10px 40px rgba(0,0,0,0.2);
            padding: 40px;
            animation: slideUp 0.9s ease;
        }
        
        .farmer-header {
            display: flex;
            align-items: center;
            gap: 15px;
            margin-bottom: 30px;
            padding-bottom: 20px;
            border-bottom: 3px solid #667eea;
        }
        
        .farmer-icon {
            font-size: 3rem;
            color: #27ae60;
        }
        
        .farmer-title {
            font-size: 2rem;
            font-weight: 700;
            color: #2c3e50;
        }
        
        .farmer-info-grid {
            display: grid;
            grid-template-columns: repeat(auto-fit, minmax(300px, 1fr));
            gap: 20px;
        }
        
        .farmer-info-card {
            background: linear-gradient(135deg, #f8f9fa 0%, #ecf0f1 100%);
            padding: 25px;
            border-radius: 15px;
            border-left: 5px solid #667eea;
            transition: all 0.3s ease;
        }
        
        .farmer-info-card:hover {
            transform: translateY(-5px);
            box-shadow: 0 8px 20px rgba(0,0,0,0.1);
        }
        
        .info-label {
            display: flex;
            align-items: center;
            gap: 10px;
            font-weight: 600;
            color: #7f8c8d;
            font-size: 0.95rem;
            margin-bottom: 10px;
            text-transform: uppercase;
            letter-spacing: 0.5px;
        }
        
        .info-value {
            color: #2c3e50;
            font-size: 1.1rem;
            font-weight: 500;
        }
        
        .contact-link {
            color: #667eea;
            text-decoration: none;
            font-weight: 600;
            transition: color 0.3s;
        }
        
        .contact-link:hover {
            color: #764ba2;
        }
        
        .error-container {
            background: white;
            padding: 80px;
            border-radius: 20px;
            text-align: center;
            box-shadow: 0 10px 40px rgba(0,0,0,0.2);
        }
        
        .error-icon {
            font-size: 5rem;
            color: #e74c3c;
            margin-bottom: 20px;
        }
        
        .error-message {
            color: #e74c3c;
            font-size: 1.5rem;
            margin-bottom: 30px;
            font-weight: 600;
        }
        
        .return-btn {
            display: inline-flex;
            align-items: center;
            gap: 10px;
            padding: 15px 35px;
            background: linear-gradient(135deg, #667eea 0%, #764ba2 100%);
            color: white;
            text-decoration: none;
            border-radius: 10px;
            font-weight: 600;
            transition: all 0.3s;
            box-shadow: 0 5px 20px rgba(102, 126, 234, 0.3);
        }
        
        .return-btn:hover {
            transform: translateY(-3px);
            box-shadow: 0 8px 25px rgba(102, 126, 234, 0.5);
        }

        @keyframes slideUp {
            from {
                opacity: 0;
                transform: translateY(30px);
            }
            to {
                opacity: 1;
                transform: translateY(0);
            }
        }
        
        @media (max-width: 1024px) {
            .product-container {
                grid-template-columns: 1fr;
            }
            
            .product-image-section {
                min-height: 400px;
            }
        }
        
        @media (max-width: 768px) {
            .nav-container {
                padding: 0 20px;
            }
            
            .nav-brand {
                font-size: 1.5rem;
            }
            
            .nav-menu {
                gap: 10px;
            }
            
            .nav-menu a span {
                display: none;
            }
            
            .product-title {
                font-size: 2rem;
            }
            
            .purchase-controls {
                flex-direction: column;
                width: 100%;
            }
            
            .quantity-selector {
                width: 100%;
            }

            .add-to-cart-btn {
                width: 100%;
            }
            
            .farmer-info-grid {
                grid-template-columns: 1fr;
            }

            .detail-row {
                grid-template-columns: 1fr;
                gap: 5px;
            }
        }
    </style>
</head>
<body>
    <!-- Navigation Bar -->
    <nav class="navbar">
        <div class="nav-container">
            <a href="BuyerDashboard.jsp" class="nav-brand">
                <i class="fas fa-leaf"></i> Kisan Mitra
            </a>
            <ul class="nav-menu">
                <li><a href="ViewTrades.jsp"><i class="fas fa-store"></i> <span>Browse</span></a></li>
                <li><a href="MyOrders.jsp"><i class="fas fa-box"></i> <span>Orders</span></a></li>
                <li><a href="BuyerProfile.jsp"><i class="fas fa-user-circle"></i> <span>Profile</span></a></li>
                <li>
                    <div class="cart-wrapper">
                        <a href="Cart.jsp" class="cart-button">
                            <i class="fas fa-shopping-cart"></i>
                            <% if (cartTotal > 0) { %>
                                &#8377;<%= String.format("%,.0f", cartTotal) %>
                            <% } else { %>
                                Cart
                            <% } %>
                        </a>
                        <% if (cartCount > 0) { %>
                            <div class="cart-badge"><%= cartCount %></div>
                        <% } %>
                    </div>
                </li>
                <li><a href="Logout.jsp" class="logout-btn"><i class="fas fa-sign-out-alt"></i> <span>Logout</span></a></li>
            </ul>
        </div>
    </nav>

    <div class="container">
        <a href="ViewTrades.jsp" class="back-link">
            <i class="fas fa-arrow-left"></i> Back to Products
        </a>
        
        <% if (trade != null) { %>
            <div class="product-container">
                <div class="product-image-section">
                    <% 
                        String base64Image = (String) trade.get("base64Image");
                        if (base64Image != null && !base64Image.isEmpty()) { 
                    %>
                        <img src="data:image/jpeg;base64,<%= base64Image %>" alt="<%= trade.get("commodity") %>" loading="lazy">
                    <% } else { %>
                        <div class="no-image">
                            <i class="fas fa-seedling"></i>
                            <p>No image available</p>
                        </div>
                    <% } %>
                </div>
                
                <div class="product-info-section">
                    <span class="product-category"><%= trade.get("category") %></span>
                    <h1 class="product-title"><%= trade.get("commodity") %></h1>
                    <div class="product-origin">
                        <i class="fas fa-map-marker-alt"></i>
                        <span><%= trade.get("origin") %></span>
                    </div>
                    <div class="availability-badge">
                        <i class="fas fa-check-circle"></i> Available Now
                    </div>
                    
                    <div class="product-details">
                        <div class="detail-row">
                            <div class="detail-label">
                                <i class="fas fa-box"></i> Quantity
                            </div>
                            <div class="detail-value"><%= trade.get("quantity") %> Kg</div>
                        </div>
                        <div class="detail-row">
                            <div class="detail-label">
                                <i class="fas fa-info-circle"></i> Description
                            </div>
                            <div class="detail-value">
                                Premium quality <%= trade.get("commodity") %> from <%= trade.get("origin") %>. 
                                Directly sourced from the farmer, ensuring freshness and quality.
                            </div>
                        </div>
                    </div>
                    
                    <div class="price-card">
                        <div class="price-row">
                            <span>Price per Kg:</span>
                            <span>&#8377;<%= String.format("%,.2f", trade.get("buyingprice")) %></span>
                        </div>
                        <div class="price-row">
                            <span>GST (5%):</span>
                            <span>&#8377;<%= String.format("%,.2f", (Double)trade.get("buyingprice") * 0.05) %></span>
                        </div>
                        <div class="price-total">
                            <span>Total per Kg:</span>
                            <span>&#8377;<%= String.format("%,.2f", (Double)trade.get("buyingprice") * 1.05) %></span>
                        </div>
                    </div>
                    
                    <form action="AddToCart.jsp" method="post" id="purchaseForm">
                        <input type="hidden" name="trade_id" value="<%= trade.get("id") %>">
                        <input type="hidden" name="price" value="<%= trade.get("buyingprice") %>">
                        
                        <div class="purchase-controls">
                            <div class="quantity-selector">
                                <button type="button" class="qty-btn" id="decrease">-</button>
                                <input type="number" name="quantity" id="quantity" class="qty-input" value="1" min="1" max="<%= trade.get("quantity") %>" readonly>
                                <button type="button" class="qty-btn" id="increase">+</button>
                            </div>
                            <button type="submit" class="add-to-cart-btn">
                                <i class="fas fa-shopping-cart"></i>
                                Add to Cart
                            </button>
                        </div>
                    </form>
                </div>
            </div>

            <!-- Farmer Information -->
            <div class="farmer-card">
                <div class="farmer-header">
                    <i class="fas fa-user-tie farmer-icon"></i>
                    <h2 class="farmer-title">Farmer Information</h2>
                </div>

                <% if (farmer != null) { %>
                    <div class="farmer-info-grid">
                        <div class="farmer-info-card">
                            <div class="info-label">
                                <i class="fas fa-user"></i> Farmer Name
                            </div>
                            <div class="info-value"><%= farmer.get("name") %></div>
                        </div>
                        <div class="farmer-info-card">
                            <div class="info-label">
                                <i class="fas fa-map-marker-alt"></i> Location
                            </div>
                            <div class="info-value"><%= farmer.get("city") %>, <%= farmer.get("state") %></div>
                        </div>
                        <div class="farmer-info-card">
                            <div class="info-label">
                                <i class="fas fa-home"></i> Address
                            </div>
                            <div class="info-value"><%= farmer.get("street") %></div>
                        </div>
                        <div class="farmer-info-card">
                            <div class="info-label">
                                <i class="fas fa-phone"></i> Contact Number
                            </div>
                            <div class="info-value">
                                <a href="tel:<%= farmer.get("mobile") %>" class="contact-link">
                                    <%= farmer.get("mobile") %>
                                </a>
                            </div>
                        </div>
                        <div class="farmer-info-card">
                            <div class="info-label">
                                <i class="fas fa-envelope"></i> Email
                            </div>
                            <div class="info-value">
                                <a href="mailto:<%= farmer.get("email") %>" class="contact-link">
                                    <%= farmer.get("email") %>
                                </a>
                            </div>
                        </div>
                    </div>
                <% } %>
            </div>
            
        <% } else { %>
            <div class="error-container">
                <div class="error-icon">
                    <i class="fas fa-exclamation-triangle"></i>
                </div>
                <p class="error-message">Product not found or invalid ID provided.</p>
                <a href="ViewTrades.jsp" class="return-btn">
                    <i class="fas fa-arrow-left"></i> Return to Products
                </a>
            </div>
        <% } %>
    </div>

    <script>
        document.addEventListener('DOMContentLoaded', function() {
            const decreaseBtn = document.getElementById('decrease');
            const increaseBtn = document.getElementById('increase');
            const quantityInput = document.getElementById('quantity');
            const purchaseForm = document.getElementById('purchaseForm');

            if (decreaseBtn && increaseBtn && quantityInput) {
                // Decrease quantity
                decreaseBtn.addEventListener('click', function(e) {
                    e.preventDefault();
                    let currentQty = parseInt(quantityInput.value);
                    if (currentQty > 1) {
                        quantityInput.value = currentQty - 1;
                    }
                });

                // Increase quantity
                increaseBtn.addEventListener('click', function(e) {
                    e.preventDefault();
                    let currentQty = parseInt(quantityInput.value);
                    let maxQty = parseInt(quantityInput.getAttribute('max'));
                    if (currentQty < maxQty) {
                        quantityInput.value = currentQty + 1;
                    }
                });

                // Prevent form submission with invalid quantity
                if (purchaseForm) {
                    purchaseForm.addEventListener('submit', function(e) {
                        let qtyValue = parseInt(quantityInput.value);
                        let maxQty = parseInt(quantityInput.getAttribute('max'));
                        
                        if (qtyValue < 1 || qtyValue > maxQty || isNaN(qtyValue)) {
                            e.preventDefault();
                            alert('Please enter a valid quantity (1 - ' + maxQty + ' Kg)');
                            quantityInput.value = 1;
                        }
                    });
                }
            }
        });
    </script>
</body>
</html>