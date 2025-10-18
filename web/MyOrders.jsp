<%@ include file="SessionValidator.jsp" %>
<%@ page import="db.DBConnector" %>
<%@ page import="java.sql.*" %>
<%@ page import="java.util.*" %>

<%
    response.setHeader("Cache-Control", "no-cache, no-store, must-revalidate");
    String buyerEmail = (String) session.getAttribute("email");
    
    // Get cart count and total for nav
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
    
    List<Map<String, Object>> orders = new ArrayList<Map<String, Object>>();
    
    try {
        Connection conn = DBConnector.getConnection();
        // Changed: Remove the status filter to show all orders (Confirmed, Pending, Completed, etc.)
        String query = "SELECT o.id, o.trade_id, o.quantity, o.total_price, o.order_status, o.order_date, " +
                       "o.farmer_email, t.commodity, t.category, t.image, f.fname, f.lname " +
                       "FROM orders o " +
                       "JOIN tradecreation t ON o.trade_id = t.id " +
                       "JOIN farmerregistration f ON o.farmer_email = f.email " +
                       "WHERE o.buyer_email = ? " +
                       "ORDER BY o.order_date DESC";
        PreparedStatement ps = conn.prepareStatement(query);
        ps.setString(1, buyerEmail);
        ResultSet rs = ps.executeQuery();
        
        while (rs.next()) {
            Map<String, Object> order = new HashMap<String, Object>();
            order.put("id", rs.getInt("id"));
            order.put("commodity", rs.getString("commodity"));
            order.put("category", rs.getString("category"));
            order.put("quantity", rs.getInt("quantity"));
            order.put("total_price", rs.getDouble("total_price"));
            order.put("status", rs.getString("order_status"));
            order.put("date", rs.getTimestamp("order_date"));
            order.put("farmer", rs.getString("fname") + " " + rs.getString("lname"));
            order.put("farmer_email", rs.getString("farmer_email"));
            
            byte[] imageBytes = rs.getBytes("image");
            String base64Image = "";
            if (imageBytes != null && imageBytes.length > 0) {
                base64Image = java.util.Base64.getEncoder().encodeToString(imageBytes);
            }
            order.put("base64Image", base64Image);
            orders.add(order);
        }
        ps.close();
        conn.close();
    } catch (SQLException e) {
        out.println("<p style='color:red;'>SQL Error: " + e.getMessage() + "</p>");
    }
%>

