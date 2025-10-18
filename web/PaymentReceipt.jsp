<%@ include file="SessionValidator.jsp" %>
<%@ page import="db.DBConnector" %>
<%@ page import="java.sql.*" %>
<%@ page import="java.util.*" %>

<%
    response.setHeader("Cache-Control", "no-cache, no-store, must-revalidate");
    String buyerEmail = (String) session.getAttribute("email");
    
    // Get order data from session
    String orderId = (String) session.getAttribute("orderId");
    String orderDate = (String) session.getAttribute("orderDate");
    List<Map<String, Object>> orderItems = (List<Map<String, Object>>) session.getAttribute("orderItems");
    Double totalAmount = (Double) session.getAttribute("totalAmount");
    String buyerName = (String) session.getAttribute("buyerName");
    String buyerAddress = (String) session.getAttribute("buyerAddress");
    String buyerMobile = (String) session.getAttribute("buyerMobile");
    Map<String, Object> currentFarmer = (Map<String, Object>) session.getAttribute("currentFarmer");
    
    // Insert orders into database and remove items from cart
    if (orderItems != null && !orderItems.isEmpty()) {
        try {
            Connection conn = DBConnector.getConnection();
            
            // Insert each order item
            String insertOrder = "INSERT INTO orders (buyer_email, trade_id, farmer_email, quantity, total_price, order_status, order_date) " +
                                "VALUES (?, ?, ?, ?, ?, 'Confirmed', NOW())";
            PreparedStatement orderPs = conn.prepareStatement(insertOrder);
            
            for (Map<String, Object> item : orderItems) {
                orderPs.setString(1, buyerEmail);
                orderPs.setInt(2, (Integer) item.get("trade_id"));
                orderPs.setString(3, (String) item.get("farmer_email"));
                orderPs.setInt(4, (Integer) item.get("quantity"));
                orderPs.setDouble(5, (Double) item.get("total"));
                orderPs.executeUpdate();
                
                // Remove this specific item from cart
                String deleteCart = "DELETE FROM cart WHERE id = ?";
                PreparedStatement deletePs = conn.prepareStatement(deleteCart);
                deletePs.setInt(1, (Integer) item.get("cart_id"));
                deletePs.executeUpdate();
                deletePs.close();
            }
            orderPs.close();
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
    <title>Payment Successful - Kisan Mitra</title>
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
            padding: 40px 20px;
        }
        
        .container {
            max-width: 900px;
            margin: 0 auto;
        }
        
        /* Success Animation */
        .success-animation {
            text-align: center;
            margin-bottom: 40px;
            animation: fadeInDown 0.6s ease-out;
        }
        
        .success-checkmark {
            width: 100px;
            height: 100px;
            margin: 0 auto 25px;
            border-radius: 50%;
            background: white;
            display: flex;
            align-items: center;
            justify-content: center;
            animation: scaleIn 0.5s ease-out;
        }
        
        .success-checkmark i {
            font-size: 3.5rem;
            color: #2ecc71;
            animation: checkmark 0.8s ease-out 0.3s forwards;
            opacity: 0;
        }
        
        .success-title {
            font-size: 2.5rem;
            font-weight: 800;
            color: white;
            margin-bottom: 10px;
        }
        
        .success-subtitle {
            font-size: 1.2rem;
            color: rgba(255, 255, 255, 0.9);
        }
        
        /* Receipt Card */
        .receipt-card {
            background: white;
            border-radius: 20px;
            overflow: hidden;
            box-shadow: 0 20px 60px rgba(0, 0, 0, 0.3);
            animation: fadeInUp 0.6s ease-out 0.3s backwards;
        }
        
        .receipt-header {
            background: linear-gradient(135deg, #2c3e50 0%, #34495e 100%);
            padding: 30px;
            color: white;
            text-align: center;
        }
        
        .receipt-logo {
            font-size: 2rem;
            font-weight: 800;
            margin-bottom: 10px;
            display: flex;
            align-items: center;
            justify-content: center;
            gap: 10px;
        }
        
        .receipt-logo i {
            font-size: 2.5rem;
        }
        
        .receipt-type {
            font-size: 1.3rem;
            font-weight: 600;
            opacity: 0.9;
        }
        
        .receipt-body {
            padding: 35px;
        }
        
        /* Order Info */
        .order-info {
            display: grid;
            grid-template-columns: 1fr 1fr;
            gap: 25px;
            margin-bottom: 35px;
            padding-bottom: 25px;
            border-bottom: 2px dashed #e0e0e0;
        }
        
        .info-block {
            background: #f8f9fa;
            padding: 20px;
            border-radius: 12px;
            border-left: 4px solid #667eea;
        }
        
        .info-label {
            font-size: 0.85rem;
            color: #7f8c8d;
            font-weight: 600;
            margin-bottom: 8px;
            text-transform: uppercase;
            letter-spacing: 0.5px;
        }
        
        .info-value {
            font-size: 1.1rem;
            color: #2c3e50;
            font-weight: 700;
        }
        
        .info-value.large {
            font-size: 1.5rem;
            color: #667eea;
        }
        
        /* Parties Section */
        .parties-section {
            display: grid;
            grid-template-columns: 1fr 1fr;
            gap: 25px;
            margin-bottom: 35px;
        }
        
        .party-card {
            background: linear-gradient(135deg, #f8f9fa 0%, #ecf0f1 100%);
            padding: 25px;
            border-radius: 12px;
            border: 2px solid #e0e0e0;
        }
        
        .party-header {
            display: flex;
            align-items: center;
            gap: 12px;
            margin-bottom: 15px;
            padding-bottom: 15px;
            border-bottom: 2px solid #bdc3c7;
        }
        
        .party-icon {
            width: 45px;
            height: 45px;
            border-radius: 50%;
            background: #667eea;
            color: white;
            display: flex;
            align-items: center;
            justify-content: center;
            font-size: 1.3rem;
        }
        
        .party-title {
            font-size: 1.2rem;
            font-weight: 700;
            color: #2c3e50;
        }
        
        .party-detail {
            display: flex;
            align-items: flex-start;
            gap: 10px;
            margin-bottom: 12px;
            font-size: 0.95rem;
            color: #34495e;
        }
        
        .party-detail i {
            color: #667eea;
            margin-top: 3px;
            min-width: 20px;
        }
        
        /* Order Items */
        .items-section {
            margin-bottom: 30px;
        }
        
        .section-title {
            font-size: 1.3rem;
            font-weight: 700;
            color: #2c3e50;
            margin-bottom: 20px;
            display: flex;
            align-items: center;
            gap: 10px;
        }
        
        .section-title i {
            color: #667eea;
        }
        
        .order-item {
            background: #f8f9fa;
            padding: 20px;
            border-radius: 10px;
            margin-bottom: 15px;
            display: grid;
            grid-template-columns: 2fr 1fr 1fr 1fr;
            gap: 15px;
            align-items: center;
        }
        
        .item-name {
            font-weight: 700;
            color: #2c3e50;
            font-size: 1.05rem;
        }
        
        .item-category {
            display: inline-block;
            background: #e8f5e9;
            color: #27ae60;
            padding: 3px 10px;
            border-radius: 10px;
            font-size: 0.75rem;
            font-weight: 600;
            margin-top: 5px;
        }
        
        .item-qty, .item-price, .item-total {
            text-align: right;
            color: #2c3e50;
            font-weight: 600;
        }
        
        /* Total Section */
        .total-section {
            background: linear-gradient(135deg, #667eea 0%, #764ba2 100%);
            padding: 25px;
            border-radius: 12px;
            color: white;
        }
        
        .total-row {
            display: flex;
            justify-content: space-between;
            margin-bottom: 12px;
            font-size: 1.05rem;
        }
        
        .total-row.final {
            font-size: 1.8rem;
            font-weight: 800;
            padding-top: 15px;
            margin-top: 15px;
            border-top: 2px solid rgba(255, 255, 255, 0.3);
        }
        
        /* Action Buttons */
        .action-buttons {
            display: grid;
            grid-template-columns: 1fr 1fr;
            gap: 15px;
            margin-top: 30px;
        }
        
        .btn {
            padding: 15px 30px;
            border: none;
            border-radius: 10px;
            font-size: 1.05rem;
            font-weight: 700;
            cursor: pointer;
            transition: all 0.3s;
            display: flex;
            align-items: center;
            justify-content: center;
            gap: 10px;
            text-decoration: none;
        }
        
        .btn-primary {
            background: linear-gradient(135deg, #667eea 0%, #764ba2 100%);
            color: white;
            box-shadow: 0 5px 20px rgba(102, 126, 234, 0.4);
        }
        
        .btn-primary:hover {
            transform: translateY(-3px);
            box-shadow: 0 8px 25px rgba(102, 126, 234, 0.5);
        }
        
        .btn-secondary {
            background: white;
            color: #667eea;
            border: 2px solid #667eea;
        }
        
        .btn-secondary:hover {
            background: #667eea;
            color: white;
            transform: translateY(-3px);
        }
        
        .info-message {
            text-align: center;
            margin-top: 20px;
            padding: 15px;
            background: #fff3cd;
            border-radius: 10px;
            color: #856404;
        }
        
        @keyframes fadeInDown {
            from {
                opacity: 0;
                transform: translateY(-30px);
            }
            to {
                opacity: 1;
                transform: translateY(0);
            }
        }
        
        @keyframes fadeInUp {
            from {
                opacity: 0;
                transform: translateY(30px);
            }
            to {
                opacity: 1;
                transform: translateY(0);
            }
        }
        
        @keyframes scaleIn {
            from {
                transform: scale(0);
            }
            to {
                transform: scale(1);
            }
        }
        
        @keyframes checkmark {
            to {
                opacity: 1;
                transform: scale(1);
            }
            from {
                opacity: 0;
                transform: scale(0);
            }
        }
        
        @media (max-width: 768px) {
            .order-info,
            .parties-section {
                grid-template-columns: 1fr;
            }
            
            .order-item {
                grid-template-columns: 1fr;
                text-align: left;
            }
            
            .item-qty, .item-price, .item-total {
                text-align: left;
            }
            
            .action-buttons {
                grid-template-columns: 1fr;
            }
        }
        
        @media print {
            body {
                background: white;
                padding: 0;
            }
            
            .success-animation,
            .action-buttons,
            .info-message {
                display: none;
            }
            
            .receipt-card {
                box-shadow: none;
            }
        }
    </style>
</head>
<body>
    <div class="container">
        <!-- Success Animation -->
        <div class="success-animation">
            <div class="success-checkmark">
                <i class="fas fa-check"></i>
            </div>
            <h1 class="success-title">Payment Successful!</h1>
            <p class="success-subtitle">Your order has been confirmed and is being processed</p>
        </div>
        
        <!-- Receipt Card -->
        <div class="receipt-card">
            <div class="receipt-header">
                <div class="receipt-logo">
                    <i class="fas fa-leaf"></i>
                    <span>Kisan Mitra</span>
                </div>
                <div class="receipt-type">Payment Receipt</div>
            </div>
            
            <div class="receipt-body">
                <!-- Order Information -->
                <div class="order-info">
                    <div class="info-block">
                        <div class="info-label">Order ID</div>
                        <div class="info-value large"><%= orderId %></div>
                    </div>
                    <div class="info-block">
                        <div class="info-label">Order Date</div>
                        <div class="info-value"><%= orderDate %></div>
                    </div>
                </div>
                
                <!-- Buyer and Farmer Details -->
                <div class="parties-section">
                    <!-- Buyer Details -->
                    <div class="party-card">
                        <div class="party-header">
                            <div class="party-icon">
                                <i class="fas fa-user"></i>
                            </div>
                            <div class="party-title">Buyer Details</div>
                        </div>
                        <div class="party-detail">
                            <i class="fas fa-user-circle"></i>
                            <div><strong><%= buyerName %></strong></div>
                        </div>
                        <div class="party-detail">
                            <i class="fas fa-envelope"></i>
                            <div><%= buyerEmail %></div>
                        </div>
                        <div class="party-detail">
                            <i class="fas fa-phone"></i>
                            <div><%= buyerMobile %></div>
                        </div>
                        <div class="party-detail">
                            <i class="fas fa-map-marker-alt"></i>
                            <div><%= buyerAddress %></div>
                        </div>
                    </div>
                    
                    <!-- Farmer Details -->
                    <% if (currentFarmer != null) { %>
                    <div class="party-card">
                        <div class="party-header">
                            <div class="party-icon">
                                <i class="fas fa-tractor"></i>
                            </div>
                            <div class="party-title">Farmer Details</div>
                        </div>
                        <div class="party-detail">
                            <i class="fas fa-user-circle"></i>
                            <div><strong><%= currentFarmer.get("name") %></strong></div>
                        </div>
                        <div class="party-detail">
                            <i class="fas fa-envelope"></i>
                            <div><%= currentFarmer.get("email") %></div>
                        </div>
                        <div class="party-detail">
                            <i class="fas fa-phone"></i>
                            <div><%= currentFarmer.get("mobile") %></div>
                        </div>
                        <div class="party-detail">
                            <i class="fas fa-map-marker-alt"></i>
                            <div><%= currentFarmer.get("address") %></div>
                        </div>
                    </div>
                    <% } %>
                </div>
                
                <!-- Order Items -->
                <div class="items-section">
                    <h3 class="section-title">
                        <i class="fas fa-shopping-basket"></i>
                        Order Items
                    </h3>
                    
                    <% 
                    if (orderItems != null) {
                        for (Map<String, Object> item : orderItems) { 
                    %>
                        <div class="order-item">
                            <div>
                                <div class="item-name"><%= item.get("commodity") %></div>
                                <span class="item-category"><%= item.get("category") %></span>
                            </div>
                            <div class="item-qty">
                                <div style="color: #7f8c8d; font-size: 0.85rem; margin-bottom: 5px;">Quantity</div>
                                <%= item.get("quantity") %> Kg
                            </div>
                            <div class="item-price">
                                <div style="color: #7f8c8d; font-size: 0.85rem; margin-bottom: 5px;">Price/MT</div>
                                &#8377;<%= String.format("%,.2f", item.get("price")) %>
                            </div>
                            <div class="item-total">
                                <div style="color: #7f8c8d; font-size: 0.85rem; margin-bottom: 5px;">Total</div>
                                &#8377;<%= String.format("%,.2f", item.get("total")) %>
                            </div>
                        </div>
                    <% 
                        }
                    }
                    %>
                </div>
                
                <!-- Total Section -->
                <div class="total-section">
                    <div class="total-row">
                        <span>Subtotal</span>
                        <span>&#8377;<%= String.format("%,.2f", totalAmount) %></span>
                    </div>
                    <div class="total-row">
                        <span>Delivery Charges</span>
                        <span style="color: #2ecc71;">FREE</span>
                    </div>
                    <div class="total-row">
                        <span>GST (5%)</span>
                        <span>&#8377;<%= String.format("%,.2f", totalAmount * 0.05) %></span>
                    </div>
                    <div class="total-row final">
                        <span>Total Amount Paid</span>
                        <span>&#8377;<%= String.format("%,.2f", totalAmount * 1.05) %></span>
                    </div>
                </div>
                
                <!-- Action Buttons -->
                <div class="action-buttons">
                    <button onclick="window.print()" class="btn btn-secondary">
                        <i class="fas fa-print"></i>
                        Print Receipt
                    </button>
                    <a href="Cart.jsp" class="btn btn-primary">
                        <i class="fas fa-shopping-cart"></i>
                        Check Cart
                    </a>
                </div>
                
                <div class="info-message">
                    <i class="fas fa-info-circle"></i> If you have items from other farmers in your cart, please complete their payments separately.
                </div>
            </div>
        </div>
    </div>
    
    <script>
        // Confetti effect
        function createConfetti() {
            const colors = ['#667eea', '#764ba2', '#2ecc71', '#f39c12', '#e74c3c'];
            const confettiCount = 50;
            
            for (let i = 0; i < confettiCount; i++) {
                const confetti = document.createElement('div');
                confetti.style.position = 'fixed';
                confetti.style.width = '10px';
                confetti.style.height = '10px';
                confetti.style.backgroundColor = colors[Math.floor(Math.random() * colors.length)];
                confetti.style.left = Math.random() * 100 + '%';
                confetti.style.top = '-10px';
                confetti.style.opacity = Math.random();
                confetti.style.transform = 'rotate(' + Math.random() * 360 + 'deg)';
                confetti.style.zIndex = '9999';
                confetti.style.pointerEvents = 'none';
                
                document.body.appendChild(confetti);
                
                const duration = Math.random() * 3 + 2;
                const delay = Math.random() * 2;
                
                confetti.animate([
                    { transform: 'translateY(0) rotate(0deg)', opacity: 1 },
                    { transform: 'translateY(' + (window.innerHeight + 20) + 'px) rotate(' + (Math.random() * 720) + 'deg)', opacity: 0 }
                ], {
                    duration: duration * 1000,
                    delay: delay * 1000,
                    easing: 'cubic-bezier(0.25, 0.46, 0.45, 0.94)'
                });
                
                setTimeout(function() { confetti.remove(); }, (duration + delay) * 1000);
            }
        }
        
        // Trigger confetti on page load
        window.addEventListener('load', function() {
            setTimeout(createConfetti, 500);
        });
    </script>
</body>
</html>