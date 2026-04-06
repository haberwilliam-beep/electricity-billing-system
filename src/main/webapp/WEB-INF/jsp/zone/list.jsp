<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<%@ include file="../header.jsp" %>

<div class="row mb-3">
    <div class="col-md-8">
        <h2><i class="fas fa-map text-primary"></i> Zone Management</h2>
    </div>
    <div class="col-md-4 text-right">
        <button class="btn btn-primary" onclick="openCreateModal()">
            <i class="fas fa-plus"></i> Add Zone
        </button>
    </div>
</div>

<div class="card shadow">
    <div class="card-body p-0">
        <table id="zoneGrid"></table>
        <div id="zonePager"></div>
    </div>
</div>

<!-- Zone Modal -->
<div class="modal fade" id="zoneModal" tabindex="-1">
    <div class="modal-dialog">
        <div class="modal-content">
            <div class="modal-header bg-primary text-white">
                <h5 class="modal-title" id="zoneModalTitle">Add Zone</h5>
                <button type="button" class="close text-white" data-dismiss="modal">&times;</button>
            </div>
            <div class="modal-body">
                <form id="zoneForm">
                    <input type="hidden" id="zoneId"/>
                    <div class="form-group">
                        <label>Zone Name <span class="text-danger">*</span></label>
                        <input type="text" class="form-control" id="zoneName" required/>
                    </div>
                    <div class="form-group">
                        <label>Description</label>
                        <textarea class="form-control" id="zoneDesc" rows="3"></textarea>
                    </div>
                    <div class="form-group">
                        <label>Status</label>
                        <select class="form-control" id="zoneActive">
                            <option value="true">Active</option>
                            <option value="false">Inactive</option>
                        </select>
                    </div>
                </form>
            </div>
            <div class="modal-footer">
                <button type="button" class="btn btn-secondary" data-dismiss="modal">Cancel</button>
                <button type="button" class="btn btn-primary" onclick="saveZone()">
                    <i class="fas fa-save"></i> Save
                </button>
            </div>
        </div>
    </div>
</div>

<script>
var ctx = '${pageContext.request.contextPath}';
$(function() {
    $("#zoneGrid").jqGrid({
        url: ctx + '/zones/data',
        datatype: 'json',
        mtype: 'GET',
        colNames: ['ID','Name','Description','Status','Actions'],
        colModel: [
            {name:'id',          index:'id',          width:50, hidden:true},
            {name:'name',        index:'name',        width:200, sortable:true},
            {name:'description', index:'description', width:300},
            {name:'active',      index:'active',      width:80,
             formatter: function(v) { return v?'<span class="badge badge-success">Active</span>':'<span class="badge badge-secondary">Inactive</span>'; }},
            {name:'actions', index:'actions', width:110, sortable:false,
             formatter: function(v,o,row) {
                return '<button class="btn btn-xs btn-info mr-1" onclick="editZone('+row.id+')"><i class="fas fa-edit"></i></button>'
                     + '<button class="btn btn-xs btn-danger" onclick="deleteZone('+row.id+',\''+row.name+'\')"><i class="fas fa-trash"></i></button>';
             }}
        ],
        rowNum: 10, rowList: [10,20,50], pager: '#zonePager',
        sortname: 'name', sortorder: 'asc', viewrecords: true,
        height: 'auto', shrinkToFit: true, autowidth: true,
        jsonReader: { root:'rows', page:'page', total:'total', records:'records', id:'id' }
    });
    $("#zoneGrid").jqGrid('navGrid','#zonePager',{add:false,edit:false,del:false,search:false,refresh:true});
});
function openCreateModal() {
    $('#zoneForm')[0].reset(); $('#zoneId').val('');
    $('#zoneModalTitle').text('Add Zone'); $('#zoneModal').modal('show');
}
function editZone(id) {
    $.get(ctx + '/zones/' + id, function(z) {
        $('#zoneId').val(z.id); $('#zoneName').val(z.name);
        $('#zoneDesc').val(z.description); $('#zoneActive').val(z.active?'true':'false');
        $('#zoneModalTitle').text('Edit Zone'); $('#zoneModal').modal('show');
    });
}
function saveZone() {
    if (!$('#zoneName').val()) { alert('Zone name is required.'); return; }
    var data = { name:$('#zoneName').val(), description:$('#zoneDesc').val(), active:$('#zoneActive').val()==='true' };
    var id = $('#zoneId').val();
    $.ajax({ url: id ? ctx+'/zones/'+id : ctx+'/zones', method: id?'PUT':'POST',
             contentType:'application/json', data:JSON.stringify(data),
             success: function(r) {
                 if(r.success) { $('#zoneModal').modal('hide'); $("#zoneGrid").trigger('reloadGrid'); showAlert('success',r.message); }
             }
    });
}
function deleteZone(id, name) {
    if (!confirm('Delete zone "'+name+'"?')) return;
    $.ajax({ url:ctx+'/zones/'+id, method:'DELETE',
             success:function(r) { if(r.success) { $("#zoneGrid").trigger('reloadGrid'); showAlert('success',r.message); } }
    });
}
</script>

<%@ include file="../footer.jsp" %>
