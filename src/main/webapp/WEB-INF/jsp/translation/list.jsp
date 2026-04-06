<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<%@ include file="../header.jsp" %>

<div class="row mb-3">
    <div class="col-md-8">
        <h2><i class="fas fa-language text-primary"></i> Translation Management</h2>
    </div>
    <div class="col-md-4 text-right">
        <button class="btn btn-primary" onclick="openCreateModal()">
            <i class="fas fa-plus"></i> Add Translation
        </button>
    </div>
</div>

<div class="card shadow">
    <div class="card-body p-0">
        <table id="translationGrid"></table>
        <div id="translationPager"></div>
    </div>
</div>

<!-- Translation Modal -->
<div class="modal fade" id="translationModal" tabindex="-1">
    <div class="modal-dialog">
        <div class="modal-content">
            <div class="modal-header bg-primary text-white">
                <h5 class="modal-title" id="translationModalTitle">Add Translation</h5>
                <button type="button" class="close text-white" data-dismiss="modal">&times;</button>
            </div>
            <div class="modal-body">
                <form id="translationForm">
                    <div class="form-group">
                        <label>Key <span class="text-danger">*</span></label>
                        <input type="text" class="form-control" id="transKey" required/>
                    </div>
                    <div class="form-group">
                        <label>English Value <span class="text-danger">*</span></label>
                        <input type="text" class="form-control" id="transEn" required/>
                    </div>
                    <div class="form-group">
                        <label>Arabic Value</label>
                        <input type="text" class="form-control" id="transAr" dir="rtl"/>
                    </div>
                </form>
            </div>
            <div class="modal-footer">
                <button type="button" class="btn btn-secondary" data-dismiss="modal">Cancel</button>
                <button type="button" class="btn btn-primary" onclick="saveTranslation()">
                    <i class="fas fa-save"></i> Save
                </button>
            </div>
        </div>
    </div>
</div>

<script>
var ctx = '${pageContext.request.contextPath}';
$(function() {
    $("#translationGrid").jqGrid({
        url: ctx + '/translations/data',
        datatype:'json', mtype:'GET',
        colNames:['ID','Key','English','Arabic','Actions'],
        colModel:[
            {name:'id',       index:'id',       width:50, hidden:true},
            {name:'msgKey',   index:'msgKey',   width:200, sortable:true},
            {name:'enValue',  index:'enValue',  width:200, editable:true},
            {name:'arValue',  index:'arValue',  width:200, editable:true},
            {name:'actions',  index:'actions',  width:110, sortable:false,
             formatter:function(v,o,row){
                return '<button class="btn btn-xs btn-info mr-1" onclick="editTranslation('+row.id+')"><i class="fas fa-edit"></i></button>'
                     + '<button class="btn btn-xs btn-danger" onclick="deleteTranslation('+row.id+')"><i class="fas fa-trash"></i></button>';
             }}
        ],
        rowNum:10, rowList:[10,20,50], pager:'#translationPager',
        sortname:'msgKey', sortorder:'asc', viewrecords:true,
        height:'auto', shrinkToFit:true, autowidth:true,
        jsonReader:{root:'rows',page:'page',total:'total',records:'records',id:'id'}
    });
    $("#translationGrid").jqGrid('navGrid','#translationPager',{add:false,edit:false,del:false,search:false,refresh:true});
});
function openCreateModal() {
    $('#translationForm')[0].reset();
    $('#translationModalTitle').text('Add Translation');
    $('#translationModal').modal('show');
}
function editTranslation(id) {
    // find row data from grid
    var rowData = $("#translationGrid").jqGrid('getRowData', id);
    $('#transKey').val(rowData.msgKey);
    $('#transEn').val(rowData.enValue);
    $('#transAr').val(rowData.arValue);
    $('#translationModalTitle').text('Edit Translation');
    $('#translationModal').modal('show');
}
function saveTranslation() {
    if (!$('#transKey').val() || !$('#transEn').val()) { alert('Key and English value are required.'); return; }
    var data = { msgKey:$('#transKey').val(), enValue:$('#transEn').val(), arValue:$('#transAr').val() };
    $.ajax({ url:ctx+'/translations', method:'POST', contentType:'application/json', data:JSON.stringify(data),
             success:function(r) { if(r.success) { $('#translationModal').modal('hide'); $("#translationGrid").trigger('reloadGrid'); showAlert('success',r.message); } }
    });
}
function deleteTranslation(id) {
    if (!confirm('Delete this translation?')) return;
    $.ajax({ url:ctx+'/translations/'+id, method:'DELETE',
             success:function(r){ if(r.success) { $("#translationGrid").trigger('reloadGrid'); showAlert('success',r.message); } }
    });
}
</script>

<%@ include file="../footer.jsp" %>
