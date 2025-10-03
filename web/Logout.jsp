<%-- 
    Document   : logout
    Created on : May 21, 2025, 3:12:27 PM
    Author     : Asus
--%>

<%@page contentType="text/html" pageEncoding="UTF-8"%>
<!DOCTYPE html>
<html>
    <head>
        <meta http-equiv="Content-Type" content="text/html; charset=UTF-8">
        <title>JSP Page</title>
    </head>
    <body>
        <%session.invalidate();
        response.sendRedirect("Home.html");
        %>
    </body>
</html>
