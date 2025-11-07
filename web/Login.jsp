<%@ page import="javax.servlet.http.HttpSession" %>
<%
    // Invalidate the current session
    session.invalidate();
%>

<!DOCTYPE html>
<html lang="en">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>Logged Out - Kisan Mitra</title>
    <link href="https://fonts.googleapis.com/css2?family=Poppins:wght@400;600;700;800&display=swap" rel="stylesheet">
    <link href="https://cdnjs.cloudflare.com/ajax/libs/font-awesome/6.0.0-beta3/css/all.min.css" rel="stylesheet">
    <style>
        * {
            margin: 0;
            padding: 0;
            box-sizing: border-box;
            font-family: 'Poppins', sans-serif;
        }

        body {
            background: linear-gradient(135deg, #667eea 0%, #764ba2 100%);
            min-height: 100vh;
            display: flex;
            align-items: center;
            justify-content: center;
            padding: 20px;
        }

        .logout-container {
            background: white;
            border-radius: 20px;
            box-shadow: 0 20px 60px rgba(0, 0, 0, 0.3);
            padding: 60px 40px;
            max-width: 500px;
            width: 100%;
            text-align: center;
            animation: slideDown 0.6s ease;
        }

        @keyframes slideDown {
            from {
                opacity: 0;
                transform: translateY(-30px);
            }
            to {
                opacity: 1;
                transform: translateY(0);
            }
        }

        .logout-icon {
            font-size: 4rem;
            color: #27ae60;
            margin-bottom: 20px;
            animation: pulse 2s ease-in-out infinite;
        }

        @keyframes pulse {
            0%, 100% {
                transform: scale(1);
            }
            50% {
                transform: scale(1.1);
            }
        }

        .logout-title {
            font-size: 2rem;
            font-weight: 700;
            color: #2c3e50;
            margin-bottom: 15px;
        }

        .logout-subtitle {
            font-size: 1.1rem;
            color: #7f8c8d;
            margin-bottom: 10px;
            font-weight: 500;
        }

        .logout-message {
            font-size: 1rem;
            color: #95a5a6;
            line-height: 1.6;
            margin-bottom: 40px;
        }

        .logout-message strong {
            color: #e74c3c;
        }

        .highlight-box {
            background: linear-gradient(135deg, #ffeaa7 0%, #fdcb6e 100%);
            border-left: 5px solid #f39c12;
            padding: 20px;
            border-radius: 10px;
            margin-bottom: 35px;
            text-align: left;
        }

        .highlight-box i {
            color: #f39c12;
            margin-right: 10px;
            font-weight: 700;
        }

        .highlight-text {
            color: #2c3e50;
            font-weight: 600;
            font-size: 0.95rem;
        }

        .button-group {
            display: flex;
            flex-direction: column;
            gap: 15px;
        }

        .login-btn {
            display: inline-flex;
            align-items: center;
            justify-content: center;
            gap: 12px;
            background: linear-gradient(135deg, #667eea 0%, #764ba2 100%);
            color: white;
            padding: 16px 40px;
            border: none;
            border-radius: 12px;
            font-size: 1.05rem;
            font-weight: 700;
            cursor: pointer;
            text-decoration: none;
            transition: all 0.3s ease;
            box-shadow: 0 8px 25px rgba(102, 126, 234, 0.3);
        }

        .login-btn:hover {
            background: linear-gradient(135deg, #764ba2 0%, #667eea 100%);
            transform: translateY(-3px);
            box-shadow: 0 12px 35px rgba(102, 126, 234, 0.5);
        }

        .login-btn:active {
            transform: translateY(-1px);
        }

        .home-btn {
            background: linear-gradient(135deg, #f39c12 0%, #e67e22 100%);
            box-shadow: 0 8px 25px rgba(243, 156, 18, 0.3);
        }

        .home-btn:hover {
            background: linear-gradient(135deg, #e67e22 0%, #d35400 100%);
            box-shadow: 0 12px 35px rgba(243, 156, 18, 0.5);
        }

        .divider {
            display: flex;
            align-items: center;
            margin: 20px 0;
            color: #bdc3c7;
            font-size: 0.9rem;
            font-weight: 600;
        }

        .divider::before,
        .divider::after {
            content: '';
            flex: 1;
            height: 2px;
            background: #ecf0f1;
        }

        .divider::before {
            margin-right: 10px;
        }

        .divider::after {
            margin-left: 10px;
        }

        .footer-text {
            font-size: 0.85rem;
            color: #95a5a6;
            margin-top: 25px;
            font-weight: 500;
        }

        .footer-text i {
            color: #3498db;
            margin-right: 5px;
        }

        @media (max-width: 600px) {
            .logout-container {
                padding: 40px 25px;
            }

            .logout-title {
                font-size: 1.7rem;
            }

            .logout-subtitle {
                font-size: 1rem;
            }

            .logout-icon {
                font-size: 3.5rem;
            }

            .button-group {
                gap: 12px;
            }

            .login-btn {
                padding: 14px 30px;
                font-size: 1rem;
            }
        }
        .footer {
            text-align: center;
            padding: 20px;
            color: white;
            font-size: 0.9rem;
            background: rgba(26, 42, 108, 0.5);
        }
    </style>
</head>
<body>
    <div class="logout-container">
        <div class="logout-icon">
            <i class="fas fa-sign-out-alt"></i>
        </div>

        <h1 class="logout-title">You've Been Logged Out</h1>
        <p class="logout-subtitle">Session Ended Successfully</p>

        <p class="logout-message">
            Your session has ended for security purposes. <strong>Please login again to access your profile and continue shopping.</strong>
        </p>

        <div class="highlight-box">
            <i class="fas fa-info-circle"></i>
            <span class="highlight-text">For your security, we automatically log you out after a period of inactivity.</span>
        </div>

        <div class="button-group">
            <a href="Home.html" class="login-btn">
                <i class="fas fa-sign-in-alt"></i>
                Login Again
            </a>

           
        </div>

        <p class="footer-text">
            <i class="fas fa-shield-alt"></i>
            Your account is secure
        </p>
    </div>
    
</body>
</html>