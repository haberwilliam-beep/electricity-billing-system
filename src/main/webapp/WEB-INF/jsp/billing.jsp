<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<!DOCTYPE html>
<html lang="en">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>Billing - Electricity Billing System</title>
    <link rel="stylesheet" href="https://cdn.jsdelivr.net/npm/bootstrap@4.6.2/dist/css/bootstrap.min.css" integrity="sha384-xOolHFLEh07PJGoPkLv1IbcEPTNtaed2xpHsD9ESMhqIYd0nLMwNLD69Npy4HI+N" crossorigin="anonymous">
    <link rel="stylesheet" href="https://code.jquery.com/ui/1.13.2/themes/ui-lightness/jquery-ui.min.css" integrity="sha384-ycPwn8wvJIR01JNxdEVweBy3WWR7uMe5jId0MswZGCYwAYXVAaKxB6C3tT/4d8b5" crossorigin="anonymous">
    <link rel="stylesheet" href="https://cdnjs.cloudflare.com/ajax/libs/free-jqgrid/4.15.5/css/ui.jqgrid.min.css" integrity="sha384-Mt0ueSlN3BG92r5nroCSUozKMhA7TT9BmcUpzAI8+b6u5gOcxK7SaThK6wmaB+IG" crossorigin="anonymous">
    <link rel="stylesheet" href="${pageContext.request.contextPath}/css/styles.css">
</head>
<body>
<%@ include file="navbar.jsp" %>

<div class="container-fluid mt-4">
    <div class="row mb-3">
        <div class="col-12">
            <h2>&#9889; Billing Management</h2>
        </div>
    </div>

    <!-- Generate Bill Panel -->
    <div class="row mb-4">
        <div class="col-md-6">
            <div class="card border-primary">
                <div class="card-header bg-primary text-white">
                    <h6 class="mb-0">&#128207; Generate Meter-Based Bill</h6>
                </div>
                <div class="card-body">
                    <div class="form-group">
                        <label>Client (Meter-Based)</label>
                        <select class="form-control" id="meterClientId">
                            <option value="">-- Select Client --</option>
                            <c:forEach var="client" items="${clients}">
                                <c:if test="${client.clientType == 'METER_BASED'}">
                                    <option value="${client.id}">${client.name}</option>
                                </c:if>
                            </c:forEach>
                        </select>
                    </div>
                    <div class="row">
                        <div class="col-md-6">
                            <div class="form-group">
                                <label>Billing Month</label>
                                <select class="form-control" id="meterBillingMonth">
                                    <option value="1">January</option><option value="2">February</option>
                                    <option value="3">March</option><option value="4">April</option>
                                    <option value="5">May</option><option value="6">June</option>
                                    <option value="7">July</option><option value="8">August</option>
                                    <option value="9">September</option><option value="10">October</option>
                                    <option value="11">November</option><option value="12">December</option>
                                </select>
                            </div>
                        </div>
                        <div class="col-md-6">
                            <div class="form-group">
                                <label>Billing Year</label>
                                <input type="number" class="form-control" id="meterBillingYear" value="2024">
                            </div>
                        </div>
                    </div>
                    <div class="form-group">
                        <label>Meter Reading</label>
                        <select class="form-control" id="meterReadingId">
                            <option value="">-- Select Reading --</option>
                        </select>
                    </div>
                    <button class="btn btn-primary btn-block" id="btnGenerateMeterBill">
                        &#9889; Generate Meter Bill
                    </button>
                </div>
            </div>
        </div>
        <div class="col-md-6">
            <div class="card border-warning">
                <div class="card-header bg-warning text-dark">
                    <h6 class="mb-0">&#9889; Generate Amper-Based Bill</h6>
                </div>
                <div class="card-body">
                    <div class="form-group">
                        <label>Client (Amper-Based)</label>
                        <select class="form-control" id="amperClientId">
                            <option value="">-- Select Client --</option>
                            <c:forEach var="client" items="${clients}">
                                <c:if test="${client.clientType == 'AMPER_BASED'}">
                                    <option value="${client.id}">${client.name} (${client.ampereCapacity}A)</option>
                                </c:if>
                            </c:forEach>
                        </select>
                    </div>
                    <div class="row">
                        <div class="col-md-6">
                            <div class="form-group">
                                <label>Billing Month</label>
                                <select class="form-control" id="amperBillingMonth">
                                    <option value="1">January</option><option value="2">February</option>
                                    <option value="3">March</option><option value="4">April</option>
                                    <option value="5">May</option><option value="6">June</option>
                                    <option value="7">July</option><option value="8">August</option>
                                    <option value="9">September</option><option value="10">October</option>
                                    <option value="11">November</option><option value="12">December</option>
                                </select>
                            </div>
                        </div>
                        <div class="col-md-6">
                            <div class="form-group">
                                <label>Billing Year</label>
                                <input type="number" class="form-control" id="amperBillingYear" value="2024">
                            </div>
                        </div>
                    </div>
                    <div class="mt-3">
                        <small class="text-muted">
                            Bill = (Price/Ampere × Capacity) + (Subscription Fee/Ampere × Capacity)
                        </small>
                    </div>
                    <button class="btn btn-warning btn-block mt-2" id="btnGenerateAmperBill">
                        &#9889; Generate Amper Bill
                    </button>
                </div>
            </div>
        </div>
    </div>

    <!-- Bills Grid -->
    <div class="row">
        <div class="col-12">
            <div class="card">
                <div class="card-header d-flex justify-content-between align-items-center">
                    <h5 class="mb-0">&#128196; Bills</h5>
                    <div>
                        <select class="form-control form-control-sm d-inline-block w-auto mr-1" id="gridMonth">
                            <option value="">All Months</option>
                            <option value="1">January</option><option value="2">February</option>
                            <option value="3">March</option><option value="4">April</option>
                            <option value="5">May</option><option value="6">June</option>
                            <option value="7">July</option><option value="8">August</option>
                            <option value="9">September</option><option value="10">October</option>
                            <option value="11">November</option><option value="12">December</option>
                        </select>
                        <input type="number" class="form-control form-control-sm d-inline-block w-auto mr-1"
                               id="gridYear" placeholder="Year" value="2024">
                        <button class="btn btn-sm btn-primary" id="btnFilterBills">Filter</button>
                    </div>
                </div>
                <div class="card-body">
                    <table id="billsGrid"></table>
                    <div id="billsGridPager"></div>
                </div>
            </div>
        </div>
    </div>
