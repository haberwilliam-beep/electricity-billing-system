<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<%@ include file="header.jsp" %>

<div class="row">
    <div class="col-md-12 mb-3">
        <h2><i class="fas fa-tachometer-alt text-primary"></i> Dashboard</h2>
        <hr/>
    </div>
</div>

<div class="row">
    <div class="col-md-3">
        <div class="card bg-primary text-white shadow">
            <div class="card-body">
                <div class="d-flex justify-content-between">
                    <div>
                        <h4 class="card-title">Customers</h4>
                        <p class="card-text display-5" id="custCount">-</p>
                    </div>
                    <div class="align-self-center">
                        <i class="fas fa-users fa-3x opacity-75"></i>
                    </div>
                </div>
                <a href="${pageContext.request.contextPath}/customers" class="text-white">
                    <i class="fas fa-arrow-right"></i> Manage Customers
                </a>
            </div>
        </div>
    </div>
    <div class="col-md-3">
        <div class="card bg-success text-white shadow">
            <div class="card-body">
                <div class="d-flex justify-content-between">
                    <div>
                        <h4 class="card-title">Zones</h4>
                        <p class="card-text display-5" id="zoneCount">-</p>
                    </div>
                    <div class="align-self-center">
                        <i class="fas fa-map fa-3x opacity-75"></i>
                    </div>
                </div>
                <a href="${pageContext.request.contextPath}/zones" class="text-white">
                    <i class="fas fa-arrow-right"></i> Manage Zones
                </a>
            </div>
        </div>
    </div>
    <div class="col-md-3">
        <div class="card bg-warning text-white shadow">
            <div class="card-body">
                <div class="d-flex justify-content-between">
                    <div>
                        <h4 class="card-title">Issuances</h4>
                        <p class="card-text display-5" id="issuanceCount">-</p>
                    </div>
                    <div class="align-self-center">
                        <i class="fas fa-calendar-alt fa-3x opacity-75"></i>
                    </div>
                </div>
                <a href="${pageContext.request.contextPath}/issuances" class="text-white">
                    <i class="fas fa-arrow-right"></i> Manage Issuances
                </a>
            </div>
        </div>
    </div>
    <div class="col-md-3">
        <div class="card bg-info text-white shadow">
            <div class="card-body">
                <div class="d-flex justify-content-between">
                    <div>
                        <h4 class="card-title">Boxes</h4>
                        <p class="card-text display-5" id="boxCount">-</p>
                    </div>
                    <div class="align-self-center">
                        <i class="fas fa-box fa-3x opacity-75"></i>
                    </div>
                </div>
                <a href="${pageContext.request.contextPath}/boxes" class="text-white">
                    <i class="fas fa-arrow-right"></i> Manage Boxes
                </a>
            </div>
        </div>
    </div>
</div>

<div class="row mt-4">
    <div class="col-md-6">
        <div class="card shadow">
            <div class="card-header bg-primary text-white">
                <i class="fas fa-bolt"></i> Quick Actions
            </div>
            <div class="card-body">
                <a href="${pageContext.request.contextPath}/issuances" class="btn btn-outline-primary mr-2 mb-2">
                    <i class="fas fa-plus"></i> New Issuance
                </a>
                <a href="${pageContext.request.contextPath}/customers" class="btn btn-outline-success mr-2 mb-2">
                    <i class="fas fa-user-plus"></i> Add Customer
                </a>
                <a href="${pageContext.request.contextPath}/billing" class="btn btn-outline-warning mr-2 mb-2">
                    <i class="fas fa-file-invoice"></i> View Bills
                </a>
                <a href="${pageContext.request.contextPath}/parameters" class="btn btn-outline-secondary mr-2 mb-2">
                    <i class="fas fa-cog"></i> Parameters
                </a>
            </div>
        </div>
    </div>
    <div class="col-md-6">
        <div class="card shadow">
            <div class="card-header bg-info text-white">
                <i class="fas fa-info-circle"></i> System Info
            </div>
            <div class="card-body" id="sysParams">
                <p><i class="fas fa-spinner fa-spin"></i> Loading parameters...</p>
            </div>
        </div>
    </div>
</div>

<script>
$(function() {
    var ctx = '${pageContext.request.contextPath}';
    // Load customer count
    $.get(ctx + '/customers/data?page=1&rows=1', function(d) {
        $('#custCount').text(d.records || 0);
    });
    $.get(ctx + '/zones/data?page=1&rows=1', function(d) {
        $('#zoneCount').text(d.records || 0);
    });
    $.get(ctx + '/boxes/data?page=1&rows=1', function(d) {
        $('#boxCount').text(d.records || 0);
    });
    $.get(ctx + '/issuances/data?page=1&rows=1', function(d) {
        $('#issuanceCount').text(d.records || 0);
    });
    $.get(ctx + '/parameters/data', function(params) {
        var html = '<ul class="list-unstyled">';
        $.each(params, function(i, p) {
            html += '<li><b>' + p.description + ':</b> ' + p.paramValue + '</li>';
        });
        html += '</ul>';
        $('#sysParams').html(html);
    });
});
</script>

<%@ include file="footer.jsp" %>
