<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<%@ include file="../header.jsp" %>

<div class="row mb-3">
    <div class="col-md-8">
        <h2><i class="fas fa-users text-primary"></i> Customer Management</h2>
    </div>
    <div class="col-md-4 text-right">
        <button class="btn btn-primary" onclick="openCreateModal()">
            <i class="fas fa-plus"></i> Add Customer
        </button>
    </div>
</div>

<!-- Filters -->
<div class="card mb-3">
    <div class="card-body py-2">
        <div class="row">
            <div class="col-md-3">
                <input type="text" id="searchInput" class="form-control form-control-sm"
                       placeholder="Search by name, phone..." />
            </div>
            <div class="col-md-3">
                <select id="billingTypeFilter" class="form-control form-control-sm">
                    <option value="">All Billing Types</option>
                    <option value="METER">Meter-Based</option>
                    <option value="AMPER">Amper-Based</option>
                </select>
            </div>
            <div class="col-md-3">
                <select id="zoneFilter" class="form-control form-control-sm">
                    <option value="">All Zones</option>
                    <c:forEach var="z" items="${zones}">
                        <option value="${z.id}">${z.name}</option>
                    </c:forEach>
                </select>
            </div>
            <div class="col-md-3">
                <button class="btn btn-sm btn-outline-secondary" onclick="reloadGrid()">
                    <i class="fas fa-filter"></i> Apply
                </button>
                <button class="btn btn-sm btn-outline-danger ml-1" onclick="clearFilters()">
                    <i class="fas fa-times"></i> Clear
                </button>
            </div>
        </div>
    </div>
</div>

<!-- jqGrid -->
<div class="card shadow">
    <div class="card-body p-0">
        <table id="customerGrid"></table>
        <div id="customerPager"></div>
    </div>
</div>

<!-- Customer Modal -->
<div class="modal fade" id="customerModal" tabindex="-1">
    <div class="modal-dialog modal-lg">
        <div class="modal-content">
            <div class="modal-header bg-primary text-white">
                <h5 class="modal-title" id="modalTitle">Add Customer</h5>
                <button type="button" class="close text-white" data-dismiss="modal">&times;</button>
            </div>
            <div class="modal-body">
                <form id="customerForm">
                    <input type="hidden" id="custId"/>
                    <div class="row">
                        <div class="col-md-6">
                            <div class="form-group">
                                <label>Customer Name <span class="text-danger">*</span></label>
                                <input type="text" class="form-control" id="custName" required/>
                            </div>
                        </div>
                        <div class="col-md-6">
                            <div class="form-group">
                                <label>Phone</label>
                                <input type="text" class="form-control" id="custPhone"/>
                            </div>
                        </div>
                    </div>
                    <div class="row">
                        <div class="col-md-12">
                            <div class="form-group">
                                <label>Address</label>
                                <input type="text" class="form-control" id="custAddress"/>
                            </div>
                        </div>
                    </div>
                    <div class="row">
                        <div class="col-md-4">
                            <div class="form-group">
                                <label>Billing Type <span class="text-danger">*</span></label>
                                <select class="form-control" id="custBillingType" onchange="toggleBillingFields()">
                                    <option value="METER">Meter-Based</option>
                                    <option value="AMPER">Amper-Based</option>
                                </select>
                            </div>
                        </div>
                        <div class="col-md-4">
                            <div class="form-group">
                                <label>Zone <span class="text-danger">*</span></label>
                                <select class="form-control" id="custZoneId" onchange="loadBoxesByZone()">
                                    <option value="">Select Zone</option>
                                    <c:forEach var="z" items="${zones}">
                                        <option value="${z.id}">${z.name}</option>
                                    </c:forEach>
                                </select>
                            </div>
                        </div>
                        <div class="col-md-4">
                            <div class="form-group">
                                <label>Box <span class="text-danger">*</span></label>
                                <select class="form-control" id="custBoxId">
                                    <option value="">Select Box</option>
                                </select>
                            </div>
                        </div>
                    </div>
                    <div class="row">
                        <div class="col-md-4" id="meterRow">
                            <div class="form-group">
                                <label>Meter Number</label>
                                <input type="text" class="form-control" id="custMeterNumber"/>
                            </div>
                        </div>
                        <div class="col-md-4" id="amperRow" style="display:none">
                            <div class="form-group">
                                <label>Amper Capacity</label>
                                <input type="number" step="0.01" class="form-control" id="custAmperCapacity"/>
                            </div>
                        </div>
                        <div class="col-md-4">
                            <div class="form-group">
                                <label>Status</label>
                                <select class="form-control" id="custActive">
                                    <option value="true">Active</option>
                                    <option value="false">Inactive</option>
                                </select>
                            </div>
                        </div>
                    </div>
                </form>
            </div>
            <div class="modal-footer">
                <button type="button" class="btn btn-secondary" data-dismiss="modal">Cancel</button>
                <button type="button" class="btn btn-primary" onclick="saveCustomer()">
                    <i class="fas fa-save"></i> Save
                </button>
            </div>
        </div>
    </div>
</div>

<script>
var ctx = '${pageContext.request.contextPath}';

