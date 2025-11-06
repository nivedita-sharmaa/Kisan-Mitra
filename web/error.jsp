<%@ page contentType="text/html" pageEncoding="UTF-8"%>
<!DOCTYPE html>
<html>
<head>
    <title>Registration Error</title>
    <style>
        * {
            margin: 0;
            padding: 0;
            box-sizing: border-box;
        }
        
        body {
            font-family: 'Segoe UI', Tahoma, Geneva, Verdana, sans-serif;
            background: linear-gradient(135deg, #667eea 0%, #764ba2 100%);
            min-height: 100vh;
            display: flex;
            align-items: center;
            justify-content: center;
            padding: 20px;
        }
        
        .error-container {
            background: white;
            max-width: 600px;
            width: 100%;
            padding: 40px;
            border-radius: 12px;
            box-shadow: 0 10px 40px rgba(0,0,0,0.2);
            text-align: center;
        }
        
        .error-icon {
            font-size: 60px;
            color: #dc3545;
            margin-bottom: 20px;
        }
        
        h1 {
            color: #333;
            margin-bottom: 15px;
            font-size: 28px;
        }
        
        .error-message {
            background: #f8d7da;
            border: 1px solid #f5c6cb;
            color: #721c24;
            padding: 20px;
            border-radius: 8px;
            margin: 20px 0;
            line-height: 1.6;
        }
        
        .error-details {
            font-size: 14px;
            word-break: break-word;
        }
        
        .btn-container {
            margin-top: 30px;
        }
        
        .btn {
            display: inline-block;
            padding: 12px 30px;
            margin: 0 10px;
            text-decoration: none;
            border-radius: 6px;
            font-weight: 600;
            transition: all 0.3s;
        }
        
        .btn-primary {
            background: #667eea;
            color: white;
        }
        
        .btn-primary:hover {
            background: #5568d3;
            transform: translateY(-2px);
            box-shadow: 0 5px 15px rgba(102, 126, 234, 0.4);
        }
        
        .btn-secondary {
            background: #6c757d;
            color: white;
        }
        
        .btn-secondary:hover {
            background: #5a6268;
            transform: translateY(-2px);
        }
    </style>
</head>
<body>
    <div class="error-container">
        <div class="error-icon">⚠️</div>
        <h1>Oops! Something Went Wrong</h1>
        <p style="color: #666; margin-bottom: 20px;">We encountered an error while processing your registration.</p>
        
        <div class="error-message">
            <strong>Error Details:</strong><br>
            <div class="error-details">
                <%= request.getParameter("error") != null ? request.getParameter("error") : "Unknown error occurred" %>
            </div>
        </div>
        
        <% 
            String errorMsg = request.getParameter("error");
            if (errorMsg != null && errorMsg.contains("Duplicate entry")) {
        %>
            <p style="color: #666; font-size: 14px;">
                This email address is already registered. Please try with a different email address.
            </p>
        <% } %>
        
        <div class="btn-container">
            <a href="BuyerRegistration.html" class="btn btn-primary">Try Again</a>
            <a href="Home.html" class="btn btn-secondary">Home Page</a>
        </div>
    </div>
</body>
</html>