<%@ include file="SessionValidator.jsp" %>
<%@ page import="db.DBConnector" %>
<%@ page import="java.sql.*" %>
<%@ page import="java.util.*" %>

<%
    response.setHeader("Cache-Control", "no-cache, no-store, must-revalidate");
    String farmerEmail = (String) session.getAttribute("email");
    
    // Fetch farmer details
    String farmerName = "";
    try {
        Connection conn = DBConnector.getConnection();
        String query = "SELECT fname, lname FROM farmerregistration WHERE email = ?";
        PreparedStatement ps = conn.prepareStatement(query);
        ps.setString(1, farmerEmail);
        ResultSet rs = ps.executeQuery();
        
        if (rs.next()) {
            farmerName = rs.getString("fname") + " " + rs.getString("lname");
        }
        ps.close();
        conn.close();
    } catch (SQLException e) {
        System.out.println(e);
    }
    
    // Fetch all sales (orders) for this farmer
    List<Map<String, Object>> sales = new ArrayList<Map<String, Object>>();
    
    try {
        Connection conn = DBConnector.getConnection();
        String query = "SELECT o.id, o.trade_id, o.quantity, o.total_price, o.order_status, o.order_date, " +
                       "o.buyer_email, t.commodity, t.category, t.image, b.fname, b.lname, b.mobile " +
                       "FROM orders o " +
                       "JOIN tradecreation t ON o.trade_id = t.id " +
                       "JOIN buyerregistration b ON o.buyer_email = b.email " +
                       "WHERE o.farmer_email = ? " +
                       "ORDER BY o.order_date DESC";
        PreparedStatement ps = conn.prepareStatement(query);
        ps.setString(1, farmerEmail);
        ResultSet rs = ps.executeQuery();
        
        while (rs.next()) {
            Map<String, Object> sale = new HashMap<String, Object>();
            sale.put("id", rs.getInt("id"));
            sale.put("commodity", rs.getString("commodity"));
            sale.put("category", rs.getString("category"));
            sale.put("quantity", rs.getInt("quantity"));
            sale.put("total_price", rs.getDouble("total_price"));
            sale.put("status", rs.getString("order_status"));
            sale.put("date", rs.getTimestamp("order_date"));
            sale.put("buyer", rs.getString("fname") + " " + rs.getString("lname"));
            sale.put("buyer_email", rs.getString("buyer_email"));
            sale.put("buyer_mobile", rs.getString("mobile"));
            
            byte[] imageBytes = rs.getBytes("image");
            String base64Image = "";
            if (imageBytes != null && imageBytes.length > 0) {
                base64Image = java.util.Base64.getEncoder().encodeToString(imageBytes);
            }
            sale.put("base64Image", base64Image);
            sales.add(sale);
        }
        ps.close();
        conn.close();
    } catch (SQLException e) {
        out.println("<p style='color:red;'>SQL Error: " + e.getMessage() + "</p>");
    }
    
    // Calculate total sales and revenue
    double totalRevenue = 0.0;
    int totalOrders = sales.size();
    for (Map<String, Object> sale : sales) {
        totalRevenue += (Double) sale.get("total_price");
    }
%>

