<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core"%>
<%@ taglib prefix="fmt" uri="http://java.sun.com/jsp/jstl/fmt"%>
<%@ taglib prefix="fn" uri="http://java.sun.com/jsp/jstl/functions"%>
<!DOCTYPE html>
<html lang="zh-CN">
<head>
    <meta charset="UTF-8">
    <title>我的举报记录</title>
    <!-- 引入 Bootstrap CSS -->
    <link href="${pageContext.request.contextPath}/static/css/bootstrap.min.css" rel="stylesheet">
    <!-- 引入 Bootstrap Icons -->
    <link href="https://cdnjs.cloudflare.com/ajax/libs/bootstrap-icons/1.10.3/font/bootstrap-icons.min.css" rel="stylesheet">
    <!-- 引入 Google Fonts -->
    <link href="https://fonts.googleapis.com/css?family=Poppins:300,400,500,600&display=swap" rel="stylesheet">
    <style>
        body {
            background: linear-gradient(to bottom right, #e2e8f0, #cbd5e0);
            font-family: 'Poppins', sans-serif;
            color: #333;
            font-size: 1.44rem;
            line-height: 1.6;
            margin: 0;
            padding: 0;
        }

        /* 导航栏样式（来自第一份代码） */
        .navbar {
            background-color: #fff;
            box-shadow: 0 2px 4px rgba(0,0,0,.08);
            padding: 1rem 0;
        }
        .navbar-brand {
            font-size: 1.8rem;
            font-weight: bold;
            color: #2c3e50;
            margin-right: 3rem;
        }
        .navbar-nav .nav-link {
            color: #2c3e50 !important;
            font-weight: 500;
            padding: 0.5rem 1rem;
            margin: 0 0.5rem;
            transition: color 0.3s ease;
        }
        .navbar-nav .nav-link:hover {
            color: #667eea !important;
        }
        .dropdown-menu {
            border: none;
            box-shadow: 0 2px 8px rgba(0,0,0,.1);
            padding: 0.5rem 0;
            right: 0;
            left: auto;
        }
        .dropdown-item {
            padding: 0.5rem 1.5rem;
            color: #2c3e50;
            transition: all 0.3s ease;
            display: flex !important;
            align-items: center;
        }
        .dropdown-item i {
            margin-right: 0.5rem;
            width: 1.2rem;
            text-align: center;
        }
        .dropdown-item span {
            flex: 1;
        }
        .dropdown-item:hover {
            background-color: #f8f9fa;
            color: #667eea;
        }
        .btn-nav {
            padding: 0.5rem 1.5rem;
            border-radius: 50px;
            transition: all 0.3s ease;
        }
        .btn-nav.btn-primary {
            background-color: #667eea;
            border-color: #667eea;
        }
        .btn-nav.btn-outline-primary {
            border-color: #667eea;
            color: #667eea;
        }
        .btn-nav:hover {
            transform: translateY(-2px);
        }
        @media (max-width: 991.98px) {
            .dropdown-menu {
                width: 100%;
                margin-top: 0;
                border-radius: 0;
                box-shadow: none;
            }
        }
        .nav-item{
            list-style-type:none;
        }

        /* 来自第二份代码的样式 */
        header {
            background: linear-gradient(to right, #4a5568, #2d3748);
            display: flex;
            align-items: center;
            justify-content: flex-start;
            padding: 40px 20px;
            margin-bottom: 40px;
            box-sizing: border-box;
            max-width: 100%;
        }
        header h1 {
            color: #fff;
            font-weight: 600;
            font-size: 2.88rem;
            margin: 0;
        }

        .container {
            max-width: 1000px;
            margin: -20px auto 0 auto;
            padding: 0 20px;
            box-sizing: border-box;
        }
        .page-title {
            margin-bottom: 36px;
            font-weight: 500;
            font-size: 2.16rem;
            color: #343a40;
            text-align: center;
        }
        .alert {
            border-radius: 0.5rem;
            margin-bottom: 24px;
            font-size: 1.32rem;
            padding: 1.5rem 1.8rem;
        }
        .alert i {
            margin-right: 12px;
            font-size: 1.56rem;
            vertical-align: middle;
        }

        .card {
            border: none;
            border-radius: 0.96rem;
            box-shadow: 0 4px 12px rgba(0,0,0,0.1);
            overflow: hidden;
        }
        .card-header {
            background-color: #ffffff;
            border-bottom: none;
            padding: 1.8rem 1.8rem;
        }
        .card-header h5 {
            font-weight: 500;
            margin: 0;
            font-size: 1.68rem;
            color: #2d3748;
        }
        .card-body {
            padding: 0;
        }

        .table {
            margin-bottom: 0;
            background: #fff;
            font-size: 1.32rem;
        }
        .table thead {
            background: #f8fafc;
        }
        .table thead th {
            border-bottom: 2px solid #dee2e6;
            font-weight: 500;
            font-size: 1.26rem;
            color: #4a5568;
            padding: 1rem;
        }
        .table tbody tr {
            transition: background 0.1s ease;
        }
        .table tbody tr:nth-child(even) {
            background: #edf2f7;
        }
        .table tbody tr:nth-child(odd) {
            background: #ffffff;
        }
        .table tbody tr:hover {
            background: #e2e8f0;
        }
        .table td {
            padding: 1rem;
            vertical-align: middle;
            color: #333;
        }

        .btn {
            font-size: 1.32rem;
            border-radius: 0.36rem;
            padding: 0.54rem 0.9rem;
        }
        .btn-warning {
            background-color: #f6c23e !important;
            border-color: #f6c23e !important;
            color: #212529 !important;
        }
        .btn-warning:hover, .btn-warning:focus {
            background-color: #e0a800 !important;
            border-color: #d39e00 !important;
            color: #212529 !important;
        }
        .btn-danger {
            background-color: #e74a3b !important;
            border-color: #e74a3b !important;
            color: #fff !important;
        }
        .btn-danger:hover, .btn-danger:focus {
            background-color: #c82333 !important;
            border-color: #bd2130 !important;
        }
        .btn-primary {
            background-color: #4e73df !important;
            border-color: #4e73df !important;
            color: #fff !important;
        }
        .btn-primary:hover, .btn-primary:focus {
            background-color: #2e59d9 !important;
            border-color: #2653d4 !important;
        }
        .btn-secondary {
            background-color: #6c757d !important;
            border-color: #6c757d !important;
            color: #fff !important;
        }
        .btn-secondary:hover, .btn-secondary:focus {
            background-color: #5a6268 !important;
            border-color: #545b62 !important;
        }

        .modal-content {
            border-radius: 0.5rem;
            background: #ffffff;
            border: none;
            box-shadow: 0 4px 12px rgba(0,0,0,0.15);
            font-size: 1.32rem;
        }
        .modal-header {
            border-bottom: none;
            background: linear-gradient(to right, #4a5568, #2d3748);
            color: #ffffff;
            border-top-left-radius: 0.5rem;
            border-top-right-radius: 0.5rem;
            padding: 1.2rem 1.8rem;
        }
        .modal-header h5 {
            font-weight: 500;
            margin: 0;
            font-size: 1.56rem;
        }
        .modal-footer {
            border-top: none;
            padding: 0.9rem 1.8rem;
        }
        .modal-body .form-group label {
            font-weight: 500;
            font-size: 1.32rem;
            color: #2d3748;
            margin-bottom: 0.6rem;
            display: inline-block;
        }
        .modal-body .form-control {
            border-radius: 0.25rem;
            font-size: 1.32rem;
            padding: 0.54rem 1.44rem;
        }
        .close {
            color: #fff;
            opacity: 1;
            font-size: 1.56rem;
        }
        .close:hover, .close:focus {
            color: #e2e8f0;
            text-decoration: none;
            opacity: 1;
        }
        #editReportType {
            width: 100%;
        }
    </style>
</head>
<body>
<!-- 导航栏（来自第一份代码） -->
<nav class="navbar navbar-expand-lg navbar-light sticky-top">
    <div class="container">
        <a class="navbar-brand" href="${pageContext.request.contextPath}/">Forum</a>
        <button class="navbar-toggler" type="button" data-toggle="collapse" data-target="#navbarNav">
            <span class="navbar-toggler-icon"></span>
        </button>
        <div class="collapse navbar-collapse" id="navbarNav">
            <ul class="navbar-nav mr-auto">
                <li class="nav-item">
                    <a class="nav-link" href="${pageContext.request.contextPath}/post">
                        <i class="bi bi-house"></i> 论坛
                    </a>
                </li>
                <li class="nav-item">
                    <a class="nav-link" href="#">
                        <i class="bi bi-info-circle"></i> 关于我们
                    </a>
                </li>
            </ul>

            <ul class="navbar-nav">
                <c:choose>
                    <c:when test="${not empty sessionScope.loggedInUser}">
                        <li class="nav-item">
                            <a class="nav-link" href="${pageContext.request.contextPath}/post/create">
                                <i class="bi bi-plus-circle"></i> 发布帖子
                            </a>
                        </li>
                        <li class="nav-item">
                            <a class="nav-link" href="${pageContext.request.contextPath}/reports/myReports">
                                <i class="bi bi-flag"></i> 我的举报
                            </a>
                        </li>
                        <li class="nav-item dropdown">
                            <a class="nav-link dropdown-toggle" href="#" id="navbarDropdown"
                               role="button" data-toggle="dropdown" aria-expanded="false">
                                <i class="bi bi-person-circle"></i> ${sessionScope.loggedInUser.username}
                            </a>
                            <div class="dropdown-menu dropdown-menu-end" aria-labelledby="navbarDropdown">
                                <a class="dropdown-item d-flex align-items-center" href="${pageContext.request.contextPath}/home">
                                    <i class="bi bi-person me-2"></i>
                                    <span>个人中心</span>
                                </a>
                                <a class="dropdown-item d-flex align-items-center" href="${pageContext.request.contextPath}/notifications">
                                    <i class="bi bi-bell me-2"></i>
                                    <span>消息通知</span>
                                </a>
                                <div class="dropdown-divider"></div>
                                <a class="dropdown-item d-flex align-items-center" href="${pageContext.request.contextPath}/logout">
                                    <i class="bi bi-box-arrow-right me-2"></i>
                                    <span>退出</span>
                                </a>
                            </div>
                        </li>
                    </c:when>
                    <c:otherwise>
                        <li class="nav-item">
                            <a class="nav-link btn btn-outline-primary me-2"
                               href="${pageContext.request.contextPath}/login">登录</a>
                        </li>
                        <li class="nav-item">
                            <a class="nav-link btn btn-outline-primary me-2"
                               href="${pageContext.request.contextPath}/register">注册</a>
                        </li>
                    </c:otherwise>
                </c:choose>
            </ul>
        </div>
    </div>
</nav>

<!-- 来自第二份代码的 header -->
<header>
    <h1>举报系统</h1>
</header>

<div class="container">
    <h1 class="page-title">我的举报记录</h1>

    <c:if test="${not empty errorMessage}">
        <div class="alert alert-danger" role="alert">
            <i class="bi bi-exclamation-triangle-fill"></i> ${errorMessage}
        </div>
    </c:if>
    <c:if test="${not empty successMessage}">
        <div class="alert alert-success" role="alert">
            <i class="bi bi-check-circle-fill"></i> ${successMessage}
        </div>
    </c:if>

    <c:if test="${empty myReports}">
        <div class="alert alert-info" role="alert">
            <i class="bi bi-info-circle-fill"></i> 暂无举报记录
        </div>
    </c:if>

    <c:if test="${not empty myReports}">
        <div class="card">
            <div class="card-header">
                <h5>举报列表</h5>
            </div>
            <div class="card-body">
                <table class="table table-bordered table-hover table-striped mb-0">
                    <thead>
                    <tr>
                        <th>帖子ID</th>
                        <th>用户ID</th>
                        <th>举报类型</th>
                        <th>举报描述</th>
                        <th>创建时间</th>
                        <th>修改时间</th>
                        <th>操作</th>
                    </tr>
                    </thead>
                    <tbody>
                    <c:forEach var="r" items="${myReports}">
                        <tr>
                            <td>${r.postId}</td>
                            <td>${r.userId}</td>
                            <td>
                                <c:choose>
                                    <c:when test="${typeMap[r.reportTypeId] != null}">
                                        ${typeMap[r.reportTypeId]}
                                    </c:when>
                                    <c:otherwise>
                                        未知类型 (ID: ${r.reportTypeId})
                                    </c:otherwise>
                                </c:choose>
                            </td>
                            <td>${r.description}</td>
                            <td><fmt:formatDate value="${r.createdAt}" pattern="yyyy-MM-dd HH:mm:ss" /></td>
                            <td><fmt:formatDate value="${r.updatedAt}" pattern="yyyy-MM-dd HH:mm:ss" /></td>
                            <td>
                                <button class="btn btn-warning"
                                        onclick="showEditModal(${r.id}, ${r.reportTypeId}, '${fn:escapeXml(r.description)}')">
                                    <i class="bi bi-pencil-square"></i> 修改
                                </button>
                                <a class="btn btn-danger"
                                   href="${pageContext.request.contextPath}/reports/delete?id=${r.id}"
                                   onclick="return confirm('确定要删除这条举报记录吗？');">
                                    <i class="bi bi-trash"></i> 删除
                                </a>
                            </td>
                        </tr>
                    </c:forEach>
                    </tbody>
                </table>
            </div>
        </div>
    </c:if>
</div>

<!-- 编辑举报的模态框 -->
<div class="modal fade" id="editModal" tabindex="-1" role="dialog" aria-labelledby="editModalLabel" data-backdrop="static">
    <div class="modal-dialog modal-dialog-centered" role="document">
        <div class="modal-content">
            <form action="${pageContext.request.contextPath}/reports/edit" method="post">
                <div class="modal-header">
                    <h5 class="modal-title" id="editModalLabel">编辑举报记录</h5>
                    <button type="button" class="close" data-dismiss="modal" aria-label="关闭">
                        <span aria-hidden="true">&times;</span>
                    </button>
                </div>
                <div class="modal-body">
                    <input type="hidden" name="id" id="editReportId">
                    <div class="form-group">
                        <label for="editReportType"><i class="bi bi-flag-fill"></i> 举报类型</label>
                        <select name="reportTypeId" id="editReportType" class="form-control" required>
                            <option value="" disabled>请选择举报类型</option>
                            <c:forEach var="t" items="${allTypes}">
                                <option value="${t.id}">${t.typeName}</option>
                            </c:forEach>
                        </select>
                    </div>
                    <div class="form-group">
                        <label for="editDescription"><i class="bi bi-pencil-fill"></i> 举报描述</label>
                        <textarea name="description" id="editDescription" class="form-control" rows="3" required minlength="5" maxlength="500"></textarea>
                    </div>
                </div>
                <div class="modal-footer">
                    <button type="button" class="btn btn-secondary" data-dismiss="modal">取消</button>
                    <button type="submit" class="btn btn-primary">保存修改</button>
                </div>
            </form>
        </div>
    </div>
</div>

<!-- 引入必要的脚本 -->
<script src="${pageContext.request.contextPath}/static/js/jquery.min.js"></script>
<script src="${pageContext.request.contextPath}/static/js/bootstrap.min.js"></script>
<script>
function showEditModal(id, reportTypeId, description) {
    $('#editReportId').val(id);
    $('#editReportType').val(reportTypeId);
    $('#editDescription').val(description);
    $('#editModal').modal('show');
}
</script>
</body>
</html>
