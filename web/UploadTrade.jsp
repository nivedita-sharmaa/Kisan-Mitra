<%@ include file="SessionValidator.jsp" %>
<%@page import="db.DBConnector"%>
<%@page contentType="text/html" pageEncoding="UTF-8"%>

<%
    // Check if user is logged in
    String farmerEmail = (String) session.getAttribute("email");
    if (farmerEmail == null || farmerEmail.isEmpty()) {
        response.sendRedirect("Login.jsp?redirect=UploadTrade.jsp");
        return;
    }
%>

<!DOCTYPE html>
<html lang="en">
<head>
  <meta charset="UTF-8" />
  <meta name="viewport" content="width=device-width, initial-scale=1.0"/>
  <title>Kisan Mitra - Upload Trade</title>

  <!-- Fonts & Icons -->
  <link href="https://fonts.googleapis.com/css2?family=Poppins:wght@400;600;700&display=swap" rel="stylesheet">
  <link href="https://cdnjs.cloudflare.com/ajax/libs/font-awesome/6.0.0-beta3/css/all.min.css" rel="stylesheet">

  <style>
    * { margin: 0; padding: 0; box-sizing: border-box; font-family: 'Poppins', sans-serif; }

    body {
      background: linear-gradient(135deg, #667eea 0%, #764ba2 100%);
      min-height: 100vh;
      display: flex;
      flex-direction: column;
    }

    /* Navbar (matches FarmerDashboard.jsp) */
    .navbar {
      background: rgba(26, 42, 108, 0.95);
      padding: 15px 30px;
      position: sticky;
      top: 0;
      z-index: 1000;
      box-shadow: 0 2px 15px rgba(0,0,0,0.2);
    }
    .nav-container {
      max-width: 1200px;
      margin: 0 auto;
      display: flex;
      justify-content: space-between;
      align-items: center;
    }
    .nav-brand {
      color: white;
      font-size: 1.8rem;
      font-weight: bold;
      text-decoration: none;
      display: flex;
      align-items: center;
      gap: 10px;
    }
    .nav-menu {
      list-style: none;
      display: flex;
      gap: 25px;
      align-items: center;
    }
    .nav-menu a {
      color: white;
      text-decoration: none;
      font-weight: 500;
      transition: 0.3s;
      display: flex;
      align-items: center;
      gap: 8px;
    }
    .nav-menu a:hover {
      color: #ffd700;
      transform: translateY(-2px);
    }
    .logout-btn {
      background: #f44336;
      padding: 8px 16px;
      border-radius: 20px;
    }
    .logout-btn:hover {
      background: #d32f2f;
      transform: scale(1.05);
    }

    /* Main Section */
    .main-content {
      flex: 1;
      display: flex;
      justify-content: center;
      align-items: center;
      padding: 40px 20px;
    }

    .container {
      background: white;
      border-radius: 20px;
      padding: 50px;
      max-width: 700px;
      width: 100%;
      box-shadow: 0 20px 60px rgba(0,0,0,0.3);
      animation: slideUp 0.8s ease;
    }

    .form-header {
      text-align: center;
      margin-bottom: 40px;
    }
    .form-header h2 {
      font-size: 2rem;
      color: #1a2a6c;
      font-weight: 700;
    }
    .form-header p {
      color: #666;
      margin-top: 10px;
      font-size: 0.95rem;
    }

    /* Input Styles */
    .form-group {
      margin-bottom: 25px;
    }
    label {
      display: block;
      margin-bottom: 8px;
      font-weight: 600;
      color: #1a2a6c;
    }
    .required { color: red; }

    input[type="text"], input[type="number"], select, input[type="file"] {
      width: 100%;
      padding: 14px 16px;
      border: 2px solid #e0e0e0;
      border-radius: 12px;
      background: #fafafa;
      font-size: 15px;
      transition: all 0.3s ease;
    }
    input:focus, select:focus {
      border-color: #667eea;
      background: #fff;
      box-shadow: 0 0 0 3px rgba(102,126,234,0.1);
      outline: none;
    }
    select {
      cursor: pointer;
      appearance: none;
      background-image: url("data:image/svg+xml,%3Csvg xmlns='http://www.w3.org/2000/svg' width='12' height='12' viewBox='0 0 12 12'%3E%3Cpath fill='%23333' d='M6 9L1 4h10z'/%3E%3C/svg%3E");
      background-repeat: no-repeat;
      background-position: right 16px center;
      padding-right: 40px;
    }

    input[type="file"] {
      background: #f8f8f8;
      cursor: pointer;
    }
    input[type="file"]::-webkit-file-upload-button {
      background: linear-gradient(90deg, #667eea, #764ba2);
      border: none;
      border-radius: 10px;
      color: white;
      padding: 10px 20px;
      cursor: pointer;
      font-weight: 600;
      transition: 0.3s;
    }
    input[type="file"]::-webkit-file-upload-button:hover {
      transform: scale(1.05);
    }

    /* Buttons */
    button[type="submit"] {
      margin-top: 30px;
      width: 100%;
      padding: 16px;
      font-size: 17px;
      font-weight: bold;
      color: white;
      background: linear-gradient(90deg, #667eea, #764ba2);
      border: none;
      border-radius: 12px;
      cursor: pointer;
      transition: all 0.3s ease;
      box-shadow: 0 6px 20px rgba(102,126,234,0.4);
      display: flex;
      justify-content: center;
      align-items: center;
      gap: 10px;
    }
    button[type="submit"]:hover {
      transform: translateY(-3px);
      box-shadow: 0 10px 25px rgba(118,75,162,0.5);
    }

    .form-footer {
      text-align: center;
      margin-top: 25px;
      padding-top: 20px;
      border-top: 1px solid #eee;
    }
    .form-footer a {
      color: #667eea;
      font-weight: 600;
      text-decoration: none;
    }
    .form-footer a:hover {
      text-decoration: underline;
    }

    .footer {
      text-align: center;
      padding: 20px;
      color: white;
      font-size: 0.9rem;
      background: rgba(26, 42, 108, 0.5);
    }

    @keyframes slideUp {
      from { opacity: 0; transform: translateY(30px); }
      to { opacity: 1; transform: translateY(0); }
    }

    /* Responsive */
    @media (max-width: 768px) {
      .container { padding: 30px 25px; }
      .form-header h2 { font-size: 1.6rem; }
    }
  </style>
</head>
<body>

  <!-- Navbar -->
  <nav class="navbar">
    <div class="nav-container">
      <a href="FarmerDashboard.jsp" class="nav-brand">
        <i class="fas fa-leaf"></i> Kisan Mitra
      </a>
      <ul class="nav-menu">
        <li><a href="FarmerDashboard.jsp"><i class="fas fa-home"></i> Dashboard</a></li>
        <li><a href="ShowTrades.jsp"><i class="fas fa-chart-line"></i> My Trades</a></li>
        <li><a href="FarmerSales.jsp" class="active"><i class="fas fa-dollar-sign"></i> Sales</a></li>
        <li><a href="FarmerProfile.jsp"><i class="fas fa-user-circle"></i> Profile</a></li>
        <li><a href="Logout.jsp" class="logout-btn"><i class="fas fa-sign-out-alt"></i> Logout</a></li>
      </ul>
    </div>
  </nav>

  <!-- Main Content -->
  <div class="main-content">
    <div class="container">
      <div class="form-header">
        <h2><i class="fas fa-handshake"></i> Upload New Trade</h2>
        <p>List your fresh produce and reach potential buyers easily</p>
      </div>

      <form action="CreateTrade" method="post" enctype="multipart/form-data">
        <div class="form-group">
          <label for="commodity"><i class="fas fa-box"></i> Commodity <span class="required">*</span></label>
          <input type="text" id="commodity" name="commodity" placeholder="e.g. Wheat, Cashew, Rice" required>
        </div>

        <div class="form-group">
          <label for="category"><i class="fas fa-tags"></i> Category <span class="required">*</span></label>
          <select id="category" name="category" required>
            <option value="">-- Select Category --</option>
            <option value="Fruit">Fruit</option>
            <option value="Vegetable">Vegetable</option>
            <option value="Cereal">Cereal</option>
            <option value="Pulse">Pulse</option>
            <option value="Masala">Masala</option>
            <option value="Dairy Product">Dairy Product</option>
          </select>
        </div>

        <div class="form-group">
          <label for="origin"><i class="fas fa-map-marker-alt"></i> Origin <span class="required">*</span></label>
          <input type="text" id="origin" name="origin" placeholder="e.g. Nashik, Haryana, Gujarat" required>
        </div>

        <div class="form-group">
          <label for="quantity"><i class="fas fa-weight-hanging"></i> Quantity (Kg) <span class="required">*</span></label>
          <input type="number" id="quantity" name="quantity" placeholder="e.g. 100, 500, 2000" min="1" required>
        </div>

        <div class="form-group">
          <label for="price"><i class="fas fa-rupee-sign"></i> Price (₹ per Kg) <span class="required">*</span></label>
          <input type="number" id="price" name="price" placeholder="e.g. 50, 100, 250" min="1" required>
        </div>

        <div class="form-group">
          <label for="image"><i class="fas fa-image"></i> Upload Image <span class="required">*</span></label>
          <input type="file" id="image" name="image" accept="image/*" required>
        </div>

        <button type="submit"><i class="fas fa-cloud-upload-alt"></i> Submit Trade</button>

        <div class="form-footer">
          <p>Want to see your trades? <a href="ShowTrades.jsp">Go to My Trades</a></p>
        </div>
      </form>
    </div>
  </div>

  <div class="footer">
    <p>&copy; 2025 Kisan Mitra. Empowering farmers through technology.</p>
  </div>

  <script>
    // Validate before submit
    document.querySelector("form").addEventListener("submit", function(e) {
      const quantity = document.getElementById("quantity").value;
      const price = document.getElementById("price").value;
      if (quantity <= 0 || price <= 0) {
        e.preventDefault();
        alert("Please enter valid positive values for quantity and price.");
      }
    });
  </script>

</body>
</html>
