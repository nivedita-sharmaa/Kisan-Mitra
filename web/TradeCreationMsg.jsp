<!DOCTYPE html>
<html lang="en">
<head>
  <meta charset="UTF-8" />
  <title>Trade Created</title>
  <style>
    body {
      font-family: Arial, sans-serif;
      text-align: center;
      padding: 100px;
    }

    #thankyouMessage {
      display: none;
      color: green;
      font-size: 20px;
      margin-top: 30px;
    }
  </style>
  <script>
    window.onload = function () {
      if (confirm("Trade created successfully!\n\nPress OK to go to Profile, or Cancel to stay here.")) {
        window.location.href = "ShowTrades.jsp"; // ? Change this to your actual profile page
      } else {
        // ? Show thank-you message
        document.getElementById("thankyouMessage").style.display = "block";
      }
    };
  </script>
</head>
<body>
  <h2>Trade successfully created.</h2>
  <div id="thankyouMessage">
    Trade successfully created. Thank you!
  </div>
</body>
</html>
