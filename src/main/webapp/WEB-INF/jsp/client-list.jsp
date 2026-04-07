<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<!DOCTYPE html>
<html lang="en">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>Client Management - Electricity Billing System</title>
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
            <h2>&#128101; Client Management</h2>
            <div>
                <button class="btn btn-success mr-2" id="btnAddClient">
                    &#43; Add Client
                </button>
                <div class="btn-group">
                    <button class="btn btn-outline-secondary btn-sm" id="btnFilterAll">All</button>
                    <button class="btn btn-outline-primary btn-sm" id="btnFilterMeter">Meter-Based</button>
                    <button class="btn btn-outline-warning btn-sm" id="btnFilterAmper">Amper-Based</button>
                </div>
            </div>
        </div>
    </div>

    <div class="row">
        <div class="col-12">
            <div class="card">
                <div class="card-body">
                    <table id="clientGrid"></table>
                    <div id="clientGridPager"></div>
                </div>
            </div>
        </div>
    </div>
</div>

<!-- Add/Edit Client Modal -->
<div class="modal fade" id="clientModal" tabindex="-1" role="dialog">
    <div class="modal-dialog modal-lg" role="document">
        <div class="modal-content">
            <div class="modal-header bg-primary text-white">
                <h5 class="modal-title" id="clientModalTitle">Add Client</h5>
                <button type="button" class="close text-white" data-dismiss="modal">
                    <span>&times;</span>
                </button>
            </div>
            <div class="modal-body">
                <form id="clientForm">
                    <input type="hidden" id="clientId" name="id">
                    <div class="row">
                        <div class="col-md-6">
                            <div class="form-group">
                                <label>Name *</label>
                                <input type="text" class="form-control" id="clientName" name="name" required>
                            </div>
                        </div>
                        <div class="col-md-6">
                            <div class="form-group">
                                <label>Account Number</label>
                                <input type="text" class="form-control" id="accountNumber" name="accountNumber"
                                       placeholder="Auto-generated if blank">
                            </div>
                        </div>
                    </div>
                    <div class="row">
                        <div class="col-md-6">
                            <div class="form-group">
                                <label>Client Type *</label>
                                <select class="form-control" id="clientType" name="clientType" required>
                                    <option value="">-- Select Type --</option>
                                    <option value="METER_BASED">Meter-Based</option>
                                    <option value="AMPER_BASED">Amper-Based</option>
                                </select>
                            </div>
                        </div>
                        <div class="col-md-6">
                            <div class="form-group">
                                <label>Ampere Capacity *</label>
                                <select class="form-control" id="ampereCapacity" name="ampereCapacity" required>
                                    <option value="5">5 Amperes</option>
                                    <option value="10">10 Amperes</option>
                                </select>
                            </div>
                        </div>
                    </div>
                    <div class="row">
                        <div class="col-md-6">
                            <div class="form-group">
                                <label>Phone</label>
                                <input type="text" class="form-control" id="clientPhone" name="phone">
                            </div>
                        </div>
                        <div class="col-md-6">
                            <div class="form-group">
                                <label>Email</label>
                                <input type="email" class="form-control" id="clientEmail" name="email">
                            </div>
                        </div>
                    </div>
                    <div class="form-group">
                        <label>Address</label>
                        <textarea class="form-control" id="clientAddress" name="address" rows="2"></textarea>
                    </div>
                    <div class="form-group">
                        <div class="custom-control custom-switch">
                            <input type="checkbox" class="custom-control-input" id="clientActive" name="active" checked>
                            <label class="custom-control-label" for="clientActive">Active</label>
                        </div>
                    </div>
                </form>
            </div>
            <div class="modal-footer">
                <button type="button" class="btn btn-secondary" data-dismiss="modal">Cancel</button>
                <button type="button" class="btn btn-primary" id="btnSaveClient">Save Client</button>
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
    // Initialize jqGrid
    $("#clientGrid").jqGrid({
        url: contextPath + '/clients/api/list',
        datatype: 'json',
        mtype: 'GET',
        colNames: ['ID', 'Name', 'Account Number', 'Type', 'Ampere Capacity', 'Phone', 'Email', 'Active', 'Actions'],
        colModel: [
            { name: 'id', index: 'id', width: 50, hidden: true },
            { name: 'name', index: 'name', width: 180 },
            { name: 'accountNumber', index: 'accountNumber', width: 140 },
            { name: 'clientType', index: 'clientType', width: 130,
              formatter: function(val) {
                  return val === 'METER_BASED'
                      ? '<span class="badge badge-primary">Meter-Based</span>'
                      : '<span class="badge badge-warning text-dark">Amper-Based</span>';
              }
            },
            { name: 'ampereCapacity', index: 'ampereCapacity', width: 120, align: 'center',
              formatter: function(val) { return val + 'A'; }
            },
            { name: 'phone', index: 'phone', width: 120 },
            { name: 'email', index: 'email', width: 160 },
            { name: 'active', index: 'active', width: 70, align: 'center',
              formatter: function(val) {
                  return val ? '<span class="badge badge-success">Yes</span>'
                             : '<span class="badge badge-secondary">No</span>';
              }
            },
            { name: 'actions', index: 'actions', width: 120, sortable: false, align: 'center',
              formatter: function(val, opts, row) {
                  return '<button class="btn btn-sm btn-info mr-1" onclick="editClient(' + row.id + ')">Edit</button>'
                       + '<button class="btn btn-sm btn-danger" onclick="deleteClient(' + row.id + ')">Del</button>';
              }
            }
        ],
        rowNum: 20,
        rowList: [10, 20, 50],
        pager: '#clientGridPager',
        sortname: 'name',
        viewrecords: true,
        sortorder: 'asc',
        caption: 'Clients',
        autowidth: true,
        height: 'auto',
        jsonReader: {
            total: 'total',
            page: 'page',
            records: 'records',
            root: 'rows'
        }
    });

    // Add client
    $('#btnAddClient').click(function() {
        clearClientForm();
        $('#clientModalTitle').text('Add Client');
        $('#clientModal').modal('show');
    });

    // Save client
    $('#btnSaveClient').click(saveClient);

    // Filter buttons
    $('#btnFilterAll').click(function() { reloadGrid(''); });
    $('#btnFilterMeter').click(function() { reloadGrid('METER_BASED'); });
    $('#btnFilterAmper').click(function() { reloadGrid('AMPER_BASED'); });
});

