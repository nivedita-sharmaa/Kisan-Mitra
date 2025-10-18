<%@ include file="SessionValidator.jsp" %>
<%@page import="db.DBConnector"%>
<%@page import="java.sql.*" %>
<%@page contentType="text/html" pageEncoding="UTF-8"%>

<%
    response.setHeader("Cache-Control", "no-cache, no-store, must-revalidate");
    response.setHeader("Pragma", "no-cache");
    response.setDateHeader("Expires", 0);

    String farmerEmail = (String) session.getAttribute("email");
    if (farmerEmail == null || farmerEmail.isEmpty()) {
        response.sendRedirect("Login.jsp");
        return;
    }

    String fname = "", lname = "", gender = "", cropgrown = "";
    String farmsize = "", mobile = "", email = "", street = "", city = "", state = "", pin = "", country = "";

    try {
        Connection conn = DBConnector.getConnection();
        String query = "SELECT fname, lname, gender, cropgrown, farmsize, mobile, email, street, city, state, pin, country FROM farmerregistration WHERE email = ?";
        PreparedStatement ps = conn.prepareStatement(query);
        ps.setString(1, farmerEmail);
        ResultSet rs = ps.executeQuery();

        if (rs.next()) {
            fname = rs.getString("fname");
            lname = rs.getString("lname");
            gender = rs.getString("gender");
            cropgrown = rs.getString("cropgrown");
            farmsize = rs.getString("farmsize");
            mobile = rs.getString("mobile");
            email = rs.getString("email");
            street = rs.getString("street");
            city = rs.getString("city");
            state = rs.getString("state");
            pin = rs.getString("pin");
            country = rs.getString("country");
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
    <title>My Profile - Kisan Mitra</title>
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

/*        .header-content {
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
        }*/

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
        .main-content {
            max-width: 1400px;
            margin: 0 auto;
            padding: 40px 30px;
        }

        .profile-container {
            background: white;
            border-radius: 20px;
            overflow: hidden;
            box-shadow: 0 10px 40px rgba(0,0,0,0.2);
            animation: slideUp 0.6s ease-out;
        }

        /* Profile Header */
        .profile-header {
            background: linear-gradient(135deg, #667eea 0%, #764ba2 100%);
            color: white;
            padding: 50px 30px;
            text-align: center;
            position: relative;
            overflow: hidden;
        }

        .profile-header::before {
            content: '';
            position: absolute;
            top: 0;
            left: 0;
            right: 0;
            bottom: 0;
            background: url('data:image/svg+xml,<svg xmlns="http://www.w3.org/2000/svg" viewBox="0 0 1440 320"><path fill="rgba(255,255,255,0.05)" d="M0,96L48,112C96,128,192,160,288,186.7C384,213,480,235,576,224C672,213,768,171,864,165.3C960,160,1056,192,1152,202.7C1248,213,1344,203,1392,197.3L1440,192L1440,320L1392,320C1344,320,1248,320,1152,320C1056,320,960,320,864,320C768,320,672,320,576,320C480,320,384,320,288,320C192,320,96,320,48,320L0,320Z"></path></svg>');
            background-repeat: no-repeat;
            background-size: cover;
        }

        .profile-avatar {
            font-size: 5rem;
            margin-bottom: 20px;
            position: relative;
            z-index: 1;
            animation: bounce 0.8s ease-out;
        }

        .profile-name {
            font-size: 2rem;
            font-weight: 700;
            margin-bottom: 8px;
            position: relative;
            z-index: 1;
        }

        .profile-email {
            font-size: 1rem;
            opacity: 0.95;
            position: relative;
            z-index: 1;
        }

        /* Profile Content */
        .profile-content {
            padding: 50px;
        }

        .section {
            margin-bottom: 45px;
        }

        .section:last-child {
            margin-bottom: 0;
        }

        .section-title {
            font-size: 1.3rem;
            font-weight: 700;
            color: #2d3436;
            margin-bottom: 25px;
            padding-bottom: 15px;
            border-bottom: 3px solid #667eea;
            display: flex;
            align-items: center;
            gap: 12px;
        }

        .section-title i {
            color: #667eea;
            font-size: 1.5rem;
        }

        .info-grid {
            display: grid;
            grid-template-columns: repeat(auto-fit, minmax(250px, 1fr));
            gap: 20px;
        }

        .info-card {
            background: linear-gradient(135deg, #f5f7fa 0%, #c3cfe2 100%);
            padding: 20px;
            border-radius: 12px;
            border-left: 4px solid #667eea;
            transition: all 0.3s ease;
        }

        .info-card:hover {
            transform: translateY(-5px);
            box-shadow: 0 8px 25px rgba(0,0,0,0.1);
            border-left-color: #764ba2;
        }

        .info-label {
            font-size: 0.8rem;
            font-weight: 700;
            color: #667eea;
            text-transform: uppercase;
            letter-spacing: 1px;
            margin-bottom: 8px;
        }

        .info-value {
            font-size: 1.1rem;
            color: #2d3436;
            font-weight: 600;
        }

        /* Action Buttons */
        .action-section {
            display: flex;
            gap: 15px;
            margin-top: 50px;
            padding-top: 30px;
            border-top: 2px solid #f1f3f5;
        }

        .btn {
            flex: 1;
            padding: 15px 30px;
            border: none;
            border-radius: 12px;
            font-weight: 700;
            font-size: 1rem;
            cursor: pointer;
            transition: all 0.3s ease;
            text-decoration: none;
            display: inline-flex;
            align-items: center;
            justify-content: center;
            gap: 12px;
        }

        .btn-edit {
            background: linear-gradient(135deg, #667eea 0%, #764ba2 100%);
            color: white;
            box-shadow: 0 4px 15px rgba(102, 126, 234, 0.3);
        }

        .btn-edit:hover {
            transform: translateY(-3px);
            box-shadow: 0 6px 25px rgba(102, 126, 234, 0.5);
        }

        .btn-back {
            background: white;
            color: #667eea;
            border: 2px solid #667eea;
            box-shadow: 0 4px 15px rgba(0,0,0,0.1);
        }

        .btn-back:hover {
            background: #f5f7fa;
            transform: translateY(-3px);
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

        @keyframes bounce {
            0% {
                transform: scale(0.8);
                opacity: 0;
            }
            50% {
                transform: scale(1.05);
            }
            100% {
                transform: scale(1);
                opacity: 1;
            }
        }

        /* Responsive */
        @media (max-width: 768px) {
            .header-content {
                flex-direction: column;
                gap: 15px;
            }

            .nav-links {
                flex-wrap: wrap;
                gap: 10px;
                justify-content: center;
            }

            .profile-header {
                padding: 40px 20px;
            }

            .profile-header::before {
                display: none;
            }

            .profile-avatar {
                font-size: 3.5rem;
            }

            .profile-name {
                font-size: 1.5rem;
            }

            .profile-content {
                padding: 30px 20px;
            }

            .info-grid {
                grid-template-columns: 1fr;
            }

            .action-section {
                flex-direction: column;
                gap: 10px;
            }

            .btn {
                width: 100%;
            }

            .section-title {
                font-size: 1.1rem;
            }
        }

        @media (max-width: 480px) {
            .main-content {
                padding: 20px 15px;
            }

            .profile-content {
                padding: 20px 15px;
            }

            .info-card {
                padding: 15px;
            }

            .section-title {
                font-size: 1rem;
                gap: 8px;
            }

            .section-title i {
                font-size: 1.2rem;
            }
        }
    </style>
</head>
<body>
<!--     Header 
    <div class="header">
        <div class="header-content">
            <div class="logo">
                <i class="fas fa-leaf"></i>
                Kisan Mitra
            </div>-->
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
                <li><a href="FarmerSales.jsp" class="active"><i class="fas fa-dollar-sign"></i> <span>Sales</span></a></li>
                 <li><a href="Logout.jsp" class="logout-btn"><i class="fas fa-sign-out-alt"></i> <span>Logout</span></a></li>
            </ul>
        </div>
    </nav>
        </div>
    </div>

    <!-- Main Content -->
    <div class="main-content">
        <div class="profile-container">
            <!-- Profile Header -->
            <div class="profile-header">
                <div class="profile-avatar">
                    <i class="fas fa-user-circle"></i>
                </div>
                <div class="profile-name"><%= fname %> <%= lname %></div>
                <div class="profile-email"><%= email %></div>
            </div>

            <!-- Profile Content -->
            <div class="profile-content">
                <!-- Personal Information -->
                <div class="section">
                    <div class="section-title">
                        <i class="fas fa-user"></i>
                        Personal Information
                    </div>
                    <div class="info-grid">
                        <div class="info-card">
                            <div class="info-label">First Name</div>
                            <div class="info-value"><%= fname %></div>
                        </div>
                        <div class="info-card">
                            <div class="info-label">Last Name</div>
                            <div class="info-value"><%= lname %></div>
                        </div>
                        <div class="info-card">
                            <div class="info-label">Gender</div>
                            <div class="info-value"><%= gender %></div>
                        </div>
                        <div class="info-card">
                            <div class="info-label">Crop Grown</div>
                            <div class="info-value"><%= cropgrown %></div>
                        </div>
                        <div class="info-card">
                            <div class="info-label">Farm Size</div>
                            <div class="info-value"><%= farmsize %></div>
                        </div>
                    </div>
                </div>

                <!-- Contact Information -->
                <div class="section">
                    <div class="section-title">
                        <i class="fas fa-phone"></i>
                        Contact Information
                    </div>
                    <div class="info-grid">
                        <div class="info-card">
                            <div class="info-label">Email</div>
                            <div class="info-value"><%= email %></div>
                        </div>
                        <div class="info-card">
                            <div class="info-label">Mobile</div>
                            <div class="info-value"><%= mobile %></div>
                        </div>
                    </div>
                </div>

                <!-- Address Information -->
                <div class="section">
                    <div class="section-title">
                        <i class="fas fa-map-marker-alt"></i>
                        Address Information
                    </div>
                    <div class="info-grid">
                        <div class="info-card">
                            <div class="info-label">Street</div>
                            <div class="info-value"><%= street %></div>
                        </div>
                        <div class="info-card">
                            <div class="info-label">City</div>
                            <div class="info-value"><%= city %></div>
                        </div>
                        <div class="info-card">
                            <div class="info-label">State</div>
                            <div class="info-value"><%= state %></div>
                        </div>
                        <div class="info-card">
                            <div class="info-label">Pin Code</div>
                            <div class="info-value"><%= pin %></div>
                        </div>
                        <div class="info-card">
                            <div class="info-label">Country</div>
                            <div class="info-value"><%= country %></div>
                        </div>
                    </div>
                </div>

                <!-- Action Buttons -->
                <div class="action-section">
                    <a href="UpdateFarmerProfile.jsp" class="btn btn-edit">
                        <i class="fas fa-edit"></i>
                        Edit Profile
                    </a>
                    <a href="FarmerDashboard.jsp" class="btn btn-back">
                        <i class="fas fa-arrow-left"></i>
                        Back to Dashboard
                    </a>
                </div>
            </div>
        </div>
    </div>

    <script>
        // Set active navigation
        document.addEventListener('DOMContentLoaded', function() {
            const currentPage = window.location.pathname.split('/').pop();
            document.querySelectorAll('.nav-item').forEach(link => {
                link.classList.remove('active');
            });
            if (currentPage === 'Profile.jsp' || currentPage === 'FarmerProfile.jsp') {
                document.querySelectorAll('.nav-item').forEach(link => {
                    if (link.href.includes('Profile.jsp')) {
                        link.classList.add('active');
                    }
                });
            }
        });
    </script>
</body>
</html>