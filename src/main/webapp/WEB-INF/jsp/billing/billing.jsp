<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<%@ include file="../header.jsp" %>

<div class="row mb-3">
    <div class="col-md-8">
        <h2><i class="fas fa-receipt text-primary"></i> Billing -
            <span class="text-muted">Month: ${issuance.billingMonth}</span>
        </h2>
    </div>
    <div class="col-md-4 text-right">
        <c:if test="${issuance.status != 'FINAL'}">
            <button class="btn btn-warning mr-2" onclick="runTrial()">
                <i class="fas fa-flask"></i> Trial Run
            </button>
            <button class="btn btn-success mr-2" onclick="runFinal()">
                <i class="fas fa-check-double"></i> Final Billing
            </button>
        </c:if>
        <button class="btn btn-secondary" onclick="window.open('${pageContext.request.contextPath}/billing/pdf/${issuance.id}','_blank')">
            <i class="fas fa-file-pdf"></i> Print PDF
        </button>
    </div>
</div>

<div class="card mb-3">
    <div class="card-body py-2">
        <div class="row">
            <div class="col-md-3"><b>Issuance Date:</b> ${issuance.issuanceDate}</div>
            <div class="col-md-3"><b>Billing Month:</b> ${issuance.billingMonth}</div>
            <div class="col-md-3"><b>Exchange Rate:</b> ${issuance.exchangeRate} LBP/USD</div>
            <div class="col-md-3"><b>Status:</b>
                <c:choose>
                    <c:when test="${issuance.status == 'FINAL'}">
                        <span class="badge badge-success">Final</span>
                    </c:when>
                    <c:otherwise>
                        <span class="badge badge-warning">Draft</span>
                    </c:otherwise>
                </c:choose>
            </div>
        </div>
    </div>
</div>

<!-- Trial Results section (hidden initially) -->
<div id="trialResults" style="display:none" class="mb-3">
    <div class="card border-warning">
        <div class="card-header bg-warning text-dark">
            <i class="fas fa-flask"></i> Trial Billing Results (Preview Only - Not Saved)
        </div>
        <div class="card-body p-0">
            <div id="trialContent"></div>
        </div>
    </div>
</div>

<!-- Meter readings form -->
<c:if test="${issuance.status != 'FINAL'}">
<div class="card mb-3" id="readingsCard">
    <div class="card-header bg-info text-white">
        <i class="fas fa-tachometer-alt"></i> Meter Readings (for Meter-Based Customers)
    </div>
    <div class="card-body">
        <div class="alert alert-info">
            Enter previous and current readings for meter-based customers. Amper-based customers are calculated automatically.
        </div>
        <div id="readingsForm">
            <p class="text-center"><i class="fas fa-spinner fa-spin"></i> Loading customers...</p>
        </div>
    </div>
</div>
</c:if>

<!-- Bills Grid -->
<div class="card shadow">
    <div class="card-header bg-primary text-white">
        <i class="fas fa-list"></i> Bills for This Issuance
        <span class="badge badge-light ml-2" id="billCount">0</span>
    </div>
    <div class="card-body p-0">
        <table id="billsGrid"></table>
        <div id="billsPager"></div>
    </div>
</div>

<script>
var ctx = '${pageContext.request.contextPath}';
var issuanceId = ${issuance.id};
var issuanceStatus = '${issuance.status}';

