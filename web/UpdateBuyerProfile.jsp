<%@ include file="SessionValidator.jsp" %>
<%@page import="db.DBConnector"%>
<%@page import="java.sql.Statement"%>
<%@page import="java.sql.ResultSet"%>
<%@page import="java.sql.SQLException"%>
<%@page import="java.sql.Connection"%>
<%@page import="java.sql.PreparedStatement"%>
<%@page contentType="text/html" pageEncoding="UTF-8"%>

<%
    response.setHeader("Cache-Control", "no-cache, no-store, must-revalidate");
    response.setHeader("Pragma", "no-cache");
    response.setDateHeader("Expires", 0);
    
    String emailSession = (String) session.getAttribute("email");
    if (emailSession == null) {
        response.sendRedirect("Login.jsp");
        return;
    }

    String fname = "", lname = "", gender = "", company = "";
    String mobile = "", email = "", street = "", city = "", state = "", pin = "", country = "", location = "";

    try {
        Connection conn = DBConnector.getConnection();
        String query = "SELECT fname, lname, gender, company, mobile, email, street, city, state, pin, country, location FROM buyerregistration WHERE email = ?";
        PreparedStatement ps = conn.prepareStatement(query);
        ps.setString(1, emailSession);
        ResultSet rs = ps.executeQuery();
        
        if (rs.next()) {
            fname = rs.getString("fname");
            lname = rs.getString("lname");
            gender = rs.getString("gender") != null ? rs.getString("gender") : "";
            company = rs.getString("company") != null ? rs.getString("company") : "";
            mobile = rs.getString("mobile");
            email = rs.getString("email");
            street = rs.getString("street") != null ? rs.getString("street") : "";
            city = rs.getString("city") != null ? rs.getString("city") : "";
            state = rs.getString("state") != null ? rs.getString("state") : "";
            pin = rs.getString("pin") != null ? rs.getString("pin") : "";
            country = rs.getString("country") != null ? rs.getString("country") : "";
            location = rs.getString("location") != null ? rs.getString("location") : "";
        }
        ps.close();
        conn.close();
    } catch (SQLException e) {
        e.printStackTrace();
    }
%>

