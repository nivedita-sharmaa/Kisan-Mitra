<%@ page import="db.DBConnector" %>
<%@ page import="java.sql.*" %>
<%@ page import="java.util.*" %>
<!DOCTYPE html>
<html lang="en">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>Farmer's Marketplace - Available Trades</title>
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
            --danger-color: #e53935;
            --warning-color: #ff9800;
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
        
        .unavailable-overlay {
            position: absolute;
            top: 0;
            left: 0;
            width: 100%;
            height: 100%;
            background-color: rgba(0,0,0,0.5);
            display: flex;
            justify-content: center;
            align-items: center;
            color: white;
            font-size: 1.2rem;
            font-weight: bold;
            text-transform: uppercase;
            letter-spacing: 1px;
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
        
        .buy-now-btn {
            display: block;
            width: 100%;
            background-color: var(--accent-color);
            color: white;
            text-align: center;
            padding: 12px;
            border: none;
            border-radius: 0 0 var(--card-radius) var(--card-radius);
            font-weight: 600;
            font-size: 1rem;
            cursor: pointer;
            transition: all 0.3s ease;
            margin-top: 15px;
            text-decoration: none;
        }
        
        .buy-now-btn:hover {
            background-color: var(--accent-hover);
            transform: translateY(-2px);
        }
        
        .buy-now-btn.disabled {
            background-color: #ccc;
            cursor: not-allowed;
        }
        
        .buy-now-btn.disabled:hover {
            background-color: #ccc;
            transform: none;
        }
        
        .buy-now-btn i {
            margin-right: 5px;
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
        
        @keyframes pulse {
            0% {
                transform: scale(1);
            }
            50% {
                transform: scale(1.05);
            }
            100% {
                transform: scale(1);
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
            .grid-container {
                grid-template-columns: 1fr;
            }
            
            .card-content {
                padding: 15px;
            }
        }
    </style>
</head>
<body>
    
    <%
        // Define a Trade class to hold trade data
        class Trade {
            int id;
            String commodity;
            String origin;
            int quantity;
            double buyingPrice;
            int available; // For out-of-stock control
            String base64Image;
            String category;
            
            Trade(int id, String commodity, String origin, int quantity, double buyingPrice, 
                  int available, String base64Image, String category) {
                this.id = id;
                this.commodity = commodity != null ? commodity : "";
                this.origin = origin != null ? origin : "";
                this.quantity = quantity;
                this.buyingPrice = buyingPrice;
                this.available = available;
                this.base64Image = base64Image != null ? base64Image : "";
                this.category = category != null ? category : "produce";
            }
        }
        
        // Get user information for the header
        String userName = (String) session.getAttribute("userName");
        if (userName == null) {
            userName = "Guest";
        }
        
        List<Trade> trades = new ArrayList<>();
        try {
            Statement st = DBConnector.getStatement();
            String query = "SELECT id, commodity, origin, quantity, buyingprice, image, available FROM tradecreation ORDER BY id DESC";
            ResultSet rs = st.executeQuery(query);
            while (rs.next()) {
                byte[] imageBytes = rs.getBytes("image");
                String base64Image = "";
                if (imageBytes != null && imageBytes.length > 0) {
                    base64Image = java.util.Base64.getEncoder().encodeToString(imageBytes);
                }
                
                // Handle available integer
                int available;
                try {
                    available = rs.getInt("available");
                    if (rs.wasNull()) {
                        available = 2; // Default as in original code
                    }
                } catch (SQLException e) {
                    available = 2; // Fallback
                }
                
                Trade trade = new Trade(
                    rs.getInt("id"),
                    rs.getString("commodity"),
                    rs.getString("origin"),
                    rs.getInt("quantity"),
                    rs.getDouble("buyingprice"),
                    available,
                    base64Image,
                    "produce" // Default category since not in query
                );
                trades.add(trade);
            }
        } catch (SQLException e) {
            out.println("<p style='color:red;'>SQL Error: " + e.getMessage() + "</p>");
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
                <li><a href="ViewTrades.jsp" class="active"><i class="fas fa-store"></i> Marketplace</a></li>
                <li><a href="About.html"><i class="fas fa-info-circle"></i> About</a></li>
                <li><a href="ContactUs.html"><i class="fas fa-envelope"></i> Contact</a></li>
            </ul>
            <div class="user-menu">
                <div class="user-icon">
                    <i class="fas fa-user"></i>
                </div>
                <a href="BuyerProfile.jsp">Welcome, <%= userName %></a>
                <a href="Logout.jsp"><i class="fas fa-sign-out-alt"></i> Logout</a>
            </div>
        </div>
    </nav>

    <div class="container">
        <div class="filters">
            <div class="search-container">
                <i class="fas fa-search"></i>
                <input type="text" id="searchInput" placeholder="Search commodities...">
            </div>
        </div>

        <div class="grid-container">
            <% 
                int delay = 0;
                for (Trade trade : trades) {
                    delay += 100; // Increment delay for staggered animation
            %>
            <div class="card" style="animation-delay: <%= delay %>ms;" 
                 data-category="<%= trade.category.toLowerCase() %>">
                <div class="card-image">
                    <% if (!trade.base64Image.isEmpty()) { %>
                        <img src="data:image/jpeg;base64,<%= trade.base64Image %>" alt="<%= trade.commodity %>" loading="lazy">
                    <% } else { %>
                        <div class="no-image">
                            <i class="fas fa-seedling"></i>
                        </div>
                    <% } %>
                    <% if (trade.available != 1) { %>
                        <div class="unavailable-overlay">
                            Out of Stock
                        </div>
                    <% } %>
                </div>
                <div class="card-content">
                    <div class="card-title"><%= trade.commodity %></div>
                    <div class="card-origin">
                        <i class="fas fa-map-marker-alt"></i>
                        <%= trade.origin %>
                    </div>
                    <div class="card-details">
                        <div class="detail-item">
                            <div class="detail-label">QUANTITY</div>
                            <div class="detail-value"><%= trade.quantity %> MT</div>
                        </div>
                        <div class="detail-item">
                            <div class="detail-label">PRICE</div>
                            <div class="detail-value">Rs.<%= String.format("%,.2f", trade.buyingPrice) %></div>
                        </div>
                    </div>
                </div>
                <% if (trade.available == 1) { %>
                    <a href="TradeDetails.jsp?id=<%= trade.id %>" class="buy-now-btn">
                        <i class="fas fa-shopping-bag"></i> Buy Now
                    </a>
                <% } else { %>
                    <a href="javascript:void(0);" class="buy-now-btn disabled">
                        <i class="fas fa-ban"></i> Out of Stock
                    </a>
                <% } %>
            </div>
            <% } %>
            
            <% if (trades.isEmpty()) { %>
            <div class="placeholder">
                <p>No crop listings available at the moment.</p>
            </div>
            <% } %>
        </div>
    </div>

    <footer>
        <p>© <%= new java.util.Date().getYear() + 1900 %> Farmer's Marketplace. Supporting local farmers and sustainable agriculture.</p>
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
            
            // Apply random animation delays for a staggered effect
            $(".card").each(function(index) {
                $(this).css("animation-delay", (index * 100) + "ms");
            });
        });
    </script>
</body>
</html>