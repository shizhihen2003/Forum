<%@ page language="java" contentType="text/html; charset=UTF-8"
	pageEncoding="UTF-8"%>
<%
    Integer userPermission = (Integer) session.getAttribute("userPermission");
%>
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
	<link href="<%=basePath%>static/css/bootstrap.min.css" rel="stylesheet" />
	<!-- MetisMenu CSS -->
	<link href="<%=basePath%>static/css/metisMenu.min.css" rel="stylesheet" />
	<!-- DataTables CSS -->
	<link href="<%=basePath%>static/css/dataTables.bootstrap.css" rel="stylesheet" />
	<!-- Custom CSS -->
	<link href="<%=basePath%>static/css/sb-admin-2.css" rel="stylesheet" />
	<!-- Custom Fonts -->
	<link href="<%=basePath%>static/css/font-awesome.min.css" rel="stylesheet" type="text/css" />
	<link href="<%=basePath%>static/css/boot-crm.css" rel="stylesheet" type="text/css" />
	<link rel="stylesheet"href="https://cdnjs.cloudflare.com/ajax/libs/font-awesome/4.7.0/css/font-awesome.min.css">



</head>
<body>
<div id="wrapper">
  <!-- 导航栏部分 -->
  <nav class="navbar navbar-default navbar-static-top" role="navigation"
		 style="margin-bottom: 0">
	<div class="navbar-header">
		<a class="navbar-brand" href="<%=basePath%>user"><i class="fa fa-home fa-fw"></i>权限设置</a>
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

  </nav>
    <!-- 列表查询部分  start-->
	<div id="page-wrapper">
		<div class="row">
			<div class="col-lg-12">
				<h1 class="page-header"><i class="fa fa-tag fa-fw"></i>权限管理</h1>
			</div>
			<!-- /.col-lg-12 -->
		</div>
		<!-- /.row -->
		<div class="panel panel-default">
			<div class="panel-body">
				<form class="form-inline" method="get" action="#">

					<div class="form-group">
						<label for="userCode">账号</label>
						<input type="text" class="form-control" id="userCode" value="${userCode }" name="userCode" />
					</div>
					<div class="form-group">
						<label for="userName"></label>
					</div>
					<button type="button" class="btn btn-primary" onclick="queryUser()">查询</button>
				</form>
			</div>
		</div>
		<a href="#" class="btn btn-primary" data-toggle="modal"
		           data-target="#newUserDialog" onclick="clearUser()">新建</a>
		<div class="row">
			<div class="col-lg-12">
				<div class="panel panel-default">
					<div class="panel-heading">权限信息列表</div>
					<!-- /.panel-heading -->
					<table class="table table-bordered table-striped">
						<thead>
							<tr>
								<th>用户名</th>
								<th>手机号</th>
								<th>权限</th>
							</tr>
						</thead>
						<tbody>
							<c:set var="page1Index" value="0" />
                            <c:forEach items="${page.rows}" var="row" varStatus="status">
                                <tr>

                                    <td>${page1.rows[page1Index].username}</td>
                                    <td>${page1.rows[page1Index].phone}</td>
                                    <td>${row.targetPermission}</td>
                                    <td>
                                      <center>
                                          <!-- 添加一个条件判断，只有当userPermission小于row.targetPermission时才显示修改按钮 -->
                                          <c:choose>
                                              <c:when test="${userPermission < row.targetPermission}">
                                                  <a href="#" class="btn btn-primary btn-xs" data-toggle="modal" data-target="#userEditDialog" onclick="editUser(${page1.rows[page1Index].phone})">修改</a>
                                              </c:when>
                                              <c:otherwise>
                                                  <!-- 权限不足时，可以显示一个不可操作的按钮或不做任何显示 -->
                                                  <a href="#" class="btn btn-primary btn-xs" onclick="alert('权限不足，无法修改！')">修改</a>
                                                  <!-- 或者完全不显示修改按钮 -->
                                                  <!-- <span></span> -->
                                              </c:otherwise>
                                          </c:choose>
                                          <!-- 删除按钮的逻辑保持不变 -->
                                          <c:choose>
                                              <c:when test="${userPermission <= row.targetPermission}">
                                                  <a href="#" class="btn btn-danger btn-xs" onclick="deleteUser(${page1.rows[page1Index].phone})">删除</a>
                                              </c:when>
                                              <c:otherwise>
                                                  <a href="#" class="btn btn-danger btn-xs" onclick="alert('权限不足，无法删除！')">删除</a>
                                              </c:otherwise>
                                          </c:choose>
                                      </center>
                                    </td>
                                </tr>
                                <c:set var="page1Index" value="${page1Index + 1}" />
                            </c:forEach>
						</tbody>
					</table>
					<div class="col-md-12 text-right">

