<%@ page import="db.DBConnector" %>
<%@ page import="java.sql.*" %>
<%@ page import="java.text.SimpleDateFormat" %>
<%@ page import="java.util.Date" %>
<!DOCTYPE html>
<html lang="en">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>Farmer's Marketplace - Payment Success</title>
    <link href="https://cdnjs.cloudflare.com/ajax/libs/font-awesome/6.0.0-beta3/css/all.min.css" rel="stylesheet">
    <style>
        :root {
            --primary-color: #2e7d32;
            --secondary-color: #81c784;
            --accent-color: #f9a825;
            --success-color: #43a047;
            --text-color: #333;
            --light-bg: #f5f5f5;
            --white: #fff;
            --shadow: 0 4px 6px rgba(0, 0, 0, 0.1);
            --card-radius: 12px;
        }
        
        * {
            margin: 0;
            padding: 0;
            box-sizing: border-box;
            font-family: 'Segoe UI', Tahoma, Geneva, Verdana, sans-serif;
        }
        
        body {
            background: linear-gradient(135deg, #f5f7fa 0%, #e4e9f2 100%);
            color: var(--text-color);
            line-height: 1.6;
            padding: 0;
            margin: 0;
            min-height: 100vh;
            overflow-x: hidden;
        }
        
        .container {
            max-width: 1000px;
            margin: 0 auto;
            padding: 20px;
        }
        
        header {
            background: linear-gradient(135deg, #1a2a6c, #b21f1f, #fdbb2d);
            color: var(--white);
            padding: 20px 0;
            text-align: center;
            margin-bottom: 30px;
            box-shadow: var(--shadow);
            position: relative;
            overflow: hidden;
        }
        
        header h1 {
            margin: 0;
            font-size: 2.5rem;
            animation: fadeInDown 1s ease-out;
        }
        
        header p {
            font-size: 1.2rem;
            opacity: 0.9;
            margin-top: 10px;
            animation: fadeInUp 1s ease-out;
        }
        
        .header-graphic {
            position: absolute;
            width: 100%;
            height: 100%;
            top: 0;
            left: 0;
            overflow: hidden;
            z-index: 0;
        }
        
        .header-graphic svg {
            position: absolute;
            bottom: -20px;
            left: 0;
            width: 100%;
            height: auto;
            opacity: 0.1;
        }
        
        .header-content {
            position: relative;
            z-index: 1;
        }
        
        .success-container {
            background: var(--white);
            border-radius: var(--card-radius);
            box-shadow: var(--shadow);
            padding: 30px;
            margin-bottom: 30px;
            text-align: center;
            animation: fadeIn 0.8s ease-out forwards;
            position: relative;
            overflow: hidden;
        }
        
        .success-icon {
            width: 100px;
            height: 100px;
            margin: 0 auto 30px;
            background-color: rgba(67, 160, 71, 0.1);
            border-radius: 50%;
            display: flex;
            justify-content: center;
            align-items: center;
            animation: pulseAnimation 2s infinite;
        }
        
        .success-icon i {
            font-size: 50px;
            color: var(--success-color);
        }
        
        .confetti-container {
            position: absolute;
            top: 0;
            left: 0;
            width: 100%;
            height: 100%;
            overflow: hidden;
            pointer-events: none;
        }
        
        .confetti {
            position: absolute;
            width: 10px;
            height: 10px;
            opacity: 0;
        }
        
        .success-title {
            font-size: 2rem;
            color: var(--success-color);
            margin-bottom: 15px;
            font-weight: 700;
        }
        
        .success-message {
            font-size: 1.2rem;
            margin-bottom: 30px;
            color: #555;
        }
        
        .order-details {
            background-color: var(--light-bg);
            border-radius: 10px;
            padding: 20px;
            margin-bottom: 30px;
            text-align: left;
        }
        
        .detail-row {
            display: grid;
            grid-template-columns: 1fr 1fr;
            padding: 12px 0;
            border-bottom: 1px dashed #ddd;
        }
        
        .detail-row:last-child {
            border-bottom: none;
        }
        
        .detail-label {
            font-weight: 600;
            color: #555;
        }
        
        .order-id {
            background-color: rgba(46, 125, 50, 0.1);
            padding: 5px 10px;
            border-radius: 5px;
            color: var(--primary-color);
            font-weight: 600;
            letter-spacing: 1px;
        }
        
        .action-buttons {
            display: flex;
            justify-content: center;
            gap: 20px;
            margin-top: 30px;
        }
        
        .btn {
            padding: 12px 25px;
            border: none;
            border-radius: 8px;
            font-size: 1rem;
            font-weight: 600;
            cursor: pointer;
            transition: all 0.3s ease;
            display: inline-flex;
            align-items: center;
            justify-content: center;
            gap: 10px;
            text-decoration: none;
        }
        
        .btn-primary {
            background-color: var(--primary-color);
            color: white;
        }
        
        .btn-primary:hover {
            background-color: #1b5e20;
            transform: translateY(-2px);
            box-shadow: 0 4px 12px rgba(27, 94, 32, 0.3);
        }
        
        .btn-secondary {
            background-color: var(--accent-color);
            color: white;
        }
        
        .btn-secondary:hover {
            background-color: #f57f17;
            transform: translateY(-2px);
            box-shadow: 0 4px 12px rgba(245, 127, 23, 0.3);
        }
        
        .contract-info {
            margin-top: 30px;
            padding: 20px;
            background-color: #e8f5e9;
            border-radius: 10px;
            border-left: 5px solid var(--primary-color);
        }
        
        .contract-title {
            font-weight: 600;
            margin-bottom: 10px;
            color: var(--primary-color);
        }
        
        /* Animations */
        @keyframes fadeIn {
            from {
                opacity: 0;
                transform: translateY(20px);
            }
            to {
                opacity: 1;
                transform: translateY(0);
            }
        }
        
        @keyframes fadeInDown {
            from {
                opacity: 0;
                transform: translateY(-20px);
            }
            to {
                opacity: 1;
                transform: translateY(0);
            }
        }
        
        @keyframes fadeInUp {
            from {
                opacity: 0;
                transform: translateY(20px);
            }
            to {
                opacity: 1;
                transform: translateY(0);
            }
        }
        
        @keyframes pulseAnimation {
            0% {
                box-shadow: 0 0 0 0 rgba(67, 160, 71, 0.4);
            }
            70% {
                box-shadow: 0 0 0 15px rgba(67, 160, 71, 0);
            }
            100% {
                box-shadow: 0 0 0 0 rgba(67, 160, 71, 0);
            }
        }
        
        /* Confetti animation */
        @keyframes confettiDrop {
            0% {
                transform: translateY(-50px) rotate(0deg);
                opacity: 1;
            }
            100% {
                transform: translateY(1000px) rotate(360deg);
                opacity: 0;
            }
        }
        
        /* Responsiveness */
        @media (max-width: 768px) {
            .detail-row {
                grid-template-columns: 1fr;
                gap: 5px;
            }
            
            .action-buttons {
                flex-direction: column;
            }
            
            .success-icon {
                width: 80px;
                height: 80px;
            }
            
            .success-icon i {
                font-size: 40px;
            }
        }
    </style>
</head>
<body>
    <%
        // Get user information for the header
        String userName = (String) session.getAttribute("userName");
        if (userName == null) {
            userName = "Guest";
        }
        
        // Get the order details from the request parameters
        String tradeIdStr = request.getParameter("tradeId");
        String quantityStr = request.getParameter("quantity");
        String totalAmountStr = request.getParameter("totalAmount");
        String paymentMethod = request.getParameter("paymentMethod");
        String orderId = request.getParameter("orderId");
        
        int tradeId = 0;
        int quantity = 0;
        double totalAmount = 0.0;
        
        try {
            tradeId = Integer.parseInt(tradeIdStr);
            quantity = Integer.parseInt(quantityStr);
            totalAmount = Double.parseDouble(totalAmountStr);
        } catch (NumberFormatException e) {
            // Error in parameters
        }
        
        // Get trade details from database
        String commodity = "";
        String origin = "";
        String farmerName = "";
        
        if (tradeId > 0) {
            try {
                Statement st = DBConnector.getStatement();
                
                // Get commodity and origin
                String tradeQuery = "SELECT commodity, origin FROM tradecreation WHERE id = " + tradeId;
                ResultSet rs = st.executeQuery(tradeQuery);
                
                if (rs.next()) {
                    commodity = rs.getString("commodity");
                    origin = rs.getString("origin");
                }
                
                // Get farmer name
//                String farmerQuery = "SELECT fname FROM farmerregistration WHERE id = " + tradeId;
//                ResultSet farmerRs = st.executeQuery(farmerQuery);
//                
//                if (farmerRs.next()) {
//                    farmerName = farmerRs.getString("fname");
//                }
//                
                // Create contract record in database
                String contractId = "CTR" + System.currentTimeMillis();
                SimpleDateFormat sdf = new SimpleDateFormat("yyyy-MM-dd HH:mm:ss");
                String currentDate = sdf.format(new Date());
                
                //String insertQuery = "INSERT INTO tradecontract (contract_id, trade_id, buyer, seller, commodity, quantity, total_amount, payment_method, order_id, contract_date) " +
                                   // "VALUES ('" + contractId + "', " + tradeId + ", '" + userName + "', '" + farmerName + "', '" + 
                                   // commodity + "', " + quantity + ", " + totalAmount + ", '" + paymentMethod + "', '" + orderId + "', '" + currentDate + "')";
                
               // st.executeUpdate(insertQuery);
                
                // Update trade quantity
                String updateQuery = "UPDATE tradecreation SET quantity = quantity - " + quantity + " WHERE id = " + tradeId;
                st.executeUpdate(updateQuery);
                
            } catch (SQLException e) {
                out.println("<p style='color:red;'>SQL Error: " + e.getMessage() + "</p>");
            }
        }
        
        // Format payment date
        SimpleDateFormat dateFormat = new SimpleDateFormat("dd MMM yyyy, HH:mm:ss");
        String paymentDate = dateFormat.format(new Date());
        
        // Format payment method for display
        String formattedPaymentMethod = "";
        if (paymentMethod != null) {
            switch(paymentMethod) {
                case "credit-card":
                    formattedPaymentMethod = "Credit Card";
                    break;
                case "debit-card":
                    formattedPaymentMethod = "Debit Card";
                    break;
                case "net-banking":
                    formattedPaymentMethod = "Net Banking";
                    break;
                case "upi":
                    formattedPaymentMethod = "UPI";
                    break;
                case "wallet":
                    formattedPaymentMethod = "Digital Wallet";
                    break;
                default:
                    formattedPaymentMethod = paymentMethod;
            }
        }
        
        // Generate a random transaction ID
        String transactionId = "TXN" + System.currentTimeMillis();
        
        // Generate estimated delivery date (7 days from now)
        SimpleDateFormat deliveryFormat = new SimpleDateFormat("dd MMM yyyy");
        Date currentDate = new Date();
        Date deliveryDate = new Date(currentDate.getTime() + (7 * 24 * 60 * 60 * 1000));
        String estimatedDelivery = deliveryFormat.format(deliveryDate);
    %>

    <header>
        <div class="header-graphic">
            <svg xmlns="http://www.w3.org/2000/svg" viewBox="0 0 1440 320">
                <path fill="#ffffff" fill-opacity="1" d="M0,96L48,112C96,128,192,160,288,186.7C384,213,480,235,576,224C672,213,768,171,864,165.3C960,160,1056,192,1152,202.7C1248,213,1344,203,1392,197.3L1440,192L1440,320L1392,320C1344,320,1248,320,1152,320C1056,320,960,320,864,320C768,320,672,320,576,320C480,320,384,320,288,320C192,320,96,320,48,320L0,320Z"></path>
            </svg>
        </div>
        <div class="header-content">
            <h1><i class="fas fa-check-circle"></i> Payment Successful</h1>
            <p>Your transaction has been processed successfully</p>
        </div>
    </header>
    
    <div class="container">
        <div class="success-container">
            <div class="confetti-container" id="confettiContainer"></div>
            
            <div class="success-icon">
                <i class="fas fa-check"></i>
            </div>
            
            <h2 class="success-title">Thank You for Your Purchase!</h2>
            <p class="success-message">Your payment has been successfully processed and your order has been confirmed.</p>
            
            <div class="order-details">
                <div class="detail-row">
                    <div class="detail-label">Order ID:</div>
                    <div class="detail-value"><span class="order-id"><%= orderId %></span></div>
                </div>
                <div class="detail-row">
                    <div class="detail-label">Transaction ID:</div>
                    <div class="detail-value"><%= transactionId %></div>
                </div>
                <div class="detail-row">
                    <div class="detail-label">Product:</div>
                    <div class="detail-value"><%= commodity %> from <%= origin %></div>
                </div>
                <div class="detail-row">
                    <div class="detail-label">Quantity:</div>
                    <div class="detail-value"><%= quantity %> MT</div>
                </div>
                <div class="detail-row">
                    <div class="detail-label">Amount Paid:</div>
                    <div class="detail-value">Rs.<%= String.format("%,.2f", totalAmount) %></div>
                </div>
                <div class="detail-row">
                    <div class="detail-label">Payment Method:</div>
                    <div class="detail-value"><%= formattedPaymentMethod %></div>
                </div>
                <div class="detail-row">
                    <div class="detail-label">Payment Date:</div>
                    <div class="detail-value"><%= paymentDate %></div>
                </div>
                <div class="detail-row">
                    <div class="detail-label">Estimated Delivery:</div>
                    <div class="detail-value"><%= estimatedDelivery %></div>
                </div>
            </div>
            
            
            
                            <a href="ViewTrades.jsp" class="btn btn-secondary">
                    <i class="fas fa-shopping-cart"></i> Continue Shopping
                </a>
            </div>
        </div>
    </div>

    <script>
        // Create and animate confetti
        function createConfetti() {
            const container = document.getElementById('confettiContainer');
            const colors = ['#2e7d32', '#81c784', '#f9a825', '#ff8a65', '#64b5f6', '#ba68c8'];
            const confettiCount = 100;
            
            for (let i = 0; i < confettiCount; i++) {
                const confetti = document.createElement('div');
                confetti.className = 'confetti';
                
                // Random positioning
                const left = Math.random() * 100;
                
                // Random color
                const color = colors[Math.floor(Math.random() * colors.length)];
                
                // Random size
                const size = Math.random() * 10 + 5;
                
                // Random rotation
                const rotation = Math.random() * 360;
                
                // Random animation duration
                const duration = Math.random() * 3 + 2;
                
                // Random animation delay
                const delay = Math.random() * 1.5;
                
                // Apply styles
                confetti.style.left = left + '%';
                confetti.style.width = size + 'px';
                confetti.style.height = size + 'px';
                confetti.style.backgroundColor = color;
                confetti.style.transform = `rotate(${rotation}deg)`;
                confetti.style.animation = `confettiDrop ${duration}s ease-in ${delay}s forwards`;
                
                container.appendChild(confetti);
            }
        }
        
        // Run confetti animation on page load
        window.addEventListener('load', function() {
            createConfetti();
            
            // Create more confetti every few seconds
            setInterval(createConfetti, 3000);
        });
    </script>
</body>
</html>