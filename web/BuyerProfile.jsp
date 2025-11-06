<%@ include file="SessionValidator.jsp" %>
<%@page import="db.DBConnector"%>
<%@page import="java.sql.*" %>
<%@page contentType="text/html" pageEncoding="UTF-8"%>

<%
    response.setHeader("Cache-Control", "no-cache, no-store, must-revalidate");
    response.setHeader("Pragma", "no-cache");
    response.setDateHeader("Expires", 0);
    
    String buyerEmail = (String) session.getAttribute("email");
    if (buyerEmail == null || buyerEmail.isEmpty()) {
        response.sendRedirect("Login.jsp");
        return;
    }
    
    String fname = "", lname = "", gender = "";
    String mobile = "", email = "", street = "", city = "", state = "", pin = "", country = "", location = "";

    try {
        Connection conn = DBConnector.getConnection();
        String query = "SELECT fname, lname, gender, mobile, email, street, city, state, pin, country, location FROM buyerregistration WHERE email = ?";
        PreparedStatement ps = conn.prepareStatement(query);
        ps.setString(1, buyerEmail);
        ResultSet rs = ps.executeQuery();
        
        if (rs.next()) {
            fname = rs.getString("fname");
            lname = rs.getString("lname");
            gender = rs.getString("gender");
//            company = rs.getString("company");
            mobile = rs.getString("mobile");
            email = rs.getString("email");
            street = rs.getString("street");
            city = rs.getString("city");
            state = rs.getString("state");
            pin = rs.getString("pin");
            country = rs.getString("country");
            location = rs.getString("location");
        }
        ps.close();
        conn.close();
    } catch (SQLException e) {
        System.out.println(e);
    }
%>