</div>

<script src="https://cdn.jsdelivr.net/npm/jquery@3.6.4/dist/jquery.min.js" integrity="sha384-0Q2PN83hmJF8xCb/VHF2nrqMpHQlC47m5EJNwMONbKHi5LHZmpVHjaxNIEBjFUCy" crossorigin="anonymous"></script>
<script src="https://code.jquery.com/ui/1.13.2/jquery-ui.min.js" integrity="sha384-XnC1bIbCVHhC5oyJQvA3C+E2qwz6pUyN6AVqGF/UQBB0bT+pIoVZgrD6h9zD+XHg" crossorigin="anonymous"></script>
<script src="https://cdn.jsdelivr.net/npm/bootstrap@4.6.2/dist/js/bootstrap.bundle.min.js" integrity="sha384-Fy6S3B9q64WdZWQUiU+q4/2Lc9npb8tCaSX9FK7E8HnRr0Jz8D6OP9dO5Vg3Q9ct" crossorigin="anonymous"></script>
<script src="https://cdnjs.cloudflare.com/ajax/libs/free-jqgrid/4.15.5/js/jquery.jqgrid.min.js" integrity="sha384-uY3wTnDsXiMOL8thf8kCbNYLas2mIKkA6dNflnYLGLDSSk4t8f82jNkagtwX/LPA" crossorigin="anonymous"></script>
<script src="${pageContext.request.contextPath}/js/common.js"></script>
<script>
var contextPath = '${pageContext.request.contextPath}';
var csrfToken = '${_csrf.token}';
var csrfHeader = '${_csrf.headerName}';

