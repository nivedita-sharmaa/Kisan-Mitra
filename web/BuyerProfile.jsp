<%@page import="db.DBConnector"%>
<%@page import="java.sql.Statement"%>
<%@page import="java.sql.ResultSet"%>
<%@page import="java.sql.SQLException"%>
<%@page contentType="text/html" pageEncoding="UTF-8"%>
<!DOCTYPE html>
<html>
    <head>
        <meta http-equiv="Content-Type" content="text/html; charset=UTF-8">
        <title>User Profile</title>
        <style>
            body {
                font-family: Arial, sans-serif;
                margin: 0;
                padding: 0;
                background: linear-gradient(135deg, #1a2a6c, #b21f1f, #fdbb2d);
                color: #333;
            }
            .container {
                width: 60%;
                margin: 50px auto;
                background: #fff;
                box-shadow: 0 4px 8px rgba(0, 0, 0, 0.1);
                border-radius: 8px;
                padding: 20px;
                overflow: hidden;
            }
            h1 {
                text-align: center;
                color: #333;
                margin-bottom: 30px;
            }
            table {
                width: 100%;
                border-collapse: collapse;
                margin-bottom: 20px;
            }
            td {
                padding: 10px;
                border: 1px solid #ddd;
                font-size: 16px;
            }
            td:first-child {
                font-weight: bold;
                background: #f1f4f9;
                width: 30%;
            }
            td:last-child {
                text-align: left;
            }
            tr:nth-child(even) {
                background-color: #f9f9f9;
            }
            .footer {
                text-align: center;
                margin-top: 20px;
                font-size: 14px;
                color: #666;
            }
        </style>
    </head>
    <body>
        <div class="container">
            <h1>Buyer Profile</h1>
            <%
                String fname = "", lname = "", gender = "", company = "";
                String mobile = "", email = "", password = "";
                String street = "", city = "", state = "", pin = "", country = "";

                try {
                    String email1 = (String) session.getAttribute("email");
                    System.out.println(email1);

                    Statement st = DBConnector.getStatement();
                    String query = "SELECT * FROM buyerregistration WHERE email='" + email1 + "'";
                    ResultSet rs = st.executeQuery(query);
                    while (rs.next()) {
                        fname = rs.getString(1);
                        lname = rs.getString(2);
                        gender = rs.getString(3);
                        company = rs.getString(4);
                        mobile = rs.getString(5);
                        email = rs.getString(6);
                        password = rs.getString(7);
                        street = rs.getString(9);
                        city = rs.getString(10);
                        state = rs.getString(11);
                        pin = rs.getString(12);
                        country = rs.getString(13);
                    }
                } catch (SQLException e) {
                    System.out.println(e);
                }
            %>

            <table>
                <tr><td>First Name:</td><td><%= fname %></td></tr>
                <tr><td>Last Name:</td><td><%= lname %></td></tr>
                <tr><td>Gender:</td><td><%= gender %></td></tr>
                <tr><td>company:</td><td><%= company %></td></tr>
                <tr><td>Mobile:</td><td><%= mobile %></td></tr>
                <tr><td>Email:</td><td><%= email %></td></tr>
                <tr><td>Password:</td><td><%= password %></td></tr>
                <tr><td>Street:</td><td><%= street %></td></tr>
                <tr><td>City:</td><td><%= city %></td></tr>
                <tr><td>State:</td><td><%= state %></td></tr>
                <tr><td>Pin:</td><td><%= pin %></td></tr>
                <tr><td>Country:</td><td><%= country %></td></tr>
            </table>

            <div class="footer">
                © 2024 Your Company. All Rights Reserved.
            </div>
        </div>
    </body>
</html>
