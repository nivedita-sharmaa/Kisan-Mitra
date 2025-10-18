package controller;
import db.DBConnector;
import java.io.*;
import java.sql.*;
import javax.servlet.*;
import javax.servlet.annotation.MultipartConfig;
import javax.servlet.http.*;

@MultipartConfig(maxFileSize = 16177215) // 16MB
public class CreateTrade extends HttpServlet {
    protected void doPost(HttpServletRequest request, HttpServletResponse response)
        throws ServletException, IOException {
        
        // Get farmer_email from session
        HttpSession session = request.getSession();
        String farmerEmail = (String) session.getAttribute("email");
        String farmerName = (String) session.getAttribute("fname");
        
        System.out.println("DEBUG: Session email = " + farmerEmail);
        System.out.println("DEBUG: Session fname = " + farmerName);
        
        // Check if user is logged in
        if (farmerEmail == null || farmerEmail.isEmpty()) {
            System.out.println("DEBUG: Email is null or empty - redirecting to login");
            response.sendRedirect("Login.jsp");
            return;
        }
        
        String commodity = request.getParameter("commodity");
        String category = request.getParameter("category");
        String origin = request.getParameter("origin");
        String quantity = request.getParameter("quantity");
        String price = request.getParameter("price");
        byte[] imageBytes = null;
        
        System.out.println("DEBUG: Commodity = " + commodity);
        System.out.println("DEBUG: Category = " + category);
        System.out.println("DEBUG: Origin = " + origin);
        System.out.println("DEBUG: Quantity = " + quantity);
        System.out.println("DEBUG: Price = " + price);
        
        Part imagePart = request.getPart("image");
        if (imagePart != null && imagePart.getSize() > 0) {
            try (InputStream imageStream = imagePart.getInputStream();
                 ByteArrayOutputStream baos = new ByteArrayOutputStream()) {
                byte[] buffer = new byte[1024];
                int bytesRead;
                while ((bytesRead = imageStream.read(buffer)) != -1) {
                    baos.write(buffer, 0, bytesRead);
                }
                imageBytes = baos.toByteArray();
                System.out.println("DEBUG: Image size = " + imageBytes.length + " bytes");
            }
        }
        
        Connection conn = null;
        PreparedStatement ps = null;
        
        try {
            conn = DBConnector.getConnection();
            System.out.println("DEBUG: Database connection obtained");
            
            // Get farmer address for farmer_address field
            String farmerAddress = origin; // Use origin as farmer's address location
            
            String query = "INSERT INTO tradecreation (commodity, category, origin, quantity, buyingprice, image, farmer_email, farmer_name, farmer_address, available) VALUES (?, ?, ?, ?, ?, ?, ?, ?, ?, true)";
            System.out.println("DEBUG: Query = " + query);
            
            ps = conn.prepareStatement(query);
            ps.setString(1, commodity);
            ps.setString(2, category);
            ps.setString(3, origin);
            ps.setInt(4, Integer.parseInt(quantity));
            ps.setDouble(5, Double.parseDouble(price));
            ps.setBytes(6, imageBytes);
            ps.setString(7, farmerEmail);
            ps.setString(8, farmerName);
            ps.setString(9, farmerAddress);
            
            System.out.println("DEBUG: Executing insert...");
            int rows = ps.executeUpdate();
            System.out.println("DEBUG: Insert result = " + rows + " rows affected");
            
            if (rows > 0) {
                session.setAttribute("message", "Trade created successfully!");
                session.setAttribute("messageType", "success");
                System.out.println("DEBUG: Trade created successfully, redirecting to ShowTrades");
                response.sendRedirect("ShowTrades.jsp");
            } else {
                session.setAttribute("message", "Failed to create trade");
                session.setAttribute("messageType", "error");
                System.out.println("DEBUG: Trade creation returned 0 rows");
                response.sendRedirect("UploadTrade.jsp");
            }
            
        } catch (SQLException e) {
            e.printStackTrace();
            System.out.println("DEBUG: SQLException = " + e.getMessage());
            System.out.println("DEBUG: SQL State = " + e.getSQLState());
            System.out.println("DEBUG: Error Code = " + e.getErrorCode());
            session.setAttribute("message", "SQL Error: " + e.getMessage());
            session.setAttribute("messageType", "error");
            response.sendRedirect("UploadTrade.jsp");
        } catch (Exception e) {
            e.printStackTrace();
            System.out.println("DEBUG: General Exception = " + e.getMessage());
            session.setAttribute("message", "Error: " + e.getMessage());
            session.setAttribute("messageType", "error");
            response.sendRedirect("UploadTrade.jsp");
        } finally {
            try {
                if (ps != null) ps.close();
                if (conn != null) conn.close();
            } catch (SQLException e) {
                System.out.println("DEBUG: Error closing resources: " + e.getMessage());
            }
        }
    }
}

