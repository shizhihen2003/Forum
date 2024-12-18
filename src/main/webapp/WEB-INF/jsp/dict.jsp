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
	<title>数据字典管理</title>
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
		<a class="navbar-brand" href="<%=basePath%>dict">数据字典系统</a>
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
				    <a href="${pageContext.request.contextPath }/customer" class="active">
				      <i class="fa fa-edit fa-fw"></i> 客户管理
				    </a>
				</li>
				<li>
				    <a href="${pageContext.request.contextPath }/user" class="active">
				      <i class="fa fa-dashboard fa-fw" ></i> 用户管理
				    </a>
				</li>
				<li>
				    <a href="${pageContext.request.contextPath }/dict" class="active">
				      <i class="fa fa-edit fa-fw"></i> 数据字典
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
				<h1 class="page-header">字典管理</h1>
			</div>
			<!-- /.col-lg-12 -->
		</div>
		<!-- /.row -->
		<div class="panel panel-default">
			<div class="panel-body">
				<form class="form-inline" method="get" 
				      action="${pageContext.request.contextPath }/dict">
					<div class="form-group">
						<label for="dictTypeCode">类型编码</label> 
						<input type="text" class="form-control" id="dictTypeCode" 
						                   value="${dicTypeCode}" name="dictTypeCode" />
					</div>
					<div class="form-group">
						<label for="dictTypeCode">类型名称</label> 
						<input type="text" class="form-control" id="dictTypeName" 
						                   value="${dicTypeName}" name="dictTypeName" />
					</div>
					<button type="submit" class="btn btn-primary">查询</button>
				</form>
			</div>
		</div>
		<a href="#" class="btn btn-primary" data-toggle="modal"
		           data-target="#newDictDialog" onclick="clearDict()">新建</a>
		<div class="row">
			<div class="col-lg-12">
				<div class="panel panel-default">
					<div class="panel-heading">数据字典列表</div>
					<!-- /.panel-heading -->
					<table class="table table-bordered table-striped">
						<thead>
							<tr>
								<th>编号</th>
								<th>类型编码</th>
								<th>类型名称</th>
								<th>项目名称</th>
								<th>操作</th>
							</tr>
						</thead>
						<tbody>
							<c:forEach items="${page.rows}" var="row">
								<tr>
									<td>${row.dictId}</td>
									<td>${row.dictTypeCode}</td>
									<td>${row.dictTypeName}</td>
									<td>${row.dictItemName}</td>
									<td><center>
										<a href="#" class="btn btn-primary btn-xs" data-toggle="modal" data-target="#customerEditDialog" onclick= "editDict(${row.dictId})">修改</a>
										<a href="#" class="btn btn-danger btn-xs" onclick="deleteDict(${row.dictId})">删除</a>
									</td>
								</tr>
							</c:forEach>
						</tbody>
					</table>
					<div class="col-md-12 text-right">
						<ujn:page url="${pageContext.request.contextPath }/dict" />
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
<div class="modal fade" id="newDictDialog" tabindex="-1" role="dialog"
	aria-labelledby="myModalLabel">
	<div class="modal-dialog" role="document">
		<div class="modal-content">
			<div class="modal-header">
				<button type="button" class="close" data-dismiss="modal" aria-label="Close">
					<span aria-hidden="true">&times;</span>
				</button>
				<h4 class="modal-title" id="myModalLabel">新建数据字典</h4>
			</div>
			<div class="modal-body">
				<form class="form-horizontal" id="new_dict_form">
				<div class="form-group">
						<label for="new_dictId" class="col-sm-2 control-label">编号</label>
						<div class="col-sm-10">
							<input type="text" class="form-control" id="new_dictId" placeholder="编号" name="dictId" />
						</div>
					</div>
					<div class="form-group">
						<label for="new_dictTypeCode" class="col-sm-2 control-label">类型编码</label>
						<div class="col-sm-10">
							<input type="text" class="form-control" id="new_dictTypeCode" placeholder="类型编码" name="dictTypeCode" />
						</div>
					</div>
					<div class="form-group">
						<label for="new_dictTypeName" class="col-sm-2 control-label">类型名称</label>
						<div class="col-sm-10">
							<input type="text" class="form-control" id="new_dictTypeName" placeholder="类型名称" name="dictTypeName" />
						</div>
					</div>
					<div class="form-group">
						<label for="new_dictItemName" class="col-sm-2 control-label">项目名称</label>
						<div class="col-sm-10">
							<input type="text" class="form-control" id="new_dictItemName" placeholder="项目名称" name="dictItemName" />
						</div>
						
					</div>
						<div class="form-group">
						<label for="new_dictEnable" class="col-sm-2 control-label">dict_enable</label>
						<div class="col-sm-10">
							<input type="text" class="form-control" id="new_dictEnable" placeholder="dict_enable" name="dictEnable" />
						</div>
						</div>
					
				</form>
			</div>
			<div class="modal-footer">
				<button type="button" class="btn btn-default" data-dismiss="modal">关闭</button>
				<button type="button" class="btn btn-primary" onclick="createDict()">创建数据字典</button>
			</div>
		</div>
	</div>
