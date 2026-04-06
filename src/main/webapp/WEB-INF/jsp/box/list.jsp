<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<%@ include file="../header.jsp" %>

<div class="row mb-3">
    <div class="col-md-8">
        <h2><i class="fas fa-box text-primary"></i> Box Management</h2>
    </div>
    <div class="col-md-4 text-right">
        <button class="btn btn-primary" onclick="openCreateModal()">
            <i class="fas fa-plus"></i> Add Box
        </button>
    </div>
</div>

<!-- Zone Filter -->
<div class="card mb-3">
    <div class="card-body py-2">
        <div class="row">
            <div class="col-md-4">
                <select id="zoneFilter" class="form-control form-control-sm" onchange="reloadGrid()">
                    <option value="">All Zones</option>
                    <c:forEach var="z" items="${zones}">
                        <option value="${z.id}">${z.name}</option>
                    </c:forEach>
                </select>
            </div>
        </div>
    </div>
</div>

<div class="card shadow">
    <div class="card-body p-0">
        <table id="boxGrid"></table>
        <div id="boxPager"></div>
    </div>
</div>

<!-- Box Modal -->
<div class="modal fade" id="boxModal" tabindex="-1">
    <div class="modal-dialog">
        <div class="modal-content">
            <div class="modal-header bg-primary text-white">
                <h5 class="modal-title" id="boxModalTitle">Add Box</h5>
                <button type="button" class="close text-white" data-dismiss="modal">&times;</button>
            </div>
            <div class="modal-body">
                <form id="boxForm">
                    <input type="hidden" id="boxId"/>
                    <div class="form-group">
                        <label>Zone <span class="text-danger">*</span></label>
                        <select class="form-control" id="boxZoneId" required>
                            <option value="">Select Zone</option>
                            <c:forEach var="z" items="${zones}">
                                <option value="${z.id}">${z.name}</option>
                            </c:forEach>
                        </select>
                    </div>
                    <div class="form-group">
                        <label>Box Name <span class="text-danger">*</span></label>
                        <input type="text" class="form-control" id="boxName" required/>
                    </div>
                    <div class="form-group">
                        <label>Description</label>
                        <textarea class="form-control" id="boxDesc" rows="2"></textarea>
                    </div>
                    <div class="form-group">
                        <label>Status</label>
                        <select class="form-control" id="boxActive">
                            <option value="true">Active</option>
                            <option value="false">Inactive</option>
                        </select>
                    </div>
                </form>
            </div>
            <div class="modal-footer">
                <button type="button" class="btn btn-secondary" data-dismiss="modal">Cancel</button>
                <button type="button" class="btn btn-primary" onclick="saveBox()">
                    <i class="fas fa-save"></i> Save
                </button>
            </div>
        </div>
    </div>
</div>

<script>
var ctx = '${pageContext.request.contextPath}';
$(function() {
    $("#boxGrid").jqGrid({
        url: ctx + '/boxes/data',
        datatype: 'json', mtype: 'GET',
        colNames: ['ID','Name','Zone','Description','Status','Actions'],
        colModel: [
            {name:'id',          index:'id',          width:50, hidden:true},
            {name:'name',        index:'name',        width:180, sortable:true},
            {name:'zoneName',    index:'zoneName',    width:150, sortable:true},
            {name:'description', index:'description', width:250},
            {name:'active',      index:'active',      width:80,
             formatter: function(v) { return v?'<span class="badge badge-success">Active</span>':'<span class="badge badge-secondary">Inactive</span>'; }},
            {name:'actions', index:'actions', width:110, sortable:false,
             formatter: function(v,o,row) {
                return '<button class="btn btn-xs btn-info mr-1" onclick="editBox('+row.id+')"><i class="fas fa-edit"></i></button>'
                     + '<button class="btn btn-xs btn-danger" onclick="deleteBox('+row.id+',\''+row.name+'\')"><i class="fas fa-trash"></i></button>';
             }}
        ],
        postData: { zoneId: '' },
        rowNum: 10, rowList: [10,20,50], pager: '#boxPager',
        sortname: 'name', sortorder: 'asc', viewrecords: true,
        height: 'auto', shrinkToFit: true, autowidth: true,
        jsonReader: { root:'rows', page:'page', total:'total', records:'records', id:'id' }
    });
    $("#boxGrid").jqGrid('navGrid','#boxPager',{add:false,edit:false,del:false,search:false,refresh:true});
});
function reloadGrid() {
    $("#boxGrid").jqGrid('setGridParam', { postData: { zoneId: $('#zoneFilter').val() } }).trigger('reloadGrid',[{page:1}]);
}
function openCreateModal() {
    $('#boxForm')[0].reset(); $('#boxId').val('');
    $('#boxModalTitle').text('Add Box'); $('#boxModal').modal('show');
}
function editBox(id) {
    $.get(ctx+'/boxes/'+id, function(b) {
        $('#boxId').val(b.id); $('#boxName').val(b.name);
        $('#boxZoneId').val(b.zoneId); $('#boxDesc').val(b.description);
        $('#boxActive').val(b.active?'true':'false');
        $('#boxModalTitle').text('Edit Box'); $('#boxModal').modal('show');
    });
}
function saveBox() {
    if (!$('#boxName').val() || !$('#boxZoneId').val()) { alert('Name and Zone are required.'); return; }
    var data = { name:$('#boxName').val(), zoneId:$('#boxZoneId').val(), description:$('#boxDesc').val(), active:$('#boxActive').val()==='true' };
    var id = $('#boxId').val();
    $.ajax({ url: id?ctx+'/boxes/'+id:ctx+'/boxes', method:id?'PUT':'POST',
             contentType:'application/json', data:JSON.stringify(data),
             success:function(r) { if(r.success) { $('#boxModal').modal('hide'); reloadGrid(); showAlert('success',r.message); } }
    });
}
function deleteBox(id, name) {
    if (!confirm('Delete box "'+name+'"?')) return;
    $.ajax({ url:ctx+'/boxes/'+id, method:'DELETE',
             success:function(r) { if(r.success) { reloadGrid(); showAlert('success',r.message); } }
    });
}
</script>

<%@ include file="../footer.jsp" %>
