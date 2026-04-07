<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<!DOCTYPE html>
<html lang="en">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>Invoices - Electricity Billing System</title>
    <link rel="stylesheet" href="https://cdn.jsdelivr.net/npm/bootstrap@4.6.2/dist/css/bootstrap.min.css" integrity="sha384-xOolHFLEh07PJGoPkLv1IbcEPTNtaed2xpHsD9ESMhqIYd0nLMwNLD69Npy4HI+N" crossorigin="anonymous">
    <link rel="stylesheet" href="https://code.jquery.com/ui/1.13.2/themes/ui-lightness/jquery-ui.min.css" integrity="sha384-ycPwn8wvJIR01JNxdEVweBy3WWR7uMe5jId0MswZGCYwAYXVAaKxB6C3tT/4d8b5" crossorigin="anonymous">
    <link rel="stylesheet" href="https://cdnjs.cloudflare.com/ajax/libs/free-jqgrid/4.15.5/css/ui.jqgrid.min.css" integrity="sha384-Mt0ueSlN3BG92r5nroCSUozKMhA7TT9BmcUpzAI8+b6u5gOcxK7SaThK6wmaB+IG" crossorigin="anonymous">
    <link rel="stylesheet" href="${pageContext.request.contextPath}/css/styles.css">
</head>
<body>
<%@ include file="navbar.jsp" %>

<div class="container-fluid mt-4">
    <div class="row mb-3">
        <div class="col-12 d-flex justify-content-between align-items-center">
            <h2>&#128196; Invoice Management</h2>
            <div>
                <select class="form-control form-control-sm d-inline-block w-auto mr-1" id="filterMonth">
                    <option value="">All Months</option>
                    <option value="1">January</option><option value="2">February</option>
                    <option value="3">March</option><option value="4">April</option>
                    <option value="5">May</option><option value="6">June</option>
                    <option value="7">July</option><option value="8">August</option>
                    <option value="9">September</option><option value="10">October</option>
                    <option value="11">November</option><option value="12">December</option>
                </select>
                <input type="number" class="form-control form-control-sm d-inline-block w-auto mr-1"
                       id="filterYear" placeholder="Year" value="2024">
                <button class="btn btn-sm btn-primary" id="btnFilter">Filter</button>
                <button class="btn btn-sm btn-secondary ml-1" id="btnExportCsv">&#128190; Export CSV</button>
            </div>
        </div>
    </div>

    <div class="row">
        <div class="col-12">
            <div class="card">
                <div class="card-body">
                    <table id="invoiceGrid"></table>
                    <div id="invoiceGridPager"></div>
                </div>
            </div>
        </div>
    </div>
</div>

<!-- Invoice Detail Modal -->
<div class="modal fade" id="invoiceDetailModal" tabindex="-1" role="dialog">
    <div class="modal-dialog modal-lg" role="document">
        <div class="modal-content">
            <div class="modal-header bg-info text-white">
                <h5 class="modal-title">Invoice Details</h5>
                <button type="button" class="close text-white" data-dismiss="modal">
                    <span>&times;</span>
                </button>
            </div>
            <div class="modal-body" id="invoiceDetailBody">
            </div>
            <div class="modal-footer">
                <button type="button" class="btn btn-secondary" data-dismiss="modal">Close</button>
                <button type="button" class="btn btn-success" id="btnMarkPaid">Mark as Paid</button>
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
var currentInvoiceId = null;

