<%@ include file="SessionValidator.jsp" %>
<%@ page import="db.DBConnector" %>
<%@ page import="java.sql.*" %>

<%
    response.setHeader("Cache-Control", "no-cache, no-store, must-revalidate");
    
    String cartIdStr = request.getParameter("cart_id");
    
    if (cartIdStr != null && !cartIdStr.isEmpty()) {
        try {
            int cartId = Integer.parseInt(cartIdStr);
            
            Connection conn = DBConnector.getConnection();
            
            // Delete the item from cart
            String deleteQuery = "DELETE FROM cart WHERE id = ?";
            PreparedStatement ps = conn.prepareStatement(deleteQuery);
            ps.setInt(1, cartId);
            
            int rowsDeleted = ps.executeUpdate();
            
            ps.close();
            conn.close();
            
            if (rowsDeleted > 0) {
                // Successfully removed
                response.sendRedirect("Cart.jsp?removed=success");
            } else {
                // Removal failed
                response.sendRedirect("Cart.jsp?error=remove_failed");
            }
            
        } catch (NumberFormatException e) {
            response.sendRedirect("Cart.jsp?error=invalid_id");
        } catch (SQLException e) {
            out.println("<p style='color:red;'>SQL Error: " + e.getMessage() + "</p>");
            response.sendRedirect("Cart.jsp?error=sql_error");
        }
    } else {
        response.sendRedirect("Cart.jsp?error=missing_id");
    }
%>