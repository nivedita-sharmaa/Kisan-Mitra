<%@ include file="SessionValidator.jsp" %>
<%@ page import="db.DBConnector" %>
<%@ page import="java.sql.*" %>
<%@ page import="java.util.*" %>

<%
    response.setHeader("Cache-Control", "no-cache, no-store, must-revalidate");
    String buyerEmail = (String) session.getAttribute("email");
    
    // Fetch buyer details
    String buyerName = "";
    String buyerAddress = "";
    String buyerMobile = "";
    
    // Group cart items by farmer
    Map<String, List<Map<String, Object>>> farmerOrders = new LinkedHashMap<String, List<Map<String, Object>>>();
    Map<String, Map<String, Object>> farmerDetails = new HashMap<String, Map<String, Object>>();
    
    try {
        Connection conn = DBConnector.getConnection();
        
        // Get buyer info
        String buyerQuery = "SELECT fname, lname, street, city, state, mobile FROM buyerregistration WHERE email = ?";
        PreparedStatement buyerPs = conn.prepareStatement(buyerQuery);
        buyerPs.setString(1, buyerEmail);
        ResultSet buyerRs = buyerPs.executeQuery();
        
        if (buyerRs.next()) {
            buyerName = buyerRs.getString("fname") + " " + buyerRs.getString("lname");
            buyerAddress = buyerRs.getString("street") + ", " + buyerRs.getString("city") + ", " + buyerRs.getString("state");
            buyerMobile = buyerRs.getString("mobile");
        }
        buyerPs.close();
        
        // Get cart items grouped by farmer
        String cartQuery = "SELECT c.id, c.quantity, c.trade_id, t.commodity, t.category, t.buyingprice, t.image, " +
                          "f.fname AS farmer_fname, f.lname AS farmer_lname, f.email AS farmer_email, " +
                          "f.street AS farmer_street, f.city AS farmer_city, f.state AS farmer_state, f.mobile AS farmer_mobile " +
                          "FROM cart c " +
                          "JOIN tradecreation t ON c.trade_id = t.id " +
                          "JOIN farmerregistration f ON t.farmer_email = f.email " +
                          "WHERE c.buyer_email = ? " +
                          "ORDER BY f.email";
        PreparedStatement cartPs = conn.prepareStatement(cartQuery);
        cartPs.setString(1, buyerEmail);
        ResultSet cartRs = cartPs.executeQuery();
        
        while (cartRs.next()) {
            String farmerEmail = cartRs.getString("farmer_email");
            
            // Store farmer details
            if (!farmerDetails.containsKey(farmerEmail)) {
                Map<String, Object> farmer = new HashMap<String, Object>();
                farmer.put("name", cartRs.getString("farmer_fname") + " " + cartRs.getString("farmer_lname"));
                farmer.put("email", farmerEmail);
                farmer.put("address", cartRs.getString("farmer_street") + ", " + cartRs.getString("farmer_city") + ", " + cartRs.getString("farmer_state"));
                farmer.put("mobile", cartRs.getString("farmer_mobile"));
                farmerDetails.put(farmerEmail, farmer);
            }
            
            // Group items by farmer
            Map<String, Object> item = new HashMap<String, Object>();
            item.put("cart_id", cartRs.getInt("id"));
            item.put("trade_id", cartRs.getInt("trade_id"));
            item.put("commodity", cartRs.getString("commodity"));
            item.put("category", cartRs.getString("category"));
            item.put("quantity", cartRs.getInt("quantity"));
            item.put("price", cartRs.getDouble("buyingprice"));
            item.put("farmer_email", farmerEmail);
            
            byte[] imageBytes = cartRs.getBytes("image");
            String base64Image = "";
            if (imageBytes != null && imageBytes.length > 0) {
                base64Image = java.util.Base64.getEncoder().encodeToString(imageBytes);
            }
            item.put("base64Image", base64Image);
            
            double itemTotal = cartRs.getInt("quantity") * cartRs.getDouble("buyingprice");
            item.put("total", itemTotal);
            
            // Add to farmer's order list
            if (!farmerOrders.containsKey(farmerEmail)) {
                farmerOrders.put(farmerEmail, new ArrayList<Map<String, Object>>());
            }
            farmerOrders.get(farmerEmail).add(item);
        }
        cartPs.close();
        conn.close();
    } catch (SQLException e) {
        out.println("<p style='color:red;'>SQL Error: " + e.getMessage() + "</p>");
    }
    
    // Check if there are multiple farmers
    int farmerCount = farmerOrders.size();
    
    // Store data in session
    session.setAttribute("farmerOrders", farmerOrders);
    session.setAttribute("farmerDetails", farmerDetails);
    session.setAttribute("buyerName", buyerName);
    session.setAttribute("buyerAddress", buyerAddress);
    session.setAttribute("buyerMobile", buyerMobile);
