<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<!DOCTYPE html>
<html lang="en">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>Meter Readings - Electricity Billing System</title>
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
            <h2>&#128207; Meter Readings</h2>
            <button class="btn btn-success" id="btnAddReading">&#43; Add Reading</button>
        </div>
    </div>

    <!-- Filter row -->
    <div class="row mb-3">
        <div class="col-md-3">
            <select class="form-control" id="filterClient">
                <option value="">-- All Clients --</option>
                <c:forEach var="client" items="${clients}">
                    <option value="${client.id}">${client.name}</option>
                </c:forEach>
            </select>
        </div>
        <div class="col-md-2">
            <select class="form-control" id="filterMonth">
                <option value="">-- Month --</option>
                <option value="1">January</option>
                <option value="2">February</option>
                <option value="3">March</option>
                <option value="4">April</option>
                <option value="5">May</option>
                <option value="6">June</option>
                <option value="7">July</option>
                <option value="8">August</option>
                <option value="9">September</option>
                <option value="10">October</option>
                <option value="11">November</option>
                <option value="12">December</option>
            </select>
        </div>
        <div class="col-md-2">
            <input type="number" class="form-control" id="filterYear" placeholder="Year" value="2024">
        </div>
        <div class="col-md-2">
            <button class="btn btn-primary" id="btnFilter">Filter</button>
            <button class="btn btn-secondary ml-1" id="btnReset">Reset</button>
        </div>
    </div>

    <div class="row">
        <div class="col-12">
            <div class="card">
                <div class="card-body">
                    <table id="meterReadingGrid"></table>
                    <div id="meterReadingGridPager"></div>
                </div>
            </div>
        </div>
    </div>
</div>

<!-- Add/Edit Meter Reading Modal -->
<div class="modal fade" id="meterReadingModal" tabindex="-1" role="dialog">
    <div class="modal-dialog" role="document">
        <div class="modal-content">
            <div class="modal-header bg-success text-white">
                <h5 class="modal-title" id="meterReadingModalTitle">Add Meter Reading</h5>
                <button type="button" class="close text-white" data-dismiss="modal">
                    <span>&times;</span>
                </button>
            </div>
            <div class="modal-body">
                <form id="meterReadingForm">
                    <input type="hidden" id="readingId" name="id">
                    <div class="form-group">
                        <label>Client *</label>
                        <select class="form-control" id="readingClientId" name="clientId" required>
                            <option value="">-- Select Client --</option>
                            <c:forEach var="client" items="${clients}">
                                <option value="${client.id}">${client.name} (${client.accountNumber})</option>
                            </c:forEach>
                        </select>
                    </div>
                    <div class="row">
                        <div class="col-md-6">
                            <div class="form-group">
                                <label>Billing Month *</label>
                                <select class="form-control" id="readingMonth" name="billingMonth" required>
                                    <option value="1">January</option>
                                    <option value="2">February</option>
                                    <option value="3">March</option>
                                    <option value="4">April</option>
                                    <option value="5">May</option>
                                    <option value="6">June</option>
                                    <option value="7">July</option>
                                    <option value="8">August</option>
                                    <option value="9">September</option>
                                    <option value="10">October</option>
                                    <option value="11">November</option>
                                    <option value="12">December</option>
                                </select>
                            </div>
                        </div>
                        <div class="col-md-6">
                            <div class="form-group">
                                <label>Billing Year *</label>
                                <input type="number" class="form-control" id="readingYear" name="billingYear"
                                       value="2024" min="2020" max="2030" required>
                            </div>
                        </div>
                    </div>
                    <div class="form-group">
                        <label>Reading Date *</label>
                        <input type="date" class="form-control" id="readingDate" name="readingDate" required>
                    </div>
                    <div class="row">
                        <div class="col-md-6">
                            <div class="form-group">
                                <label>Start Reading (kWh) *</label>
                                <input type="number" class="form-control" id="startReading" name="startReading"
                                       step="0.01" min="0" required onchange="calculateConsumption()">
                            </div>
                        </div>
                        <div class="col-md-6">
                            <div class="form-group">
                                <label>End Reading (kWh) *</label>
                                <input type="number" class="form-control" id="endReading" name="endReading"
                                       step="0.01" min="0" required onchange="calculateConsumption()">
                            </div>
                        </div>
                    </div>
                    <div class="form-group">
                        <label>Consumption (kWh)</label>
                        <input type="text" class="form-control" id="consumption" readonly
                               style="background: #f8f9fa; font-weight: bold;">
                    </div>
                    <div class="form-group">
                        <label>Notes</label>
                        <textarea class="form-control" id="readingNotes" name="notes" rows="2"></textarea>
                    </div>
                </form>
            </div>
            <div class="modal-footer">
                <button type="button" class="btn btn-secondary" data-dismiss="modal">Cancel</button>
                <button type="button" class="btn btn-success" id="btnSaveReading">Save Reading</button>
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
    // Set today's date as default
    var today = new Date().toISOString().split('T')[0];
    $('#readingDate').val(today);

    // Initialize jqGrid
    $("#meterReadingGrid").jqGrid({
        url: contextPath + '/meter-readings/api/list',
        datatype: 'json',
        mtype: 'GET',
        colNames: ['ID', 'Client', 'Period', 'Start (kWh)', 'End (kWh)', 'Consumption', 'Reading Date', 'Notes', 'Actions'],
        colModel: [
            { name: 'id', index: 'id', width: 50, hidden: true },
            { name: 'clientName', index: 'clientName', width: 180 },
            { name: 'period', index: 'billingMonth', width: 100, align: 'center',
              formatter: function(val, opts, row) {
                  return row.billingMonth + '/' + row.billingYear;
              }
            },
            { name: 'startReading', index: 'startReading', width: 110, align: 'right' },
            { name: 'endReading', index: 'endReading', width: 110, align: 'right' },
            { name: 'consumption', index: 'consumption', width: 120, align: 'right',
              formatter: function(val) {
                  return '<strong>' + parseFloat(val).toFixed(2) + ' kWh</strong>';
              }
            },
            { name: 'readingDate', index: 'readingDate', width: 110 },
            { name: 'notes', index: 'notes', width: 150 },
            { name: 'actions', index: 'actions', width: 120, sortable: false, align: 'center',
              formatter: function(val, opts, row) {
                  return '<button class="btn btn-sm btn-info mr-1" onclick="editReading(' + JSON.stringify(row).replace(/"/g,'&quot;') + ')">Edit</button>'
                       + '<button class="btn btn-sm btn-danger" onclick="deleteReading(' + row.id + ')">Del</button>';
              }
            }
        ],
        rowNum: 20,
        rowList: [10, 20, 50],
        pager: '#meterReadingGridPager',
        sortname: 'readingDate',
        viewrecords: true,
        sortorder: 'desc',
        caption: 'Meter Readings',
        autowidth: true,
        height: 'auto',
        jsonReader: {
            total: 'total', page: 'page', records: 'records', root: 'rows'
        }
    });

    $('#btnAddReading').click(function() {
        clearReadingForm();
        $('#meterReadingModalTitle').text('Add Meter Reading');
        $('#meterReadingModal').modal('show');
    });

    $('#btnSaveReading').click(saveReading);

    $('#btnFilter').click(function() {
        var params = {};
        var clientId = $('#filterClient').val();
        var month = $('#filterMonth').val();
        var year = $('#filterYear').val();
        if (clientId) params.clientId = clientId;
        if (month) params.month = month;
        if (year) params.year = year;
        $("#meterReadingGrid").jqGrid('setGridParam', {
            url: contextPath + '/meter-readings/api/list',
            postData: params
        }).trigger('reloadGrid');
    });

    $('#btnReset').click(function() {
        $('#filterClient').val('');
        $('#filterMonth').val('');
        $('#filterYear').val('2024');
        $("#meterReadingGrid").jqGrid('setGridParam', {
            url: contextPath + '/meter-readings/api/list',
            postData: {}
        }).trigger('reloadGrid');
    });
});

