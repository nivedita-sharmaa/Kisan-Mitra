<%@ include file="SessionValidator.jsp" %>
<%@page import="db.DBConnector"%>
<%@page import="java.sql.*" %>
<% response.setHeader("Cache-Control", "no-cache, no-store, must-revalidate");
    response.setHeader("Pragma", "no-cache");
    response.setDateHeader("Expires", 0);
%>
<%@page contentType="text/html" pageEncoding="UTF-8"%>

<%
    String fname = "", lname = "";
    String email = (String) session.getAttribute("email");
    
    try {
        Connection conn = DBConnector.getConnection();
        String query = "SELECT fname, lname FROM buyerregistration WHERE email = ?";
        PreparedStatement ps = conn.prepareStatement(query);
        ps.setString(1, email);
        ResultSet rs = ps.executeQuery();
        
        if (rs.next()) {
            fname = rs.getString("fname");
            lname = rs.getString("lname");
        }
        ps.close();
        conn.close();
    } catch (SQLException e) {
        System.out.println(e);
    }
%>

<!DOCTYPE html>
<html lang="en">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <meta http-equiv="Cache-Control" content="no-cache, no-store, must-revalidate" />
    <meta http-equiv="Pragma" content="no-cache" />
    <meta http-equiv="Expires" content="0" />
    <title>Buyer Dashboard - Kisan Mitra</title>
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
            display: flex;
            flex-direction: column;
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

        /* Main Container */
        .main-content {
            flex: 1;
            display: flex;
            justify-content: center;
            align-items: center;
            padding: 40px 20px;
        }

        .dashboard-container {
            max-width: 1200px;
            width: 100%;
        }

        /* Welcome Section */
        .welcome-section {
            background: white;
            border-radius: 20px;
            padding: 50px;
            margin-bottom: 40px;
            box-shadow: 0 20px 60px rgba(0,0,0,0.3);
            animation: slideUp 0.8s ease;
            text-align: center;
        }

        .welcome-icon {
            font-size: 4rem;
            color: #667eea;
            margin-bottom: 20px;
        }

        .welcome-title {
            font-size: 2.5rem;
            color: #1a2a6c;
            margin-bottom: 10px;
            font-weight: 700;
        }

        .welcome-subtitle {
            font-size: 1.2rem;
            color: #666;
            margin-bottom: 20px;
        }

        .welcome-text {
            font-size: 1rem;
            color: #888;
            max-width: 600px;
            margin: 0 auto;
            line-height: 1.6;
        }

        /* Options Grid */
        .options-section {
            display: grid;
            grid-template-columns: repeat(auto-fit, minmax(250px, 1fr));
            gap: 25px;
        }

        .option-card {
            background: white;
            border-radius: 15px;
            padding: 40px;
            text-align: center;
            box-shadow: 0 10px 30px rgba(0,0,0,0.1);
            transition: all 0.3s cubic-bezier(0.175, 0.885, 0.32, 1.275);
            cursor: pointer;
            position: relative;
            overflow: hidden;
            animation: fadeIn 0.8s ease;
            text-decoration: none;
            display: flex;
            flex-direction: column;
            align-items: center;
            justify-content: center;
            min-height: 250px;
        }

        .option-card::before {
            content: '';
            position: absolute;
            top: 0;
            left: -100%;
            width: 100%;
            height: 100%;
            background: linear-gradient(90deg, transparent, rgba(255,255,255,0.3), transparent);
            transition: 0.5s;
        }

        .option-card:hover::before {
            left: 100%;
        }

        .option-card:hover {
            transform: translateY(-15px) scale(1.02);
            box-shadow: 0 20px 50px rgba(0,0,0,0.2);
        }

        .option-icon {
            font-size: 3.5rem;
            margin-bottom: 15px;
            transition: all 0.3s ease;
        }

        .option-card.browse .option-icon {
            color: #667eea;
        }

        .option-card.orders .option-icon {
            color: #f093fb;
        }

        .option-card.profile .option-icon {
            color: #4facfe;
        }

        .option-card.cart .option-icon {
            color: #43e97b;
        }

        .option-title {
            font-size: 1.5rem;
            font-weight: 700;
            color: #1a2a6c;
            margin-bottom: 10px;
            position: relative;
            z-index: 1;
        }

        .option-description {
            font-size: 0.95rem;
            color: #888;
            position: relative;
            z-index: 1;
        }

        /* Footer */
        .footer {
            text-align: center;
            padding: 20px;
            color: white;
            font-size: 0.9rem;
            background: rgba(26, 42, 108, 0.5);
        }

        /* Animations */
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

        /* Responsive Design */
        @media (max-width: 768px) {
            .navbar {
                padding: 15px 20px;
            }

            .nav-menu {
                gap: 15px;
            }

            .nav-brand {
                font-size: 1.5rem;
            }

            .welcome-section {
                padding: 30px 20px;
                margin-bottom: 30px;
            }

            .welcome-title {
                font-size: 2rem;
            }

            .welcome-icon {
                font-size: 3rem;
            }

            .options-section {
                grid-template-columns: repeat(auto-fit, minmax(200px, 1fr));
                gap: 15px;
            }

            .option-card {
                padding: 30px 20px;
                min-height: 200px;
            }

            .option-icon {
                font-size: 2.5rem;
            }

            .option-title {
                font-size: 1.2rem;
            }

            .option-description {
                font-size: 0.85rem;
            }
        }

        @media (max-width: 480px) {
            .options-section {
                grid-template-columns: 1fr;
            }

            .welcome-section {
                padding: 20px;
            }

            .welcome-title {
                font-size: 1.5rem;
            }

            .nav-menu {
                gap: 10px;
            }

            .nav-menu a span {
                display: none;
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
                <li><a href="Cart.jsp"><i class="fas fa-shopping-cart"></i> <span>Cart</span></a></li>
                <li><a href="BuyerProfile.jsp"><i class="fas fa-user-circle"></i> <span>Profile</span></a></li>
                <li><a href="Logout.jsp" class="logout-btn"><i class="fas fa-sign-out-alt"></i> <span>Logout</span></a></li>
            </ul>
        </div>
    </nav>

    <!-- Main Content -->
    <div class="main-content">
        <div class="dashboard-container">
            <!-- Welcome Section -->
            <div class="welcome-section">
                <div class="welcome-icon">
                    <i class="fas fa-smile-wink"></i>
                </div>
                <h1 class="welcome-title">Welcome back, <%= fname %>! 👋</h1>
                <p class="welcome-subtitle">Ready to discover fresh produce from local farmers?</p>
                <p class="welcome-text">
                    Browse through our collection of quality products directly from farmers. 
                    Support local agriculture while getting the freshest produce at the best prices.
                </p>
            </div>

            <!-- Options Grid -->
            <div class="options-section">
                <!-- Browse Products -->
                <a href="ViewTrades.jsp" class="option-card browse">
                    <div class="option-icon">
                        <i class="fas fa-store"></i>
                    </div>
                    <div class="option-title">Browse Products</div>
                    <div class="option-description">
                        Explore fresh products from verified farmers
                    </div>
                </a>

                <!-- My Orders -->
                <a href="MyOrders.jsp" class="option-card orders">
                    <div class="option-icon">
                        <i class="fas fa-box"></i>
                    </div>
                    <div class="option-title">My Orders</div>
                    <div class="option-description">
                        View your order history and track status
                    </div>
                </a>

                <!-- Shopping Cart -->
                <a href="Cart.jsp" class="option-card cart">
                    <div class="option-icon">
                        <i class="fas fa-shopping-cart"></i>
                    </div>
                    <div class="option-title">Shopping Cart</div>
                    <div class="option-description">
                        Review and manage your cart items
                    </div>
                </a>

                <!-- My Profile -->
                <a href="BuyerProfile.jsp" class="option-card profile">
                    <div class="option-icon">
                        <i class="fas fa-user-circle"></i>
                    </div>
                    <div class="option-title">My Profile</div>
                    <div class="option-description">
                        View and update your profile information
                    </div>
                </a>
            </div>
        </div>
    </div>

    <!-- Footer -->
    <div class="footer">
        <p>&copy; 2025 Kisan Mitra. Supporting local farmers and sustainable agriculture.</p>
    </div>

    <!-- SESSION CHECK SCRIPT -->
    <script>
        var sessionCheckInterval = setInterval(function() {
            fetch('CheckSession.jsp')
                .then(response => {
                    if (response.status === 401) {
                        clearInterval(sessionCheckInterval);
                        window.location.href = 'Login.jsp';
                    }
                })
                .catch(error => {
                    console.log('Session check error:', error);
                });
        }, 3000);
    </script>
</body>
</html>