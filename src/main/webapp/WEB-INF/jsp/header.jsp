<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<%@ taglib prefix="fmt" uri="http://java.sun.com/jsp/jstl/fmt" %>
<%@ taglib prefix="fn" uri="http://java.sun.com/jsp/jstl/functions" %>
<!DOCTYPE html>
<html lang="en">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>Electricity Billing System</title>

    <!-- Bootstrap 4 CSS -->
    <link rel="stylesheet" href="https://stackpath.bootstrapcdn.com/bootstrap/4.5.2/css/bootstrap.min.css"/>
    <!-- Font Awesome -->
    <link rel="stylesheet" href="https://cdnjs.cloudflare.com/ajax/libs/font-awesome/5.15.4/css/all.min.css"/>
    <!-- jqGrid CSS -->
    <link rel="stylesheet" href="https://cdnjs.cloudflare.com/ajax/libs/free-jqgrid/4.15.5/css/ui.jqgrid.min.css"/>
    <!-- jQuery UI CSS -->
    <link rel="stylesheet" href="https://cdnjs.cloudflare.com/ajax/libs/jqueryui/1.12.1/themes/base/jquery-ui.min.css"/>
    <!-- Custom CSS -->
    <link rel="stylesheet" href="${pageContext.request.contextPath}/static/css/app.css"/>
</head>
<body>

<!-- Navigation -->
<nav class="navbar navbar-expand-lg navbar-dark bg-primary">
    <a class="navbar-brand" href="${pageContext.request.contextPath}/dashboard">
        <i class="fas fa-bolt"></i> Electricity Billing
    </a>
    <button class="navbar-toggler" type="button" data-toggle="collapse" data-target="#navbarNav">
        <span class="navbar-toggler-icon"></span>
    </button>
    <div class="collapse navbar-collapse" id="navbarNav">
        <ul class="navbar-nav mr-auto">
            <li class="nav-item">
                <a class="nav-link" href="${pageContext.request.contextPath}/dashboard">
                    <i class="fas fa-tachometer-alt"></i> Dashboard
                </a>
            </li>
            <li class="nav-item dropdown">
                <a class="nav-link dropdown-toggle" href="#" data-toggle="dropdown">
                    <i class="fas fa-users"></i> Management
                </a>
                <div class="dropdown-menu">
                    <a class="dropdown-item" href="${pageContext.request.contextPath}/customers">
                        <i class="fas fa-user"></i> Customers
                    </a>
                    <a class="dropdown-item" href="${pageContext.request.contextPath}/zones">
                        <i class="fas fa-map"></i> Zones
                    </a>
                    <a class="dropdown-item" href="${pageContext.request.contextPath}/boxes">
                        <i class="fas fa-box"></i> Boxes
                    </a>
                </div>
            </li>
            <li class="nav-item dropdown">
                <a class="nav-link dropdown-toggle" href="#" data-toggle="dropdown">
                    <i class="fas fa-file-invoice-dollar"></i> Billing
                </a>
                <div class="dropdown-menu">
                    <a class="dropdown-item" href="${pageContext.request.contextPath}/issuances">
                        <i class="fas fa-calendar-alt"></i> Issuances
                    </a>
                    <a class="dropdown-item" href="${pageContext.request.contextPath}/billing">
                        <i class="fas fa-receipt"></i> Bills
                    </a>
                </div>
            </li>
            <li class="nav-item dropdown">
                <a class="nav-link dropdown-toggle" href="#" data-toggle="dropdown">
                    <i class="fas fa-cog"></i> Settings
                </a>
                <div class="dropdown-menu">
                    <a class="dropdown-item" href="${pageContext.request.contextPath}/parameters">
                        <i class="fas fa-sliders-h"></i> Parameters
                    </a>
                    <a class="dropdown-item" href="${pageContext.request.contextPath}/translations">
                        <i class="fas fa-language"></i> Translations
                    </a>
                    <a class="dropdown-item" href="${pageContext.request.contextPath}/users">
                        <i class="fas fa-user-shield"></i> Users
                    </a>
                    <a class="dropdown-item" href="${pageContext.request.contextPath}/audit">
                        <i class="fas fa-clipboard-list"></i> Audit Log
                    </a>
                </div>
            </li>
        </ul>
        <ul class="navbar-nav">
            <li class="nav-item dropdown">
                <a class="nav-link dropdown-toggle" href="#" data-toggle="dropdown">
                    <i class="fas fa-user-circle"></i>
                    <sec:authentication property="name" xmlns:sec="http://www.springframework.org/security/tags"
                                        xmlns:sec="http://www.springframework.org/security/tags"/>
                </a>
                <div class="dropdown-menu dropdown-menu-right">
                    <a class="dropdown-item" href="?lang=en"><i class="fas fa-flag"></i> English</a>
                    <a class="dropdown-item" href="?lang=ar"><i class="fas fa-flag"></i> العربية</a>
                    <div class="dropdown-divider"></div>
                    <a class="dropdown-item" href="${pageContext.request.contextPath}/logout">
                        <i class="fas fa-sign-out-alt"></i> Logout
                    </a>
                </div>
            </li>
        </ul>
    </div>
</nav>

<!-- Main Content -->
<div class="container-fluid mt-3">
