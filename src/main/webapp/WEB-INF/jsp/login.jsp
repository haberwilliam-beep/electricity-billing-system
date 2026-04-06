<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<!DOCTYPE html>
<html lang="en">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>Login - Electricity Billing System</title>
    <link rel="stylesheet" href="https://cdn.jsdelivr.net/npm/bootstrap@4.6.2/dist/css/bootstrap.min.css"
          integrity="sha384-xOolHFLEh07PJGoPkLv1IbcEPTNtaed2xpHsD9ESMhqIYd0nLMwNLD69Npy4HI+N"
          crossorigin="anonymous">
    <link rel="stylesheet" href="${pageContext.request.contextPath}/css/styles.css">
    <style>
        body {
            background: linear-gradient(135deg, #1a1a2e 0%, #16213e 50%, #0f3460 100%);
            min-height: 100vh;
            display: flex;
            align-items: center;
            justify-content: center;
        }
        .login-card {
            background: rgba(255,255,255,0.95);
            border-radius: 15px;
            box-shadow: 0 20px 60px rgba(0,0,0,0.4);
            padding: 40px;
            width: 420px;
        }
        .login-logo {
            text-align: center;
            margin-bottom: 25px;
        }
        .login-logo i {
            font-size: 60px;
            color: #f39c12;
        }
        .login-title {
            text-align: center;
            color: #2c3e50;
            font-weight: 700;
            font-size: 1.5rem;
            margin-bottom: 5px;
        }
        .login-subtitle {
            text-align: center;
            color: #7f8c8d;
            font-size: 0.9rem;
            margin-bottom: 30px;
        }
        .btn-login {
            background: linear-gradient(135deg, #f39c12, #e67e22);
            border: none;
            padding: 12px;
            font-size: 1rem;
            font-weight: 600;
            letter-spacing: 1px;
            border-radius: 8px;
        }
        .btn-login:hover {
            background: linear-gradient(135deg, #e67e22, #d35400);
        }
        .form-control:focus {
            border-color: #f39c12;
            box-shadow: 0 0 0 0.2rem rgba(243, 156, 18, 0.25);
        }
    </style>
</head>
<body>
    <div class="login-card">
        <div class="login-logo">
            <span style="font-size:60px;">&#9889;</span>
        </div>
        <h2 class="login-title">Electricity Billing</h2>
        <p class="login-subtitle">Management System</p>

        <c:if test="${param.error != null}">
            <div class="alert alert-danger" role="alert">
                <strong>Invalid credentials!</strong> Please check your username and password.
            </div>
        </c:if>
        <c:if test="${param.logout != null}">
            <div class="alert alert-success" role="alert">
                You have been successfully logged out.
            </div>
        </c:if>

        <form action="${pageContext.request.contextPath}/perform_login" method="post">
            <input type="hidden" name="${_csrf.parameterName}" value="${_csrf.token}"/>
            <div class="form-group">
                <label for="username">Username</label>
                <div class="input-group">
                    <div class="input-group-prepend">
                        <span class="input-group-text">&#128100;</span>
                    </div>
                    <input type="text" class="form-control" id="username" name="username"
                           placeholder="Enter username" required autofocus>
                </div>
            </div>
            <div class="form-group">
                <label for="password">Password</label>
                <div class="input-group">
                    <div class="input-group-prepend">
                        <span class="input-group-text">&#128274;</span>
                    </div>
                    <input type="password" class="form-control" id="password" name="password"
                           placeholder="Enter password" required>
                </div>
            </div>
            <div class="form-group">
                <div class="custom-control custom-checkbox">
                    <input type="checkbox" class="custom-control-input" id="rememberMe" name="remember-me">
                    <label class="custom-control-label" for="rememberMe">Remember me</label>
                </div>
            </div>
            <button type="submit" class="btn btn-warning btn-block btn-login text-white">
                Sign In
            </button>
        </form>

        <hr>
        <p class="text-center text-muted mt-3" style="font-size:0.8rem;">
            &copy; 2024 Electricity Billing Management System
        </p>
    </div>

    <script src="https://cdn.jsdelivr.net/npm/jquery@3.6.4/dist/jquery.min.js"
            integrity="sha384-0Q2PN83hmJF8xCb/VHF2nrqMpHQlC47m5EJNwMONbKHi5LHZmpVHjaxNIEBjFUCy"
            crossorigin="anonymous"></script>
    <script src="https://cdn.jsdelivr.net/npm/bootstrap@4.6.2/dist/js/bootstrap.bundle.min.js"
            integrity="sha384-Fy6S3B9q64WdZWQUiU+q4/2Lc9npb8tCaSX9FK7E8HnRr0Jz8D6OP9dO5Vg3Q9ct"
            crossorigin="anonymous"></script>
</body>
</html>
