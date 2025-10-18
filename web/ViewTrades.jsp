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
    
    // Get location and category filters
    String category = request.getParameter("category");
    if (category == null) category = "";
    
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
    
    // Get trades with filters
    List<Map<String, Object>> trades = new ArrayList<>();
    try {
        Connection conn = DBConnector.getConnection();
        StringBuilder queryBuilder = new StringBuilder(
            "SELECT t.id, t.commodity, t.category, t.origin, t.quantity, t.buyingprice, " +
            "t.image, t.available, t.farmer_email, f.fname, f.street, f.city, f.state " +
            "FROM tradecreation t " +
            "JOIN farmerregistration f ON t.farmer_email = f.email " +
            "WHERE t.available = 1"
        );
        
        if (category != null && !category.isEmpty()) {
            queryBuilder.append(" AND t.category = ?");
        }
        
        queryBuilder.append(" ORDER BY t.created_at DESC");
        
        PreparedStatement ps = conn.prepareStatement(queryBuilder.toString());
        
        if (category != null && !category.isEmpty()) {
            ps.setString(1, category);
        }
        
        ResultSet rs = ps.executeQuery();
        
        while (rs.next()) {
            Map<String, Object> trade = new HashMap<>();
            trade.put("id", rs.getInt("id"));
            trade.put("commodity", rs.getString("commodity"));
            trade.put("category", rs.getString("category"));
            trade.put("origin", rs.getString("origin"));
            trade.put("quantity", rs.getInt("quantity"));
            trade.put("buyingprice", rs.getDouble("buyingprice"));
            trade.put("farmer_email", rs.getString("farmer_email"));
            trade.put("fname", rs.getString("fname"));
            trade.put("street", rs.getString("street"));
            trade.put("city", rs.getString("city"));
            trade.put("state", rs.getString("state"));
            
            byte[] imageBytes = rs.getBytes("image");
            String base64Image = "";
            if (imageBytes != null && imageBytes.length > 0) {
                base64Image = java.util.Base64.getEncoder().encodeToString(imageBytes);
            }
            trade.put("base64Image", base64Image);
            trades.add(trade);
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
    <title>Kisan Mitra - Fresh from Farm</title>
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
        
        /* Categories */
        .categories {
            background: white;
            padding: 25px 0;
            box-shadow: 0 2px 10px rgba(0,0,0,0.05);
        }
        
        .categories-container {
            max-width: 1400px;
            margin: 0 auto;
            padding: 0 30px;
        }
        
        .categories-grid {
            display: flex;
            gap: 15px;
            overflow-x: auto;
            scrollbar-width: none;
            padding-bottom: 5px;
        }
        
        .categories-grid::-webkit-scrollbar {
            display: none;
        }
        
        .category-card {
            min-width: 140px;
            padding: 20px;
            border-radius: 20px;
            text-align: center;
            cursor: pointer;
            transition: all 0.3s ease;
            background: linear-gradient(135deg, #f5f7fa 0%, #c3cfe2 100%);
            border: 3px solid transparent;
        }
        
        .category-card:hover {
            transform: translateY(-5px);
            box-shadow: 0 10px 30px rgba(0,0,0,0.15);
        }
        
        .category-card.active {
            background: linear-gradient(135deg, #667eea 0%, #764ba2 100%);
            border-color: white;
            box-shadow: 0 10px 30px rgba(102, 126, 234, 0.4);
        }
        
        .category-icon {
            font-size: 3rem;
            margin-bottom: 10px;
            transition: all 0.3s;
        }
        
        .category-card.active .category-icon {
            transform: scale(1.2);
        }
        
        .category-name {
            font-size: 14px;
            font-weight: 700;
            color: #333;
        }
        
        .category-card.active .category-name {
            color: white;
        }
        
        /* Main Content */
        .main-content {
            max-width: 1400px;
            margin: 0 auto;
            padding: 40px 30px;
        }
        
        .section-header {
            margin-bottom: 30px;
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
        
        /* Product Grid */
        .products-grid {
            display: grid;
            grid-template-columns: repeat(auto-fill, minmax(220px, 1fr));
            gap: 25px;
        }
        
        .product-card {
            background: white;
            border-radius: 20px;
            overflow: hidden;
            transition: all 0.4s cubic-bezier(0.175, 0.885, 0.32, 1.275);
            cursor: pointer;
            position: relative;
            box-shadow: 0 5px 20px rgba(0,0,0,0.1);
        }
        
        .product-card:hover {
            transform: translateY(-10px) scale(1.02);
            box-shadow: 0 20px 40px rgba(0,0,0,0.2);
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
        
        .product-category-badge {
            position: absolute;
            top: 15px;
            right: 15px;
            background: rgba(255,255,255,0.95);
            color: #667eea;
            padding: 8px 15px;
            border-radius: 20px;
            font-size: 12px;
            font-weight: 700;
            box-shadow: 0 4px 15px rgba(0,0,0,0.2);
        }
        
        .product-details {
            padding: 20px;
        }
        
        .product-name {
            font-size: 1.2rem;
            font-weight: 700;
            color: #2d3436;
            margin-bottom: 8px;
            overflow: hidden;
            text-overflow: ellipsis;
            white-space: nowrap;
        }
        
        .product-farmer {
            font-size: 13px;
            color: #636e72;
            margin-bottom: 5px;
            display: flex;
            align-items: center;
            gap: 6px;
        }
        
        .product-quantity {
            font-size: 13px;
            color: #00b894;
            margin-bottom: 15px;
            font-weight: 600;
        }
        
        .product-footer {
            display: flex;
            justify-content: space-between;
            align-items: center;
            padding-top: 15px;
            border-top: 2px solid #f1f3f5;
        }
        
        .product-price {
            font-size: 1.5rem;
            font-weight: 900;
            background: linear-gradient(135deg, #667eea 0%, #764ba2 100%);
            -webkit-background-clip: text;
            -webkit-text-fill-color: transparent;
        }
        
        .product-price-label {
            font-size: 11px;
            color: #999;
            font-weight: 600;
        }
        
        .add-to-cart-btn {
            background: linear-gradient(135deg, #667eea 0%, #764ba2 100%);
            color: white;
            border: none;
            padding: 10px 20px;
            border-radius: 25px;
            font-weight: 700;
            cursor: pointer;
            transition: all 0.3s;
            font-size: 14px;
            box-shadow: 0 4px 15px rgba(102, 126, 234, 0.3);
        }
        
        .add-to-cart-btn:hover {
            transform: scale(1.05);
            box-shadow: 0 6px 20px rgba(102, 126, 234, 0.5);
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
            text-shadow: 2px 2px 4px rgba(0,0,0,0.2);
        }
        
        .empty-state p {
            font-size: 1.2rem;
            opacity: 0.9;
        }
        
        @media (max-width: 768px) {
            .header-content {
                padding: 15px 20px;
                flex-direction: column;
                gap: 15px;
            }
            
            .logo {
                font-size: 1.5rem;
            }
            
            .nav-links {
                flex-wrap: wrap;
                gap: 10px;
                justify-content: center;
            }
            
            .nav-item {
                padding: 8px 15px;
                font-size: 0.9rem;
            }
            
            .cart-button {
                padding: 8px 20px;
                font-size: 0.95rem;
            }
            
            .products-grid {
                grid-template-columns: repeat(auto-fill, minmax(160px, 1fr));
                gap: 15px;
            }
            
            .section-title {
                font-size: 2rem;
            }
            
            .categories-grid {
                gap: 10px;
            }
            
            .category-card {
                min-width: 110px;
                padding: 15px;
            }
            
            .category-icon {
                font-size: 2.5rem;
            }
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
                <a href="BuyerDashboard.jsp" class="nav-item">
                    <i class="fas fa-home"></i>
                    Dashboard
                </a>
                <a href="MyOrders.jsp" class="nav-item">
                    <i class="fas fa-box"></i>
                    Orders
                </a>
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
 
    <!-- Categories -->
    <div class="categories">
        <div class="categories-container">
            <div class="categories-grid">
                <div class="category-card <%= category.isEmpty() ? "active" : "" %>" onclick="filterCategory('')">
                    <div class="category-icon"><i class="fas fa-th"></i></div>
                    <div class="category-name">All Products</div>
                </div>
                <div class="category-card <%= "Fruit".equals(category) ? "active" : "" %>" onclick="filterCategory('Fruit')">
                    <div class="category-icon"><i class="fas fa-apple-alt"></i></div>
                    <div class="category-name">Fruits</div>
                </div>
                <div class="category-card <%= "Vegetable".equals(category) ? "active" : "" %>" onclick="filterCategory('Vegetable')">
                    <div class="category-icon"><i class="fas fa-carrot"></i></div>
                    <div class="category-name">Vegetables</div>
                </div>
                <div class="category-card <%= "Cereal".equals(category) ? "active" : "" %>" onclick="filterCategory('Cereal')">
                    <div class="category-icon"><i class="fas fa-seedling"></i></div>
                    <div class="category-name">Cereals</div>
                </div>
                <div class="category-card <%= "Pulse".equals(category) ? "active" : "" %>" onclick="filterCategory('Pulse')">
                    <div class="category-icon"><i class="fas fa-circle"></i></div>
                    <div class="category-name">Pulses</div>
                </div>
                <div class="category-card <%= "Masala".equals(category) ? "active" : "" %>" onclick="filterCategory('Masala')">
                    <div class="category-icon"><i class="fas fa-pepper-hot"></i></div>
                    <div class="category-name">Masala</div>
                </div>
                <div class="category-card <%= "Dairy Product".equals(category) ? "active" : "" %>" onclick="filterCategory('Dairy Product')">
                    <div class="category-icon"><i class="fas fa-glass-whiskey"></i></div>
                    <div class="category-name">Dairy</div>
                </div>
            </div>
        </div>
    </div>
    
    <!-- Main Content -->
    <div class="main-content">
        <div class="section-header">
            <h1 class="section-title">
                <%= category.isEmpty() ? "Fresh From Farm" : category %>
            </h1>
            <p class="section-subtitle">Premium quality products directly from farmers</p>
        </div>
        
        <% if (!trades.isEmpty()) { %>
            <div class="products-grid">
                <% for (Map<String, Object> trade : trades) { %>
                    <div class="product-card" onclick="window.location.href='TradeDetails.jsp?id=<%= trade.get("id") %>'">
                        <div class="product-image-wrapper">
                            <% String base64Image = (String) trade.get("base64Image");
                               if (base64Image != null && !base64Image.isEmpty()) { %>
                                <img src="data:image/jpeg;base64,<%= base64Image %>" alt="<%= trade.get("commodity") %>">
                            <% } else { %>
                                <div style="width: 100%; height: 100%; display: flex; align-items: center; justify-content: center;">
                                    <i class="fas fa-image" style="font-size: 4rem; color: rgba(0,0,0,0.1);"></i>
                                </div>
                            <% } %>
                            <span class="product-category-badge"><%= trade.get("category") %></span>
                        </div>
                        <div class="product-details">
                            <div class="product-name"><%= trade.get("commodity") %></div>
                            <div class="product-farmer">
                                <i class="fas fa-user-tie"></i>
                                <%= trade.get("fname") %>
                            </div>
                            <div class="product-quantity">
                                <i class="fas fa-box"></i> <%= trade.get("quantity") %> Kg
                            </div>
                            <div class="product-footer">
                                <div>
                                    <div class="product-price">&#8377;<%= String.format("%,.0f", trade.get("buyingprice")) %></div>
                                    <div class="product-price-label">per Kg</div>
                                </div>
                                <form action="AddToCart.jsp" method="post" onclick="event.stopPropagation();">
                                    <input type="hidden" name="trade_id" value="<%= trade.get("id") %>">
                                    <button type="submit" class="add-to-cart-btn">
                                        <i class="fas fa-plus"></i> ADD
                                    </button>
                                </form>
                            </div>
                        </div>
                    </div>
                <% } %>
            </div>
        <% } else { %>
            <div class="empty-state">
                <i class="fas fa-seedling"></i>
                <h3>No Products Found</h3>
                <p>Try browsing other categories</p>
            </div>
        <% } %>
    </div>
    
    <script>
        function filterCategory(category) {
            window.location.href = 'ViewTrades.jsp' + (category ? '?category=' + encodeURIComponent(category) : '');
        }
    </script>
</body>
</html>