$(document).ready(function() {
    // Set current month
    $('#meterBillingMonth').val(new Date().getMonth() + 1);
    $('#amperBillingMonth').val(new Date().getMonth() + 1);
    $('#gridMonth').val(new Date().getMonth() + 1);

    // Initialize bills grid
    $("#billsGrid").jqGrid({
        url: contextPath + '/billing/api/list',
        datatype: 'json',
        mtype: 'GET',
        colNames: ['ID', 'Client', 'Period', 'Consumption (kWh)', 'Ampere', 'Charge (USD)', 'Sub. Fee (USD)', 'Total (USD)', 'Total (LBP)', 'Status', 'Actions'],
        colModel: [
            { name: 'id', width: 50, hidden: true },
            { name: 'clientName', width: 160 },
            { name: 'period', width: 90, align: 'center',
              formatter: function(val, opts, row) { return row.billingMonth + '/' + row.billingYear; }
            },
            { name: 'consumption', width: 130, align: 'right',
              formatter: function(val) { return val ? parseFloat(val).toFixed(2) : '-'; }
            },
            { name: 'ampereCapacity', width: 80, align: 'center',
              formatter: function(val) { return val + 'A'; }
            },
            { name: 'consumptionChargeUsd', width: 120, align: 'right',
              formatter: function(val) { return '$' + parseFloat(val).toFixed(2); }
            },
            { name: 'subscriptionFeeUsd', width: 120, align: 'right',
              formatter: function(val) { return '$' + parseFloat(val).toFixed(2); }
            },
            { name: 'totalAmountUsd', width: 110, align: 'right',
              formatter: function(val) { return '<strong>$' + parseFloat(val).toFixed(2) + '</strong>'; }
            },
            { name: 'totalAmountLbp', width: 130, align: 'right',
              formatter: function(val) { return parseFloat(val).toLocaleString() + ' LBP'; }
            },
            { name: 'status', width: 90, align: 'center',
              formatter: function(val) {
                  var cls = {PENDING:'warning',INVOICED:'primary',PAID:'success',CANCELLED:'secondary'}[val] || 'secondary';
                  return '<span class="badge badge-' + cls + '">' + val + '</span>';
              }
            },
            { name: 'actions', width: 130, sortable: false, align: 'center',
              formatter: function(val, opts, row) {
                  var html = '';
                  if (row.status === 'PENDING') {
                      html += '<button class="btn btn-sm btn-info mr-1" onclick="generateInvoice(' + row.id + ')">Invoice</button>';
                  }
                  html += '<button class="btn btn-sm btn-danger" onclick="deleteBill(' + row.id + ')">Del</button>';
                  return html;
              }
            }
        ],
        rowNum: 20,
        rowList: [10, 20, 50],
        pager: '#billsGridPager',
        viewrecords: true,
        caption: 'Bills',
        autowidth: true,
        height: 'auto',
        jsonReader: { total: 'total', page: 'page', records: 'records', root: 'rows' }
    });

    // Load meter readings when client changes
    $('#meterClientId').change(function() {
        var clientId = $(this).val();
        if (!clientId) {
            $('#meterReadingId').html('<option value="">-- Select Reading --</option>');
            return;
        }
        $.get(contextPath + '/meter-readings/api/list?clientId=' + clientId, function(data) {
            var options = '<option value="">-- Select Reading --</option>';
            if (data.rows) {
                data.rows.forEach(function(r) {
                    options += '<option value="' + r.id + '">' + r.billingMonth + '/' + r.billingYear
                             + ' - ' + r.consumption + ' kWh</option>';
                });
            }
            $('#meterReadingId').html(options);
        });
    });

    // Generate meter bill
    $('#btnGenerateMeterBill').click(function() {
        var clientId = $('#meterClientId').val();
        var readingId = $('#meterReadingId').val();
        var month = $('#meterBillingMonth').val();
        var year = $('#meterBillingYear').val();
        if (!clientId || !readingId) {
            showError('Please select client and meter reading');
            return;
        }
        var headers = {};
        headers[csrfHeader] = csrfToken;
        $.ajax({
            url: contextPath + '/billing/api/generate/meter',
            type: 'POST',
            headers: headers,
            data: { clientId: clientId, meterReadingId: readingId, billingMonth: month, billingYear: year },
            success: function(resp) {
                if (resp.success) {
                    showSuccess(resp.message);
                    $("#billsGrid").trigger('reloadGrid');
                } else {
                    showError(resp.message);
                }
            }
        });
    });

    // Generate amper bill
    $('#btnGenerateAmperBill').click(function() {
        var clientId = $('#amperClientId').val();
        var month = $('#amperBillingMonth').val();
        var year = $('#amperBillingYear').val();
        if (!clientId) {
            showError('Please select a client');
            return;
        }
        var headers = {};
        headers[csrfHeader] = csrfToken;
        $.ajax({
            url: contextPath + '/billing/api/generate/amper',
            type: 'POST',
            headers: headers,
            data: { clientId: clientId, billingMonth: month, billingYear: year },
            success: function(resp) {
                if (resp.success) {
                    showSuccess(resp.message);
                    $("#billsGrid").trigger('reloadGrid');
                } else {
                    showError(resp.message);
                }
            }
        });
    });

    // Filter bills
    $('#btnFilterBills').click(function() {
        var month = $('#gridMonth').val();
        var year = $('#gridYear').val();
        var params = {};
        if (month) params.month = month;
        if (year) params.year = year;
        $("#billsGrid").jqGrid('setGridParam', { postData: params }).trigger('reloadGrid');
    });
});

function generateInvoice(billId) {
    if (!confirm('Generate invoice for this bill?')) return;
    var headers = {};
    headers[csrfHeader] = csrfToken;
    $.ajax({
        url: contextPath + '/invoices/api/generate/' + billId,
        type: 'POST',
        headers: headers,
        success: function(resp) {
            if (resp.success) {
                showSuccess('Invoice ' + resp.data.invoiceNumber + ' generated!');
                $("#billsGrid").trigger('reloadGrid');
            } else {
                showError(resp.message);
            }
        }
    });
}

function deleteBill(id) {
    if (!confirm('Delete this bill?')) return;
    var headers = {};
    headers[csrfHeader] = csrfToken;
    $.ajax({
        url: contextPath + '/billing/api/' + id,
        type: 'DELETE',
        headers: headers,
        success: function(resp) {
            showSuccess(resp.message);
            $("#billsGrid").trigger('reloadGrid');
        }
    });
}
</script>
</body>
</html>
