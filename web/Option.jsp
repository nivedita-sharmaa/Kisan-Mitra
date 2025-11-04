<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%
    // Prevent caching
    response.setHeader("Cache-Control", "no-cache, no-store, must-revalidate");
    response.setHeader("Pragma", "no-cache");
    response.setDateHeader("Expires", 0);
    response.setContentType("text/html; charset=UTF-8");
%>
<!DOCTYPE html>
<html lang="en">
<head>
    <meta charset="UTF-8">
    <meta http-equiv="Content-Type" content="text/html; charset=UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>Choose Your Role - KisanMitra</title>
    <style>
        * {
            margin: 0;
            padding: 0;
            box-sizing: border-box;
        }

        body {
            font-family: 'Segoe UI', Tahoma, Geneva, Verdana, sans-serif;
            min-height: 100vh;
            display: flex;
            justify-content: center;
            align-items: center;
            background: linear-gradient(135deg, #0f2027 0%, #203a43 50%, #2c5364 100%);
            padding: 20px;
        }

        .container {
            max-width: 1100px;
            width: 100%;
            padding: 60px 40px;
            background: rgba(255, 255, 255, 0.98);
            border-radius: 24px;
            box-shadow: 0 20px 60px rgba(0, 0, 0, 0.3);
        }

        .header {
            text-align: center;
            margin-bottom: 50px;
        }

        h1 {
            font-size: 2.5rem;
            color: #1a3a2e;
            margin-bottom: 12px;
            font-weight: 700;
        }

        .subtitle {
            font-size: 1.1rem;
            color: #666;
            margin-top: 10px;
        }

        .options {
            display: grid;
            grid-template-columns: repeat(auto-fit, minmax(280px, 1fr));
            gap: 40px;
            margin-top: 40px;
        }

        .option-form {
            background: white;
            border-radius: 20px;
            padding: 50px 30px;
            transition: transform 0.3s ease, box-shadow 0.3s ease;
            box-shadow: 0 10px 30px rgba(0, 0, 0, 0.1);
            border: 2px solid transparent;
            text-align: center;
        }

        .option-form:hover {
            transform: translateY(-8px);
            box-shadow: 0 15px 40px rgba(0, 0, 0, 0.2);
        }

        .option-form.farmer {
            border-color: #4CAF50;
        }

        .option-form.farmer:hover {
            background: #f1f8f4;
        }

        .option-form.buyer {
            border-color: #FF9800;
        }

        .option-form.buyer:hover {
            background: #fff8f0;
        }

        .icon-wrapper {
            width: 100px;
            height: 100px;
            margin: 0 auto 25px;
            display: flex;
            align-items: center;
            justify-content: center;
            border-radius: 50%;
        }

        .option-form.farmer .icon-wrapper {
            background: #4CAF50;
            box-shadow: 0 8px 25px rgba(76, 175, 80, 0.3);
        }

        .option-form.buyer .icon-wrapper {
            background: #FF9800;
            box-shadow: 0 8px 25px rgba(255, 152, 0, 0.3);
        }

        .icon {
            font-size: 50px;
            color: white;
            font-weight: bold;
        }
        
        .icon svg {
            width: 50px;
            height: 50px;
            fill: white;
        }

        .option-title {
            font-size: 1.8rem;
            color: #1a3a2e;
            margin-bottom: 15px;
            font-weight: 700;
        }

        .option-description {
            font-size: 1rem;
            color: #666;
            line-height: 1.6;
            margin-bottom: 25px;
        }

        .features {
            list-style: none;
            text-align: left;
            margin-top: 20px;
            margin-bottom: 25px;
        }

        .features li {
            padding: 8px 0;
            color: #555;
            font-size: 0.95rem;
            position: relative;
            padding-left: 25px;
        }

        .features li::before {
            content: '✓';
            position: absolute;
            left: 0;
            font-weight: bold;
            font-size: 1.2rem;
        }

        .option-form.farmer .features li::before {
            color: #4CAF50;
        }

        .option-form.buyer .features li::before {
            color: #FF9800;
        }

        .submit-btn {
            display: block;
            width: 100%;
            max-width: 250px;
            margin: 0 auto;
            padding: 14px 35px;
            border: none;
            border-radius: 30px;
            font-size: 1rem;
            font-weight: 600;
            color: white;
            text-align: center;
            text-transform: uppercase;
            letter-spacing: 0.5px;
            cursor: pointer;
            transition: transform 0.2s ease, box-shadow 0.2s ease;
        }

        .option-form.farmer .submit-btn {
            background: #4CAF50;
            box-shadow: 0 4px 15px rgba(76, 175, 80, 0.3);
        }

        .option-form.farmer .submit-btn:hover {
            background: #45a049;
            transform: translateY(-2px);
            box-shadow: 0 6px 20px rgba(76, 175, 80, 0.4);
        }

        .option-form.buyer .submit-btn {
            background: #FF9800;
            box-shadow: 0 4px 15px rgba(255, 152, 0, 0.3);
        }

        .option-form.buyer .submit-btn:hover {
            background: #f57c00;
            transform: translateY(-2px);
            box-shadow: 0 6px 20px rgba(255, 152, 0, 0.4);
        }

        .submit-btn:active {
            transform: translateY(0);
        }

        @media (max-width: 768px) {
            .container {
                padding: 40px 25px;
            }

            h1 {
                font-size: 2rem;
            }

            .options {
                gap: 30px;
            }

            .option-form {
                padding: 40px 25px;
            }
        }
    </style>
</head>
<body>
    <%
        String email = request.getParameter("email");
        String password = request.getParameter("password");
    %>
    
    <div class="container">
        <div class="header">
            <h1>Choose Your Role</h1>
            <p class="subtitle">Select how you want to continue</p>
        </div>

        <div class="options">
            <form action="FarmerLoginChecker" method="post" class="option-form farmer">
                <input type="hidden" value="<%=email%>" name="email">
                <input type="hidden" value="<%=password%>" name="password">
                
                <div class="icon-wrapper">
                    <div class="icon">
                        <svg xmlns="http://www.w3.org/2000/svg" viewBox="0 0 24 24" fill="none" stroke="currentColor" stroke-width="2" stroke-linecap="round" stroke-linejoin="round">
                            <path d="M12 22V8"/>
                            <path d="M6 12c0-3.5 2-6 6-6s6 2.5 6 6"/>
                            <path d="M6 12c0 3.5 2 6 6 6s6-2.5 6-6"/>
                            <path d="M9 8c0-1.5 1.5-3 3-3s3 1.5 3 3"/>
                        </svg>
                    </div>
                </div>
                <h2 class="option-title">I'm a Farmer</h2>
                <p class="option-description">
                    Sell your produce directly to buyers and get the best prices for your harvest
                </p>
                <ul class="features">
                    <li>List your products easily</li>
                    <li>Set your own prices</li>
                    <li>Connect with verified buyers</li>
                    <li>Track your sales in real-time</li>
                </ul>
                <button type="submit" class="submit-btn">Continue as Farmer</button>
            </form>

            <form action="BuyerLoginChecker" method="post" class="option-form buyer">
                <input type="hidden" value="<%=email%>" name="email">
                <input type="hidden" value="<%=password%>" name="password">
                
                <div class="icon-wrapper">
                    <div class="icon">
                        <svg xmlns="http://www.w3.org/2000/svg" viewBox="0 0 24 24" fill="none" stroke="currentColor" stroke-width="2" stroke-linecap="round" stroke-linejoin="round">
                            <circle cx="9" cy="21" r="1"/>
                            <circle cx="20" cy="21" r="1"/>
                            <path d="M1 1h4l2.68 13.39a2 2 0 0 0 2 1.61h9.72a2 2 0 0 0 2-1.61L23 6H6"/>
                        </svg>
                    </div>
                </div>
                <h2 class="option-title">I'm a Buyer</h2>
                <p class="option-description">
                    Source fresh produce directly from farmers at competitive prices
                </p>
                <ul class="features">
                    <li>Browse quality products</li>
                    <li>Compare prices easily</li>
                    <li>Connect with local farmers</li>
                    <li>Secure payment options</li>
                </ul>
                <button type="submit" class="submit-btn">Continue as Buyer</button>
            </form>
        </div>
    </div>
</body>
</html>