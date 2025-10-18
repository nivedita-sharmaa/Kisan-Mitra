<%@ page import="db.DBConnector" %>
<%@ page import="java.sql.*" %>

<%
    String buyerEmail = (String) session.getAttribute("email");
    String tradeIdStr = request.getParameter("trade_id");
    
    if (buyerEmail != null && tradeIdStr != null) {
        try {
            int tradeId = Integer.parseInt(tradeIdStr);
            Connection conn = DBConnector.getConnection();
            
            // Check if item already in cart
            String checkQuery = "SELECT id, quantity FROM cart WHERE buyer_email = ? AND trade_id = ?";
            PreparedStatement checkPs = conn.prepareStatement(checkQuery);
            checkPs.setString(1, buyerEmail);
            checkPs.setInt(2, tradeId);
            ResultSet checkRs = checkPs.executeQuery();
            
            if (checkRs.next()) {
                // Update quantity if exists
                String updateQuery = "UPDATE cart SET quantity = quantity + 1 WHERE buyer_email = ? AND trade_id = ?";
                PreparedStatement updatePs = conn.prepareStatement(updateQuery);
                updatePs.setString(1, buyerEmail);
                updatePs.setInt(2, tradeId);
                updatePs.executeUpdate();
                updatePs.close();
            } else {
                // Insert new cart item
                String insertQuery = "INSERT INTO cart (buyer_email, trade_id, quantity) VALUES (?, ?, 1)";
                PreparedStatement insertPs = conn.prepareStatement(insertQuery);
                insertPs.setString(1, buyerEmail);
                insertPs.setInt(2, tradeId);
                insertPs.executeUpdate();
                insertPs.close();
            }
            
            checkPs.close();
            conn.close();
        } catch (Exception e) {
            System.out.println(e);
        }
    }
    
    response.sendRedirect("ViewTrades.jsp");
%>