$(document).ready(function() {
    $('#filterMonth').val(new Date().getMonth() + 1);

    // Initialize read-only invoices grid
    $("#invoiceGrid").jqGrid({
        url: contextPath + '/invoices/api/list',
        datatype: 'json',
        mtype: 'GET',
        colNames: ['ID', 'Invoice #', 'Client', 'Period', 'Issue Date', 'Due Date', 'Total (USD)', 'Total (LBP)', 'Exchange Rate', 'Status', 'Actions'],
        colModel: [
            { name: 'id', width: 50, hidden: true },
            { name: 'invoiceNumber', width: 160, align: 'center',
              formatter: function(val) { return '<strong>' + val + '</strong>'; }
            },
            { name: 'clientName', width: 160 },
            { name: 'period', width: 90, align: 'center',
              formatter: function(val, opts, row) { return row.billingMonth + '/' + row.billingYear; }
            },
            { name: 'issueDate', width: 110 },
            { name: 'dueDate', width: 110 },
            { name: 'totalAmountUsd', width: 120, align: 'right',
              formatter: function(val) { return '<strong style="color:#27ae60">$' + parseFloat(val).toFixed(2) + '</strong>'; }
            },
            { name: 'totalAmountLbp', width: 150, align: 'right',
              formatter: function(val) { return parseFloat(val).toLocaleString() + ' LBP'; }
            },
            { name: 'exchangeRate', width: 110, align: 'right' },
            { name: 'status', width: 90, align: 'center',
              formatter: function(val) {
                  var cls = {ISSUED:'primary',PAID:'success',OVERDUE:'danger',CANCELLED:'secondary'}[val] || 'secondary';
                  return '<span class="badge badge-' + cls + '">' + val + '</span>';
              }
            },
            { name: 'actions', width: 120, sortable: false, align: 'center',
              formatter: function(val, opts, row) {
                  return '<button class="btn btn-sm btn-info mr-1" onclick="viewInvoice(' + row.id + ')">View</button>'
                       + (row.status === 'ISSUED'
                           ? '<button class="btn btn-sm btn-success" onclick="markPaid(' + row.id + ')">Pay</button>'
                           : '');
              }
            }
        ],
        rowNum: 20,
        rowList: [10, 20, 50],
        pager: '#invoiceGridPager',
        sortname: 'issueDate',
        viewrecords: true,
        sortorder: 'desc',
        caption: 'Invoices (Read-Only)',
        autowidth: true,
        height: 'auto',
        jsonReader: { total: 'total', page: 'page', records: 'records', root: 'rows' }
    });

    $('#btnFilter').click(function() {
        var params = {};
        var month = $('#filterMonth').val();
        var year = $('#filterYear').val();
        if (month) params.month = month;
        if (year) params.year = year;
        $("#invoiceGrid").jqGrid('setGridParam', { postData: params }).trigger('reloadGrid');
    });

    $('#btnExportCsv').click(exportCsv);

    $('#btnMarkPaid').click(function() {
        if (currentInvoiceId) markPaid(currentInvoiceId);
    });
});

function viewInvoice(id) {
    $.ajax({
        url: contextPath + '/invoices/api/' + id,
        type: 'GET',
        success: function(inv) {
            currentInvoiceId = inv.id;
            var html = '<table class="table table-bordered">'
                + '<tr><td><strong>Invoice #</strong></td><td>' + inv.invoiceNumber + '</td>'
                + '<td><strong>Status</strong></td><td><span class="badge badge-primary">' + inv.status + '</span></td></tr>'
                + '<tr><td><strong>Client</strong></td><td>' + inv.clientName + '</td>'
                + '<td><strong>Period</strong></td><td>' + inv.billingMonth + '/' + inv.billingYear + '</td></tr>'
                + '<tr><td><strong>Issue Date</strong></td><td>' + inv.issueDate + '</td>'
                + '<td><strong>Due Date</strong></td><td>' + inv.dueDate + '</td></tr>'
                + '<tr class="table-success"><td><strong>Total (USD)</strong></td>'
                + '<td><strong>$' + parseFloat(inv.totalAmountUsd).toFixed(2) + '</strong></td>'
                + '<td><strong>Total (LBP)</strong></td>'
                + '<td><strong>' + parseFloat(inv.totalAmountLbp).toLocaleString() + ' LBP</strong></td></tr>'
                + '<tr><td><strong>Exchange Rate</strong></td><td>' + inv.exchangeRate + ' LBP/USD</td>'
                + '<td><strong>Notes</strong></td><td>' + (inv.notes || '-') + '</td></tr>'
                + '</table>';
            $('#invoiceDetailBody').html(html);
            $('#btnMarkPaid').toggle(inv.status === 'ISSUED');
            $('#invoiceDetailModal').modal('show');
        }
    });
}

function markPaid(id) {
    var headers = {};
    headers[csrfHeader] = csrfToken;
    $.ajax({
        url: contextPath + '/invoices/api/' + id + '/status?status=PAID',
        type: 'PUT',
        headers: headers,
        success: function(resp) {
            showSuccess('Invoice marked as paid');
            $('#invoiceDetailModal').modal('hide');
            $("#invoiceGrid").trigger('reloadGrid');
        }
    });
}

function exportCsv() {
    var rows = [];
    $("#invoiceGrid").jqGrid('getDataIDs').forEach(function(id) {
        var row = $("#invoiceGrid").jqGrid('getRowData', id);
        rows.push(row);
    });
    if (!rows.length) {
        showError('No data to export');
        return;
    }
    var csv = 'Invoice #,Client,Period,Issue Date,Total USD,Total LBP,Status\n';
    rows.forEach(function(r) {
        csv += [r.invoiceNumber, r.clientName, r.period, r.issueDate, r.totalAmountUsd, r.totalAmountLbp, r.status].join(',') + '\n';
    });
    var blob = new Blob([csv], { type: 'text/csv' });
    var url = window.URL.createObjectURL(blob);
    var a = $('<a>').attr({ href: url, download: 'invoices.csv' }).appendTo('body');
    a[0].click();
    a.remove();
}
</script>
</body>
</html>
