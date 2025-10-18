
<%
    response.setHeader("Cache-Control", "no-cache, no-store, must-revalidate");
    response.setHeader("Pragma", "no-cache");
    response.setDateHeader("Expires", 0);
    
    String userEmail = (String) session.getAttribute("email");
    if (userEmail == null || userEmail.isEmpty()) {
        response.sendRedirect("Login.jsp");
        return;
    }
%>

<!-- Session validation script -->
<script>
    // Check if session is valid every 3 seconds
    setInterval(function() {
        fetch('CheckSession.jsp')
            .then(response => {
                if (response.status === 401) {
                    // Session expired, redirect to login
                    window.location.href = 'Login.jsp';
                }
            })
            .catch(error => {
                console.log('Session check error:', error);
            });
    }, 3000);
</script>