<!DOCTYPE html>
<html lang="en">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>My Orders - Kisan Mitra</title>
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
            background: linear-gradient(135deg, #2c3e50 0%, #34495e 100%);
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
            text-decoration: none;
        }
        
        .nav-links {
            display: flex;
            gap: 15px;
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
        }
        
        .nav-item:hover {
            background: rgba(255,255,255,0.1);
            transform: translateY(-2px);
        }
        
        .nav-item.active {
            background: rgba(255,255,255,0.15);
        }
        
        .cart-wrapper {
            position: relative;
        }
        
        .cart-button {
            background: linear-gradient(135deg, #e74c3c 0%, #c0392b 100%);
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
            box-shadow: 0 4px 15px rgba(231, 76, 60, 0.3);
        }
        
        .cart-button:hover {
            transform: translateY(-2px);
            box-shadow: 0 6px 20px rgba(231, 76, 60, 0.4);
        }
        
        .cart-badge {
            background: #f39c12;
            color: white;
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
            max-width: 1200px;
            margin: 0 auto;
            padding: 40px 30px;
        }
        
        .page-title {
            color: white;
            font-size: 2.5rem;
            font-weight: 900;
            text-align: center;
            margin-bottom: 40px;
            text-shadow: 2px 2px 4px rgba(0,0,0,0.2);
        }
        
        .orders-grid {
            display: grid;
            gap: 25px;
        }
        
        .order-card {
            background: white;
            border-radius: 20px;
            overflow: hidden;
            box-shadow: 0 10px 30px rgba(0,0,0,0.2);
            transition: all 0.3s;
        }
        
        .order-card:hover {
            transform: translateY(-5px);
            box-shadow: 0 15px 40px rgba(0,0,0,0.3);
        }
        
        .order-content {
            display: grid;
            grid-template-columns: 150px 1fr;
            gap: 25px;
            padding: 25px;
        }
        
        .order-image {
            width: 150px;
            height: 150px;
            border-radius: 15px;
            overflow: hidden;
            background: #f5f5f5;
        }
        
        .order-image img {
            width: 100%;
            height: 100%;
            object-fit: cover;
        }
        
        .order-details {
            display: flex;
            flex-direction: column;
            gap: 15px;
        }
        
        .order-header {
            display: flex;
            justify-content: space-between;
            align-items: start;
        }
        
        .order-title {
            font-size: 1.5rem;
            font-weight: 700;
            color: #2d3436;
        }
        
        .order-id {
            font-size: 0.9rem;
            color: #636e72;
            margin-top: 5px;
        }
        
        .status-badge {
            padding: 8px 20px;
            border-radius: 20px;
            font-size: 0.9rem;
            font-weight: 700;
            display: inline-flex;
            align-items: center;
            gap: 6px;
        }
        
        .status-confirmed {
            background: linear-gradient(135deg, #00b894, #00cec9);
            color: white;
            box-shadow: 0 4px 15px rgba(0, 184, 148, 0.3);
        }
        
        .status-pending {
            background: linear-gradient(135deg, #fdcb6e, #f39c12);
            color: white;
            box-shadow: 0 4px 15px rgba(253, 203, 110, 0.3);
        }
        
        .status-completed {
            background: linear-gradient(135deg, #6c5ce7, #a29bfe);
            color: white;
            box-shadow: 0 4px 15px rgba(108, 92, 231, 0.3);
        }
        
        .status-cancelled {
            background: linear-gradient(135deg, #d63031, #ff7675);
            color: white;
            box-shadow: 0 4px 15px rgba(214, 48, 49, 0.3);
        }
        
        .order-info-grid {
            display: grid;
            grid-template-columns: repeat(auto-fit, minmax(180px, 1fr));
            gap: 20px;
            padding: 20px;
            background: #f8f9fa;
            border-radius: 15px;
        }
        
        .info-item {
            display: flex;
            flex-direction: column;
            gap: 5px;
        }
        
        .info-label {
            font-size: 0.85rem;
            color: #636e72;
            font-weight: 600;
        }
        
        .info-value {
            font-size: 1.1rem;
            color: #2d3436;
            font-weight: 700;
        }
        
        .empty-state {
            text-align: center;
            padding: 100px 20px;
            color: white;
        }
        
        .empty-state i {
            font-size: 5rem;
            margin-bottom: 25px;
            opacity: 0.5;
        }
        
        .empty-state h3 {
            font-size: 2rem;
            margin-bottom: 15px;
        }
        
        .shop-button {
            display: inline-block;
            margin-top: 25px;
            padding: 15px 40px;
            background: white;
            color: #667eea;
            text-decoration: none;
            border-radius: 50px;
            font-weight: 700;
            font-size: 1.1rem;
            transition: all 0.3s;
            box-shadow: 0 10px 30px rgba(0,0,0,0.2);
        }
        
        .shop-button:hover {
            transform: translateY(-3px);
            box-shadow: 0 15px 40px rgba(0,0,0,0.3);
        }
        
        @media (max-width: 768px) {
            .header-content {
                flex-wrap: wrap;
            }
            
            .nav-links {
                flex-wrap: wrap;
                gap: 10px;
                justify-content: center;
            }
            
            .order-content {
                grid-template-columns: 1fr;
            }
            
            .order-image {
                width: 100%;
                height: 200px;
            }
            
            .order-info-grid {
                grid-template-columns: 1fr;
            }
        }
    </style>
</head>
<body>
    <!-- Header -->
    <div class="header">
        <div class="header-content">
            <a href="index.jsp" class="logo">
                <i class="fas fa-leaf"></i>
                Kisan Mitra
            </a>
            <div class="nav-links">
                <a href="BuyerDashboard.jsp" class="nav-item">
            <i class="fas fa-home"></i>
            Dashboard
                </a>
                <a href="ViewTrades.jsp" class="nav-item">
                    <i class="fas fa-store"></i>
                    Browse
                </a>
<!--                <a href="MyOrders.jsp" class="nav-item active">
                    <i class="fas fa-box"></i>
                    Orders
                </a>-->
                <a href="BuyerProfile.jsp" class="nav-item">
                    <i class="fas fa-user"></i>
                    Profile
                </a>
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
            </div>
        </div>
    </div>
    
    <!-- Main Content -->
    <div class="container">
        <h1 class="page-title"><i class="fas fa-box-open"></i> My Orders</h1>
        
        <% if (orders.isEmpty()) { %>
            <div class="empty-state">
                <i class="fas fa-shopping-bag"></i>
                <h3>No Orders Yet</h3>
                <p style="font-size: 1.2rem; margin-top: 10px;">Start shopping for fresh produce from local farmers!</p>
                <a href="ViewTrades.jsp" class="shop-button">
                    <i class="fas fa-shopping-cart"></i> Start Shopping
                </a>
            </div>
        <% } else { %>
            <div class="orders-grid">
                <% for (Map<String, Object> order : orders) { 
                    String status = (String) order.get("status");
                    String statusClass = "status-confirmed";
                    String statusIcon = "fa-check-circle";
                    
                    if (status != null) {
                        if (status.equalsIgnoreCase("Pending")) {
                            statusClass = "status-pending";
                            statusIcon = "fa-clock";
                        } else if (status.equalsIgnoreCase("Completed")) {
                            statusClass = "status-completed";
                            statusIcon = "fa-check-double";
                        } else if (status.equalsIgnoreCase("Cancelled")) {
                            statusClass = "status-cancelled";
                            statusIcon = "fa-times-circle";
                        }
                    }
                %>
                    <div class="order-card">
                        <div class="order-content">
                            <div class="order-image">
                                <% String base64Image = (String) order.get("base64Image");
                                   if (base64Image != null && !base64Image.isEmpty()) { %>
                                    <img src="data:image/jpeg;base64,<%= base64Image %>" alt="<%= order.get("commodity") %>">
                                <% } else { %>
                                    <div style="width: 100%; height: 100%; display: flex; align-items: center; justify-content: center; background: #f0f0f0;">
                                        <i class="fas fa-image" style="font-size: 3rem; color: #ccc;"></i>
                                    </div>
                                <% } %>
                            </div>
                            
                            <div class="order-details">
                                <div class="order-header">
                                    <div>
                                        <div class="order-title"><%= order.get("commodity") %></div>
                                        <div class="order-id">Order #<%= order.get("id") %></div>
                                    </div>
                                    <span class="status-badge <%= statusClass %>">
                                        <i class="fas <%= statusIcon %>"></i> <%= status %>
                                    </span>
                                </div>
                                
                                <div class="order-info-grid">
                                    <div class="info-item">
                                        <div class="info-label"><i class="fas fa-tag"></i> Category</div>
                                        <div class="info-value"><%= order.get("category") %></div>
                                    </div>
                                    <div class="info-item">
                                        <div class="info-label"><i class="fas fa-box"></i> Quantity</div>
                                        <div class="info-value"><%= order.get("quantity") %> Kg</div>
                                    </div>
                                    <div class="info-item">
                                        <div class="info-label"><i class="fas fa-rupee-sign"></i> Total Price</div>
                                        <div class="info-value">&#8377;<%= String.format("%,.2f", order.get("total_price")) %></div>
                                    </div>
                                    <div class="info-item">
                                        <div class="info-label"><i class="fas fa-user-tie"></i> Farmer</div>
                                        <div class="info-value"><%= order.get("farmer") %></div>
                                    </div>
                                    <div class="info-item">
                                        <div class="info-label"><i class="fas fa-calendar"></i> Order Date</div>
                                        <div class="info-value"><%= new java.text.SimpleDateFormat("MMM dd, yyyy").format(order.get("date")) %></div>
                                    </div>
                                </div>
                            </div>
                        </div>
                    </div>
                <% } %>
            </div>
        <% } %>
    </div>
</body>
</html>