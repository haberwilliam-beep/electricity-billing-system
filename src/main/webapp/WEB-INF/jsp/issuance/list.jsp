<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<%@ include file="../header.jsp" %>

<div class="row mb-3">
    <div class="col-md-8">
        <h2><i class="fas fa-calendar-alt text-primary"></i> Issuance Management</h2>
    </div>
    <div class="col-md-4 text-right">
        <button class="btn btn-primary" onclick="openCreateModal()">
            <i class="fas fa-plus"></i> New Issuance
        </button>
    </div>
</div>

<div class="card shadow">
    <div class="card-body p-0">
        <table id="issuanceGrid"></table>
        <div id="issuancePager"></div>
    </div>
</div>

<!-- Issuance Modal -->
<div class="modal fade" id="issuanceModal" tabindex="-1">
    <div class="modal-dialog">
        <div class="modal-content">
            <div class="modal-header bg-primary text-white">
                <h5 class="modal-title" id="issuanceModalTitle">New Issuance</h5>
                <button type="button" class="close text-white" data-dismiss="modal">&times;</button>
            </div>
            <div class="modal-body">
                <form id="issuanceForm">
                    <input type="hidden" id="issId"/>
                    <div class="form-group">
                        <label>Issuance Date <span class="text-danger">*</span></label>
                        <input type="date" class="form-control" id="issDate" required/>
                    </div>
                    <div class="form-group">
                        <label>Billing Month <span class="text-danger">*</span></label>
                        <input type="month" class="form-control" id="issBillingMonth" required/>
                    </div>
                    <div class="form-group">
                        <label>Exchange Rate (USD to LBP) <span class="text-danger">*</span></label>
                        <input type="number" step="0.01" class="form-control" id="issExchangeRate"
                               value="${defaultExchangeRate}" required/>
                    </div>
                    <div class="form-group">
                        <label>Notes</label>
                        <textarea class="form-control" id="issNotes" rows="2"></textarea>
                    </div>
                </form>
            </div>
            <div class="modal-footer">
                <button type="button" class="btn btn-secondary" data-dismiss="modal">Cancel</button>
                <button type="button" class="btn btn-primary" onclick="saveIssuance()">
                    <i class="fas fa-save"></i> Save
                </button>
            </div>
        </div>
    </div>
</div>

<script>
var ctx = '${pageContext.request.contextPath}';
$(function() {
    $("#issuanceGrid").jqGrid({
        url: ctx + '/issuances/data',
        datatype: 'json', mtype:'GET',
        colNames: ['ID','Issuance Date','Billing Month','Exchange Rate','Status','Created By','Actions'],
        colModel: [
            {name:'id',             index:'id',           width:50, hidden:true},
            {name:'issuanceDate',   index:'issuanceDate', width:120, sortable:true},
            {name:'billingMonth',   index:'billingMonth', width:120, sortable:true},
            {name:'exchangeRate',   index:'exchangeRate', width:120},
            {name:'status',         index:'status',       width:90,
             formatter:function(v){ return v==='FINAL'?'<span class="badge badge-success">Final</span>':'<span class="badge badge-warning">Draft</span>'; }},
            {name:'createdByUsername', index:'createdByUsername', width:120},
            {name:'actions', index:'actions', width:180, sortable:false,
             formatter:function(v,o,row){
                var btns = '<button class="btn btn-xs btn-warning mr-1" onclick="openBilling('+row.id+')" title="Run Billing"><i class="fas fa-receipt"></i></button>';
                if (row.status !== 'FINAL') {
                    btns += '<button class="btn btn-xs btn-info mr-1" onclick="editIssuance('+row.id+')" title="Edit"><i class="fas fa-edit"></i></button>';
                    btns += '<button class="btn btn-xs btn-danger" onclick="deleteIssuance('+row.id+')" title="Delete"><i class="fas fa-trash"></i></button>';
                }
                btns += '<button class="btn btn-xs btn-secondary ml-1" onclick="printPdf('+row.id+')" title="PDF"><i class="fas fa-file-pdf"></i></button>';
                return btns;
             }}
        ],
        rowNum: 10, rowList:[10,20,50], pager:'#issuancePager',
        sortname:'billingMonth', sortorder:'desc', viewrecords:true,
        height:'auto', shrinkToFit:true, autowidth:true,
        jsonReader:{ root:'rows', page:'page', total:'total', records:'records', id:'id' }
    });
    $("#issuanceGrid").jqGrid('navGrid','#issuancePager',{add:false,edit:false,del:false,search:false,refresh:true});

    // Default today's date
    $('#issDate').val(new Date().toISOString().split('T')[0]);
});
function openCreateModal() {
    $('#issuanceForm')[0].reset(); $('#issId').val('');
    $('#issDate').val(new Date().toISOString().split('T')[0]);
    $('#issuanceModalTitle').text('New Issuance');
    $('#issuanceModal').modal('show');
}
function editIssuance(id) {
    $.get(ctx+'/issuances/'+id, function(iss) {
        $('#issId').val(iss.id);
        $('#issDate').val(iss.issuanceDate);
        $('#issBillingMonth').val(iss.billingMonth ? iss.billingMonth.substring(0,7) : '');
        $('#issExchangeRate').val(iss.exchangeRate);
        $('#issNotes').val(iss.notes);
        $('#issuanceModalTitle').text('Edit Issuance');
        $('#issuanceModal').modal('show');
    });
}
function saveIssuance() {
    if (!$('#issDate').val() || !$('#issBillingMonth').val() || !$('#issExchangeRate').val()) {
        alert('Please fill required fields.'); return;
    }
    var billingMonth = $('#issBillingMonth').val() + '-01';
    var data = {
        issuanceDate: $('#issDate').val(),
        billingMonth: billingMonth,
        exchangeRate: $('#issExchangeRate').val(),
        notes: $('#issNotes').val()
    };
    var id = $('#issId').val();
    $.ajax({ url: id?ctx+'/issuances/'+id:ctx+'/issuances', method:id?'PUT':'POST',
             contentType:'application/json', data:JSON.stringify(data),
             success:function(r) {
                 if(r.success) {
                     $('#issuanceModal').modal('hide');
                     $("#issuanceGrid").trigger('reloadGrid');
                     showAlert('success', r.message);
                 }
             }
    });
}
function deleteIssuance(id) {
    if (!confirm('Delete this issuance?')) return;
    $.ajax({ url:ctx+'/issuances/'+id, method:'DELETE',
             success:function(r) { if(r.success) { $("#issuanceGrid").trigger('reloadGrid'); showAlert('success',r.message); } }
    });
}
function openBilling(id) {
    window.location.href = ctx + '/billing/issuance/' + id;
}
function printPdf(id) {
    window.open(ctx + '/billing/pdf/' + id, '_blank');
}
</script>

<%@ include file="../footer.jsp" %>
