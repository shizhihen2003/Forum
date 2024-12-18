<%@ page language="java" contentType="text/html; charset=UTF-8"
	pageEncoding="UTF-8"%>
<%@ page trimDirectiveWhitespaces="true"%>
<%@ page isELIgnored="false" %>
<%@ taglib prefix="c" uri="jakarta.tags.core" %>
<%@ taglib prefix="ujn" uri="http://ujn.edu.cn/common/"%>
<%
	String path = request.getContextPath();
	String basePath = request.getScheme() + "://" + request.getServerName() 
	                   + ":" + request.getServerPort() + path + "/";
%>
<!DOCTYPE HTML> 
<html>
<head>
	<meta http-equiv="Content-Type" content="text/html; charset=UTF-8">
	<title>用户管理</title>
	<!-- 引入css样式文件 -->
	<!-- Bootstrap Core CSS -->
	<link href="<%=basePath%>css/bootstrap.min.css" rel="stylesheet" />
	<!-- MetisMenu CSS -->
	<link href="<%=basePath%>css/metisMenu.min.css" rel="stylesheet" />
	<!-- DataTables CSS -->
	<link href="<%=basePath%>css/dataTables.bootstrap.css" rel="stylesheet" />
	<!-- Custom CSS -->
	<link href="<%=basePath%>css/sb-admin-2.css" rel="stylesheet" />
	<!-- Custom Fonts -->
	<link href="<%=basePath%>css/font-awesome.min.css" rel="stylesheet" type="text/css" />
	<link href="<%=basePath%>css/boot-crm.css" rel="stylesheet" type="text/css" />
	<link rel="stylesheet"href="https://cdnjs.cloudflare.com/ajax/libs/font-awesome/4.7.0/css/font-awesome.min.css">
</head>
<body>
<div id="wrapper">
  <!-- 导航栏部分 -->
  <nav class="navbar navbar-default navbar-static-top" role="navigation"
		 style="margin-bottom: 0">
	<div class="navbar-header">
		<a class="navbar-brand" href="<%=basePath%>user"><i class="fa fa-home fa-fw"></i>用户管理系统</a>
    </div>
	<ul class="nav navbar-top-links navbar-right">
		<!-- 用户信息和系统设置 start -->
		<li class="dropdown">
			<a class="dropdown-toggle" data-toggle="dropdown" href="#"> 
				<i class="fa fa-user fa-fw"></i>
				<i class="fa fa-caret-down"></i>
			</a>
			<ul class="dropdown-menu dropdown-user">
				<li><a href="#"><i class="fa fa-user fa-fw"></i>
				               用户：${sessionScope.USER_SESSION.userCode}
				    </a>
				</li>
				<li><a href="#"><i class="fa fa-gear fa-fw"></i> 系统设置</a></li>
				<li class="divider"></li>
				<li>
					<a href="${pageContext.request.contextPath }/logout">
					<i class="fa fa-sign-out fa-fw"></i>退出登录
					</a>
				</li>
			</ul> 
		</li>
		<!-- 用户信息和系统设置结束 -->
    </ul>
	<!-- 左侧显示列表部分 start-->
	<div class="navbar-default sidebar" role="navigation">
		<div class="sidebar-nav navbar-collapse">
			<ul class="nav" id="side-menu">


				<li>
				    <a href="${pageContext.request.contextPath }/user" class="active">
				      <i class="fa fa-address-card fa-fw" ></i> 用户管理
				    </a>
				</li>
                <!-- -->
                <li>
                    <a href="#" class="active">
                      <i class="fa fa-users fa-fw"></i> 客户管理
                    </a>
                </li>

				<li>
				    <a href="#" class="active">
				      <i class="fa fa-book fa-fw"></i> 数据字典
				    </a>
				</li>

			</ul>
		</div>
	</div>
	<!-- 左侧显示列表部分 end--> 
  </nav>
    <!-- 列表查询部分  start-->
	<div id="page-wrapper">
		<div class="row">
			<div class="col-lg-12">
				<h1 class="page-header"><i class="fa fa-tag fa-fw"></i>用户管理</h1>
			</div>
			<!-- /.col-lg-12 -->
		</div>
		<!-- /.row -->
		<div class="panel panel-default">
			<div class="panel-body">
				<form class="form-inline" method="get" 
				      action="${pageContext.request.contextPath }/user">
					
					<div class="form-group">
						<label for="userCode">账号</label> 
						<input type="text" class="form-control" id="userCode" 
						                   value="${userCode }" name="userCode" />
					</div>
					<div class="form-group">
						<label for="userName">用户名称</label> 
						<input type="text" class="form-control" id="userName" 
						                   value="${userName }" name="userName" />
					</div>
					<button type="submit" class="btn btn-primary" >查询</button>
				</form>
			</div>
		</div>
		<a href="#" class="btn btn-primary" data-toggle="modal" 
		           data-target="#newUserDialog" onclick="clearUser()">新建</a>
		<div class="row">
			<div class="col-lg-12">
				<div class="panel panel-default">
					<div class="panel-heading">用户信息列表</div>
					<!-- /.panel-heading -->
					<table class="table table-bordered table-striped">
						<thead>
							<tr>
								<th>编号</th>
								<th>账号</th>
								<th>用户名称</th>
								<th>密码</th>
								<th>用户状态</th>
								<th>操作</th>
							</tr>
						</thead>
						<tbody>
							<c:forEach items="${page.rows}" var="row">
								<tr>
									<td>${row.userId}</td>
									<td>${row.userCode}</td>
									<td>${row.userName}</td>
									<td>${row.userPassword}</td>
									<td>${row.userState}</td>
									<td><center>
										<a href="#" class="btn btn-primary btn-xs" data-toggle="modal" data-target="#userEditDialog" onclick= "editUser(${row.userId})">修改</a>
										<a href="#" class="btn btn-danger btn-xs" onclick="deleteUser(${row.userId})">删除</a>

									</td>
								</tr>
							</c:forEach>
						</tbody>
					</table>
					<div class="col-md-12 text-right">
						<ujn:page url="${pageContext.request.contextPath }/user" />
					</div>
					<!-- /.panel-body -->
				</div>
				<!-- /.panel -->
			</div>
			<!-- /.col-lg-12 -->
		</div>
	</div>
	<!-- 列表查询部分  end-->