<!DOCTYPE html>
<html>
    <head>
        <meta http-equiv="Content-Type" content="text/html; charset=UTF-8">
        <meta name="viewport" content="width=device-width, initial-scale=1.0">
        <meta http-equiv="Cache-Control" content="no-cache, no-store, must-revalidate" />
        <meta http-equiv="Pragma" content="no-cache" />
        <meta http-equiv="Expires" content="0" />
        
        <title>Buyer Profile</title>
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

            /* Main Content */
            .main-content {
                flex: 1;
                padding: 40px 20px;
            }
            
            .container {
                width: 90%;
                max-width: 1000px;
                margin: 0 auto;
                background: #fff;
                box-shadow: 0 10px 40px rgba(0, 0, 0, 0.2);
                border-radius: 20px;
                overflow: hidden;
                animation: slideUp 0.8s ease;
            }
            
            .profile-header {
                background: linear-gradient(135deg, #667eea, #764ba2);
                color: white;
                padding: 50px 30px;
                text-align: center;
            }
            
            .profile-header h1 {
                margin: 0 0 10px 0;
                font-size: 2.5rem;
                font-weight: 700;
            }
            
            .profile-header p {
                margin: 0;
                font-size: 1.2rem;
                opacity: 0.95;
            }
            
            .profile-icon {
                font-size: 4.5rem;
                margin-bottom: 20px;
            }
            
            .profile-content {
                padding: 50px;
            }
            
            .info-section {
                margin-bottom: 40px;
            }
            
            .section-title {
                color: #1a2a6c;
                font-size: 1.4rem;
                font-weight: 600;
                margin-bottom: 25px;
                padding-bottom: 12px;
                border-bottom: 3px solid #667eea;
                display: flex;
                align-items: center;
                gap: 12px;
            }
            
            .info-grid {
                display: grid;
                grid-template-columns: repeat(auto-fit, minmax(280px, 1fr));
                gap: 25px;
            }
            
            .info-item {
                background: #f8f9fa;
                padding: 20px;
                border-radius: 12px;
                border-left: 4px solid #667eea;
                transition: all 0.3s ease;
            }

            .info-item:hover {
                transform: translateY(-3px);
                box-shadow: 0 5px 15px rgba(0,0,0,0.1);
            }
            
            .info-label {
                font-weight: 600;
                color: #666;
                font-size: 0.9rem;
                margin-bottom: 8px;
                text-transform: uppercase;
                letter-spacing: 0.5px;
            }
            
            .info-value {
                color: #333;
                font-size: 1.05rem;
                font-weight: 500;
            }
            
            .action-buttons {
                display: flex;
                gap: 20px;
                margin-top: 40px;
            }
            
            .btn {
                flex: 1;
                padding: 15px 25px;
                border: none;
                border-radius: 12px;
                font-weight: 600;
                font-size: 1rem;
                cursor: pointer;
                transition: all 0.3s ease;
                text-decoration: none;
                display: inline-flex;
                align-items: center;
                justify-content: center;
                gap: 10px;
            }
            
            .btn-edit {
                background: linear-gradient(135deg, #667eea, #764ba2);
                color: white;
            }
            
            .btn-edit:hover {
                transform: translateY(-3px);
                box-shadow: 0 10px 25px rgba(102, 126, 234, 0.4);
            }
            
            .btn-back {
                background: linear-gradient(135deg, #f093fb, #f5576c);
                color: white;
            }
            
            .btn-back:hover {
                transform: translateY(-3px);
                box-shadow: 0 10px 25px rgba(240, 147, 251, 0.4);
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

                .container {
                    width: 95%;
                }

                .profile-header {
                    padding: 40px 20px;
                }

                .profile-header h1 {
                    font-size: 2rem;
                }

                .profile-icon {
                    font-size: 3.5rem;
                }

                .profile-content {
                    padding: 30px 20px;
                }

                .info-grid {
                    grid-template-columns: 1fr;
                    gap: 15px;
                }

                .action-buttons {
                    flex-direction: column;
                }

                .btn {
                    width: 100%;
                }
            }

            @media (max-width: 480px) {
                .nav-menu {
                    gap: 10px;
                }

                .nav-menu a span {
                    display: none;
                }

                .profile-header h1 {
                    font-size: 1.5rem;
                }

                .section-title {
                    font-size: 1.2rem;
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
        
        <!-- SESSION CHECK SCRIPT -->
        <script>
            var sessionCheckInterval = setInterval(function() {
                fetch('CheckSession.jsp')
                    .then(response => {
                        if (response.status === 401) {
                            clearInterval(sessionCheckInterval);
                            window.location.href = 'Login.jsp';
                        }
                    });
            }, 3000);
        </script>
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
            <div class="container">
                <div class="profile-header">
                    <div class="profile-icon">
                        <i class="fas fa-user-circle"></i>
                    </div>
                    <h1>Welcome, <%= fname %>! 👋</h1>
                    <p>Your Buyer Profile</p>
                </div>
                
                <div class="profile-content">
                    <div class="info-section">
                        <div class="section-title">
                            <i class="fas fa-user"></i> Personal Information
                        </div>
                        <div class="info-grid">
                            <div class="info-item">
                                <div class="info-label">First Name</div>
                                <div class="info-value"><%= fname %></div>
                            </div>
                            <div class="info-item">
                                <div class="info-label">Last Name</div>
                                <div class="info-value"><%= lname %></div>
                            </div>
                            <div class="info-item">
                                <div class="info-label">Gender</div>
                                <div class="info-value"><%= gender %></div>
                            </div>
<!--                            <div class="info-item">
                                <div class="info-label">Company</div>
                                <div class="info-value"></div>
                            </div>-->
                        </div>
                    </div>
                    
                    <div class="info-section">
                        <div class="section-title">
                            <i class="fas fa-phone"></i> Contact Information
                        </div>
                        <div class="info-grid">
                            <div class="info-item">
                                <div class="info-label">Email</div>
                                <div class="info-value"><%= email %></div>
                            </div>
                            <div class="info-item">
                                <div class="info-label">Mobile</div>
                                <div class="info-value"><%= mobile %></div>
                            </div>
                        </div>
                    </div>
                    
                    <div class="info-section">
                        <div class="section-title">
                            <i class="fas fa-map-marker-alt"></i> Address Information
                        </div>
                        <div class="info-grid">
                            <div class="info-item">
                                <div class="info-label">Street</div>
                                <div class="info-value"><%= street %></div>
                            </div>
                            <div class="info-item">
                                <div class="info-label">City</div>
                                <div class="info-value"><%= city %></div>
                            </div>
                            <div class="info-item">
                                <div class="info-label">State</div>
                                <div class="info-value"><%= state %></div>
                            </div>
                            <div class="info-item">
                                <div class="info-label">Postal Code</div>
                                <div class="info-value"><%= pin %></div>
                            </div>
                            <div class="info-item">
                                <div class="info-label">Country</div>
                                <div class="info-value"><%= country %></div>
                            </div>
                            <div class="info-item">
                                <div class="info-label">Preferred Location</div>
                                <div class="info-value"><%= location.isEmpty() ? "Not set" : location %></div>
                            </div>
                        </div>
                    </div>
                    
                    <div class="action-buttons">
                        <a href="UpdateBuyerProfile.jsp" class="btn btn-edit">
                            <i class="fas fa-edit"></i> Edit Profile
                        </a>
                        <a href="BuyerDashboard.jsp" class="btn btn-back">
                            <i class="fas fa-arrow-left"></i> Back to Dashboard
                        </a>
                    </div>
                </div>
            </div>
        </div>
         <div class="footer">
        <p>&copy; 2025 Kisan Mitra. Empowering farmers through technology.</p>
    </div>
    </body>
</html>