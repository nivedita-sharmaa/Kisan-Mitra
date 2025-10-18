<%@ include file="SessionValidator.jsp" %>
<%@ page import="java.time.LocalDateTime" %>
<%@ page import="java.time.format.DateTimeFormatter" %>
<%@ page import="java.util.*" %>

<%
    response.setHeader("Cache-Control", "no-cache, no-store, must-revalidate");
    
    // Get selected farmer email
    String selectedFarmerEmail = request.getParameter("farmer_email");
    
    // Generate order ID and date
    String orderId = "ORD" + System.currentTimeMillis();
    String orderDate = LocalDateTime.now().format(DateTimeFormatter.ofPattern("dd MMM yyyy, hh:mm a"));
    
    // Get farmer orders from session
    Map<String, List<Map<String, Object>>> farmerOrders = 
        (Map<String, List<Map<String, Object>>>) session.getAttribute("farmerOrders");
    Map<String, Map<String, Object>> farmerDetails = 
        (Map<String, Map<String, Object>>) session.getAttribute("farmerDetails");
    
    // Get only the selected farmer's items
    List<Map<String, Object>> selectedItems = farmerOrders.get(selectedFarmerEmail);
    Map<String, Object> selectedFarmer = farmerDetails.get(selectedFarmerEmail);
    
    // Calculate total for selected farmer
    double totalAmount = 0.0;
    for (Map<String, Object> item : selectedItems) {
        totalAmount += (Double) item.get("total");
    }
    
    // Store in session for receipt
    session.setAttribute("orderId", orderId);
    session.setAttribute("orderDate", orderDate);
    session.setAttribute("orderItems", selectedItems);
    session.setAttribute("totalAmount", totalAmount);
    session.setAttribute("currentFarmer", selectedFarmer);
%>

