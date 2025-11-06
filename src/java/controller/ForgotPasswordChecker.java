package controller;

import db.DBConnector;
import java.io.IOException;
import java.net.URLEncoder;
import java.sql.ResultSet;
import java.sql.SQLException;
import java.sql.Statement;
import javax.servlet.ServletException;
import javax.servlet.http.HttpServlet;
import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;

public class ForgotPasswordChecker extends HttpServlet {
    
    public void doGet(HttpServletRequest request, HttpServletResponse response) throws ServletException, IOException {
        response.sendRedirect("ForgotPassword.html");
    }
    
    public void doPost(HttpServletRequest request, HttpServletResponse response) throws ServletException, IOException {
        String email = request.getParameter("email");
        String userType = request.getParameter("user-type");
        
        // Determine which table to check based on user type
        String tableName = "";
        if ("buyer".equals(userType)) {
            tableName = "buyerregistration";
        } else if ("farmer".equals(userType)) {
            tableName = "farmerregistration"; // Change this to your actual farmer table name
        } else {
            response.sendRedirect("error.jsp?error=" + URLEncoder.encode("Invalid account type selected.", "UTF-8"));
            return;
        }
        
        try {
            Statement st = DBConnector.getStatement();
            String query = "SELECT email FROM " + tableName + " WHERE email='" + email + "'";
            ResultSet rs = st.executeQuery(query);
            
            if (rs.next()) {
                // Email exists - redirect to reset password page
                response.sendRedirect("ResetPassword.jsp?email=" + URLEncoder.encode(email, "UTF-8") + "&userType=" + userType);
            } else {
                // Email not found
                String errorMsg = "Email not found in " + (userType.equals("buyer") ? "Buyer" : "Farmer") + " records. Please check and try again.";
                response.sendRedirect("error.jsp?error=" + URLEncoder.encode(errorMsg, "UTF-8"));
            }
            
        } catch (SQLException e) {
            e.printStackTrace();
            response.sendRedirect("error.jsp?error=" + URLEncoder.encode(e.getMessage(), "UTF-8"));
        }
    }
}