%>

<!DOCTYPE html>
<html lang="en">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>Payment - Kisan Mitra</title>
    <link href="https://cdnjs.cloudflare.com/ajax/libs/font-awesome/6.0.0-beta3/css/all.min.css" rel="stylesheet">
    <style>
        * {
            margin: 0;
            padding: 0;
            box-sizing: border-box;
            font-family: -apple-system, BlinkMacSystemFont, 'Segoe UI', Roboto, sans-serif;
        }
        
        body {
            background: #f5f7fa;
        }
        
        .header {
            background: linear-gradient(135deg, #2c3e50 0%, #34495e 100%);
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
        
         /* Navigation Bar */
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
        .container {
            max-width: 1200px;
            margin: 30px auto;
            padding: 0 20px;
        }
        
        .warning-banner {
            background: linear-gradient(135deg, #f39c12 0%, #e67e22 100%);
            color: white;
            padding: 20px;
            border-radius: 12px;
            margin-bottom: 30px;
            display: flex;
            align-items: center;
            gap: 15px;
            box-shadow: 0 5px 20px rgba(243, 156, 18, 0.3);
        }
        
        .warning-icon {
            font-size: 2rem;
        }
        
        .warning-content h3 {
            font-size: 1.3rem;
            margin-bottom: 5px;
        }
        
        .warning-content p {
            font-size: 1rem;
            opacity: 0.9;
        }
        
        .farmer-orders {
            display: flex;
            flex-direction: column;
            gap: 30px;
        }
        
        .farmer-order-card {
            background: white;
            border-radius: 20px;
            overflow: hidden;
            box-shadow: 0 5px 20px rgba(0,0,0,0.08);
        }
        
        .farmer-header {
            background: linear-gradient(135deg, #667eea 0%, #764ba2 100%);
            color: white;
            padding: 25px;
            display: flex;
            align-items: center;
            gap: 15px;
        }
        
        .farmer-icon {
            width: 60px;
            height: 60px;
            background: white;
            color: #667eea;
            border-radius: 50%;
            display: flex;
            align-items: center;
            justify-content: center;
            font-size: 1.8rem;
        }
        
        .farmer-info h3 {
            font-size: 1.5rem;
            margin-bottom: 5px;
        }
        
        .farmer-info p {
            opacity: 0.9;
        }
        
        .order-content {
            padding: 30px;
        }
        
        .order-items {
            margin-bottom: 25px;
        }
        
        .order-item {
            display: grid;
            grid-template-columns: 80px 1fr auto;
            gap: 20px;
            padding: 20px;
            background: #f8f9fa;
            border-radius: 12px;
            margin-bottom: 15px;
            align-items: center;
        }
        
        .item-image {
            width: 80px;
            height: 80px;
            border-radius: 10px;
            overflow: hidden;
            background: #e0e0e0;
        }
        
        .item-image img {
            width: 100%;
            height: 100%;
            object-fit: cover;
        }
        
        .item-details h4 {
            font-size: 1.2rem;
            color: #2c3e50;
            margin-bottom: 5px;
        }
        
        .item-category {
            display: inline-block;
            background: #e8f5e9;
            color: #27ae60;
            padding: 4px 10px;
            border-radius: 10px;
            font-size: 0.8rem;
            font-weight: 600;
            margin-bottom: 5px;
        }
        
        .item-qty {
            color: #7f8c8d;
            font-size: 0.95rem;
        }
        
        .item-price {
            text-align: right;
        }
        
        .item-price-value {
            font-size: 1.3rem;
            font-weight: 700;
            color: #667eea;
        }
        
        .order-total {
            background: linear-gradient(135deg, #667eea 0%, #764ba2 100%);
            color: white;
            padding: 20px;
            border-radius: 12px;
            display: flex;
            justify-content: space-between;
            align-items: center;
            font-size: 1.3rem;
            font-weight: 700;
            margin-bottom: 20px;
        }
        
        .pay-farmer-btn {
            width: 100%;
            padding: 15px;
            background: linear-gradient(135deg, #2ecc71 0%, #27ae60 100%);
            color: white;
            border: none;
            border-radius: 12px;
            font-size: 1.1rem;
            font-weight: 700;
            cursor: pointer;
            display: flex;
            align-items: center;
            justify-content: center;
            gap: 10px;
            transition: all 0.3s;
            box-shadow: 0 5px 15px rgba(46, 204, 113, 0.3);
        }
        
        .pay-farmer-btn:hover {
            transform: translateY(-2px);
            box-shadow: 0 8px 20px rgba(46, 204, 113, 0.4);
        }
        
        @media (max-width: 768px) {
            .order-item {
                grid-template-columns: 1fr;
            }
            
            .item-price {
                text-align: left;
            }
        }
    </style>
</head>
<body>
<!--    <div class="header">
        <div class="header-content">
            <a href="index.jsp" class="logo">
                <i class="fas fa-leaf"></i>
                Kisan Mitra
            </a>
        </div>
    </div>-->
     <!-- Navigation Bar -->
        <nav class="navbar">
            <div class="nav-container">
                <a href="BuyerDashboard.jsp" class="nav-brand">
                    <i class="fas fa-leaf"></i> Kisan Mitra
                </a>
                <ul class="nav-menu">
                    <li><a href="BuyerDashboard.jsp" class="nav-item"><i class="fas fa-home"></i><span>Dashboard</span></a></li>
                    <li><a href="ViewTrades.jsp"><i class="fas fa-store"></i> <span>Browse</span></a></li>
                    <li><a href="MyOrders.jsp"><i class="fas fa-box"></i> <span>Orders</span></a></li>
                    <li><a href="Cart.jsp"><i class="fas fa-shopping-cart"></i> <span>Cart</span></a></li>
                    <li><a href="BuyerProfile.jsp"><i class="fas fa-user-circle"></i> <span>Profile</span></a></li>
                </ul>
            </div>
        </nav>
    <div class="container">
        <% if (farmerCount > 1) { %>
            <div class="warning-banner">
                <div class="warning-icon">
                    <i class="fas fa-info-circle"></i>
                </div>
                <div class="warning-content">
                    <h3>Multiple Farmers Detected</h3>
                    <p>Your cart contains items from <%= farmerCount %> different farmers. You'll need to complete separate payments for each farmer.</p>
                </div>
            </div>
        <% } %>
        
        <div class="farmer-orders">
            <% 
            int orderNumber = 1;
            for (Map.Entry<String, List<Map<String, Object>>> entry : farmerOrders.entrySet()) {
                String farmerEmail = entry.getKey();
                List<Map<String, Object>> items = entry.getValue();
                Map<String, Object> farmer = farmerDetails.get(farmerEmail);
                
                double farmerTotal = 0.0;
                for (Map<String, Object> item : items) {
                    farmerTotal += (Double) item.get("total");
                }
                double finalTotal = farmerTotal * 1.05; // Including GST
            %>
                <div class="farmer-order-card">
                    <div class="farmer-header">
                        <div class="farmer-icon">
                            <i class="fas fa-tractor"></i>
                        </div>
                        <div class="farmer-info">
                            <h3>Order #<%= orderNumber++ %> - <%= farmer.get("name") %></h3>
                            <p><i class="fas fa-envelope"></i> <%= farmer.get("email") %> | <i class="fas fa-phone"></i> <%= farmer.get("mobile") %></p>
                        </div>
                    </div>
                    
                    <div class="order-content">
                        <div class="order-items">
                            <% for (Map<String, Object> item : items) { %>
                                <div class="order-item">
                                    <div class="item-image">
                                        <% 
                                            String base64Image = (String) item.get("base64Image");
                                            if (base64Image != null && !base64Image.isEmpty()) { 
                                        %>
                                            <img src="data:image/jpeg;base64,<%= base64Image %>" alt="<%= item.get("commodity") %>">
                                        <% } else { %>
                                            <div style="width: 100%; height: 100%; display: flex; align-items: center; justify-content: center; color: #bdc3c7;">
                                                <i class="fas fa-image"></i>
                                            </div>
                                        <% } %>
                                    </div>
                                    <div class="item-details">
                                        <h4><%= item.get("commodity") %></h4>
                                        <span class="item-category"><%= item.get("category") %></span>
                                        <div class="item-qty"><%= item.get("quantity") %> Kg × &#8377;<%= String.format("%,.0f", item.get("price")) %></div>
                                    </div>
                                    <div class="item-price">
                                        <div class="item-price-value">&#8377;<%= String.format("%,.0f", item.get("total")) %></div>
                                    </div>
                                </div>
                            <% } %>
                        </div>
                        
                        <div class="order-total">
                            <span>Total (incl. 5% GST)</span>
                            <span>&#8377;<%= String.format("%,.2f", finalTotal) %></span>
                        </div>
                        
                        <form action="ProcessPayment.jsp" method="post">
                            <input type="hidden" name="farmer_email" value="<%= farmerEmail %>">
                            <button type="submit" class="pay-farmer-btn">
                                <i class="fas fa-lock"></i>
                                Pay &#8377;<%= String.format("%,.2f", finalTotal) %> to <%= farmer.get("name") %>
                            </button>
                        </form>
                    </div>
                </div>
            <% } %>
        </div>
    </div>
</body>
</html>