<!DOCTYPE html>
<html lang="en">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>Processing Payment - Kisan Mitra</title>
    <link href="https://cdnjs.cloudflare.com/ajax/libs/font-awesome/6.0.0-beta3/css/all.min.css" rel="stylesheet">
    <style>
        * {
            margin: 0;
            padding: 0;
            box-sizing: border-box;
            font-family: -apple-system, BlinkMacSystemFont, 'Segoe UI', Roboto, sans-serif;
        }
        
        body {
            background: linear-gradient(135deg, #667eea 0%, #764ba2 100%);
            min-height: 100vh;
            display: flex;
            align-items: center;
            justify-content: center;
            overflow: hidden;
        }
        
        .payment-container {
            text-align: center;
            color: white;
            position: relative;
            z-index: 10;
        }
        
        .payment-icon {
            font-size: 5rem;
            margin-bottom: 30px;
            animation: pulse 1.5s infinite;
        }
        
        .payment-title {
            font-size: 2.5rem;
            font-weight: 800;
            margin-bottom: 15px;
        }
        
        .payment-subtitle {
            font-size: 1.2rem;
            opacity: 0.9;
            margin-bottom: 40px;
        }
        
        .progress-bar {
            width: 400px;
            height: 8px;
            background: rgba(255, 255, 255, 0.3);
            border-radius: 10px;
            overflow: hidden;
            margin: 0 auto;
        }
        
        .progress-fill {
            height: 100%;
            background: white;
            border-radius: 10px;
            animation: fillProgress 3s ease-out forwards;
        }
        
        .processing-steps {
            margin-top: 40px;
            display: flex;
            flex-direction: column;
            gap: 15px;
        }
        
        .step {
            display: flex;
            align-items: center;
            justify-content: center;
            gap: 15px;
            opacity: 0;
            transform: translateX(-20px);
        }
        
        .step.active {
            animation: slideIn 0.5s forwards;
        }
        
        .step-icon {
            width: 30px;
            height: 30px;
            border-radius: 50%;
            background: white;
            color: #667eea;
            display: flex;
            align-items: center;
            justify-content: center;
            font-weight: bold;
        }
        
        .step-text {
            font-size: 1.1rem;
        }
        
        /* Background Animation */
        .circles {
            position: fixed;
            top: 0;
            left: 0;
            width: 100%;
            height: 100%;
            overflow: hidden;
            z-index: 1;
        }
        
        .circles li {
            position: absolute;
            display: block;
            list-style: none;
            width: 20px;
            height: 20px;
            background: rgba(255, 255, 255, 0.2);
            animation: float 25s infinite;
            bottom: -150px;
        }
        
        .circles li:nth-child(1) {
            left: 25%;
            width: 80px;
            height: 80px;
            animation-delay: 0s;
        }
        
        .circles li:nth-child(2) {
            left: 10%;
            width: 20px;
            height: 20px;
            animation-delay: 2s;
            animation-duration: 12s;
        }
        
        .circles li:nth-child(3) {
            left: 70%;
            width: 20px;
            height: 20px;
            animation-delay: 4s;
        }
        
        .circles li:nth-child(4) {
            left: 40%;
            width: 60px;
            height: 60px;
            animation-delay: 0s;
            animation-duration: 18s;
        }
        
        .circles li:nth-child(5) {
            left: 65%;
            width: 20px;
            height: 20px;
            animation-delay: 0s;
        }
        
        .circles li:nth-child(6) {
            left: 75%;
            width: 110px;
            height: 110px;
            animation-delay: 3s;
        }
        
        .circles li:nth-child(7) {
            left: 35%;
            width: 150px;
            height: 150px;
            animation-delay: 7s;
        }
        
        .circles li:nth-child(8) {
            left: 50%;
            width: 25px;
            height: 25px;
            animation-delay: 15s;
            animation-duration: 45s;
        }
        
        .circles li:nth-child(9) {
            left: 20%;
            width: 15px;
            height: 15px;
            animation-delay: 2s;
            animation-duration: 35s;
        }
        
        .circles li:nth-child(10) {
            left: 85%;
            width: 150px;
            height: 150px;
            animation-delay: 0s;
            animation-duration: 11s;
        }
        
        @keyframes pulse {
            0%, 100% {
                transform: scale(1);
                opacity: 1;
            }
            50% {
                transform: scale(1.1);
                opacity: 0.8;
            }
        }
        
        @keyframes fillProgress {
            from {
                width: 0%;
            }
            to {
                width: 100%;
            }
        }
        
        @keyframes slideIn {
            to {
                opacity: 1;
                transform: translateX(0);
            }
        }
        
        @keyframes float {
            0% {
                transform: translateY(0) rotate(0deg);
                opacity: 1;
                border-radius: 0;
            }
            100% {
                transform: translateY(-1000px) rotate(720deg);
                opacity: 0;
                border-radius: 50%;
            }
        }
        
        @media (max-width: 768px) {
            .payment-title {
                font-size: 2rem;
            }
            
            .progress-bar {
                width: 300px;
            }
        }
    </style>
</head>
<body>
    <ul class="circles">
        <li></li>
        <li></li>
        <li></li>
        <li></li>
        <li></li>
        <li></li>
        <li></li>
        <li></li>
        <li></li>
        <li></li>
    </ul>

    <div class="payment-container">
        <div class="payment-icon">
            <i class="fas fa-credit-card"></i>
        </div>
        
        <h1 class="payment-title">Processing Payment</h1>
        <p class="payment-subtitle">Please wait while we process your transaction...</p>
        
        <div class="progress-bar">
            <div class="progress-fill"></div>
        </div>
        
        <div class="processing-steps">
            <div class="step" id="step1">
                <div class="step-icon"><i class="fas fa-check"></i></div>
                <div class="step-text">Verifying payment details</div>
            </div>
            <div class="step" id="step2">
                <div class="step-icon"><i class="fas fa-check"></i></div>
                <div class="step-text">Connecting to payment gateway</div>
            </div>
            <div class="step" id="step3">
                <div class="step-icon"><i class="fas fa-check"></i></div>
                <div class="step-text">Processing transaction</div>
            </div>
            <div class="step" id="step4">
                <div class="step-icon"><i class="fas fa-check"></i></div>
                <div class="step-text">Confirming order</div>
            </div>
        </div>
    </div>
    
    <script>
        // Animate steps
        setTimeout(() => document.getElementById('step1').classList.add('active'), 500);
        setTimeout(() => document.getElementById('step2').classList.add('active'), 1200);
        setTimeout(() => document.getElementById('step3').classList.add('active'), 2000);
        setTimeout(() => document.getElementById('step4').classList.add('active'), 2700);
        
        // Redirect to receipt after animation
        setTimeout(() => {
            window.location.href = 'PaymentReceipt.jsp';
        }, 3500);
    </script>
</body>
</html>