function reloadGrid(type) {
    var url = contextPath + '/clients/api/list';
    if (type) url += '?type=' + type;
    $("#clientGrid").jqGrid('setGridParam', { url: url }).trigger('reloadGrid');
}

function clearClientForm() {
    $('#clientId').val('');
    $('#clientName').val('');
    $('#accountNumber').val('');
    $('#clientType').val('');
    $('#ampereCapacity').val('5');
    $('#clientPhone').val('');
    $('#clientEmail').val('');
    $('#clientAddress').val('');
    $('#clientActive').prop('checked', true);
}

function editClient(id) {
    $.ajax({
        url: contextPath + '/clients/api/' + id,
        type: 'GET',
        success: function(data) {
            $('#clientId').val(data.id);
            $('#clientName').val(data.name);
            $('#accountNumber').val(data.accountNumber);
            $('#clientType').val(data.clientType);
            $('#ampereCapacity').val(data.ampereCapacity);
            $('#clientPhone').val(data.phone);
            $('#clientEmail').val(data.email);
            $('#clientAddress').val(data.address);
            $('#clientActive').prop('checked', data.active);
            $('#clientModalTitle').text('Edit Client');
            $('#clientModal').modal('show');
        }
    });
}

function saveClient() {
    var client = {
        id: $('#clientId').val() || null,
        name: $('#clientName').val(),
        accountNumber: $('#accountNumber').val(),
        clientType: $('#clientType').val(),
        ampereCapacity: parseInt($('#ampereCapacity').val()),
        phone: $('#clientPhone').val(),
        email: $('#clientEmail').val(),
        address: $('#clientAddress').val(),
        active: $('#clientActive').is(':checked')
    };

    var headers = {};
    headers[csrfHeader] = csrfToken;

    $.ajax({
        url: contextPath + '/clients/api/save',
        type: 'POST',
        contentType: 'application/json',
        headers: headers,
        data: JSON.stringify(client),
        success: function(resp) {
            if (resp.success) {
                showSuccess(resp.message);
                $('#clientModal').modal('hide');
                $("#clientGrid").trigger('reloadGrid');
            } else {
                showError(resp.message);
            }
        },
        error: function(xhr) {
            showError('Error saving client: ' + xhr.responseText);
        }
    });
}

function deleteClient(id) {
    if (!confirm('Are you sure you want to delete this client?')) return;
    var headers = {};
    headers[csrfHeader] = csrfToken;
    $.ajax({
        url: contextPath + '/clients/api/' + id,
        type: 'DELETE',
        headers: headers,
        success: function(resp) {
            showSuccess(resp.message);
            $("#clientGrid").trigger('reloadGrid');
        },
        error: function(xhr) {
            showError('Error deleting client');
        }
    });
}
</script>
</body>
</html>
