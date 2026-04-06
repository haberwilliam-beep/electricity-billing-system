<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<%@ include file="../header.jsp" %>

<div class="row mb-3">
    <div class="col-md-8">
        <h2><i class="fas fa-sliders-h text-primary"></i> System Parameters</h2>
    </div>
    <div class="col-md-4 text-right">
        <button class="btn btn-success" onclick="saveAllParams()">
            <i class="fas fa-save"></i> Save All Parameters
        </button>
    </div>
</div>

<div class="card shadow">
    <div class="card-body">
        <div class="alert alert-info">
            <i class="fas fa-info-circle"></i>
            Configure the system pricing parameters. Changes will affect all future billing calculations.
        </div>
        <div id="paramsContainer">
            <div class="text-center"><i class="fas fa-spinner fa-spin fa-2x"></i></div>
        </div>
    </div>
</div>

<!-- Inline editable jqGrid for parameters -->
<div class="card shadow mt-3">
    <div class="card-header bg-secondary text-white">
        <i class="fas fa-table"></i> Parameters Grid (Inline Edit)
    </div>
    <div class="card-body p-0">
        <table id="paramGrid"></table>
        <div id="paramPager"></div>
    </div>
</div>

<script>
var ctx = '${pageContext.request.contextPath}';
var paramsData = [];

$(function() {
    loadParams();

    $("#paramGrid").jqGrid({
        url: ctx + '/parameters/data',
        datatype: 'json', mtype: 'GET',
        colNames: ['Key','Value','Description','Last Updated'],
        colModel: [
            {name:'paramKey',   index:'paramKey',   width:200, editable:false},
            {name:'paramValue', index:'paramValue', width:120, editable:true,
             editoptions:{size:20}},
            {name:'description', index:'description', width:300, editable:false},
            {name:'updatedAt',   index:'updatedAt',   width:160, editable:false}
        ],
        rowNum: 20, pager:'#paramPager', viewrecords:true,
        height:'auto', shrinkToFit:true, autowidth:true,
        jsonReader: { root:'rows', page:'page', total:'total', records:'records', id:'paramKey',
                      repeatitems: false }
    });
    $("#paramGrid").jqGrid('navGrid','#paramPager',{add:false,edit:false,del:false,search:false,refresh:true});
    $("#paramGrid").jqGrid('inlineNav','#paramPager',{
        edit: true, edittext:'Edit', add: false, cancel:true, save:true,
        savetext:'Save',
        editParams: {
            successfunc: function(response) {
                var r = JSON.parse(response.responseText);
                if (r && r.success) showAlert('success', r.message);
                return true;
            },
            url: ctx + '/parameters/save',
            mtype: 'POST',
            extraparam: function() { return {}; }
        }
    });
});

function loadParams() {
    $.get(ctx + '/parameters/data', function(params) {
        paramsData = params;
        var html = '<div class="row">';
        $.each(params, function(i, p) {
            html += '<div class="col-md-6 mb-3">';
            html += '<div class="card">';
            html += '<div class="card-body">';
            html += '<label class="font-weight-bold">' + (p.description || p.paramKey) + '</label>';
            html += '<div class="input-group">';
            html += '<input type="text" class="form-control" id="param_' + p.paramKey + '" value="' + p.paramValue + '" data-key="' + p.paramKey + '" data-desc="' + (p.description||'') + '"/>';
            html += '<div class="input-group-append"><span class="input-group-text"><small class="text-muted">' + p.paramKey + '</small></span></div>';
            html += '</div></div></div></div>';
        });
        html += '</div>';
        $('#paramsContainer').html(html);
    });
}

function saveAllParams() {
    var params = [];
    $('[data-key]').each(function() {
        params.push({ paramKey: $(this).data('key'), paramValue: $(this).val(), description: $(this).data('desc') });
    });
    $.ajax({
        url: ctx + '/parameters/save', method:'POST',
        contentType:'application/json', data:JSON.stringify(params),
        success: function(r) {
            if(r.success) { showAlert('success', r.message); loadParams(); }
        }
    });
}
</script>

<%@ include file="../footer.jsp" %>
