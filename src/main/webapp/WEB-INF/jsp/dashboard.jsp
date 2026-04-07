<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<%@ taglib prefix="fmt" uri="http://java.sun.com/jsp/jstl/fmt" %>
<!DOCTYPE html>
<html lang="en">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>Dashboard - Electricity Billing System</title>
    <link rel="stylesheet" href="https://cdn.jsdelivr.net/npm/bootstrap@4.6.2/dist/css/bootstrap.min.css"
          integrity="sha384-xOolHFLEh07PJGoPkLv1IbcEPTNtaed2xpHsD9ESMhqIYd0nLMwNLD69Npy4HI+N"
          crossorigin="anonymous">
    <link rel="stylesheet" href="${pageContext.request.contextPath}/css/styles.css">
</head>
<body>
<%@ include file="navbar.jsp" %>

<div class="container-fluid mt-4">
    <div class="row mb-4">
        <div class="col-12">
            <h2><span>&#9889;</span> Dashboard</h2>
            <hr>
        </div>
    </div>

    <!-- Summary Cards -->
    <div class="row mb-4">
        <div class="col-md-3">
            <div class="card summary-card bg-primary text-white">
                <div class="card-body">
                    <div class="d-flex justify-content-between">
                        <div>
                            <h6 class="card-title">Total Clients</h6>
                            <h2 class="mb-0">${totalClients}</h2>
                        </div>
                        <div class="align-self-center">
                            <span style="font-size:2.5rem;">&#128101;</span>
                        </div>
                    </div>
                </div>
                <div class="card-footer">
                    <a href="${pageContext.request.contextPath}/clients" class="text-white">
                        View Clients &rarr;
                    </a>
                </div>
            </div>
        </div>
        <div class="col-md-3">
            <div class="card summary-card bg-success text-white">
                <div class="card-body">
                    <div class="d-flex justify-content-between">
                        <div>
                            <h6 class="card-title">Meter-Based Clients</h6>
                            <h2 class="mb-0">${meterBasedClients}</h2>
                        </div>
                        <div class="align-self-center">
                            <span style="font-size:2.5rem;">&#128207;</span>
                        </div>
                    </div>
                </div>
                <div class="card-footer">
                    <a href="${pageContext.request.contextPath}/clients" class="text-white">
                        View Details &rarr;
                    </a>
                </div>
            </div>
        </div>
        <div class="col-md-3">
            <div class="card summary-card bg-warning text-white">
                <div class="card-body">
                    <div class="d-flex justify-content-between">
                        <div>
                            <h6 class="card-title">Amper-Based Clients</h6>
                            <h2 class="mb-0">${amperBasedClients}</h2>
                        </div>
                        <div class="align-self-center">
                            <span style="font-size:2.5rem;">&#9889;</span>
                        </div>
                    </div>
                </div>
                <div class="card-footer">
                    <a href="${pageContext.request.contextPath}/clients" class="text-white">
                        View Details &rarr;
                    </a>
                </div>
            </div>
        </div>
        <div class="col-md-3">
            <div class="card summary-card bg-info text-white">
                <div class="card-body">
                    <div class="d-flex justify-content-between">
                        <div>
                            <h6 class="card-title">Total Invoices</h6>
                            <h2 class="mb-0">${totalInvoices}</h2>
                        </div>
                        <div class="align-self-center">
                            <span style="font-size:2.5rem;">&#128196;</span>
                        </div>
                    </div>
                </div>
                <div class="card-footer">
                    <a href="${pageContext.request.contextPath}/invoices" class="text-white">
                        View Invoices &rarr;
                    </a>
                </div>
            </div>
        </div>
    </div>

    <!-- Recent Invoices -->
    <div class="row">
        <div class="col-12">
            <div class="card">
                <div class="card-header bg-dark text-white">
                    <h5 class="mb-0">&#128196; Recent Invoices</h5>
                </div>
                <div class="card-body">
                    <div class="table-responsive">
                        <table class="table table-striped table-hover">
                            <thead class="thead-dark">
                                <tr>
                                    <th>Invoice #</th>
                                    <th>Client</th>
                                    <th>Period</th>
                                    <th>Amount (USD)</th>
                                    <th>Amount (LBP)</th>
                                    <th>Status</th>
                                    <th>Issue Date</th>
                                </tr>
                            </thead>
                            <tbody>
                                <c:choose>
                                    <c:when test="${not empty recentInvoices}">
                                        <c:forEach var="inv" items="${recentInvoices}" varStatus="s">
                                            <c:if test="${s.index < 10}">
                                                <tr>
                                                    <td><strong>${inv.invoiceNumber}</strong></td>
                                                    <td>${inv.clientName}</td>
                                                    <td>${inv.billingMonth}/${inv.billingYear}</td>
                                                    <td>$<fmt:formatNumber value="${inv.totalAmountUsd}" pattern="#,##0.00"/></td>
                                                    <td><fmt:formatNumber value="${inv.totalAmountLbp}" pattern="#,##0.00"/> LBP</td>
                                                    <td>
                                                        <c:choose>
                                                            <c:when test="${inv.status == 'ISSUED'}">
                                                                <span class="badge badge-primary">${inv.status}</span>
                                                            </c:when>
                                                            <c:when test="${inv.status == 'PAID'}">
                                                                <span class="badge badge-success">${inv.status}</span>
                                                            </c:when>
                                                            <c:when test="${inv.status == 'OVERDUE'}">
                                                                <span class="badge badge-danger">${inv.status}</span>
                                                            </c:when>
                                                            <c:otherwise>
                                                                <span class="badge badge-secondary">${inv.status}</span>
                                                            </c:otherwise>
                                                        </c:choose>
                                                    </td>
                                                    <td>${inv.issueDate}</td>
                                                </tr>
                                            </c:if>
                                        </c:forEach>
                                    </c:when>
                                    <c:otherwise>
                                        <tr>
                                            <td colspan="7" class="text-center text-muted">No invoices found</td>
                                        </tr>
                                    </c:otherwise>
                                </c:choose>
                            </tbody>
                        </table>
                    </div>
                </div>
            </div>
        </div>
    </div>
</div>

<script src="https://cdn.jsdelivr.net/npm/jquery@3.6.4/dist/jquery.min.js"
        integrity="sha384-0Q2PN83hmJF8xCb/VHF2nrqMpHQlC47m5EJNwMONbKHi5LHZmpVHjaxNIEBjFUCy"
        crossorigin="anonymous"></script>
<script src="https://cdn.jsdelivr.net/npm/bootstrap@4.6.2/dist/js/bootstrap.bundle.min.js"
        integrity="sha384-Fy6S3B9q64WdZWQUiU+q4/2Lc9npb8tCaSX9FK7E8HnRr0Jz8D6OP9dO5Vg3Q9ct"
        crossorigin="anonymous"></script>
<script src="${pageContext.request.contextPath}/js/common.js"></script>
</body>
</html>
