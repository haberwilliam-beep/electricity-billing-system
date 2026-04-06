<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<%@ include file="../header.jsp" %>

<div class="row mb-3">
    <div class="col-md-8">
        <h2><i class="fas fa-user-shield text-primary"></i> User Management</h2>
    </div>
    <div class="col-md-4 text-right">
        <button class="btn btn-primary" onclick="openCreateModal()">
            <i class="fas fa-user-plus"></i> Add User
        </button>
    </div>
</div>

<div class="card shadow">
    <div class="card-body p-0">
        <table id="userGrid"></table>
        <div id="userPager"></div>
    </div>
</div>

<!-- User Modal -->
<div class="modal fade" id="userModal" tabindex="-1">
    <div class="modal-dialog">
        <div class="modal-content">
            <div class="modal-header bg-primary text-white">
                <h5 class="modal-title" id="userModalTitle">Add User</h5>
                <button type="button" class="close text-white" data-dismiss="modal">&times;</button>
            </div>
            <div class="modal-body">
                <form id="userForm">
                    <input type="hidden" id="userId"/>
                    <div class="form-group">
                        <label>Username <span class="text-danger">*</span></label>
                        <input type="text" class="form-control" id="userUsername" required/>
                    </div>
                    <div class="form-group">
                        <label>Full Name</label>
                        <input type="text" class="form-control" id="userFullName"/>
                    </div>
                    <div class="form-group">
                        <label>Email</label>
                        <input type="email" class="form-control" id="userEmail"/>
                    </div>
                    <div class="form-group">
                        <label>Password <span id="pwdHint" class="text-muted">(leave blank to keep current)</span></label>
                        <input type="password" class="form-control" id="userPassword"
                               autocomplete="new-password"/>
                    </div>
                    <div class="form-group">
                        <label>Role <span class="text-danger">*</span></label>
                        <select class="form-control" id="userRoleId">
                            <c:forEach var="r" items="${roles}">
                                <option value="${r.id}">${r.name}</option>
                            </c:forEach>
                        </select>
                    </div>
                    <div class="form-group">
                        <label>Status</label>
                        <select class="form-control" id="userEnabled">
                            <option value="true">Active</option>
                            <option value="false">Disabled</option>
                        </select>
                    </div>
                </form>
            </div>
            <div class="modal-footer">
                <button type="button" class="btn btn-secondary" data-dismiss="modal">Cancel</button>
                <button type="button" class="btn btn-primary" onclick="saveUser()">
                    <i class="fas fa-save"></i> Save
                </button>
            </div>
        </div>
    </div>
</div>

<script>
var ctx = '${pageContext.request.contextPath}';
$(function() {
    $("#userGrid").jqGrid({
        url: ctx + '/users/data',
        datatype:'json', mtype:'GET',
        colNames:['ID','Username','Full Name','Email','Role','Status','Actions'],
        colModel:[
            {name:'id',        index:'id',        width:50, hidden:true},
            {name:'username',  index:'username',  width:120, sortable:true},
            {name:'fullName',  index:'fullName',  width:150},
            {name:'email',     index:'email',     width:180},
            {name:'roleName',  index:'roleName',  width:120},
            {name:'enabled',   index:'enabled',   width:80,
             formatter:function(v){ return v?'<span class="badge badge-success">Active</span>':'<span class="badge badge-secondary">Disabled</span>'; }},
            {name:'actions',   index:'actions',   width:110, sortable:false,
             formatter:function(v,o,row){
                return '<button class="btn btn-xs btn-info mr-1" onclick="editUser('+row.id+')"><i class="fas fa-edit"></i></button>'
                     + '<button class="btn btn-xs btn-danger" onclick="deleteUser('+row.id+',\''+row.username+'\')"><i class="fas fa-trash"></i></button>';
             }}
        ],
        rowNum:10, rowList:[10,20,50], pager:'#userPager',
        sortname:'username', sortorder:'asc', viewrecords:true,
        height:'auto', shrinkToFit:true, autowidth:true,
        jsonReader:{root:'rows',page:'page',total:'total',records:'records',id:'id'}
    });
    $("#userGrid").jqGrid('navGrid','#userPager',{add:false,edit:false,del:false,search:false,refresh:true});
});
function openCreateModal() {
    $('#userForm')[0].reset(); $('#userId').val('');
    $('#pwdHint').hide();
    $('#userModalTitle').text('Add User'); $('#userModal').modal('show');
}
function editUser(id) {
    $.get(ctx+'/users/'+id, function(u) {
        $('#userId').val(u.id); $('#userUsername').val(u.username);
        $('#userFullName').val(u.fullName); $('#userEmail').val(u.email);
        $('#userRoleId').val(u.roleId);
        $('#userEnabled').val(u.enabled?'true':'false');
        $('#userPassword').val('');
        $('#pwdHint').show();
        $('#userModalTitle').text('Edit User'); $('#userModal').modal('show');
    });
}
function saveUser() {
    if (!$('#userUsername').val()) { alert('Username is required.'); return; }
    var data = {
        username:$('#userUsername').val(), fullName:$('#userFullName').val(),
        email:$('#userEmail').val(), password:$('#userPassword').val(),
        roleId:$('#userRoleId').val(), enabled:$('#userEnabled').val()==='true'
    };
    var id = $('#userId').val();
    $.ajax({ url:id?ctx+'/users/'+id:ctx+'/users', method:id?'PUT':'POST',
             contentType:'application/json', data:JSON.stringify(data),
             success:function(r) { if(r.success) { $('#userModal').modal('hide'); $("#userGrid").trigger('reloadGrid'); showAlert('success',r.message); } }
    });
}
function deleteUser(id, name) {
    if (!confirm('Delete user "'+name+'"?')) return;
    $.ajax({ url:ctx+'/users/'+id, method:'DELETE',
             success:function(r) { if(r.success) { $("#userGrid").trigger('reloadGrid'); showAlert('success',r.message); } }
    });
}
</script>

<%@ include file="../footer.jsp" %>