$(function() {
    // Load billing grid
    $("#billsGrid").jqGrid({
        url: ctx + '/billing/data?issuanceId=' + issuanceId,
        datatype:'json', mtype:'GET',
        colNames:['Customer','Zone','Box','Type','Prev Rd','Curr Rd','Consumption','Sub Fee','Total USD','Total LBP'],
        colModel:[
            {name:'customerName', index:'customerName', width:150},
            {name:'zoneName',     index:'zoneName',     width:100},
            {name:'boxName',      index:'boxName',      width:100},
            {name:'billingType',  index:'billingType',  width:80,
             formatter:function(v){ return v==='METER'?'<span class="badge badge-info">Meter</span>':'<span class="badge badge-warning">Amper</span>'; }},
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
        loadComplete: function(data) { $('#billCount').text(data.records||0); },
        jsonReader:{root:'rows',page:'page',total:'total',records:'records',id:'id'}
    });
    $("#billsGrid").jqGrid('navGrid','#billsPager',{add:false,edit:false,del:false,search:false,refresh:true});

    // Load meter customers for readings input
    if (issuanceStatus !== 'FINAL') {
        loadMeterCustomers();
    }
});

function loadMeterCustomers() {
    $.get(ctx + '/customers/data?rows=200&page=1&billingType=METER', function(data) {
        var html = '<div class="table-responsive"><table class="table table-sm table-bordered">';
        html += '<thead class="thead-light"><tr><th>Customer</th><th>Zone</th><th>Box</th>'
              + '<th>Prev Reading</th><th>Curr Reading</th></tr></thead><tbody>';
        $.each(data.rows, function(i, c) {
            html += '<tr>';
            html += '<td>'+c.name+'</td>';
            html += '<td>'+c.zoneName+'</td>';
            html += '<td>'+c.boxName+'</td>';
            html += '<td><input type="number" step="0.01" class="form-control form-control-sm reading-prev" data-id="'+c.id+'" value="0"/></td>';
            html += '<td><input type="number" step="0.01" class="form-control form-control-sm reading-curr" data-id="'+c.id+'" value="0"/></td>';
            html += '</tr>';
        });
        html += '</tbody></table></div>';
        if (data.records === 0) html = '<p class="text-muted">No meter-based customers found.</p>';
        $('#readingsForm').html(html);
    });
}

function getReadings() {
    var readings = {};
    $('.reading-prev').each(function() {
        var id = $(this).data('id');
        if (!readings[id]) readings[id] = {};
        readings[id].prev = $(this).val() || '0';
    });
    $('.reading-curr').each(function() {
        var id = $(this).data('id');
        if (!readings[id]) readings[id] = {};
        readings[id].curr = $(this).val() || '0';
    });
    return readings;
}

function runTrial() {
    var readings = getReadings();
    $.ajax({
        url: ctx + '/billing/trial/' + issuanceId,
        method: 'POST', contentType:'application/json',
        data: JSON.stringify(readings),
        success: function(result) {
            displayTrialResults(result);
        },
        error: function(xhr) { showAlert('danger', 'Trial billing failed: ' + xhr.responseText); }
    });
}

function displayTrialResults(result) {
    var html = '<div class="p-3">';
    html += '<div class="row mb-2"><div class="col-md-6"><b>Grand Total USD:</b> $' + result.grandTotalUsd + '</div>';
    html += '<div class="col-md-6"><b>Grand Total LBP:</b> ' + result.grandTotalLbp + ' LBP</div></div>';
    html += '<table class="table table-sm table-bordered table-hover">';
    html += '<thead class="thead-dark"><tr><th>Customer</th><th>Zone</th><th>Box</th><th>Type</th>'
          + '<th>Consumption/Amper</th><th>Sub Fee</th><th>Total USD</th><th>Total LBP</th></tr></thead><tbody>';
    $.each(result.bills, function(i, b) {
        var detail = b.billingType === 'METER' ? b.consumption : b.amperCapacity;
        html += '<tr>';
        html += '<td>'+b.customerName+'</td><td>'+b.zoneName+'</td><td>'+b.boxName+'</td>';
        html += '<td><span class="badge badge-'+(b.billingType==='METER'?'info':'warning')+'">'+b.billingType+'</span></td>';
        html += '<td>'+detail+'</td><td>'+b.subFee+'</td><td>'+b.totalUsd+'</td><td>'+b.totalLbp+'</td>';
        html += '</tr>';
    });
    html += '</tbody></table></div>';
    $('#trialContent').html(html);
    $('#trialResults').slideDown();
}

function runFinal() {
    if (!confirm('Are you sure you want to run FINAL billing? This cannot be undone.')) return;
    var readings = getReadings();
    $.ajax({
        url: ctx + '/billing/final/' + issuanceId,
        method:'POST', contentType:'application/json',
        data: JSON.stringify(readings),
        success: function(r) {
            if(r.success) {
                showAlert('success', r.message);
                setTimeout(function() { window.location.reload(); }, 1500);
            }
        },
        error: function(xhr) { showAlert('danger', 'Final billing failed: ' + xhr.responseText); }
    });
}
</script>

<%@ include file="../footer.jsp" %>