function calculateConsumption() {
    var start = parseFloat($('#startReading').val()) || 0;
    var end = parseFloat($('#endReading').val()) || 0;
    var consumption = end - start;
    $('#consumption').val(consumption >= 0 ? consumption.toFixed(2) : 'Invalid (end < start)');
}

function clearReadingForm() {
    $('#readingId').val('');
    $('#readingClientId').val('');
    $('#readingMonth').val(new Date().getMonth() + 1);
    $('#readingYear').val(new Date().getFullYear());
    var today = new Date().toISOString().split('T')[0];
    $('#readingDate').val(today);
    $('#startReading').val('');
    $('#endReading').val('');
    $('#consumption').val('');
    $('#readingNotes').val('');
}

function editReading(row) {
    $('#readingId').val(row.id);
    $('#readingClientId').val(row.clientId);
    $('#readingMonth').val(row.billingMonth);
    $('#readingYear').val(row.billingYear);
    $('#readingDate').val(row.readingDate);
    $('#startReading').val(row.startReading);
    $('#endReading').val(row.endReading);
    $('#consumption').val(row.consumption);
    $('#readingNotes').val(row.notes);
    $('#meterReadingModalTitle').text('Edit Meter Reading');
    $('#meterReadingModal').modal('show');
}

function saveReading() {
    var reading = {
        id: $('#readingId').val() || null,
        clientId: $('#readingClientId').val(),
        billingMonth: parseInt($('#readingMonth').val()),
        billingYear: parseInt($('#readingYear').val()),
        readingDate: $('#readingDate').val(),
        startReading: parseFloat($('#startReading').val()),
        endReading: parseFloat($('#endReading').val()),
        notes: $('#readingNotes').val()
    };

    var headers = {};
    headers[csrfHeader] = csrfToken;

    $.ajax({
        url: contextPath + '/meter-readings/api/save',
        type: 'POST',
        contentType: 'application/json',
        headers: headers,
        data: JSON.stringify(reading),
        success: function(resp) {
            if (resp.success) {
                showSuccess(resp.message);
                $('#meterReadingModal').modal('hide');
                $("#meterReadingGrid").trigger('reloadGrid');
            } else {
                showError(resp.message);
            }
        }
    });
}

function deleteReading(id) {
    if (!confirm('Are you sure you want to delete this reading?')) return;
    var headers = {};
    headers[csrfHeader] = csrfToken;
    $.ajax({
        url: contextPath + '/meter-readings/api/' + id,
        type: 'DELETE',
        headers: headers,
        success: function(resp) {
            showSuccess(resp.message);
            $("#meterReadingGrid").trigger('reloadGrid');
        }
    });
}
</script>
</body>
</html>