</div>
<!-- 修改模态框 -->
<div class="modal fade" id="customerEditDialog" tabindex="-1" role="dialog"
	aria-labelledby="myModalLabel">
	<div class="modal-dialog" role="document">
		<div class="modal-content">
			<div class="modal-header">
				<button type="button" class="close" data-dismiss="modal" aria-label="Close">
					<span aria-hidden="true">&times;</span>
				</button>
				<h4 class="modal-title" id="myModalLabel">修改信息</h4>
			</div>
			<div class="modal-body">
				<form class="form-horizontal" id="edit_dict_form">
					<input type="hidden" id="edit_dictId" name="dictId"/>
						<div class="form-group">
						<label for="edit_dictTypeCode" class="col-sm-2 control-label">类型编码</label>
						<div class="col-sm-10">
							<input type="text" class="form-control" id="edit_dictTypeCode" placeholder="类型编码" name="dictTypeCode" />
						</div>
					</div>
					<div class="form-group">
						<label for="edit_dictTypeName" class="col-sm-2 control-label">类型名称</label>
						<div class="col-sm-10">
							<input type="text" class="form-control" id="edit_dictTypeName" placeholder="类型名称" name="dictTypeName" />
						</div>
					</div>
					<div class="form-group">
						<label for="edit_dictItemName" class="col-sm-2 control-label">项目名称</label>
						<div class="col-sm-10">
							<input type="text" class="form-control" id="edit_dictItemName" placeholder="项目名称" name="dictItemName" />
						</div>
					</div>
					
				</form>
			</div>
			<div class="modal-footer">
				<button type="button" class="btn btn-default" data-dismiss="modal">关闭</button>
				<button type="button" class="btn btn-primary" onclick="updateDict()">保存修改</button>
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
	function clearDict() {
	    $("#new_dictTypeCode").val("");
	    $("#new_dictTypeName").val("")
	    $("#new_dictItemName").val("")
	}
	// 创建
	function createDict() {
	$.post("<%=basePath%>dict",
	$("#new_dict_form").serialize(),function(data){
	        if(data =="OK"){
	            alert("创建成功！");
	            window.location.reload();
	        }else{
	            alert("创建失败！");
	            window.location.reload();
	        }
	    });
	}
	// 通过id获取修改的数据字典信息
	function editDict(id) {
	    $.ajax({
	        type:"get",
	        url:"<%=basePath%>dict/"+id,
	        success:function(data) {
	            $("#edit_dictId").val(data.dictId);
	            $("#edit_dictTypeCode").val(data.dictTypeCode);
	            $("#edit_dictTypeName").val(data.dictTypeName)
	            $("#edit_dictItemName").val(data.dictItemName)
	        }
	    });
	}
    // 执行修改操作
	function updateDict() {
            var dictId = $("#edit_dictId").val();
    	    var dictTypeCode = $("#edit_dictTypeCode").val();
            var dictTypeName = $("#edit_dictTypeName").val();
            var dictItemName = $("#edit_dictItemName").val();
    	    $.ajax({
               url: '<%=basePath%>customer',
               type: 'PUT',
               data : JSON.stringify({
    				dictId : dictId,
    				dictTypeCode : dictTypeCode,
    				dictTypeName : dictTypeName,
    				dictItemName : dictItemName
    			}),
    	       contentType : "application/json;charset=UTF-8",
               success: function(data) {
                        if(data =="OK"){
             				alert("数据字典信息更新成功！");
             				window.location.reload();
             			}else{
             				alert("数据字典信息更新失败！");
             				window.location.reload();
             			}
               }
           });
	}
	// 删除
	function deleteDict(id) {
	    if(confirm('确实要删除该数据字典吗?')) {
               $.ajax({   url: '<%=basePath%>dict/'+id,
                      type: 'DELETE',
                      success: function(data) {
                          if(data =="OK"){
                      		alert("数据字典信息删除成功！");
                      		window.location.reload();
                          }else{
                      		alert("数据字典信息删除失败！");
                       		window.location.reload();
                          }
                      }
               });
        }
	}
</script>
</body>
</html>