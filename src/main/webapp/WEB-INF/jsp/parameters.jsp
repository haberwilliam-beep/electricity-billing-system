<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<!DOCTYPE html>
<html lang="en">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>Parameters - Electricity Billing System</title>
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
            <h2>&#9881; System Parameters</h2>
            <button class="btn btn-success" id="btnAddParam">&#43; Add Parameter</button>
        </div>
    </div>

    <!-- Quick Set Core Parameters -->
    <div class="row mb-4">
        <div class="col-12">
            <div class="card border-info">
                <div class="card-header bg-info text-white">
                    <h6 class="mb-0">&#9881; Core Billing Parameters</h6>
                </div>
                <div class="card-body">
                    <div class="row">
                        <div class="col-md-3">
                            <div class="form-group">
                                <label>&#9889; Price per kWh (USD)</label>
                                <div class="input-group">
                                    <div class="input-group-prepend"><span class="input-group-text">$</span></div>
                                    <input type="number" class="form-control" id="pricePerKwh" step="0.01" min="0">
                                </div>
                            </div>
                        </div>
                        <div class="col-md-3">
                            <div class="form-group">
                                <label>&#9889; Price per Ampere (USD)</label>
                                <div class="input-group">
                                    <div class="input-group-prepend"><span class="input-group-text">$</span></div>
                                    <input type="number" class="form-control" id="pricePerAmpere" step="0.01" min="0">
                                </div>
                            </div>
                        </div>
                        <div class="col-md-3">
                            <div class="form-group">
                                <label>&#9889; Monthly Subscription Fee/Ampere (USD)</label>
                                <div class="input-group">
                                    <div class="input-group-prepend"><span class="input-group-text">$</span></div>
                                    <input type="number" class="form-control" id="subscriptionFeePerAmpere" step="0.01" min="0">
                                </div>
                            </div>
                        </div>
                        <div class="col-md-3">
                            <div class="form-group">
                                <label>&#128176; USD to LBP Exchange Rate</label>
                                <div class="input-group">
                                    <input type="number" class="form-control" id="exchangeRate" step="1" min="1">
                                    <div class="input-group-append"><span class="input-group-text">LBP</span></div>
                                </div>
                            </div>
                        </div>
                    </div>
                    <button class="btn btn-info" id="btnSaveCoreParams">
                        &#128190; Save Core Parameters
                    </button>
                </div>
            </div>
        </div>
    </div>

    <!-- All Parameters Grid -->
    <div class="row">
        <div class="col-12">
            <div class="card">
                <div class="card-header">
                    <h5 class="mb-0">All Parameters</h5>
                </div>
                <div class="card-body">
                    <table id="paramsGrid"></table>
                    <div id="paramsGridPager"></div>
                </div>
            </div>
        </div>
    </div>
</div>

<!-- Add/Edit Parameter Modal -->
<div class="modal fade" id="paramModal" tabindex="-1" role="dialog">
    <div class="modal-dialog" role="document">
        <div class="modal-content">
            <div class="modal-header bg-info text-white">
                <h5 class="modal-title" id="paramModalTitle">Add Parameter</h5>
                <button type="button" class="close text-white" data-dismiss="modal">
                    <span>&times;</span>
                </button>
            </div>
            <div class="modal-body">
                <form id="paramForm">
                    <input type="hidden" id="paramId" name="id">
                    <div class="form-group">
                        <label>Parameter Key *</label>
                        <input type="text" class="form-control" id="paramKey" name="paramKey"
                               placeholder="e.g. PRICE_PER_KWH" required>
                    </div>
                    <div class="form-group">
                        <label>Value *</label>
                        <input type="text" class="form-control" id="paramValue" name="paramValue"
                               required>
                    </div>
                    <div class="form-group">
                        <label>Description</label>
                        <input type="text" class="form-control" id="paramDesc" name="description">
                    </div>
                </form>
            </div>
            <div class="modal-footer">
                <button type="button" class="btn btn-secondary" data-dismiss="modal">Cancel</button>
                <button type="button" class="btn btn-info" id="btnSaveParam">Save</button>
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
    // Load current values into quick-set form
    loadCoreParams();

    // Initialize parameters grid
    $("#paramsGrid").jqGrid({
        url: contextPath + '/parameters/api/list',
        datatype: 'json',
        mtype: 'GET',
        colNames: ['ID', 'Key', 'Value', 'Description', 'Updated At', 'Actions'],
        colModel: [
            { name: 'id', width: 50, hidden: true },
            { name: 'paramKey', width: 200, formatter: function(val) { return '<code>' + val + '</code>'; } },
            { name: 'paramValue', width: 120, align: 'right', formatter: function(val) { return '<strong>' + val + '</strong>'; } },
            { name: 'description', width: 250 },
            { name: 'updatedAt', width: 160 },
            { name: 'actions', width: 120, sortable: false, align: 'center',
              formatter: function(val, opts, row) {
                  return '<button class="btn btn-sm btn-info mr-1" onclick="editParam(' + JSON.stringify(row).replace(/"/g,'&quot;') + ')">Edit</button>'
                       + '<button class="btn btn-sm btn-danger" onclick="deleteParam(' + row.id + ')">Del</button>';
              }
            }
        ],
        rowNum: 20,
        pager: '#paramsGridPager',
        viewrecords: true,
        caption: 'System Parameters',
        autowidth: true,
        height: 'auto',
        jsonReader: { total: 'total', page: 'page', records: 'records', root: 'rows' }
    });

    $('#btnAddParam').click(function() {
        $('#paramId').val('');
        $('#paramKey').val('').prop('readonly', false);
        $('#paramValue').val('');
        $('#paramDesc').val('');
        $('#paramModalTitle').text('Add Parameter');
        $('#paramModal').modal('show');
    });

    $('#btnSaveParam').click(saveParam);

    $('#btnSaveCoreParams').click(saveCoreParams);
});

