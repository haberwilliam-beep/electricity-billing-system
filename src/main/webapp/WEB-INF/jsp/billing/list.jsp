<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<%@ include file="../header.jsp" %>

<div class="row mb-3">
    <div class="col-md-8">
        <h2><i class="fas fa-receipt text-primary"></i> Bills</h2>
    </div>
    <div class="col-md-4 text-right">
        <a href="${pageContext.request.contextPath}/issuances" class="btn btn-primary">
            <i class="fas fa-calendar-alt"></i> Manage Issuances
        </a>
    </div>
</div>

<!-- Filter by issuance -->
<div class="card mb-3">
    <div class="card-body py-2">
        <div class="row">
            <div class="col-md-4">
                <select id="issuanceFilter" class="form-control form-control-sm" onchange="reloadGrid()">
                    <option value="">All Issuances</option>
                    <c:forEach var="iss" items="${issuances}">
                        <option value="${iss.id}">${iss.billingMonth} (${iss.status})</option>
                    </c:forEach>
                </select>
            </div>
        </div>
    </div>
</div>

<div class="card shadow">
    <div class="card-body p-0">
        <table id="billsGrid"></table>
        <div id="billsPager"></div>
    </div>
</div>

<script>
var ctx = '${pageContext.request.contextPath}';
$(function() {
    $("#billsGrid").jqGrid({
        url: ctx + '/billing/data',
        datatype:'json', mtype:'GET',
        colNames:['ID','Customer','Zone','Box','Type','Billing Month','Prev Rd','Curr Rd','Consumption','Sub Fee','Total USD','Total LBP'],
        colModel:[
            {name:'id',           index:'id',           width:50, hidden:true},
            {name:'customerName', index:'customerName', width:140},
            {name:'zoneName',     index:'zoneName',     width:100},
            {name:'boxName',      index:'boxName',      width:100},
            {name:'billingType',  index:'billingType',  width:80,
             formatter:function(v){ return v==='METER'?'<span class="badge badge-info">Meter</span>':'<span class="badge badge-warning">Amper</span>'; }},
            {name:'billingMonthStr', index:'billingMonthStr', width:100},
            {name:'prevReading',  index:'prevReading',  width:80},
            {name:'currReading',  index:'currReading',  width:80},
            {name:'consumption',  index:'consumption',  width:90},
            {name:'subFee',       index:'subFee',       width:90},
            {name:'totalUsd',     index:'totalUsd',     width:100},
            {name:'totalLbp',     index:'totalLbp',     width:120}
        ],
        rowNum:10, rowList:[10,20,50], pager:'#billsPager',
        sortname:'customerName', sortorder:'asc', viewrecords:true,
        height:'auto', shrinkToFit:true, autowidth:true,
        jsonReader:{root:'rows',page:'page',total:'total',records:'records',id:'id'}
    });
    $("#billsGrid").jqGrid('navGrid','#billsPager',{add:false,edit:false,del:false,search:false,refresh:true});
});
function reloadGrid() {
    var issuanceId = $('#issuanceFilter').val();
    var url = ctx + '/billing/data' + (issuanceId ? '?issuanceId='+issuanceId : '');
    $("#billsGrid").jqGrid('setGridParam',{url:url}).trigger('reloadGrid',[{page:1}]);
}
</script>

<%@ include file="../footer.jsp" %>
