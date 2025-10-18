<%@ include file="SessionValidator.jsp" %>
<%@ page import="db.DBConnector" %>
<%@ page import="java.sql.*" %>

<%
    response.setHeader("Cache-Control", "no-cache, no-store, must-revalidate");
    
    String cartIdStr = request.getParameter("cart_id");
    String quantityStr = request.getParameter("quantity");
    
    if (cartIdStr != null && quantityStr != null) {
        try {
            int cartId = Integer.parseInt(cartIdStr);
            int quantity = Integer.parseInt(quantityStr);
            
            // If quantity is 0 or less, remove the item
            if (quantity <= 0) {
                response.sendRedirect("RemoveFromCart.jsp?cart_id=" + cartId);
                return;
            }
            
            Connection conn = DBConnector.getConnection();
            
            // Update the quantity in the database
            String updateQuery = "UPDATE cart SET quantity = ? WHERE id = ?";
            PreparedStatement ps = conn.prepareStatement(updateQuery);
            ps.setInt(1, quantity);
            ps.setInt(2, cartId);
            
            int rowsUpdated = ps.executeUpdate();
            
            ps.close();
            conn.close();
            
            if (rowsUpdated > 0) {
                // Successfully updated
                response.sendRedirect("Cart.jsp?updated=success");
            } else {
                // Update failed
                response.sendRedirect("Cart.jsp?error=update_failed");
            }
            
        } catch (NumberFormatException e) {
            response.sendRedirect("Cart.jsp?error=invalid_data");
        } catch (SQLException e) {
            out.println("<p style='color:red;'>SQL Error: " + e.getMessage() + "</p>");
            response.sendRedirect("Cart.jsp?error=sql_error");
        }
    } else {
        response.sendRedirect("Cart.jsp?error=missing_data");
    }
%>