function loadCoreParams() {
    $.get(contextPath + '/parameters/api/list', function(data) {
        if (data.rows) {
            data.rows.forEach(function(p) {
                if (p.paramKey === 'PRICE_PER_KWH') $('#pricePerKwh').val(p.paramValue);
                if (p.paramKey === 'PRICE_PER_AMPERE') $('#pricePerAmpere').val(p.paramValue);
                if (p.paramKey === 'SUBSCRIPTION_FEE_PER_AMPERE') $('#subscriptionFeePerAmpere').val(p.paramValue);
                if (p.paramKey === 'EXCHANGE_RATE_USD_TO_LBP') $('#exchangeRate').val(p.paramValue);
            });
        }
    });
}

function saveCoreParams() {
    var params = [
        { paramKey: 'PRICE_PER_KWH', paramValue: $('#pricePerKwh').val(), description: 'Price per kWh in USD' },
        { paramKey: 'PRICE_PER_AMPERE', paramValue: $('#pricePerAmpere').val(), description: 'Price per Ampere per month in USD' },
        { paramKey: 'SUBSCRIPTION_FEE_PER_AMPERE', paramValue: $('#subscriptionFeePerAmpere').val(), description: 'Monthly subscription fee per Ampere in USD' },
        { paramKey: 'EXCHANGE_RATE_USD_TO_LBP', paramValue: $('#exchangeRate').val(), description: 'USD to LBP exchange rate' }
    ];

    var headers = {};
    headers[csrfHeader] = csrfToken;

    var promises = params.map(function(p) {
        return $.ajax({
            url: contextPath + '/parameters/api/save',
            type: 'POST',
            contentType: 'application/json',
            headers: headers,
            data: JSON.stringify(p)
        });
    });

    $.when.apply($, promises).done(function() {
        showSuccess('Core parameters saved successfully');
        $("#paramsGrid").trigger('reloadGrid');
    }).fail(function() {
        showError('Error saving some parameters');
    });
}

function editParam(row) {
    $('#paramId').val(row.id);
    $('#paramKey').val(row.paramKey).prop('readonly', true);
    $('#paramValue').val(row.paramValue);
    $('#paramDesc').val(row.description);
    $('#paramModalTitle').text('Edit Parameter');
    $('#paramModal').modal('show');
}

function saveParam() {
    var param = {
        id: $('#paramId').val() || null,
        paramKey: $('#paramKey').val(),
        paramValue: $('#paramValue').val(),
        description: $('#paramDesc').val()
    };

    var headers = {};
    headers[csrfHeader] = csrfToken;

    var url = param.id
        ? contextPath + '/parameters/api/' + param.id
        : contextPath + '/parameters/api/save';
    var method = param.id ? 'PUT' : 'POST';

    $.ajax({
        url: url,
        type: method,
        contentType: 'application/json',
        headers: headers,
        data: JSON.stringify(param),
        success: function(resp) {
            if (resp.success) {
                showSuccess(resp.message);
                $('#paramModal').modal('hide');
                $("#paramsGrid").trigger('reloadGrid');
                loadCoreParams();
            } else {
                showError(resp.message);
            }
        }
    });
}

function deleteParam(id) {
    if (!confirm('Delete this parameter?')) return;
    var headers = {};
    headers[csrfHeader] = csrfToken;
    $.ajax({
        url: contextPath + '/parameters/api/' + id,
        type: 'DELETE',
        headers: headers,
        success: function(resp) {
            showSuccess(resp.message);
            $("#paramsGrid").trigger('reloadGrid');
            loadCoreParams();
        }
    });
}
</script>
</body>
</html>