<!DOCTYPE html>
<html lang="en">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>My Sales - Kisan Mitra</title>
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
        
        /* Navbar */
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
            max-width: 1200px;
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
        
        .nav-menu a.active {
            color: #ffd700;
            font-weight: 700;
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
            margin-bottom: 20px;
            text-shadow: 2px 2px 4px rgba(0,0,0,0.2);
        }
        
        .page-subtitle {
            color: rgba(255, 255, 255, 0.9);
            text-align: center;
            font-size: 1.1rem;
            margin-bottom: 40px;
        }
        
        /* Stats Cards */
        .stats-grid {
            display: grid;
            grid-template-columns: repeat(auto-fit, minmax(250px, 1fr));
            gap: 25px;
            margin-bottom: 40px;
        }
        
        .stat-card {
            background: white;
            border-radius: 20px;
            padding: 30px;
            box-shadow: 0 10px 30px rgba(0,0,0,0.2);
            display: flex;
            align-items: center;
            gap: 20px;
            transition: all 0.3s;
        }
        
        .stat-card:hover {
            transform: translateY(-5px);
            box-shadow: 0 15px 40px rgba(0,0,0,0.3);
        }
        
        .stat-icon {
            width: 70px;
            height: 70px;
            border-radius: 50%;
            display: flex;
            align-items: center;
            justify-content: center;
            font-size: 2rem;
            color: white;
        }
        
        .stat-icon.revenue {
            background: linear-gradient(135deg, #2ecc71, #27ae60);
        }
        
        .stat-icon.orders {
            background: linear-gradient(135deg, #3498db, #2980b9);
        }
        
        .stat-icon.avg {
            background: linear-gradient(135deg, #f39c12, #e67e22);
        }
        
        .stat-content h3 {
            font-size: 0.9rem;
            color: #7f8c8d;
            font-weight: 600;
            margin-bottom: 5px;
        }
        
        .stat-content .stat-value {
            font-size: 1.8rem;
            font-weight: 900;
            color: #2c3e50;
        }
        
        /* Sales Grid */
        .sales-grid {
            display: grid;
            gap: 25px;
        }
        
        .sale-card {
            background: white;
            border-radius: 20px;
            overflow: hidden;
            box-shadow: 0 10px 30px rgba(0,0,0,0.2);
            transition: all 0.3s;
        }
        
        .sale-card:hover {
            transform: translateY(-5px);
            box-shadow: 0 15px 40px rgba(0,0,0,0.3);
        }
        
        .sale-content {
            display: grid;
            grid-template-columns: 150px 1fr;
            gap: 25px;
            padding: 25px;
        }
        
        .sale-image {
            width: 150px;
            height: 150px;
            border-radius: 15px;
            overflow: hidden;
            background: #f5f5f5;
        }
        
        .sale-image img {
            width: 100%;
            height: 100%;
            object-fit: cover;
        }
        
        .sale-details {
            display: flex;
            flex-direction: column;
            gap: 15px;
        }
        
        .sale-header {
            display: flex;
            justify-content: space-between;
            align-items: start;
        }
        
        .sale-title {
            font-size: 1.5rem;
            font-weight: 700;
            color: #2d3436;
        }
        
        .sale-id {
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
        
        .sale-info-grid {
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
        
        @media (max-width: 768px) {
            .sale-content {
                grid-template-columns: 1fr;
            }
            
            .sale-image {
                width: 100%;
                height: 200px;
            }
            
            .sale-info-grid {
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
    <!-- Navbar -->
    <nav class="navbar">
        <div class="nav-container">
            <a href="FarmerDashboard.jsp" class="nav-brand">
                <i class="fas fa-leaf"></i> Kisan Mitra
            </a>
            <ul class="nav-menu">
                <li><a href="FarmerDashboard.jsp"><i class="fas fa-home"></i> <span>Dashboard</span></a></li>
                <li><a href="UploadTrade.jsp"><i class="fas fa-upload"></i> <span>Upload Trade</span></a></li>
                <li><a href="ShowTrades.jsp"><i class="fas fa-chart-line"></i> <span>My Trades</span></a></li>
                
                <li><a href="FarmerProfile.jsp"><i class="fas fa-user-circle"></i> <span>Profile</span></a></li>
            </ul>
        </div>
    </nav>
    
    <!-- Main Content -->
    <div class="container">
        <h1 class="page-title"><i class="fas fa-chart-line"></i> My Sales</h1>
        <p class="page-subtitle">Track all your orders and revenue from buyers</p>
        
        <!-- Stats Section -->
        <div class="stats-grid">
            <div class="stat-card">
                <div class="stat-icon revenue">
                    <i class="fas fa-rupee-sign"></i>
                </div>
                <div class="stat-content">
                    <h3>Total Revenue</h3>
                    <div class="stat-value">&#8377;<%= String.format("%,.2f", totalRevenue) %></div>
                </div>
            </div>
            
            <div class="stat-card">
                <div class="stat-icon orders">
                    <i class="fas fa-shopping-bag"></i>
                </div>
                <div class="stat-content">
                    <h3>Total Orders</h3>
                    <div class="stat-value"><%= totalOrders %></div>
                </div>
            </div>
            
            <div class="stat-card">
                <div class="stat-icon avg">
                    <i class="fas fa-chart-bar"></i>
                </div>
                <div class="stat-content">
                    <h3>Average Order</h3>
                    <div class="stat-value">&#8377;<%= totalOrders > 0 ? String.format("%,.2f", totalRevenue / totalOrders) : "0.00" %></div>
                </div>
            </div>
        </div>
        
        <!-- Sales List -->
        <% if (sales.isEmpty()) { %>
            <div class="empty-state">
                <i class="fas fa-inbox"></i>
                <h3>No Sales Yet</h3>
                <p style="font-size: 1.2rem; margin-top: 10px;">Orders from buyers will appear here once they make purchases.</p>
            </div>
        <% } else { %>
            <div class="sales-grid">
                <% for (Map<String, Object> sale : sales) { 
                    String status = (String) sale.get("status");
                    String statusClass = "status-confirmed";
                    String statusIcon = "fa-check-circle";
                    
                    if (status != null) {
                        if (status.equalsIgnoreCase("Pending")) {
                            statusClass = "status-pending";
                            statusIcon = "fa-clock";
                        } else if (status.equalsIgnoreCase("Completed")) {
                            statusClass = "status-completed";
                            statusIcon = "fa-check-double";
                        }
                    }
                %>
                    <div class="sale-card">
                        <div class="sale-content">
                            <div class="sale-image">
                                <% String base64Image = (String) sale.get("base64Image");
                                   if (base64Image != null && !base64Image.isEmpty()) { %>
                                    <img src="data:image/jpeg;base64,<%= base64Image %>" alt="<%= sale.get("commodity") %>">
                                <% } else { %>
                                    <div style="width: 100%; height: 100%; display: flex; align-items: center; justify-content: center; background: #f0f0f0;">
                                        <i class="fas fa-image" style="font-size: 3rem; color: #ccc;"></i>
                                    </div>
                                <% } %>
                            </div>
                            
                            <div class="sale-details">
                                <div class="sale-header">
                                    <div>
                                        <div class="sale-title"><%= sale.get("commodity") %></div>
                                        <div class="sale-id">Order #<%= sale.get("id") %></div>
                                    </div>
                                    <span class="status-badge <%= statusClass %>">
                                        <i class="fas <%= statusIcon %>"></i> <%= status %>
                                    </span>
                                </div>
                                
                                <div class="sale-info-grid">
                                    <div class="info-item">
                                        <div class="info-label"><i class="fas fa-tag"></i> Category</div>
                                        <div class="info-value"><%= sale.get("category") %></div>
                                    </div>
                                    <div class="info-item">
                                        <div class="info-label"><i class="fas fa-box"></i> Quantity Sold</div>
                                        <div class="info-value"><%= sale.get("quantity") %> Kg</div>
                                    </div>
                                    <div class="info-item">
                                        <div class="info-label"><i class="fas fa-rupee-sign"></i> Revenue</div>
                                        <div class="info-value">&#8377;<%= String.format("%,.2f", sale.get("total_price")) %></div>
                                    </div>
                                    <div class="info-item">
                                        <div class="info-label"><i class="fas fa-user"></i> Buyer</div>
                                        <div class="info-value"><%= sale.get("buyer") %></div>
                                    </div>
                                    <div class="info-item">
                                        <div class="info-label"><i class="fas fa-phone"></i> Contact</div>
                                        <div class="info-value"><%= sale.get("buyer_mobile") %></div>
                                    </div>
                                    <div class="info-item">
                                        <div class="info-label"><i class="fas fa-calendar"></i> Order Date</div>
                                        <div class="info-value"><%= new java.text.SimpleDateFormat("MMM dd, yyyy").format(sale.get("date")) %></div>
                                    </div>
                                </div>
                            </div>
                        </div>
                    </div>
                <% } %>
            </div>
        <% } %>
    </div>
    <div class="footer">
        <p>&copy; 2025 Kisan Mitra. Empowering farmers through technology.</p>
    </div>
</body>
</html>