$(function() {
    $("#customerGrid").jqGrid({
        url: ctx + '/customers/data',
        datatype: 'json',
        mtype: 'GET',
        colNames: ['ID','Name','Phone','Zone','Box','Billing Type','Amper Cap','Meter No','Status','Actions'],
        colModel: [
            {name:'id',       index:'id',       width:50,  hidden:true},
            {name:'name',     index:'name',     width:150, sortable:true},
            {name:'phone',    index:'phone',    width:100},
            {name:'zoneName', index:'zoneName', width:100},
            {name:'boxName',  index:'boxName',  width:100},
            {name:'billingType', index:'billingType', width:100,
             formatter: function(v) { return v==='METER'?'<span class="badge badge-info">Meter</span>':'<span class="badge badge-warning">Amper</span>'; }},
            {name:'amperCapacity', index:'amperCapacity', width:80},
            {name:'meterNumber',   index:'meterNumber',   width:100},
            {name:'active',   index:'active',   width:70,
             formatter: function(v) { return v?'<span class="badge badge-success">Active</span>':'<span class="badge badge-secondary">Inactive</span>'; }},
            {name:'actions',  index:'actions',  width:110, sortable:false,
             formatter: function(v,o,row) {
                return '<button class="btn btn-xs btn-info mr-1" onclick="editCustomer('+row.id+')"><i class="fas fa-edit"></i></button>'
                     + '<button class="btn btn-xs btn-danger" onclick="deleteCustomer('+row.id+',\''+row.name+'\')"><i class="fas fa-trash"></i></button>';
             }}
        ],
        postData: { search: '', billingType: '', zoneId: '' },
        rowNum: 10,
        rowList: [10, 20, 50],
        pager: '#customerPager',
        sortname: 'name',
        sortorder: 'asc',
        viewrecords: true,
        height: 'auto',
        shrinkToFit: true,
        autowidth: true,
        jsonReader: { root:'rows', page:'page', total:'total', records:'records', id:'id' }
    });
    $("#customerGrid").jqGrid('navGrid','#customerPager',{add:false,edit:false,del:false,search:false,refresh:true});
});

function reloadGrid() {
    var pg = $("#customerGrid");
    pg.jqGrid('setGridParam', {
        postData: {
            search:      $('#searchInput').val(),
            billingType: $('#billingTypeFilter').val(),
            zoneId:      $('#zoneFilter').val()
        }
    }).trigger('reloadGrid', [{page:1}]);
}
function clearFilters() {
    $('#searchInput').val(''); $('#billingTypeFilter').val(''); $('#zoneFilter').val('');
    reloadGrid();
}
function openCreateModal() {
    $('#customerForm')[0].reset();
    $('#custId').val('');
    $('#modalTitle').text('Add Customer');
    $('#customerModal').modal('show');
}
function toggleBillingFields() {
    var type = $('#custBillingType').val();
    if (type === 'METER') { $('#meterRow').show(); $('#amperRow').hide(); }
    else { $('#meterRow').hide(); $('#amperRow').show(); }
}
function loadBoxesByZone() {
    var zoneId = $('#custZoneId').val();
    if (!zoneId) return;
    $.get(ctx + '/boxes/by-zone/' + zoneId, function(boxes) {
        var opts = '<option value="">Select Box</option>';
        $.each(boxes, function(i, b) { opts += '<option value="'+b.id+'">'+b.name+'</option>'; });
        $('#custBoxId').html(opts);
    });
}
function editCustomer(id) {
    $.get(ctx + '/customers/' + id, function(c) {
        $('#custId').val(c.id);
        $('#custName').val(c.name);
        $('#custPhone').val(c.phone);
        $('#custAddress').val(c.address);
        $('#custBillingType').val(c.billingType);
        $('#custActive').val(c.active ? 'true' : 'false');
        $('#custAmperCapacity').val(c.amperCapacity);
        $('#custMeterNumber').val(c.meterNumber);
        toggleBillingFields();
        // Load zones select, then set zone, load boxes, set box
        $('#custZoneId').val(c.zoneId);
        loadBoxesByZone();
        setTimeout(function() { $('#custBoxId').val(c.boxId); }, 500);
        $('#modalTitle').text('Edit Customer');
        $('#customerModal').modal('show');
    });
}
function saveCustomer() {
    if (!$('#custName').val() || !$('#custBoxId').val()) {
        alert('Please fill in required fields.'); return;
    }
    var data = {
        name: $('#custName').val(), phone: $('#custPhone').val(),
        address: $('#custAddress').val(), billingType: $('#custBillingType').val(),
        boxId: $('#custBoxId').val(), amperCapacity: $('#custAmperCapacity').val(),
        meterNumber: $('#custMeterNumber').val(), active: $('#custActive').val() === 'true'
    };
    var id = $('#custId').val();
    var method = id ? 'PUT' : 'POST';
    var url = id ? ctx + '/customers/' + id : ctx + '/customers';
    $.ajax({ url:url, method:method, contentType:'application/json',
             data: JSON.stringify(data),
             success: function(r) {
                 if(r.success) { $('#customerModal').modal('hide'); reloadGrid(); showAlert('success', r.message); }
                 else showAlert('danger', r.message);
             }
    });
}
function deleteCustomer(id, name) {
    if (!confirm('Delete customer "' + name + '"?')) return;
    $.ajax({ url: ctx+'/customers/'+id, method:'DELETE',
             success: function(r) {
                 if(r.success) { reloadGrid(); showAlert('success', r.message); }
             }
    });
}
</script>

<%@ include file="../footer.jsp" %>