<ujn:page url="${pageContext.request.contextPath }/p" />


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
				<h4 class="modal-title" id="myModalLabel">新建权限信息</h4>
			</div>
			<div class="modal-body">




				<form class="form-horizontal" id="new_user_form">



	<div  class="q22">
                						<label for="new_userCode" class="col-sm-2 control-label">
                						  用户名
                						</label>

                						<div class="col-sm-10">
                							<input type="text" class="form-control" id="new_username" placeholder="请输入用户名" name="username" style="  margin-bottom: 15px; width: 458px;"/>
                						</div>

				<div  class="q22">
                						<label for="new_userCode" class="col-sm-2 control-label">
                						   邮箱
                						</label>

                						<div class="col-sm-10">
                							<input type="text" class="form-control" id="new_email" placeholder="请输入邮箱" name="email"style=" margin-bottom: 15px;width: 458px; " />
                						</div>


	<div  class="q22">
						<label for="new_userCode" class="col-sm-2 control-label">
						   手机号
						</label>

						<div class="col-sm-10">
							<input type="text" class="form-control" id="new_phone" placeholder="请输入手机号" name="phone" style=" margin-bottom: 15px; width: 458px;"/>
						</div>


					</div>




	<div class="form-group" class="w">
  						<label for="new_userCode" class="col-sm-2 control-label" style="padding-left: 8px;">
  						 密码
  						</label>

  						<div class="col-sm-10">
  							<input type="text" class="form-control" id="new_passwordHash" placeholder="请输入密码" name="passwordHash" />
  						</div>


  					</div>










					<div class="form-group">
						<label for="new_userPassword" class="col-sm-2 control-label" style="padding-left: 15px;">权限</label>
						<div class="col-sm-10">
							 <select id="permissionSelect" name="targetPermission" style=" width: 50px; margin-left: 5px;">
                                    <% if (userPermission != null) { %>
                                        <% if (userPermission == 1) { %>
                                            <option value="2">2</option>
                                            <option value="3">3</option>

                                        <% } else if (userPermission == 2) { %>
                                            <option value="3">3</option>
                                        <% } %>
                                    <% } else { %>
                                        <!-- 如果没有权限值，可以选择不显示复选框或者显示一个默认选项 -->
                                        <option value="">请选择权限</option>
                                    <% } %>
                                </select>
						</div>
					</div>
					<div class="form-group">

						<div class="col-sm-10">

						</div>
					</div>

				</form>





			</div>
			<div class="modal-footer">
				<button type="button" class="btn btn-default" data-dismiss="modal">关闭</button>

				<button type="button" class="btn btn-primary" onclick="createUser()">创建权限</button>

			</div>
		</div>
	</div>
</div>




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
				<h4 class="modal-title" id="myModalLabel">修改权限信息</h4>
			</div>
			<div class="modal-body">
				<form class="form-horizontal" id="edit_user_form">
					<input type="hidden" id="edit_userId" name="userId"/>
					<div class="form-group">
						<label for="edit_userCode" class="col-sm-2 control-label">用户名</label>
						<div class="col-sm-10">
							<input type="text" class="form-control" id="permissionId" placeholder="请输入用户名" name="permissionId" />
						</div>
					</div>
					<div class="form-group">
						<label for="edit_userName" class="col-sm-2 control-label">密码</label>
						<div class="col-sm-10">
							<input type="text" class="form-control" id="userId" placeholder="请输入密码" name="userId" />
						</div>
					</div>
					<div class="form-group">
						<label for="edit_userPassword" class="col-sm-2 control-label">权限</label>
						<div class="col-sm-10">

						<select id="targetPermission" name="targetPermission" style=" width: 50px; margin-left: 5px;">
                                                            <% if (userPermission != null) { %>
                                                                <% if (userPermission == 1) { %>
                                                                    <option value="2">2</option>
                                                                    <option value="3">3</option>

                                                                <% } else if (userPermission == 2) { %>
                                                                    <option value="3">3</option>
                                                                <% } %>
                                                            <% } else { %>
                                                                <!-- 如果没有权限值，可以选择不显示复选框或者显示一个默认选项 -->
                                                                <option value="">请选择权限</option>
                                                            <% } %>
                                                        </select>

						</div>
					</div>
