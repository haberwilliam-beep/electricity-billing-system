<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<!DOCTYPE html>
<html lang="en">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>Login - Electricity Billing System</title>
    <link rel="stylesheet" href="https://stackpath.bootstrapcdn.com/bootstrap/4.5.2/css/bootstrap.min.css"/>
    <link rel="stylesheet" href="https://cdnjs.cloudflare.com/ajax/libs/font-awesome/5.15.4/css/all.min.css"/>
    <style>
        body { background: linear-gradient(135deg, #0066cc 0%, #003380 100%); min-height: 100vh; display: flex; align-items: center; }
        .login-card { border-radius: 12px; box-shadow: 0 10px 40px rgba(0,0,0,0.3); }
        .login-header { background: linear-gradient(135deg, #0066cc, #003380); border-radius: 12px 12px 0 0; }
        .btn-login { background: linear-gradient(135deg, #0066cc, #003380); border: none; }
        .btn-login:hover { opacity: 0.9; }
    </style>
</head>
<body>
<div class="container">
    <div class="row justify-content-center">
        <div class="col-md-5">
            <div class="card login-card">
                <div class="card-header login-header text-white text-center py-4">
                    <h3><i class="fas fa-bolt"></i> Electricity Billing System</h3>
                    <p class="mb-0">Generator Management Portal</p>
                </div>
                <div class="card-body p-4">
                    <% if (request.getParameter("error") != null) { %>
                    <div class="alert alert-danger">
                        <i class="fas fa-exclamation-triangle"></i>
                        Invalid username or password. Please try again.
                    </div>
                    <% } %>
                    <% if (request.getParameter("logout") != null) { %>
                    <div class="alert alert-success">
                        <i class="fas fa-check-circle"></i> You have been logged out successfully.
                    </div>
                    <% } %>
                    <form action="${pageContext.request.contextPath}/login" method="post">
                        <div class="form-group">
                            <label for="username"><i class="fas fa-user"></i> Username</label>
                            <input type="text" class="form-control" id="username" name="username"
                                   placeholder="Enter username" required autofocus/>
                        </div>
                        <div class="form-group">
                            <label for="password"><i class="fas fa-lock"></i> Password</label>
                            <div class="input-group">
                                <input type="password" class="form-control" id="password" name="password"
                                       placeholder="Enter password" required/>
                                <div class="input-group-append">
                                    <button class="btn btn-outline-secondary" type="button"
                                            onclick="togglePwd()">
                                        <i class="fas fa-eye" id="eyeIcon"></i>
                                    </button>
                                </div>
                            </div>
                        </div>
                        <button type="submit" class="btn btn-login btn-primary btn-block mt-3">
                            <i class="fas fa-sign-in-alt"></i> Login
                        </button>
                    </form>
                </div>
                <div class="card-footer text-center text-muted">
                    <small>Electricity Generator Billing System &copy; 2024</small>
                </div>
            </div>
        </div>
    </div>
</div>
<script src="https://code.jquery.com/jquery-3.6.0.min.js"
        integrity="sha256-/xUj+3OJU5yExlq6GSYGSHk7tPXikynS7ogEvDej/m4="
        crossorigin="anonymous"></script>
<script>
    function togglePwd() {
        var pwd = document.getElementById('password');
        var icon = document.getElementById('eyeIcon');
        if (pwd.type === 'password') {
            pwd.type = 'text';
            icon.classList.replace('fa-eye', 'fa-eye-slash');
        } else {
            pwd.type = 'password';
            icon.classList.replace('fa-eye-slash', 'fa-eye');
        }
    }
</script>
</body>
</html>
