<%@ page import="db.DBConnector" %>
<%@ page import="java.sql.*" %>

<%
    String buyerEmail = (String) session.getAttribute("email");
    
    if (buyerEmail != null) {
        try {
            Connection conn = DBConnector.getConnection();
            
            // Get all cart items
            String cartQuery = "SELECT c.trade_id, c.quantity, t.farmer_email, t.buyingprice " +
                               "FROM cart c JOIN tradecreation t ON c.trade_id = t.id " +
                               "WHERE c.buyer_email = ?";
            PreparedStatement cartPs = conn.prepareStatement(cartQuery);
            cartPs.setString(1, buyerEmail);
            ResultSet cartRs = cartPs.executeQuery();
            
            // Insert each cart item as an order
            String orderQuery = "INSERT INTO orders (buyer_email, trade_id, farmer_email, quantity, total_price, order_status) VALUES (?, ?, ?, ?, ?, 'Pending')";
            PreparedStatement orderPs = conn.prepareStatement(orderQuery);
            
            while (cartRs.next()) {
                int tradeId = cartRs.getInt("trade_id");
                int quantity = cartRs.getInt("quantity");
                String farmerEmail = cartRs.getString("farmer_email");
                double price = cartRs.getDouble("buyingprice");
                double totalPrice = price * quantity;
                
                orderPs.setString(1, buyerEmail);
                orderPs.setInt(2, tradeId);
                orderPs.setString(3, farmerEmail);
                orderPs.setInt(4, quantity);
                orderPs.setDouble(5, totalPrice);
                orderPs.addBatch();
            }
            
            orderPs.executeBatch();
            
            // Clear the cart
            String clearQuery = "DELETE FROM cart WHERE buyer_email = ?";
            PreparedStatement clearPs = conn.prepareStatement(clearQuery);
            clearPs.setString(1, buyerEmail);
            clearPs.executeUpdate();
            
            cartPs.close();
            orderPs.close();
            clearPs.close();
            conn.close();
            
            session.setAttribute("message", "Order placed successfully!");
            response.sendRedirect("MyOrders.jsp");
        } catch (SQLException e) {
            System.out.println(e);
            session.setAttribute("message", "Error placing order");
            response.sendRedirect("Cart.jsp");
        }
    } else {
        response.sendRedirect("Login.jsp");
    }
%>