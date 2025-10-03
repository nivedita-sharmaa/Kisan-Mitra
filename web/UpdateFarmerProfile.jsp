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

    String fname = "", lname = "", gender = "", cropgrown = "";
    String farmsize = "", mobile = "", email = "", password = "", street = "", city = "", state = "", pin = "", country = "";

    try {
        Statement st = DBConnector.getStatement();
        String query = "SELECT * FROM farmerregistration WHERE email='" + emailSession + "'";
        ResultSet rs = st.executeQuery(query);
        if (rs.next()) {
            fname = rs.getString("fname");
            lname = rs.getString("lname");
            gender = rs.getString("gender");
            cropgrown = rs.getString("cropGrown");
            farmsize = rs.getString("farmSize");
            mobile = rs.getString("mobile");
            email = rs.getString("email");
            password = rs.getString("password");
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
    <title>Update Farmer Profile</title>
    <link href="https://cdnjs.cloudflare.com/ajax/libs/font-awesome/6.0.0-beta3/css/all.min.css" rel="stylesheet" />
    <link href="https://fonts.googleapis.com/css2?family=Roboto:wght@400;700&display=swap" rel="stylesheet" />
    <style>
        body {
            font-family: 'Roboto', sans-serif;
            background: #f3f4f6;
            margin: 0;
            padding: 0;
        }

        .container {
            max-width: 800px;
            margin: 40px auto;
            background: #ffffff;
            padding: 40px;
            border-radius: 12px;
            box-shadow: 0 0 15px rgba(0, 0, 0, 0.1);
        }

        h1 {
            text-align: center;
            margin-bottom: 30px;
            color: #2c3e50;
        }

        .form-group {
            display: flex;
            flex-direction: column;
            margin-bottom: 20px;
        }

        label {
            margin-bottom: 6px;
            font-weight: bold;
            color: #34495e;
        }

        input, select {
            padding: 10px;
            border: 1px solid #ccc;
            border-radius: 6px;
            font-size: 16px;
        }

        input[readonly] {
            background-color: #e9ecef;
            cursor: not-allowed;
        }

        .form-actions {
            display: flex;
            justify-content: space-between;
            margin-top: 30px;
        }

        button {
            padding: 12px 25px;
            font-size: 16px;
            border: none;
            border-radius: 6px;
            cursor: pointer;
            transition: all 0.3s ease;
        }

        button[type="submit"] {
            background-color: #27ae60;
            color: #fff;
        }

        button[type="submit"]:hover {
            background-color: #219150;
        }

        button[type="button"] {
            background-color: #bdc3c7;
            color: #2c3e50;
        }

        button[type="button"]:hover {
            background-color: #95a5a6;
        }

        @media (max-width: 600px) {
            .form-actions {
                flex-direction: column;
                gap: 10px;
            }
        }
    </style>
</head>
<body>

<div class="container">
    <h1><i class="fas fa-user-edit"></i> Update Your Profile</h1>

    <form action="UpdateFarmerProfile" method="post">
        <div class="form-group">
            <label for="first-name">First Name</label>
            <input type="text" name="first-name" id="first-name" value="<%= fname %>" required />
        </div>

        <div class="form-group">
            <label for="last-name">Last Name</label>
            <input type="text" name="last-name" id="last-name" value="<%= lname %>" required />
        </div>

        <div class="form-group">
            <label for="gender">Gender</label>
            <select name="gender" id="gender" required>
                <option value="male" <%= "male".equalsIgnoreCase(gender) ? "selected" : "" %>>Male</option>
                <option value="female" <%= "female".equalsIgnoreCase(gender) ? "selected" : "" %>>Female</option>
                <option value="other" <%= "other".equalsIgnoreCase(gender) ? "selected" : "" %>>Other</option>
            </select>
        </div>

        <div class="form-group">
            <label for="crop-grown">Crop Grown</label>
            <input type="text" name="crop-grown" id="crop-grown" value="<%= cropgrown %>" required />
        </div>

        <div class="form-group">
            <label for="farmsize">Farm Size</label>
            <input type="text" name="farmsize" id="farmsize" value="<%= farmsize %>" required />
        </div>

        <div class="form-group">
            <label for="mobile">Mobile</label>
            <input type="tel" name="mobile" id="mobile" value="<%= mobile %>" required />
        </div>

        <div class="form-group">
            <label for="email">Email (cannot change)</label>
            <input type="email" name="email" id="email" value="<%= email %>" readonly />
        </div>
         
        
        
        <div class="form-group">
            <label for="street">Street Address</label>
            <input type="text" name="street" id="street" value="<%= street %>" required />
        </div>

        <div class="form-group">
            <label for="city">City</label>
            <input type="text" name="city" id="city" value="<%= city %>" required />
        </div>

        <div class="form-group">
            <label for="state">State</label>
            <input type="text" name="state" id="state" value="<%= state %>" required />
        </div>

        <div class="form-group">
            <label for="postal">Postal Code</label>
            <input type="text" name="postal" id="postal" value="<%= pin %>" required />
        </div>

        <div class="form-group">
            <label for="country">Country</label>
            <input type="text" name="country" id="country" value="<%= country %>" required />
        </div>

        <div class="form-actions">
            <button type="submit"><i class="fas fa-save"></i> Update Profile</button>
            <button type="button" onclick="window.location.href='FarmerProfile.html';"><i class="fas fa-arrow-left"></i> Cancel</button>
        </div>
    </form>
</div>

</body>
</html>