</div>
<!-- 创建模态框 -->
<div class="modal fade" id="newUserDialog" tabindex="-1" role="dialog"
	aria-labelledby="myModalLabel">
	<div class="modal-dialog" role="document">
		<div class="modal-content">
			<div class="modal-header">
				<button type="button" class="close" data-dismiss="modal" aria-label="Close">
					<span aria-hidden="true">&times;</span>
				</button>
				<h4 class="modal-title" id="myModalLabel">新建用户信息</h4>
			</div>
			<div class="modal-body">
				<form class="form-horizontal" id="new_user_form">
					<div class="form-group">
						<label for="new_userCode" class="col-sm-2 control-label">
						    账号
						</label>
						<div class="col-sm-10">
							<input type="text" class="form-control" id="new_userCode" placeholder="账号" name="userCode" />
						</div>
					</div>
					<div class="form-group">
						<label for="new_userName" class="col-sm-2 control-label">用户名称</label>
						<div class="col-sm-10">
							<input type="text" class="form-control" id="new_userName" placeholder="用户名称" name="userName" />
						</div>
					</div>
					<div class="form-group">
						<label for="new_userPassword" class="col-sm-2 control-label">密码</label>
						<div class="col-sm-10">
							<input type="text" class="form-control" id="new_userPassword" placeholder="密码" name="userPassword" />
						</div>
					</div>
					<div class="form-group">
						<label for="new_userState" class="col-sm-2 control-label">用户状态</label>
						<div class="col-sm-10">
							<input type="text" class="form-control" id="new_userState" placeholder="用户状态" name="userState" />
						</div>
					</div>
					
				</form>
			</div>
			<div class="modal-footer">
				<button type="button" class="btn btn-default" data-dismiss="modal">关闭</button>

				<button type="button" class="btn btn-primary" onclick="createUser()">创建用户</button>

			</div>
		</div>
	</div>
