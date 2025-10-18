package model;
import db.DBConnector;
import java.sql.ResultSet;
import java.sql.SQLException;
import java.sql.Connection;
import java.sql.PreparedStatement;

public class BuyerLoginAuthenticator
{
    public boolean isLogin(String email, String password)
    {
        String tablePassword = "";
        Connection conn = null;
        PreparedStatement ps = null;
        ResultSet rs = null;
        
        try {
            conn = DBConnector.getConnection();
            String query = "SELECT password FROM buyerregistration WHERE email = ?";
            ps = conn.prepareStatement(query);
            ps.setString(1, email);
            rs = ps.executeQuery();
            
            if (rs.next()) {
                tablePassword = rs.getString(1);
            } else {
                return false;
            }
            
        } catch (SQLException e) {
            System.out.println(e);
            return false;
        } finally {
            try {
                if (rs != null) rs.close();
                if (ps != null) ps.close();
                if (conn != null) conn.close();
            } catch (SQLException e) {
                System.out.println(e);
            }
        }
        
        if (email != null && password != null && 
            !email.trim().equals("") && !password.trim().equals("") && 
            password.equals(tablePassword)) {
            return true;
        }
        return false;
    }
}