<%@ include file="SessionValidator.jsp" %>
<%@page import="db.DBConnector"%>
<%@page import="java.sql.*" %>
<% 
    response.setHeader("Cache-Control", "no-cache, no-store, must-revalidate");
    response.setHeader("Pragma", "no-cache");
    response.setDateHeader("Expires", 0);
%>
<%@page contentType="text/html" pageEncoding="UTF-8"%>

<%
    String fname = "", lname = "";
    String email = (String) session.getAttribute("email");

    try {
        Connection conn = DBConnector.getConnection();
        String query = "SELECT fname, lname FROM farmerregistration WHERE email = ?";
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
    <title>Farmer Dashboard - Kisan Mitra</title>
    <link href="https://fonts.googleapis.com/css2?family=Poppins:wght@400;600;700&display=swap" rel="stylesheet">
    <link href="https://cdnjs.cloudflare.com/ajax/libs/font-awesome/6.0.0-beta3/css/all.min.css" rel="stylesheet">

    <style>
        * { margin: 0; padding: 0; box-sizing: border-box; font-family: 'Poppins', sans-serif; }

        body {
            background: linear-gradient(135deg, #667eea 0%, #764ba2 100%);
            min-height: 100vh;
            display: flex;
            flex-direction: column;
        }

        /* Navbar */
        .navbar {
            background: rgba(26, 42, 108, 0.95);
            padding: 15px 30px;
            position: sticky;
            top: 0;
            z-index: 1000;
            box-shadow: 0 2px 15px rgba(0,0,0,0.2);
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
            list-style: none;
            display: flex;
            gap: 25px;
            align-items: center;
        }
        .nav-menu a {
            color: white;
            text-decoration: none;
            font-weight: 500;
            transition: 0.3s;
            display: flex;
            align-items: center;
            gap: 8px;
        }
        .nav-menu a:hover {
            color: #ffd700;
            transform: translateY(-2px);
        }
        .sales .option-icon { color: #2ecc71; }
        
        .logout-btn {
            background: #f44336;
            padding: 8px 16px;
            border-radius: 20px;
        }
        .logout-btn:hover {
            background: #d32f2f;
            transform: scale(1.05);
        }

        /* Main Layout */
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
            text-align: center;
            animation: slideUp 0.8s ease;
        }
        .welcome-icon { font-size: 4rem; color: #667eea; margin-bottom: 20px; }
        .welcome-title { font-size: 2.5rem; color: #1a2a6c; font-weight: 700; }
        .welcome-subtitle { color: #666; font-size: 1.1rem; margin-top: 10px; }
        .welcome-text { color: #888; font-size: 1rem; margin-top: 15px; line-height: 1.6; }

        /* Options */
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
            transition: 0.3s;
            text-decoration: none;
            color: inherit;
        }
        .option-card:hover {
            transform: translateY(-10px);
            box-shadow: 0 20px 40px rgba(0,0,0,0.2);
        }
        .option-icon { font-size: 3.5rem; margin-bottom: 15px; }
        .option-title { font-size: 1.5rem; font-weight: 700; color: #1a2a6c; }
        .option-description { color: #888; font-size: 0.95rem; }

        .upload .option-icon { color: #43e97b; }
        .profile .option-icon { color: #4facfe; }
        .trades .option-icon { color: #f093fb; }
        .update .option-icon { color: #ffd700; }

        .footer {
            text-align: center;
            padding: 20px;
            color: white;
            font-size: 0.9rem;
            background: rgba(26, 42, 108, 0.5);
        }

        @keyframes slideUp {
            from {opacity: 0; transform: translateY(30px);}
            to {opacity: 1; transform: translateY(0);}
        }
    </style>
</head>
<body>

    <!-- Navbar -->
    <nav class="navbar">
        <div class="nav-container">
            <a href="FarmerDashboard.jsp" class="nav-brand"><i class="fas fa-leaf"></i> Kisan Mitra</a>
            <ul class="nav-menu">
<!--                <li><a href="Home.html"><i class="fas fa-upload"></i> <span>Home</span></a></li>-->
                <li><a href="UploadTrade.jsp"><i class="fas fa-upload"></i> <span>Upload Trade</span></a></li>
                <li><a href="ShowTrades.jsp"><i class="fas fa-chart-line"></i> <span>My Trades</span></a></li>
                <li><a href="FarmerSales.jsp"><i class="fas fa-dollar-sign"></i> <span>Sales</span></a></li>
                <li><a href="FarmerProfile.jsp"><i class="fas fa-user-circle"></i> <span>Profile</span></a></li>
                <li><a href="Logout.jsp" class="logout-btn"><i class="fas fa-sign-out-alt"></i> <span>Logout</span></a></li>
            </ul>
        </div>
    </nav>

    <!-- Main Dashboard -->
    <div class="main-content">
        <div class="dashboard-container">
            <div class="welcome-section">
                <div class="welcome-icon"><i class="fas fa-smile-wink"></i></div>
                <h1 class="welcome-title">Welcome back, <%= fname %>! 👋</h1>
                <p class="welcome-subtitle">Ready to manage your trades and connect with buyers?</p>
                <p class="welcome-text">Use Kisan Mitra to upload your latest produce, manage your listings, and keep your profile updated for better buyer connections.</p>
            </div>

            <div class="options-section">
                <a href="UploadTrade.jsp" class="option-card upload">
                    <div class="option-icon"><i class="fas fa-upload"></i></div>
                    <div class="option-title">Upload Trade</div>
                    <div class="option-description">List your fresh produce for buyers</div>
                </a>

                <a href="ShowTrades.jsp" class="option-card trades">
                    <div class="option-icon"><i class="fas fa-chart-line"></i></div>
                    <div class="option-title">My Trades</div>
                    <div class="option-description">View and manage your uploaded trades</div>
                </a>

                <a href="FarmerSales.jsp" class="option-card sales">
                <div class="option-icon"><i class="fas fa-dollar-sign"></i></div>
                <div class="option-title">My Sales</div>
                <div class="option-description">View your orders and revenue</div>
                </a>
                
                <a href="FarmerProfile.jsp" class="option-card profile">
                    <div class="option-icon"><i class="fas fa-user-circle"></i></div>
                    <div class="option-title">My Profile</div>
                    <div class="option-description">View your farmer details and info</div>
                </a>
            </div>
        </div>
    </div>

    <div class="footer">
        <p>&copy; 2025 Kisan Mitra. Empowering farmers through technology.</p>
    </div>

    <!-- SESSION CHECK -->
    <script>
        var sessionCheckInterval = setInterval(function() {
            fetch('CheckSession.jsp').then(response => {
                if (response.status === 401) {
                    clearInterval(sessionCheckInterval);
                    window.location.href = 'Login.jsp';
                }
            }).catch(console.error);
        }, 3000);
    </script>

</body>
</html>