</div>
<!-- 修改模态框 -->
<div class="modal fade" id="userEditDialog" tabindex="-1" role="dialog"
	aria-labelledby="myModalLabel">
	<div class="modal-dialog" role="document">
		<div class="modal-content">
			<div class="modal-header">
				<button type="button" class="close" data-dismiss="modal" aria-label="Close">
					<span aria-hidden="true">&times;</span>
				</button>
				<h4 class="modal-title" id="myModalLabel">修改用户信息</h4>
			</div>
			<div class="modal-body">
				<form class="form-horizontal" id="edit_user_form">
					<input type="hidden" id="edit_userId" name="userId"/>
					<div class="form-group">
						<label for="edit_userCode" class="col-sm-2 control-label">账号</label>
						<div class="col-sm-10">
							<input type="text" class="form-control" id="edit_userCode" placeholder="账号" name="userCode" />
						</div>
					</div>
					<div class="form-group">
						<label for="edit_userName" class="col-sm-2 control-label">用户名称</label>
						<div class="col-sm-10">
							<input type="text" class="form-control" id="edit_userName" placeholder="用户名称" name="userName" />
						</div>
					</div>
					<div class="form-group">
						<label for="edit_userPassword" class="col-sm-2 control-label">密码</label>
						<div class="col-sm-10">
							<input type="text" class="form-control" id="edit_userPassword" placeholder="密码" name="userPassword" />
						</div>
					</div>
					<div class="form-group">
						<label for="edit_userState" class="col-sm-2 control-label">用户状态</label>
						<div class="col-sm-10">
							<input type="text" class="form-control" id="edit_userState" placeholder="用户状态" name="userState" />
						</div>
					</div>
					
				</form>
			</div>
			<div class="modal-footer">
				<button type="button" class="btn btn-default" data-dismiss="modal">关闭</button>
				<button type="button" class="btn btn-primary" onclick="updateUser()">保存修改</button>
			</div>
		</div>
	</div>
</div>
<!-- 引入js文件 -->
<!-- jQuery -->
<script src="<%=basePath%>js/jquery-1.11.3.min.js"></script>
<!-- Bootstrap Core JavaScript -->
<script src="<%=basePath%>js/bootstrap.min.js"></script>
<!-- Metis Menu Plugin JavaScript -->
<script src="<%=basePath%>js/metisMenu.min.js"></script>
<!-- DataTables JavaScript -->
<script src="<%=basePath%>js/jquery.dataTables.min.js"></script>
<script src="<%=basePath%>js/dataTables.bootstrap.min.js"></script>
<!-- Custom Theme JavaScript -->
<script src="<%=basePath%>js/sb-admin-2.js"></script>
<!-- 编写js代码 -->
<script type="text/javascript">
//清空新建窗口中的数据
	function clearUser() {
	    $("#new_userCode").val("");
	    $("#new_userName").val("")
	    $("#new_userPassword").val("")
	    $("#new_userState").val("")
	}
	// 创建
	function createUser() {
	$.post("<%=basePath%>user",
	$("#new_user_form").serialize(),function(data){
	        if(data =="OK"){
	            alert("用户创建成功！");
	            window.location.reload();
	        }else{
	            alert("用户创建失败！");
	            window.location.reload();
	        }
	    });
	}
	// 通过id获取修改的用户信息
	function editUser(id) {
	    $.ajax({
	        type:"get",
	        url:"<%=basePath%>user/"+id,
	        success:function(data) {
	            $("#edit_userId").val(data.userId);
	            $("#edit_userCode").val(data.userCode);
	            $("#edit_userName").val(data.userName)
	            $("#edit_userPassword").val(data.userPassword)
	            $("#edit_userState").val(data.userState)
	        }
	    });
	}
    // 执行修改操作
	function updateUser() {
	    var userId = $("#edit_userId").val();
	    var userCode = $("#edit_userCode").val();
        var userName = $("#edit_userName").val();
        var userPassword = $("#edit_userPassword").val();
        var userState = $("#edit_userState").val();
	    $.ajax({
           url: '<%=basePath%>user',
           type: 'PUT',
           data : JSON.stringify({
				userId : userId,
				userCode : userCode,
				userName : userName,
				userPassword : userPassword,
				userState : userState
			}),
	       contentType : "application/json;charset=UTF-8",
           success: function(data) {
                    if(data =="OK"){
         				alert("用户信息更新成功！");
         				window.location.reload();
         			}else{
         				alert("用户信息更新失败！");
         				window.location.reload();
         			}
           }
       });
	}
	// 删除
	function deleteUser(id) {
	    if(confirm('确实要删除该用户吗?')) {
	    $.ajax({   url: '<%=basePath%>user/'+id,
                   type: 'DELETE',
                   success: function(data) {
                            if(data =="OK"){
                 				alert("用户信息删除成功！");
                 				window.location.reload();
                 			}else{
                 				alert("用户信息删除失败！");
                 				window.location.reload();
                 			}
                   }
        });
	    }
	}
</script>
</body>
</html>