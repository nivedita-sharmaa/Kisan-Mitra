<%@page import="db.DBConnector"%>
<%@page import="java.sql.Statement"%>
<%@page import="java.sql.ResultSet"%>
<%@page import="java.sql.SQLException"%>
<%@page contentType="text/html" pageEncoding="UTF-8"%>
<!DOCTYPE html>
<html lang="en">
<head>
  <meta charset="UTF-8" />
  <meta name="viewport" content="width=device-width, initial-scale=1.0"/>
  <title>Kisan Mitra - Trade Creation</title>
  <link href="https://fonts.googleapis.com/css2?family=Poppins:wght@400;600&display=swap" rel="stylesheet">
  <style>
    * {
      box-sizing: border-box;
      margin: 0;
      padding: 0;
      font-family: 'Poppins', sans-serif;
    }
    body {
      background: linear-gradient(135deg, #1a2a6c, #b21f1f, #fdbb2d);
      min-height: 100vh;
      display: flex;
      justify-content: center;
      align-items: center;
      padding: 40px;
    }
    .container {
      background: #fff8f0;
      padding: 40px;
      border-radius: 20px;
      box-shadow: 0 10px 25px rgba(0,0,0,0.15);
      max-width: 600px;
      width: 100%;
      animation: fadeIn 0.8s ease;
    }
    h2 {
      text-align: center;
      color: #e65c00;
      margin-bottom: 25px;
    }
    label {
      display: block;
      margin-top: 20px;
      font-weight: 600;
      color: #333;
    }
    input[type="text"],
    input[type="number"],
    input[type="file"] {
      width: 100%;
      padding: 12px;
      margin-top: 8px;
      border: 1px solid #ccc;
      border-radius: 10px;
      font-size: 15px;
    }
    button {
      margin-top: 30px;
      width: 100%;
      padding: 15px;
      font-size: 16px;
      font-weight: bold;
      color: white;
      background: linear-gradient(90deg, #6BBF59, #D4A017);
      border: none;
      border-radius: 30px;
      cursor: pointer;
      transition: transform 0.3s ease, box-shadow 0.3s ease;
    }
    button:hover {
      transform: translateY(-4px);
      box-shadow: 0 8px 16px rgba(0,0,0,0.2);
    }
    @keyframes fadeIn {
      from { opacity: 0; transform: translateY(20px); }
      to { opacity: 1; transform: translateY(0); }
    }
    
    /* Chrome, Safari, Edge, Opera */
    input[type=number]::-webkit-inner-spin-button,
    input[type=number]::-webkit-outer-spin-button {
      -webkit-appearance: none;
      margin: 0;
    }
    /* Firefox */
    input[type=number] {
      -moz-appearance: textfield;
    }
  </style>
</head>
<body>
  <div class="container">
    <h2>Trade Creation - Kisan Mitra</h2>
    <form action="CreateTrade" method="post" enctype="multipart/form-data">
      <label for="commodity">Select Commodity *</label>
      <input type="text" id="commodity" name="commodity" placeholder="e.g. Apple, Cashew Nuts" required>
      <label for="origin">Origin of Commodity *</label>
      <input type="text" id="origin" name="origin" placeholder="e.g. Delhi, Haryana" required>
      <label for="quantity">Commodity Quantity (MT) *</label>
      <input type="number" id="quantity" name="quantity" placeholder="e.g. 100, 500, 2000" required>
      <label for="price">Indicative Buying Price (₹) *</label>
      <input type="number" id="price" name="price" placeholder="e.g. 200, 6000" required>
      <label for="image">Upload Commodity Image *</label>
      <input type="file" id="image" name="image" accept="image/*" required>
      <button type="submit" href="TradeMsg.jsp">Proceed</button>
    </form>
  </div>
</body>
</html>