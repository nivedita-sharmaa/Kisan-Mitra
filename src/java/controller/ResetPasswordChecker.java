package controller;

import db.DBConnector;
import java.io.IOException;
import java.net.URLEncoder;
import java.sql.SQLException;
import java.sql.Statement;
import javax.servlet.ServletException;
import javax.servlet.http.HttpServlet;
import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;

public class ResetPasswordChecker extends HttpServlet {
    
    public void doPost(HttpServletRequest request, HttpServletResponse response) throws ServletException, IOException {
        String email = request.getParameter("email");
        String newPassword = request.getParameter("new-password");
        String confirmPassword = request.getParameter("confirm-password");
        String userType = request.getParameter("user-type");
        
        // Validate passwords match
        if (!newPassword.equals(confirmPassword)) {
            request.setAttribute("error", "Passwords do not match!");
            request.getRequestDispatcher("ResetPassword.jsp?email=" + email + "&userType=" + userType).forward(request, response);
            return;
        }
        
        // Determine which table to update based on user type
        String tableName = "";
        if ("buyer".equals(userType)) {
            tableName = "buyerregistration";
        } else if ("farmer".equals(userType)) {
            tableName = "farmerregistration"; // Change this to your actual farmer table name
        } else {
            response.sendRedirect("error.jsp?error=" + URLEncoder.encode("Invalid account type.", "UTF-8"));
            return;
        }
        
        try {
            Statement st = DBConnector.getStatement();
            String query = "UPDATE " + tableName + " SET password='" + newPassword + "', confirm='" + confirmPassword + "' WHERE email='" + email + "'";
            
            int i = st.executeUpdate(query);
            
            if (i > 0) {
                // Password updated successfully - redirect with user type info
                response.sendRedirect("PasswordResetSuccess.html?userType=" + userType);
            } else {
                response.sendRedirect("error.jsp?error=" + URLEncoder.encode("Failed to update password. Please try again.", "UTF-8"));
            }
            
        } catch (SQLException e) {
            e.printStackTrace();
            response.sendRedirect("error.jsp?error=" + URLEncoder.encode(e.getMessage(), "UTF-8"));
        }
    }
}