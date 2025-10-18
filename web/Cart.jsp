<%@ include file="SessionValidator.jsp" %>
<%@ page import="db.DBConnector" %>
<%@ page import="java.sql.*" %>
<%@ page import="java.util.*" %>

<%
    response.setHeader("Cache-Control", "no-cache, no-store, must-revalidate");
    String buyerEmail = (String) session.getAttribute("email");
    
    List<Map<String, Object>> cartItems = new ArrayList<>();
    double totalAmount = 0.0;
    
    try {
        Connection conn = DBConnector.getConnection();
        String query = "SELECT c.id, c.quantity, c.trade_id, t.commodity, t.category, t.buyingprice, " +
                       "t.image, f.fname, f.city, f.state FROM cart c " +
                       "JOIN tradecreation t ON c.trade_id = t.id " +
                       "JOIN farmerregistration f ON t.farmer_email = f.email " +
                       "WHERE c.buyer_email = ?";
        PreparedStatement ps = conn.prepareStatement(query);
        ps.setString(1, buyerEmail);
        ResultSet rs = ps.executeQuery();
        
        while (rs.next()) {
            Map<String, Object> item = new HashMap<>();
            item.put("cart_id", rs.getInt("id"));
            item.put("trade_id", rs.getInt("trade_id"));
            item.put("commodity", rs.getString("commodity"));
            item.put("category", rs.getString("category"));
            item.put("quantity", rs.getInt("quantity"));
            item.put("price", rs.getDouble("buyingprice"));
            item.put("farmer", rs.getString("fname"));
            item.put("city", rs.getString("city"));
            item.put("state", rs.getString("state"));
            
            double itemTotal = rs.getInt("quantity") * rs.getDouble("buyingprice");
            item.put("total", itemTotal);
            totalAmount += itemTotal;
            
            byte[] imageBytes = rs.getBytes("image");
            String base64Image = "";
            if (imageBytes != null && imageBytes.length > 0) {
                base64Image = java.util.Base64.getEncoder().encodeToString(imageBytes);
            }
            item.put("base64Image", base64Image);
            cartItems.add(item);
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
    <title>Shopping Cart - Kisan Mitra</title>
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
        
        /* Notification */
        .notification {
            position: fixed;
            top: 20px;
            right: 20px;
            padding: 15px 25px;
            background: #2ecc71;
            color: white;
            border-radius: 10px;
            box-shadow: 0 5px 20px rgba(0,0,0,0.3);
            z-index: 1000;
            animation: slideIn 0.3s ease-out;
        }
        
        .notification.error {
            background: #e74c3c;
        }
        
        @keyframes slideIn {
            from {
                transform: translateX(400px);
                opacity: 0;
            }
            to {
                transform: translateX(0);
                opacity: 1;
            }
        }
        
        /* Main Container */
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
        
        .cart-layout {
            display: grid;
            grid-template-columns: 1fr 400px;
            gap: 30px;
        }
        
        /* Cart Items */
        .cart-items {
            display: flex;
            flex-direction: column;
            gap: 20px;
        }
        
        .cart-item {
            background: white;
            border-radius: 20px;
            padding: 25px;
            display: grid;
            grid-template-columns: 120px 1fr auto;
            gap: 20px;
            align-items: center;
            box-shadow: 0 10px 30px rgba(0,0,0,0.15);
            transition: all 0.3s;
        }
        
        .cart-item:hover {
            transform: translateY(-3px);
            box-shadow: 0 15px 40px rgba(0,0,0,0.2);
        }
        
        .item-image {
            width: 120px;
            height: 120px;
            border-radius: 15px;
            overflow: hidden;
            background: #f5f5f5;
        }
        
        .item-image img {
            width: 100%;
            height: 100%;
            object-fit: cover;
        }
        
        .item-details {
            display: flex;
            flex-direction: column;
            gap: 10px;
        }
        
        .item-name {
            font-size: 1.3rem;
            font-weight: 700;
            color: #2d3436;
        }
        
        .item-category {
            display: inline-block;
            background: #e8f5e9;
            color: #2e7d32;
            padding: 5px 12px;
            border-radius: 15px;
            font-size: 0.85rem;
            font-weight: 600;
            width: fit-content;
        }
        
        .item-farmer {
            font-size: 0.95rem;
            color: #636e72;
        }
        
        .item-price {
            font-size: 1.1rem;
            font-weight: 700;
            color: #667eea;
        }
        
        .item-actions {
            display: flex;
            flex-direction: column;
            gap: 15px;
            align-items: flex-end;
        }
        
        .quantity-control {
            display: flex;
            align-items: center;
            gap: 10px;
            background: #f8f9fa;
            padding: 8px 15px;
            border-radius: 25px;
        }
        
        .qty-btn {
            background: #667eea;
            color: white;
            border: none;
            width: 35px;
            height: 35px;
            border-radius: 50%;
            cursor: pointer;
            font-size: 1.2rem;
            font-weight: 700;
            transition: all 0.3s;
            display: flex;
            align-items: center;
            justify-content: center;
        }
        
        .qty-btn:hover {
            background: #764ba2;
            transform: scale(1.1);
        }
        
        .qty-btn:disabled {
            background: #ddd;
            cursor: not-allowed;
            transform: scale(1);
        }
        
        .qty-display {
            font-size: 1.1rem;
            font-weight: 700;
            min-width: 30px;
            text-align: center;
        }
        
        .item-total {
            font-size: 1.5rem;
            font-weight: 900;
            color: #2d3436;
        }
        
        .remove-btn {
            background: #ff6b6b;
            color: white;
            border: none;
            padding: 8px 20px;
            border-radius: 20px;
            cursor: pointer;
            font-weight: 600;
            transition: all 0.3s;
        }
        
        .remove-btn:hover {
            background: #ff5252;
            transform: scale(1.05);
        }
        
        /* Order Summary */
        .order-summary {
            background: white;
            border-radius: 20px;
            padding: 30px;
            height: fit-content;
            position: sticky;
            top: 100px;
            box-shadow: 0 10px 30px rgba(0,0,0,0.15);
        }
        
        .summary-title {
            font-size: 1.5rem;
            font-weight: 700;
            margin-bottom: 25px;
            color: #2d3436;
        }
        
        .summary-row {
            display: flex;
            justify-content: space-between;
            padding: 15px 0;
            border-bottom: 1px solid #f1f3f5;
        }
        
        .summary-row:last-child {
            border-bottom: none;
            padding-top: 20px;
            margin-top: 10px;
            border-top: 2px solid #f1f3f5;
        }
        
        .summary-label {
            font-size: 1rem;
            color: #636e72;
        }
        
        .summary-value {
            font-size: 1rem;
            font-weight: 700;
            color: #2d3436;
        }
        
        .total-label {
            font-size: 1.2rem;
            font-weight: 700;
            color: #2d3436;
        }
        
        .total-value {
            font-size: 1.8rem;
            font-weight: 900;
            background: linear-gradient(135deg, #667eea 0%, #764ba2 100%);
            -webkit-background-clip: text;
            -webkit-text-fill-color: transparent;
        }
        
        .buy-button {
            width: 100%;
            background: linear-gradient(135deg, #667eea 0%, #764ba2 100%);
            color: white;
            border: none;
            padding: 18px;
            border-radius: 50px;
            font-size: 1.2rem;
            font-weight: 700;
            cursor: pointer;
            margin-top: 25px;
            transition: all 0.3s;
            box-shadow: 0 10px 30px rgba(102, 126, 234, 0.4);
        }
        
        .buy-button:hover {
            transform: translateY(-3px);
            box-shadow: 0 15px 40px rgba(102, 126, 234, 0.5);
        }
        
        .empty-cart {
            text-align: center;
            padding: 100px 20px;
            color: white;
            grid-column: 1 / -1;
        }
        
        .empty-cart i {
            font-size: 5rem;
            margin-bottom: 25px;
            opacity: 0.5;
        }
        
        .empty-cart h3 {
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
        
        @media (max-width: 968px) {
            .cart-layout {
                grid-template-columns: 1fr;
            }
            
            .order-summary {
                position: relative;
                top: 0;
            }
            
            .cart-item {
                grid-template-columns: 1fr;
            }
            
            .item-actions {
                flex-direction: row;
                justify-content: space-between;
            }
        }
    </style>
</head>
<body>
    <!-- Notification Messages -->
    <%
        String updated = request.getParameter("updated");
        String removed = request.getParameter("removed");
        String error = request.getParameter("error");
        
        if ("success".equals(updated)) {
    %>
        <div class="notification" id="notification">
            <i class="fas fa-check-circle"></i> Cart updated successfully!
        </div>
    <%
        } else if ("success".equals(removed)) {
    %>
        <div class="notification" id="notification">
            <i class="fas fa-check-circle"></i> Item removed from cart!
        </div>
    <%
        } else if (error != null) {
    %>
        <div class="notification error" id="notification">
            <i class="fas fa-exclamation-circle"></i> An error occurred!
        </div>
    <%
        }
    %>

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
                <a href="MyOrders.jsp" class="nav-item">
                    <i class="fas fa-box"></i>
                    Orders
                </a>
                <a href="BuyerProfile.jsp" class="nav-item">
                    <i class="fas fa-user"></i>
                    Profile
                </a>
            </div>
        </div>
    </div>
    
    <!-- Main Container -->
    <div class="container">
        <h1 class="page-title"><i class="fas fa-shopping-cart"></i> Shopping Cart</h1>
        
        <% if (cartItems.isEmpty()) { %>
            <div class="cart-layout">
                <div class="empty-cart">
                    <i class="fas fa-shopping-cart"></i>
                    <h3>Your Cart is Empty</h3>
                    <p style="font-size: 1.2rem; margin-top: 10px;">Add some fresh produce to get started!</p>
                    <a href="ViewTrades.jsp" class="shop-button">
                        <i class="fas fa-store"></i> Browse Products
                    </a>
                </div>
            </div>
        <% } else { %>
            <div class="cart-layout">
                <!-- Cart Items -->
                <div class="cart-items">
                    <% for (Map<String, Object> item : cartItems) { 
                        int currentQty = (Integer) item.get("quantity");
                    %>
                        <div class="cart-item">
                            <div class="item-image">
                                <% String base64Image = (String) item.get("base64Image");
                                   if (base64Image != null && !base64Image.isEmpty()) { %>
                                    <img src="data:image/jpeg;base64,<%= base64Image %>" alt="<%= item.get("commodity") %>">
                                <% } else { %>
                                    <div style="width: 100%; height: 100%; display: flex; align-items: center; justify-content: center;">
                                        <i class="fas fa-image" style="font-size: 3rem; color: #ccc;"></i>
                                    </div>
                                <% } %>
                            </div>
                            
                            <div class="item-details">
                                <div class="item-name"><%= item.get("commodity") %></div>
                                <span class="item-category"><%= item.get("category") %></span>
                                <div class="item-farmer">
                                    <i class="fas fa-user-tie"></i> <%= item.get("farmer") %>
                                </div>
                                <div class="item-price">&#8377;<%= String.format("%,.2f", item.get("price")) %> / Kg</div>
                            </div>
                            
                            <div class="item-actions">
                                <div class="quantity-control">
                                    <button class="qty-btn" 
                                            onclick="updateQuantity(<%= item.get("cart_id") %>, <%= currentQty %> - 1)"
                                            <%= currentQty <= 1 ? "disabled" : "" %>>
                                        -
                                    </button>
                                    <span class="qty-display"><%= currentQty %></span>
                                    <button class="qty-btn" onclick="updateQuantity(<%= item.get("cart_id") %>, <%= currentQty %> + 1)">
                                        +
                                    </button>
                                </div>
                                <div class="item-total">&#8377;<%= String.format("%,.2f", item.get("total")) %></div>
                                <form action="RemoveFromCart.jsp" method="post" style="margin: 0;" onsubmit="return confirm('Remove this item from cart?');">
                                    <input type="hidden" name="cart_id" value="<%= item.get("cart_id") %>">
                                    <button type="submit" class="remove-btn">
                                        <i class="fas fa-trash"></i> Remove
                                    </button>
                                </form>
                            </div>
                        </div>
                    <% } %>
                </div>
                
                <!-- Order Summary -->
                <div class="order-summary">
                    <h2 class="summary-title">Order Summary</h2>
                    
                    <div class="summary-row">
                        <span class="summary-label">Items (<%= cartItems.size() %>)</span>
                        <span class="summary-value">&#8377;<%= String.format("%,.2f", totalAmount) %></span>
                    </div>
                    
                    <div class="summary-row">
                        <span class="summary-label">Delivery</span>
                        <span class="summary-value" style="color: #00b894;">FREE</span>
                    </div>
                    
                    <div class="summary-row">
                        <span class="total-label">Total Amount</span>
                        <span class="total-value">&#8377;<%= String.format("%,.2f", totalAmount) %></span>
                    </div>
                    
                    <form action="PaymentGateway.jsp" method="post">
                        <button type="submit" class="buy-button">
                            <i class="fas fa-lock"></i> Proceed to Buy
                        </button>
                    </form>
                </div>
            </div>
        <% } %>
    </div>
    
    <script>
        // Auto-hide notification after 3 seconds
        const notification = document.getElementById('notification');
        if (notification) {
            setTimeout(() => {
                notification.style.animation = 'slideIn 0.3s ease-out reverse';
                setTimeout(() => {
                    notification.remove();
                }, 300);
            }, 3000);
        }
        
        // Update quantity function
        function updateQuantity(cartId, newQty) {
            if (newQty < 1) {
                if (confirm('Remove this item from cart?')) {
                    window.location.href = 'RemoveFromCart.jsp?cart_id=' + cartId;
                }
                return;
            }
            
            // Show loading state
            event.target.disabled = true;
            event.target.style.opacity = '0.5';
            
            // Update quantity in database
            window.location.href = 'UpdateCartQuantity.jsp?cart_id=' + cartId + '&quantity=' + newQty;
        }
    </script>
</body>
</html>