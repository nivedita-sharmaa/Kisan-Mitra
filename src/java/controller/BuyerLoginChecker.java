package controller;
import db.DBConnector;
import java.io.IOException;
import java.sql.ResultSet;
import java.sql.SQLException;
import java.sql.Connection;
import java.sql.PreparedStatement;
import javax.servlet.ServletException;
import javax.servlet.http.HttpServlet;
import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;
import javax.servlet.http.HttpSession;
import model.BuyerLoginAuthenticator;

public class BuyerLoginChecker extends HttpServlet 
{
    public void doGet(HttpServletRequest request, HttpServletResponse response) throws ServletException, IOException 
    {
        response.sendRedirect("Home.html");
    }
     
    public void doPost(HttpServletRequest request, HttpServletResponse response) throws ServletException, IOException 
    {
        String email = request.getParameter("email");
        String password = request.getParameter("password");
        String fname = "";
        
        try {
            Connection conn = DBConnector.getConnection();
            String query = "SELECT fname FROM buyerregistration WHERE email = ?";
            PreparedStatement ps = conn.prepareStatement(query);
            ps.setString(1, email);
            ResultSet rs = ps.executeQuery();
            
            if (rs.next()) {
                fname = rs.getString("fname");
            }
            ps.close();
            conn.close();
        } catch (SQLException e) {
            System.out.println(e);
        }
        
        BuyerLoginAuthenticator l1 = new BuyerLoginAuthenticator();
        boolean login = l1.isLogin(email, password);
        
        if (login) {
            HttpSession session = request.getSession(true);
            session.setAttribute("email", email);
            session.setAttribute("fname", fname);
            response.sendRedirect("BuyerDashboard.jsp");  // CHANGED FROM BuyerProfile.html
        } else {
            response.sendRedirect("LoginFail.html");
        }
    }
}