<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<%@ include file="../header.jsp" %>

<div class="row mb-3">
    <div class="col-md-12">
        <h2><i class="fas fa-clipboard-list text-primary"></i> Audit Log</h2>
    </div>
</div>

<!-- Search Filter -->
<div class="card mb-3">
    <div class="card-body py-2">
        <div class="row">
            <div class="col-md-4">
                <input type="text" id="auditSearch" class="form-control form-control-sm"
                       placeholder="Search by username, action, entity..."/>
            </div>
            <div class="col-md-2">
                <button class="btn btn-sm btn-outline-secondary" onclick="reloadAudit()">
                    <i class="fas fa-search"></i> Search
                </button>
            </div>
        </div>
    </div>
</div>

<div class="card shadow">
    <div class="card-body p-0">
        <table id="auditGrid"></table>
        <div id="auditPager"></div>
    </div>
</div>

<script>
var ctx = '${pageContext.request.contextPath}';
$(function() {
    $("#auditGrid").jqGrid({
        url: ctx + '/audit/data',
        datatype:'json', mtype:'GET',
        colNames:['ID','Username','Action','Entity Type','Entity ID','Description','IP Address','Date/Time'],
        colModel:[
            {name:'id',          index:'id',          width:50, hidden:true},
            {name:'username',    index:'username',    width:100, sortable:true},
            {name:'action',      index:'action',      width:120,
             formatter:function(v){
                var color='secondary';
                if(v.includes('CREATE')) color='success';
                else if(v.includes('UPDATE')||v.includes('UPSERT')) color='info';
                else if(v.includes('DELETE')) color='danger';
                else if(v.includes('BILLING')) color='warning';
                return '<span class="badge badge-'+color+'">'+v+'</span>';
             }},
            {name:'entityType',  index:'entityType',  width:100},
            {name:'entityId',    index:'entityId',    width:70},
            {name:'description', index:'description', width:300},
            {name:'ipAddress',   index:'ipAddress',   width:100},
            {name:'createdAt',   index:'createdAt',   width:150, sortable:true}
        ],
        rowNum:15, rowList:[15,30,50], pager:'#auditPager',
        sortname:'createdAt', sortorder:'desc', viewrecords:true,
        height:'auto', shrinkToFit:true, autowidth:true,
        jsonReader:{root:'rows',page:'page',total:'total',records:'records',id:'id'}
    });
    $("#auditGrid").jqGrid('navGrid','#auditPager',{add:false,edit:false,del:false,search:false,refresh:true});
});
function reloadAudit() {
    $("#auditGrid").jqGrid('setGridParam',{postData:{search:$('#auditSearch').val()}}).trigger('reloadGrid',[{page:1}]);
}
</script>

<%@ include file="../footer.jsp" %>
