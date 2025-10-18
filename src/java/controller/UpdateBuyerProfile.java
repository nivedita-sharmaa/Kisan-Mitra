package controller;
import db.DBConnector;
import java.io.IOException;
import java.sql.*;
import javax.servlet.ServletException;
import javax.servlet.http.HttpServlet;
import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;
import javax.servlet.http.HttpSession;

public class UpdateBuyerProfile extends HttpServlet {
    protected void doPost(HttpServletRequest request, HttpServletResponse response)
        throws ServletException, IOException {
        
        HttpSession session = request.getSession();
        String email = (String) session.getAttribute("email");
        
        if (email == null) {
            response.sendRedirect("Login.jsp");
            return;
        }
        
        String firstName = request.getParameter("first-name");
        String lastName = request.getParameter("last-name");
        String gender = request.getParameter("gender");
        String company = request.getParameter("company");
        String mobile = request.getParameter("mobile");
        String street = request.getParameter("street");
        String city = request.getParameter("city");
        String state = request.getParameter("state");
        String postal = request.getParameter("postal");
        String country = request.getParameter("country");
        String location = request.getParameter("location");
        
        try {
            Connection conn = DBConnector.getConnection();
            String query = "UPDATE buyerregistration SET fname=?, lname=?, gender=?, company=?, mobile=?, street=?, city=?, state=?, pin=?, country=?, location=? WHERE email=?";
            PreparedStatement ps = conn.prepareStatement(query);
            
            ps.setString(1, firstName);
            ps.setString(2, lastName);
            ps.setString(3, gender);
            ps.setString(4, company);
            ps.setString(5, mobile);
            ps.setString(6, street);
            ps.setString(7, city);
            ps.setString(8, state);
            ps.setString(9, postal);
            ps.setString(10, country);
            ps.setString(11, location);
            ps.setString(12, email);
            
            int result = ps.executeUpdate();
            
            if (result > 0) {
                session.setAttribute("message", "Profile updated successfully!");
                session.setAttribute("messageType", "success");
            } else {
                session.setAttribute("message", "Failed to update profile");
                session.setAttribute("messageType", "error");
            }
            
            ps.close();
            conn.close();
            response.sendRedirect("BuyerProfile.jsp");
            
        } catch (SQLException e) {
            e.printStackTrace();
            session.setAttribute("message", "Error: " + e.getMessage());
            session.setAttribute("messageType", "error");
            try {
                response.sendRedirect("UpdateBuyerProfile.jsp");
            } catch (IOException ex) {
                ex.printStackTrace();
            }
        }
    }
}