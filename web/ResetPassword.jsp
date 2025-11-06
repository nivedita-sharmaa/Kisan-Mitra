<%@ page contentType="text/html" pageEncoding="UTF-8"%>
<!DOCTYPE html>
<html lang="en">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>Reset Password</title>
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
        
        .reset-container {
            background: white;
            max-width: 450px;
            width: 100%;
            padding: 40px;
            border-radius: 12px;
            box-shadow: 0 10px 40px rgba(0,0,0,0.2);
        }
        
        h2 {
            color: #333;
            margin-bottom: 10px;
            text-align: center;
        }
        
        .subtitle {
            color: #666;
            text-align: center;
            margin-bottom: 30px;
            font-size: 14px;
        }
        
        .user-info {
            background: #f0f2ff;
            padding: 15px;
            border-radius: 6px;
            margin-bottom: 25px;
            text-align: center;
        }
        
        .user-info strong {
            color: #667eea;
        }
        
        .form-group {
            margin-bottom: 20px;
            position: relative;
        }
        
        label {
            display: block;
            margin-bottom: 8px;
            color: #333;
            font-weight: 500;
        }
        
        .password-wrapper {
            position: relative;
            display: flex;
            align-items: center;
        }
        
        input[type="password"], input[type="text"] {
            width: 100%;
            padding: 12px;
            padding-right: 45px;
            border: 1px solid #ddd;
            border-radius: 6px;
            font-size: 14px;
            transition: border-color 0.3s;
        }
        
        input[type="password"]:focus, input[type="text"]:focus {
            outline: none;
            border-color: #667eea;
        }
        
        .toggle-password {
            position: absolute;
            right: 12px;
            background: none;
            border: none;
            cursor: pointer;
            font-size: 20px;
            color: #666;
            padding: 5px;
            transition: color 0.3s;
            user-select: none;
        }
        
        .toggle-password:hover {
            color: #667eea;
        }
        
        .btn-submit {
            width: 100%;
            padding: 12px;
            background: #667eea;
            color: white;
            border: none;
            border-radius: 6px;
            font-size: 16px;
            font-weight: 600;
            cursor: pointer;
            transition: all 0.3s;
        }
        
        .btn-submit:hover {
            background: #5568d3;
            transform: translateY(-2px);
            box-shadow: 0 5px 15px rgba(102, 126, 234, 0.4);
        }
        
        .error-msg {
            color: #dc3545;
            font-size: 14px;
            margin-bottom: 15px;
            text-align: center;
            background: #f8d7da;
            padding: 10px;
            border-radius: 6px;
        }
        
        .password-strength {
            margin-top: 8px;
            font-size: 12px;
        }
        
        .strength-bar {
            height: 4px;
            border-radius: 2px;
            background: #e0e0e0;
            margin-top: 5px;
            overflow: hidden;
        }
        
        .strength-fill {
            height: 100%;
            width: 0%;
            transition: all 0.3s;
        }
        
        .weak { background: #dc3545; }
        .medium { background: #ffc107; }
        .strong { background: #28a745; }
    </style>
</head>
<body>
    <div class="reset-container">
        <h2>🔑 Reset Password</h2>
        <p class="subtitle">Enter your new password</p>
        
        <div class="user-info">
            <strong><%= request.getParameter("userType").equals("buyer") ? "Buyer" : "Farmer" %> Account:</strong> <%= request.getParameter("email") %>
        </div>
        
        <% if (request.getAttribute("error") != null) { %>
            <p class="error-msg"><%= request.getAttribute("error") %></p>
        <% } %>
        
        <form action="ResetPasswordChecker" method="post">
            <input type="hidden" name="email" value="<%= request.getParameter("email") %>">
            <input type="hidden" name="user-type" value="<%= request.getParameter("userType") %>">
            
            <div class="form-group">
                <label for="new-password">New Password</label>
                <div class="password-wrapper">
                    <input type="password" id="new-password" name="new-password" placeholder="Enter new password" required minlength="6">
                    <button type="button" class="toggle-password" onclick="togglePassword('new-password', this)">
                        👁
                    </button>
                </div>
<!--                <div class="password-strength">
                    <span id="strength-text"></span>
                    <div class="strength-bar">
                        <div class="strength-fill" id="strength-fill"></div>
                    </div>
                </div>
            </div>-->
            
            <div class="form-group">
                <label for="confirm-password">Confirm Password</label>
                <div class="password-wrapper">
                    <input type="password" id="confirm-password" name="confirm-password" placeholder="Confirm new password" required minlength="6">
                    <button type="button" class="toggle-password" onclick="togglePassword('confirm-password', this)">
                        👁
                    </button>
                </div>
                <span id="match-message" style="font-size: 12px; margin-top: 5px; display: block;"></span>
            </div>
            
            <button type="submit" class="btn-submit">Reset Password</button>
        </form>
    </div>
    
    <script>
        // Toggle password visibility
        function togglePassword(inputId, button) {
            const input = document.getElementById(inputId);
            if (input.type === "password") {
                input.type = "text";
                button.innerHTML = "👁‍🗨"; // Eye with speech bubble (hidden state)
            } else {
                input.type = "password";
                button.innerHTML = "👁"; // Regular eye (visible state)
            }
        }
        
//        // Password strength checker
//        const newPasswordInput = document.getElementById('new-password');
//        const strengthText = document.getElementById('strength-text');
//        const strengthFill = document.getElementById('strength-fill');
//        
//        newPasswordInput.addEventListener('input', function() {
//            const password = this.value;
//            let strength = 0;
//            
//            if (password.length >= 6) strength++;
//            if (password.length >= 10) strength++;
//            if (/[a-z]/.test(password) && /[A-Z]/.test(password)) strength++;
//            if (/\d/.test(password)) strength++;
//            if (/[^a-zA-Z0-9]/.test(password)) strength++;
//            
//            strengthFill.style.width = (strength * 20) + '%';
//            
//            if (strength <= 2) {
//                strengthText.textContent = 'Weak password';
//                strengthFill.className = 'strength-fill weak';
//            } else if (strength <= 3) {
//                strengthText.textContent = 'Medium password';
//                strengthFill.className = 'strength-fill medium';
//            } else {
//                strengthText.textContent = 'Strong password';
//                strengthFill.className = 'strength-fill strong';
//            }
//        });
//        
        // Password match checker
        const confirmPasswordInput = document.getElementById('confirm-password');
        const matchMessage = document.getElementById('match-message');
        
        confirmPasswordInput.addEventListener('input', function() {
            if (this.value === '') {
                matchMessage.textContent = '';
                matchMessage.style.color = '';
            } else if (this.value === newPasswordInput.value) {
                matchMessage.textContent = '✓ Passwords match';
                matchMessage.style.color = '#28a745';
            } else {
                matchMessage.textContent = '✗ Passwords do not match';
                matchMessage.style.color = '#dc3545';
            }
        });
        
        // Form validation
        document.querySelector('form').addEventListener('submit', function(e) {
            const newPass = document.getElementById('new-password').value;
            const confirmPass = document.getElementById('confirm-password').value;
            
            if (newPass !== confirmPass) {
                e.preventDefault();
                alert('Passwords do not match!');
            }
        });
    </script>
</body>
</html>