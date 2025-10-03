<%@page import="db.DBConnector"%>
<%@page import="java.sql.Statement"%>
<%@page import="java.sql.ResultSet"%>
<%@page import="java.sql.SQLException"%>
<%@page contentType="text/html" pageEncoding="UTF-8"%>
<%
    String emailSession = (String) session.getAttribute("email");
    if (emailSession == null) {
        response.sendRedirect("login.jsp");
        return;
    }

    String fname = "", lname = "", gender = "", company = "";
    String mobile = "", email = "", street = "", city = "", state = "", pin = "", country = "";

    try {
        Statement st = DBConnector.getStatement();
        String query = "SELECT * FROM buyerregistration WHERE email='" + emailSession + "'";
        ResultSet rs = st.executeQuery(query);
        if (rs.next()) {
            fname = rs.getString("fname");
            lname = rs.getString("lname");
            gender = rs.getString("gender");
            company = rs.getString("company");
            mobile = rs.getString("mobile");
            email = rs.getString("email");
            street = rs.getString("street");
            city = rs.getString("city");
            state = rs.getString("state");
            pin = rs.getString("pin");
            country = rs.getString("country");
        }
    } catch (SQLException e) {
        e.printStackTrace();
    }
%>

<!DOCTYPE html>
<html lang="en">
<head>
    <meta charset="UTF-8" />
    <title>Update Profile</title>
    <link href="https://cdn.jsdelivr.net/npm/bootstrap@5.3.2/dist/css/bootstrap.min.css" rel="stylesheet">
    <link href="https://cdnjs.cloudflare.com/ajax/libs/font-awesome/6.4.0/css/all.min.css" rel="stylesheet">
    <style>
        body {
            background-color: #f5f7fa;
            font-family: 'Segoe UI', sans-serif;
        }
        .profile-form {
            background-color: #ffffff;
            border-radius: 15px;
            box-shadow: 0px 0px 12px rgba(0,0,0,0.1);
            padding: 40px;
            max-width: 800px;
            margin: 60px auto;
            animation: fadeInUp 0.6s ease;
        }
        .form-label {
            font-weight: 600;
        }
        .btn-custom {
            padding: 10px 24px;
            border-radius: 8px;
            font-weight: bold;
        }
        @keyframes fadeInUp {
            from {opacity: 0; transform: translateY(20px);}
            to {opacity: 1; transform: translateY(0);}
        }
    </style>
</head>
<body>
    <div class="container">
        <div class="profile-form">
            <h2 class="mb-4 text-center"><i class="fas fa-user-edit me-2"></i>Update Your Profile</h2>
            <form action="UpdateBuyerProfile" method="post">
                <div class="row g-3">
                    <div class="col-md-6">
                        <label for="first-name" class="form-label">First Name</label>
                        <input type="text" class="form-control" name="first-name" id="first-name" value="<%= fname %>" required>
                    </div>
                    <div class="col-md-6">
                        <label for="last-name" class="form-label">Last Name</label>
                        <input type="text" class="form-control" name="last-name" id="last-name" value="<%= lname %>" required>
                    </div>
                    <div class="col-md-6">
                        <label for="gender" class="form-label">Gender</label>
                        <select name="gender" id="gender" class="form-select" required>
                            <option value="male" <%= "male".equalsIgnoreCase(gender) ? "selected" : "" %>>Male</option>
                            <option value="female" <%= "female".equalsIgnoreCase(gender) ? "selected" : "" %>>Female</option>
                            <option value="other" <%= "other".equalsIgnoreCase(gender) ? "selected" : "" %>>Other</option>
                        </select>
                    </div>
                    <div class="col-md-6">
                        <label for="crop-grown" class="form-label">Company</label>
                        <input type="text" class="form-control" name="company" id="crop-grown" value="<%= company %>" required>
                    </div>
                    <div class="col-md-6">
                        <label for="mobile" class="form-label">Mobile</label>
                        <input type="tel" class="form-control" name="mobile" id="mobile" value="<%= mobile %>" required>
                    </div>
                    <div class="col-md-6">
                        <label for="email" class="form-label">Email (cannot change)</label>
                        <input type="email" class="form-control bg-light" name="email" id="email" value="<%= email %>" readonly>
                    </div>
                    <div class="col-md-6">
                        <label for="street" class="form-label">Street Address</label>
                        <input type="text" class="form-control" name="street" id="street" value="<%= street %>" required>
                    </div>
                    <div class="col-md-6">
                        <label for="city" class="form-label">City</label>
                        <input type="text" class="form-control" name="city" id="city" value="<%= city %>" required>
                    </div>
                    <div class="col-md-6">
                        <label for="state" class="form-label">State</label>
                        <input type="text" class="form-control" name="state" id="state" value="<%= state %>" required>
                    </div>
                    <div class="col-md-6">
                        <label for="postal" class="form-label">Postal Code</label>
                        <input type="text" class="form-control" name="postal" id="postal" value="<%= pin %>" required>
                    </div>
                    <div class="col-md-6">
                        <label for="country" class="form-label">Country</label>
                        <input type="text" class="form-control" name="country" id="country" value="<%= country %>" required>
                    </div>
                </div>

                <div class="mt-4 d-flex justify-content-between">
                    <button type="submit" class="btn btn-success btn-custom">
                        <i class="fas fa-save me-1"></i>Update Profile
                    </button>
                    <button type="button" class="btn btn-secondary btn-custom" onclick="window.location.href='BuyerProfile.html';">
                        <i class="fas fa-arrow-left me-1"></i>Cancel
                    </button>
                </div>
            </form>
        </div>
    </div>

    <script src="https://cdn.jsdelivr.net/npm/bootstrap@5.3.2/dist/js/bootstrap.bundle.min.js"></script>
</body>
</html>