<!DOCTYPE html>
<html lang="en">
<head>
    <meta charset="UTF-8" />
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <meta http-equiv="Cache-Control" content="no-cache, no-store, must-revalidate" />
    <meta http-equiv="Pragma" content="no-cache" />
    <meta http-equiv="Expires" content="0" />
    
    <title>Update Buyer Profile - Kisan Mitra</title>
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
            padding: 40px 20px;
        }

        .container {
            max-width: 900px;
            margin: 0 auto;
            background: white;
            border-radius: 15px;
            box-shadow: 0 10px 40px rgba(0,0,0,0.2);
            overflow: hidden;
            animation: slideUp 0.8s ease;
        }

        .header {
            background: linear-gradient(135deg, #1a2a6c, #b21f1f);
            color: white;
            padding: 30px;
            text-align: center;
        }

        .header h2 {
            font-size: 2rem;
            margin-bottom: 10px;
            display: flex;
            align-items: center;
            justify-content: center;
            gap: 15px;
        }

        .header p {
            opacity: 0.9;
            font-size: 1rem;
        }

        .form-container {
            padding: 40px;
        }

        .form-row {
            display: grid;
            grid-template-columns: repeat(auto-fit, minmax(300px, 1fr));
            gap: 20px;
            margin-bottom: 25px;
        }

        .form-group {
            display: flex;
            flex-direction: column;
        }

        label {
            font-weight: 600;
            color: #333;
            margin-bottom: 8px;
            display: flex;
            align-items: center;
            gap: 8px;
        }

        label i {
            color: #2e7d32;
            font-size: 1.1rem;
        }

        input[type="text"],
        input[type="email"],
        input[type="tel"],
        input[type="number"],
        select {
            padding: 12px 15px;
            border: 2px solid #e0e0e0;
            border-radius: 8px;
            font-size: 1rem;
            transition: all 0.3s ease;
            background: #fafafa;
        }

        input[type="text"]:focus,
        input[type="email"]:focus,
        input[type="tel"]:focus,
        input[type="number"]:focus,
        select:focus {
            outline: none;
            border-color: #2e7d32;
            background: white;
            box-shadow: 0 0 0 3px rgba(46, 125, 50, 0.1);
        }

        input[readonly] {
            background: #f5f5f5;
            cursor: not-allowed;
            color: #999;
        }

        select {
            cursor: pointer;
            appearance: none;
            background-image: url("data:image/svg+xml,%3Csvg xmlns='http://www.w3.org/2000/svg' width='12' height='12' viewBox='0 0 12 12'%3E%3Cpath fill='%23333' d='M6 9L1 4h10z'/%3E%3C/svg%3E");
            background-repeat: no-repeat;
            background-position: right 15px center;
            padding-right: 40px;
        }

        .section-title {
            font-size: 1.3rem;
            color: #1a2a6c;
            margin-top: 30px;
            margin-bottom: 20px;
            padding-bottom: 10px;
            border-bottom: 2px solid #e65c00;
            display: flex;
            align-items: center;
            gap: 10px;
        }

        .section-title i {
            color: #e65c00;
            font-size: 1.5rem;
        }

        .action-buttons {
            display: grid;
            grid-template-columns: repeat(auto-fit, minmax(200px, 1fr));
            gap: 15px;
            margin-top: 40px;
            padding-top: 20px;
            border-top: 1px solid #e0e0e0;
        }

        button {
            padding: 13px 25px;
            border: none;
            border-radius: 8px;
            font-weight: 600;
            font-size: 1rem;
            cursor: pointer;
            transition: all 0.3s ease;
            display: flex;
            align-items: center;
            justify-content: center;
            gap: 10px;
        }

        .btn-submit {
            background: linear-gradient(90deg, #2e7d32, #6BBF59);
            color: white;
        }

        .btn-submit:hover {
            transform: translateY(-2px);
            box-shadow: 0 8px 20px rgba(46, 125, 50, 0.3);
        }

        .btn-cancel {
            background: #e0e0e0;
            color: #333;
        }

        .btn-cancel:hover {
            background: #d0d0d0;
            transform: translateY(-2px);
        }

        .alert {
            padding: 15px 20px;
            border-radius: 8px;
            margin-bottom: 20px;
            display: none;
        }

        .alert.success {
            background: #d4edda;
            color: #155724;
            border: 1px solid #c3e6cb;
            display: block;
        }

        .alert.error {
            background: #f8d7da;
            color: #721c24;
            border: 1px solid #f5c6cb;
            display: block;
        }

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

        @media (max-width: 768px) {
            .form-row {
                grid-template-columns: 1fr;
            }

            .form-container {
                padding: 25px;
            }

            .header h2 {
                font-size: 1.5rem;
            }

            .action-buttons {
                grid-template-columns: 1fr;
            }
        }

        /* SESSION CHECK SCRIPT */
        .session-check {
            display: none;
        }
    </style>
</head>
<body>
    <div class="container">
        <div class="header">
            <h2>
                <i class="fas fa-user-edit"></i> Update Your Profile
            </h2>
            <p>Keep your information up to date</p>
        </div>

        <div class="form-container">
            <form action="UpdateBuyerProfile" method="post">
                <!-- Personal Information Section -->
                <div class="section-title">
                    <i class="fas fa-user"></i> Personal Information
                </div>

                <div class="form-row">
                    <div class="form-group">
                        <label for="first-name">
                            <i class="fas fa-user"></i> First Name
                        </label>
                        <input type="text" id="first-name" name="first-name" value="<%= fname %>" required>
                    </div>
                    <div class="form-group">
                        <label for="last-name">
                            <i class="fas fa-user"></i> Last Name
                        </label>
                        <input type="text" id="last-name" name="last-name" value="<%= lname %>" required>
                    </div>
                </div>

                <div class="form-row">
                    <div class="form-group">
                        <label for="gender">
                            <i class="fas fa-venus-mars"></i> Gender
                        </label>
                        <select id="gender" name="gender" required>
                            <option value="">-- Select --</option>
                            <option value="Male" <%= "Male".equals(gender) ? "selected" : "" %>>Male</option>
                            <option value="Female" <%= "Female".equals(gender) ? "selected" : "" %>>Female</option>
                            <option value="Other" <%= "Other".equals(gender) ? "selected" : "" %>>Other</option>
                        </select>
                    </div>
                    <div class="form-group">
                        <label for="company">
                            <i class="fas fa-building"></i> Company
                        </label>
                        <input type="text" id="company" name="company" value="<%= company %>">
                    </div>
                </div>

                <!-- Contact Information Section -->
                <div class="section-title">
                    <i class="fas fa-phone"></i> Contact Information
                </div>

                <div class="form-row">
                    <div class="form-group">
                        <label for="email">
                            <i class="fas fa-envelope"></i> Email (Cannot Change)
                        </label>
                        <input type="email" id="email" name="email" value="<%= email %>" readonly>
                    </div>
                    <div class="form-group">
                        <label for="mobile">
                            <i class="fas fa-mobile-alt"></i> Mobile Number
                        </label>
                        <input type="tel" id="mobile" name="mobile" value="<%= mobile %>" required>
                    </div>
                </div>

                <!-- Address Information Section -->
                <div class="section-title">
                    <i class="fas fa-map-marker-alt"></i> Address Information
                </div>

                <div class="form-row">
                    <div class="form-group">
                        <label for="street">
                            <i class="fas fa-road"></i> Street Address
                        </label>
                        <input type="text" id="street" name="street" value="<%= street %>" required>
                    </div>
                    <div class="form-group">
                        <label for="city">
                            <i class="fas fa-city"></i> City
                        </label>
                        <input type="text" id="city" name="city" value="<%= city %>" required>
                    </div>
                </div>

                <div class="form-row">
                    <div class="form-group">
                        <label for="state">
                            <i class="fas fa-flag"></i> State
                        </label>
                        <input type="text" id="state" name="state" value="<%= state %>" required>
                    </div>
                    <div class="form-group">
                        <label for="postal">
                            <i class="fas fa-mailbox"></i> Postal Code
                        </label>
                        <input type="text" id="postal" name="postal" value="<%= pin %>" required>
                    </div>
                </div>

                <div class="form-row">
                    <div class="form-group">
                        <label for="country">
                            <i class="fas fa-globe"></i> Country
                        </label>
                        <input type="text" id="country" name="country" value="<%= country %>" required>
                    </div>
                </div>

                <!-- Preference Section -->
                <div class="section-title">
                    <i class="fas fa-compass"></i> Shopping Preferences
                </div>

                <div class="form-row">
                    <div class="form-group">
                        <label for="location">
                            <i class="fas fa-search-location"></i> Preferred Location (For Product Search)
                        </label>
                        <input type="text" id="location" name="location" 
                               placeholder="e.g. Maharashtra, Gujarat, Punjab" 
                               value="<%= location %>">
                    </div>
                </div>

                <!-- Action Buttons -->
                <div class="action-buttons">
                    <button type="submit" class="btn-submit">
                        <i class="fas fa-save"></i> Update Profile
                    </button>
                    <button type="button" class="btn-cancel" onclick="window.location.href='BuyerProfile.jsp';">
                        <i class="fas fa-times-circle"></i> Cancel
                    </button>
                </div>
            </form>
        </div>
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
                });
        }, 3000);
    </script>
</body>
</html>