<%--					<div class="form-group">--%>
<%--						<label for="edit_userState" class="col-sm-2 control-label">用户状态</label>--%>
<%--						<div class="col-sm-10">--%>
<%--							<input type="text" class="form-control" id="edit_userState" placeholder="用户状态" name="userState" />--%>
<%--						</div>--%>
<%--					</div>--%>

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
    <script src="<%=basePath%>static/js/jquery-1.11.3.min.js"></script>
    <!-- Bootstrap Core JavaScript -->
    <script src="<%=basePath%>static/js/bootstrap.min.js"></script>
    <!-- Metis Menu Plugin JavaScript -->
    <script src="<%=basePath%>static/js/metisMenu.min.js"></script>
    <!-- DataTables JavaScript -->
    <script src="<%=basePath%>static/js/jquery.dataTables.min.js"></script>
    <script src="<%=basePath%>static/js/dataTables.bootstrap.min.js"></script>
    <!-- Custom Theme JavaScript -->
    <script src="<%=basePath%>static/js/sb-admin-2.js"></script>
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
            $.post("http://localhost:8080/Forum/permission/per",
            $("#new_user_form").serialize(), function(data) {
                if (data == "OK") {
                    alert("用户创建成功！");
                    window.location.reload();
                } else {
                    alert("用户创建失败！");
                    window.location.reload();
                }
            });
        }
    	// 通过id获取修改的用户信息
    	function editUser(id) {
    	    $.ajax({
    	        type:"get",
    	        url:"<%=basePath%>permission/"+id,
    	        success:function(data) {
    	            $("#edit_userId").val(data.userId);
    	            $("#edit_userCode").val(data.userCode);
    	            $("#edit_userName").val(data.userName)
    	            $("#edit_userPassword").val(data.userPassword)
    	            $("#edit_userState").val(data.userState)
    	        }
    	    });
    	}

		function queryUser() {
			var userCode = $("#userCode").val();
			userCode=userCode===""?"-1":userCode;
    	    $.ajax({
    	        type:"get",
    	        url:"<%=basePath%>permission/query/"+userCode,
    	        success:function(data) {
					document.querySelector('table tbody').innerHTML = '';
					data.forEach(item => {
						// 创建一个新的<tr>元素
						let tr = document.createElement('tr');

						// 创建td元素并设置它们的文本内容
						let tdPermissionId = document.createElement('td');
						tdPermissionId.textContent = item.permissionId;
						tr.appendChild(tdPermissionId);

						let tdUserId = document.createElement('td');
						tdUserId.textContent = item.userId;
						tr.appendChild(tdUserId);

						let tdTargetPermission = document.createElement('td');
						tdTargetPermission.textContent = item.targetPermission;
						tr.appendChild(tdTargetPermission);

						// 创建操作列
						let tdActions = document.createElement('td');
						tdActions.innerHTML = `
        <center>

        </center>
      `;
						tr.appendChild(tdActions);

						// 将新创建的<tr>元素添加到表格的tbody中
						document.querySelector('table tbody').appendChild(tr);
					})
    	        }
    	    })
		}
      // 执行修改操作
          	function updateUser() {
          	    var targetPermission = $("#targetPermission").val();
          	    var userId = $("#userId").val();
                  var permissionId = $("#permissionId").val();
          	    $.ajax({
                     url: '<%=basePath%>permission/update',
                     type: 'PUT',
                     data : JSON.stringify({
          				userId : userId,
      				   user: permissionId,
      				   targetPermission : targetPermission
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
    	    $.ajax({   url: '<%=basePath%>permission/delete/'+id,
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