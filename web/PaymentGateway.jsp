
<%@ page import="db.DBConnector" %>
<%@ page import="java.sql.*" %>
<%@ page import="java.util.*" %>
<%@ page import="java.text.SimpleDateFormat" %>
<!DOCTYPE html>
<html lang="en">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>Farmer's Marketplace - Payment Gateway</title>
    <link href="https://cdnjs.cloudflare.com/ajax/libs/font-awesome/6.0.0-beta3/css/all.min.css" rel="stylesheet">
    <style>
        :root {
            --primary-color: #2e7d32;
            --secondary-color: #81c784;
            --accent-color: #f9a825;
            --accent-hover: #f57f17;
            --danger-color: #e53935;
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
        }
        
        .container {
            max-width: 1200px;
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
        
        .payment-container {
            background: var(--white);
            border-radius: var(--card-radius);
            box-shadow: var(--shadow);
            padding: 30px;
            margin-bottom: 30px;
            animation: fadeIn 0.8s ease-out forwards;
        }
        
        .page-title {
            color: var(--primary-color);
            margin-bottom: 20px;
            font-size: 1.8rem;
            border-bottom: 2px solid var(--secondary-color);
            padding-bottom: 10px;
        }
        
        .order-summary {
            background-color: rgba(129, 199, 132, 0.1);
            padding: 20px;
            border-radius: 10px;
            margin-bottom: 30px;
        }
        
        .summary-title {
            font-weight: 600;
            margin-bottom: 15px;
            color: var(--primary-color);
            font-size: 1.2rem;
        }
        
        .summary-row {
            display: flex;
            justify-content: space-between;
            padding: 8px 0;
            border-bottom: 1px dashed #ddd;
        }
        
        .summary-row:last-child {
            border-bottom: none;
        }
        
        .summary-label {
            font-weight: 500;
        }
        
        .summary-value {
            font-weight: 600;
        }
        
        .total-row {
            margin-top: 15px;
            padding-top: 15px;
            border-top: 2px solid #ddd;
            font-size: 1.2rem;
            font-weight: 700;
            color: var(--primary-color);
        }
        
        .payment-options {
            margin-bottom: 30px;
        }
        
        .payment-title {
            font-weight: 600;
            margin-bottom: 15px;
            color: var(--primary-color);
            font-size: 1.2rem;
        }
        
        .payment-methods {
            display: grid;
            grid-template-columns: repeat(auto-fill, minmax(150px, 1fr));
            gap: 15px;
            margin-bottom: 20px;
        }
        
        .payment-method {
            border: 2px solid #ddd;
            border-radius: 10px;
            padding: 15px;
            text-align: center;
            cursor: pointer;
            transition: all 0.3s ease;
        }
        
        .payment-method:hover {
            border-color: var(--secondary-color);
            transform: translateY(-3px);
            box-shadow: 0 5px 15px rgba(0, 0, 0, 0.1);
        }
        
        .payment-method.selected {
            border-color: var(--primary-color);
            background-color: rgba(46, 125, 50, 0.05);
        }
        
        .payment-icon {
            font-size: 2rem;
            margin-bottom: 10px;
            color: var(--text-color);
        }
        
        .payment-name {
            font-weight: 500;
        }
        
        .payment-form {
            display: none;
        }
        
        .payment-form.active {
            display: block;
            animation: fadeIn 0.5s ease-out forwards;
        }
        
        .form-group {
            margin-bottom: 20px;
        }
        
        .form-label {
            display: block;
            margin-bottom: 8px;
            font-weight: 500;
        }
        
        .form-input {
            width: 100%;
            padding: 12px 15px;
            border: 1px solid #ddd;
            border-radius: 8px;
            font-size: 1rem;
            transition: border 0.3s ease;
        }
        
        .form-input:focus {
            border-color: var(--secondary-color);
            outline: none;
        }
        
        .input-row {
            display: grid;
            grid-template-columns: 1fr 1fr;
            gap: 15px;
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
        }
        
        .btn-primary {
            background-color: var(--accent-color);
            color: white;
        }
        
        .btn-primary:hover {
            background-color: var(--accent-hover);
            transform: translateY(-2px);
        }
        
        .btn-secondary {
            background-color: #e0e0e0;
            color: var(--text-color);
        }
        
        .btn-secondary:hover {
            background-color: #d0d0d0;
        }
        
        .action-buttons {
            display: flex;
            justify-content: space-between;
            margin-top: 30px;
        }
        
        /* Overlay for Payment Processing */
        .overlay {
            position: fixed;
            top: 0;
            left: 0;
            width: 100%;
            height: 100%;
            background-color: rgba(0, 0, 0, 0.7);
            display: flex;
            justify-content: center;
            align-items: center;
            z-index: 1000;
            opacity: 0;
            visibility: hidden;
            transition: opacity 0.5s ease, visibility 0.5s ease;
        }
        
        .overlay.active {
            opacity: 1;
            visibility: visible;
        }
        
        .processing-box {
            background-color: var(--white);
            padding: 30px;
            border-radius: 15px;
            text-align: center;
            max-width: 500px;
            width: 90%;
        }
        
        .loader {
            border: 5px solid #f3f3f3;
            border-top: 5px solid var(--primary-color);
            border-radius: 50%;
            width: 50px;
            height: 50px;
            animation: spin 1s linear infinite;
            margin: 0 auto 20px;
        }
        
        .success-animation {
            width: 80px;
            height: 80px;
            margin: 0 auto 20px;
            border-radius: 50%;
            background-color: #eafaea;
            position: relative;
            display: none;
        }
        
        .checkmark {
            width: 40px;
            height: 40px;
            position: absolute;
            top: 50%;
            left: 50%;
            transform: translate(-50%, -50%);
            color: var(--success-color);
            font-size: 40px;
            display: none;
        }
        
        .processing-message {
            font-size: 1.2rem;
            margin-bottom: 15px;
            font-weight: 500;
        }
        
        .processing-details {
            color: #666;
            margin-bottom: 20px;
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
        
        @keyframes spin {
            0% { transform: rotate(0deg); }
            100% { transform: rotate(360deg); }
        }
        
        @keyframes checkScale {
            0% { transform: translate(-50%, -50%) scale(0); }
            50% { transform: translate(-50%, -50%) scale(1.2); }
            100% { transform: translate(-50%, -50%) scale(1); }
        }
        
        @keyframes boxScale {
            0% { transform: scale(0.8); opacity: 0; }
            50% { transform: scale(1.1); opacity: 1; }
            100% { transform: scale(1); opacity: 1; }
        }
        
        /* Responsiveness */
        @media (max-width: 768px) {
            .input-row {
                grid-template-columns: 1fr;
            }
            
            .payment-methods {
                grid-template-columns: repeat(auto-fill, minmax(120px, 1fr));
            }
            
            .action-buttons {
                flex-direction: column;
                gap: 15px;
            }
            
            .action-buttons .btn {
                width: 100%;
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
        
        // Get the trade and quantity data from the request
        String tradeIdStr = request.getParameter("tradeId");
        String quantityStr = request.getParameter("quantity");
        String priceStr = request.getParameter("price");
        
        int tradeId = 0;
        int quantity = 0;
        double price = 0.0;
        
        try {
            tradeId = Integer.parseInt(tradeIdStr);
            quantity = Integer.parseInt(quantityStr);
            price = Double.parseDouble(priceStr);
        } catch (NumberFormatException e) {
            // Error in parameters
        }
        
        // Get trade and farmer details from database
        String commodity = "";
        String origin = "";
        
        if (tradeId > 0) {
            try {
                Statement st = DBConnector.getStatement();
                String query = "SELECT commodity, origin FROM tradecreation WHERE id = " + tradeId;
                ResultSet rs = st.executeQuery(query);
                
                if (rs.next()) {
                    commodity = rs.getString("commodity");
                    origin = rs.getString("origin");
                }
            } catch (SQLException e) {
                out.println("<p style='color:red;'>SQL Error: " + e.getMessage() + "</p>");
            }
        }
        
        // Calculate totals
        double subtotal = price * quantity;
        double gst = subtotal * 0.05;
        double total = subtotal + gst;
        
        // Generate a random order ID
        String orderId = "ORD" + System.currentTimeMillis();
    %>

    <header>
        <div class="header-graphic">
            <svg xmlns="http://www.w3.org/2000/svg" viewBox="0 0 1440 320">
                <path fill="#ffffff" fill-opacity="1" d="M0,96L48,112C96,128,192,160,288,186.7C384,213,480,235,576,224C672,213,768,171,864,165.3C960,160,1056,192,1152,202.7C1248,213,1344,203,1392,197.3L1440,192L1440,320L1392,320C1344,320,1248,320,1152,320C1056,320,960,320,864,320C768,320,672,320,576,320C480,320,384,320,288,320C192,320,96,320,48,320L0,320Z"></path>
            </svg>
        </div>
        <div class="header-content">
            <h1><i class="fas fa-leaf"></i> Payment Gateway</h1>
            <p>Secure payment processing for your purchase</p>
        </div>
    </header>
    
    <div class="container">
        <div class="payment-container">
            <h2 class="page-title">Complete Your Purchase</h2>
            
            <div class="order-summary">
                <div class="summary-title">Order Summary</div>
                <div class="summary-row">
                    <div class="summary-label">Product:</div>
                    <div class="summary-value"><%= commodity %></div>
                </div>
                <div class="summary-row">
                    <div class="summary-label">Origin:</div>
                    <div class="summary-value"><%= origin %></div>
                </div>
                <div class="summary-row">
                    <div class="summary-label">Quantity:</div>
                    <div class="summary-value"><%= quantity %> MT</div>
                </div>
                <div class="summary-row">
                    <div class="summary-label">Price per MT:</div>
                    <div class="summary-value">Rs.<%= String.format("%,.2f", price) %></div>
                </div>
                <div class="summary-row">
                    <div class="summary-label">Subtotal:</div>
                    <div class="summary-value">Rs.<%= String.format("%,.2f", subtotal) %></div>
                </div>
                <div class="summary-row">
                    <div class="summary-label">GST (5%):</div>
                    <div class="summary-value">Rs.<%= String.format("%,.2f", gst) %></div>
                </div>
                <div class="summary-row total-row">
                    <div class="summary-label">Total:</div>
                    <div class="summary-value">Rs.<%= String.format("%,.2f", total) %></div>
                </div>
            </div>
            
            <div class="payment-options">
                <div class="payment-title">Select Payment Method</div>
                <div class="payment-methods">
                    <div class="payment-method" data-method="credit-card">
                        <div class="payment-icon"><i class="fas fa-credit-card"></i></div>
                        <div class="payment-name">Credit Card</div>
                    </div>
                    <div class="payment-method" data-method="debit-card">
                        <div class="payment-icon"><i class="fas fa-credit-card"></i></div>
                        <div class="payment-name">Debit Card</div>
                    </div>
                    <div class="payment-method" data-method="net-banking">
                        <div class="payment-icon"><i class="fas fa-university"></i></div>
                        <div class="payment-name">Net Banking</div>
                    </div>
                    <div class="payment-method" data-method="upi">
                        <div class="payment-icon"><i class="fas fa-mobile-alt"></i></div>
                        <div class="payment-name">UPI</div>
                    </div>
                    <div class="payment-method" data-method="wallet">
                        <div class="payment-icon"><i class="fas fa-wallet"></i></div>
                        <div class="payment-name">Wallet</div>
                    </div>
                </div>
                
                <!-- Credit Card Form -->
                <div class="payment-form" id="credit-card-form">
                    <div class="form-group">
                        <label class="form-label">Card Number</label>
                        <input type="text" class="form-input" placeholder="1234 5678 9012 3456" maxlength="19">
                    </div>
                    <div class="form-group">
                        <label class="form-label">Cardholder Name</label>
                        <input type="text" class="form-input" placeholder="Name on card">
                    </div>
                    <div class="input-row">
                        <div class="form-group">
                            <label class="form-label">Expiry Date</label>
                            <input type="text" class="form-input" placeholder="MM/YY" maxlength="5">
                        </div>
                        <div class="form-group">
                            <label class="form-label">CVV</label>
                            <input type="password" class="form-input" placeholder="123" maxlength="3">
                        </div>
                    </div>
                </div>
                
                <!-- Debit Card Form (same as credit card) -->
                <div class="payment-form" id="debit-card-form">
                    <div class="form-group">
                        <label class="form-label">Card Number</label>
                        <input type="text" class="form-input" placeholder="1234 5678 9012 3456" maxlength="19">
                    </div>
                    <div class="form-group">
                        <label class="form-label">Cardholder Name</label>
                        <input type="text" class="form-input" placeholder="Name on card">
                    </div>
                    <div class="input-row">
                        <div class="form-group">
                            <label class="form-label">Expiry Date</label>
                            <input type="text" class="form-input" placeholder="MM/YY" maxlength="5">
                        </div>
                        <div class="form-group">
                            <label class="form-label">CVV</label>
                            <input type="password" class="form-input" placeholder="123" maxlength="3">
                        </div>
                    </div>
                </div>
                
                <!-- Net Banking Form -->
                <div class="payment-form" id="net-banking-form">
                    <div class="form-group">
                        <label class="form-label">Select Bank</label>
                        <select class="form-input">
                            <option value="">Choose your bank</option>
                            <option value="sbi">State Bank of India</option>
                            <option value="hdfc">HDFC Bank</option>
                            <option value="icici">ICICI Bank</option>
                            <option value="axis">Axis Bank</option>
                            <option value="pnb">Punjab National Bank</option>
                            <option value="kotak">Kotak Mahindra Bank</option>
                        </select>
                    </div>
                </div>
                
                <!-- UPI Form -->
                <div class="payment-form" id="upi-form">
                    <div class="form-group">
                        <label class="form-label">UPI ID</label>
                        <input type="text" class="form-input" placeholder="yourname@upi">
                    </div>
                </div>
                
                <!-- Wallet Form -->
                <div class="payment-form" id="wallet-form">
                    <div class="form-group">
                        <label class="form-label">Select Wallet</label>
                        <select class="form-input">
                            <option value="">Choose your wallet</option>
                            <option value="paytm">Paytm</option>
                            <option value="phonepe">PhonePe</option>
                            <option value="gpay">Google Pay</option>
                            <option value="mobikwik">Mobikwik</option>
                            <option value="freecharge">Freecharge</option>
                        </select>
                    </div>
                    <div class="form-group">
                        <label class="form-label">Mobile Number</label>
                        <input type="text" class="form-input" placeholder="Your registered mobile number">
                    </div>
                </div>
            </div>
            
            <!-- Hidden form for processing -->
            <form action="PaymentSuccess.jsp" method="post" id="paymentForm">
                <input type="hidden" name="tradeId" value="<%= tradeId %>">
                <input type="hidden" name="quantity" value="<%= quantity %>">
                <input type="hidden" name="totalAmount" value="<%= total %>">
                <input type="hidden" name="paymentMethod" id="paymentMethodInput" value="">
                <input type="hidden" name="orderId" value="<%= orderId %>">
            </form>
            
            <div class="action-buttons">
                <a href="ViewTrades.jsp?id=<%= tradeId %>" class="btn btn-secondary">
                    <i class="fas fa-arrow-left"></i> Go Back
                </a>
                <button id="payNowBtn" class="btn btn-primary">
                    <i class="fas fa-lock"></i> Pay Now Rs.<%= String.format("%,.2f", total) %>
                </button>
            </div>
        </div>
    </div>
    
    <!-- Processing Overlay -->
    <div class="overlay" id="processingOverlay">
        <div class="processing-box">
            <div class="loader" id="paymentLoader"></div>
            <div class="success-animation" id="successAnimation">
                <i class="fas fa-check checkmark" id="checkmark"></i>
            </div>
            <h3 class="processing-message" id="processingMessage">Processing Payment...</h3>
            <p class="processing-details" id="processingDetails">Please wait while we securely process your payment. Do not refresh the page.</p>
            <button id="continueBtn" class="btn btn-primary" style="display: none;">
                Continue to Order Summary
            </button>
        </div>
    </div>

    <script>
        // Payment method selection
        const paymentMethods = document.querySelectorAll('.payment-method');
        const paymentForms = document.querySelectorAll('.payment-form');
        const payMethodInput = document.getElementById('paymentMethodInput');
        
        paymentMethods.forEach(method => {
            method.addEventListener('click', function() {
                // Remove selected class from all methods
                paymentMethods.forEach(m => m.classList.remove('selected'));
                
                // Add selected class to clicked method
                this.classList.add('selected');
                
                // Hide all forms
                paymentForms.forEach(form => form.classList.remove('active'));
                
                // Show selected form
                const methodName = this.getAttribute('data-method');
                document.getElementById(methodName + '-form').classList.add('active');
                
                // Update form value
                payMethodInput.value = methodName;
            });
        });
        
        // Select credit card by default
        document.querySelector('[data-method="credit-card"]').click();
        
        // Pay Now button handler
        document.getElementById('payNowBtn').addEventListener('click', function() {
            // Show overlay
            document.getElementById('processingOverlay').classList.add('active');
            
            // Simulate payment processing
            setTimeout(function() {
                // Hide loader
                document.getElementById('paymentLoader').style.display = 'none';
                
                // Show success animation
                const successAnim = document.getElementById('successAnimation');
                successAnim.style.display = 'block';
                successAnim.style.animation = 'boxScale 0.5s forwards';
                
                // Show checkmark with animation
                const checkmark = document.getElementById('checkmark');
                checkmark.style.display = 'block';
                checkmark.style.animation = 'checkScale 0.5s forwards';
                
                // Update messages
                document.getElementById('processingMessage').textContent = 'Payment Successful!';
                document.getElementById('processingDetails').textContent = 'Your order has been placed successfully. You will receive a confirmation shortly.';
                
                // Show continue button
                const continueBtn = document.getElementById('continueBtn');
                continueBtn.style.display = 'inline-block';
                
                // Set up continue button to submit form
                continueBtn.addEventListener('click', function() {
                    document.getElementById('paymentForm').submit();
                });
                
            }, 3000); // 3 seconds of "processing"
        });
    </script>
</body>
</html>