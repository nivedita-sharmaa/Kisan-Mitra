package model;
import db.DBConnector;
import java.sql.ResultSet;
import java.sql.SQLException;
import java.sql.Connection;
import java.sql.PreparedStatement;

public class FarmerLoginAuthenticator
{
    public boolean isLogin(String email, String password)
    {
        String tablePassword = "";
        Connection conn = null;
        PreparedStatement ps = null;
        ResultSet rs = null;
        
        try {
            conn = DBConnector.getConnection();
            String query = "SELECT password FROM farmerregistration WHERE email = ?";
            System.out.println("DEBUG: Query = " + query);
            System.out.println("DEBUG: Email parameter = " + email);
            
            ps = conn.prepareStatement(query);
            ps.setString(1, email);
            rs = ps.executeQuery();
            
            if (rs.next()) {
                tablePassword = rs.getString(1);
                System.out.println("DEBUG: Found password in database");
            } else {
                System.out.println("DEBUG: Email not found in database");
                return false;
            }
            
        } catch (SQLException e) {
            System.out.println("DEBUG: SQLException in authenticator: " + e.getMessage());
            e.printStackTrace();
            return false;
        } finally {
            try {
                if (rs != null) rs.close();
                if (ps != null) ps.close();
                if (conn != null) conn.close();
            } catch (SQLException e) {
                System.out.println("DEBUG: Error closing resources: " + e.getMessage());
            }
        }
        
        System.out.println("DEBUG: Email = " + email);
        System.out.println("DEBUG: Password provided = " + password);
        System.out.println("DEBUG: Password in DB = " + tablePassword);
        System.out.println("DEBUG: Passwords match = " + (password != null && password.equals(tablePassword)));
        
        if (email != null && password != null && !email.trim().equals("") && !password.trim().equals("") && password.equals(tablePassword)) {
            System.out.println("DEBUG: Login SUCCESSFUL");
            return true;
        }
        
        System.out.println("DEBUG: Login FAILED");
        return false;
    }
}