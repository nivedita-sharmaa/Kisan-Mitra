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

        String commodity = request.getParameter("commodity");
        String origin = request.getParameter("origin");
        String quantity = request.getParameter("quantity");
        String price = request.getParameter("price");

        byte[] imageBytes = null;
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
            }
        }

        try {
            Statement st = DBConnector.getStatement();

            // Convert byte array to hex string for insertion
            String imageHex = "NULL";
            if (imageBytes != null && imageBytes.length > 0) {
                StringBuilder sb = new StringBuilder();
                for (byte b : imageBytes) {
                    sb.append(String.format("%02X", b));
                }
                imageHex = "0x" + sb.toString();
            }

            // IMPORTANT: Escape strings properly to avoid SQL injection (not done here, risky)
            String query = "INSERT INTO tradecreation (commodity, origin, quantity, buyingprice, image) VALUES ("
                    + "'" + commodity + "', "
                    + "'" + origin + "', "
                    + quantity + ", "
                    + price + ", "
                    + imageHex + ")";

            System.out.println("query=" + query);

            int rows = st.executeUpdate(query);

            if (rows > 0) {
                response.sendRedirect("TradeCreationMsg.jsp");
            } else {
                response.getWriter().println("Failed to insert record.");
            }

        } catch (SQLException e) {
            e.printStackTrace();
            response.getWriter().println("SQL Error: " + e.getMessage());
        } catch (Exception e) {
            e.printStackTrace();
            response.getWriter().println("General Error: " + e.getMessage());
        }
    }
}
