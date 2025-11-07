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
        
        .user-message {
            color: #666;
            font-size: 14px;
            margin-top: 15px;
            line-height: 1.6;
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
            String userMessage = "";
            String registrationType = "Buyer"; // Default
            String tryAgainLink = "BuyerRegistration.html";
            String homeLink = "Home.html";
            
            // Determine registration type from multiple sources
            String referer = request.getHeader("referer");
            String type = request.getParameter("type");
            String source = request.getParameter("source");
            
            // Check if it's from Farmer registration
            boolean isFarmer = false;
            
            if (type != null && type.equalsIgnoreCase("farmer")) {
                isFarmer = true;
            } else if (source != null && source.toLowerCase().contains("farmer")) {
                isFarmer = true;
            } else if (referer != null && referer.toLowerCase().contains("farmer")) {
                isFarmer = true;
            }
            
            // Set appropriate links based on registration type
            if (isFarmer) {
                registrationType = "Farmer";
                tryAgainLink = "FarmerRegistration.html";
            } else {
                registrationType = "Buyer";
                tryAgainLink = "BuyerRegistration.html";
            }
            
            // Parse the error message
            if (errorMsg != null && errorMsg.contains("Duplicate entry")) {
                // Extract the key information from the error message
                // Error format: "Duplicate entry 'value' for key 'key_number'"
                
                if (errorMsg.contains("for key 2") || errorMsg.contains("for key '2'")) {
                    // Key 2 is mobile number
                    userMessage = "This mobile number is already registered. Please try with a different mobile number or contact support if you've forgotten your account details.";
                } else if (errorMsg.contains("for key 3") || errorMsg.contains("for key '3'")) {
                    // Key 3 is email
                    userMessage = "This email address is already registered. Please try with a different email address or use the login page if you already have an account.";
                } else {
                    // Generic duplicate message
                    userMessage = "This information is already registered in our system. Please check your details and try again with different information.";
                }
            } else if (errorMsg != null) {
                // Other error messages
                userMessage = "Please check your information and try again. Make sure all fields are filled correctly. If the problem persists, contact support.";
            }
        %>
        
        <% if (!userMessage.isEmpty()) { %>
            <p class="user-message">
                <%= userMessage %>
            </p>
        <% } %>
        
        <div class="btn-container">
            <a href="<%= tryAgainLink %>" class="btn btn-primary">Try Again (<%= registrationType %>)</a>
            <a href="<%= homeLink %>" class="btn btn-secondary">Home Page</a>
        </div>
    </div>
</body>
</html>