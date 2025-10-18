<%
    String userEmail = (String) session.getAttribute("email");
    if (userEmail == null || userEmail.isEmpty()) {
        response.setStatus(401);
        response.getWriter().write("UNAUTHORIZED");
    } else {
        response.setStatus(200);
        response.getWriter().write("OK");
    }
%>