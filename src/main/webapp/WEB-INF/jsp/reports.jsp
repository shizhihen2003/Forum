<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core"%>
<%@ taglib prefix="fmt" uri="http://java.sun.com/jsp/jstl/fmt"%>
<%@ taglib prefix="fn" uri="http://java.sun.com/jsp/jstl/functions"%>
<!DOCTYPE html>
<html>
<head>
    <meta charset="UTF-8">
    <title>我的举报记录</title>
    <link href="${pageContext.request.contextPath}/static/css/bootstrap.min.css" rel="stylesheet">
    <link href="https://cdnjs.cloudflare.com/ajax/libs/bootstrap-icons/1.10.3/font/bootstrap-icons.min.css" rel="stylesheet">
    <style>
        body {
            background-color: #f8f9fa;
        }
        .container {
            margin-top: 40px;
        }
        .page-title {
            margin-bottom: 20px;
        }
        .table {
            background: #fff;
        }
        /* 导航栏样式 */
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

        /* 下拉菜单样式修复 */
        .dropdown-menu {
            border: none;
            box-shadow: 0 2px 8px rgba(0,0,0,.1);
            padding: 0.5rem 0;
            right: 0;  /* 确保下拉菜单右对齐 */
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
            width: 1.2rem;  /* 固定图标宽度 */
            text-align: center;
        }

        .dropdown-item span {
            flex: 1;  /* 让文本占据剩余空间 */
        }

        .dropdown-item:hover {
            background-color: #f8f9fa;
            color: #667eea;
        }

        /* 按钮样式 */
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
        /* 修复下拉菜单在移动端的显示 */
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
    </style>
</head>
<body>
<!-- 导航栏 -->
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
                        <!-- 修改下拉菜单部分的结构 -->
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
<div class="container">
    <h1 class="page-title">我的举报记录</h1>

    <c:if test="${not empty errorMessage}">
        <div class="alert alert-danger" role="alert">
            ${errorMessage}
        </div>
    </c:if>
    <c:if test="${not empty successMessage}">
        <div class="alert alert-success" role="alert">
            ${successMessage}
        </div>
    </c:if>

    <c:if test="${empty myReports}">
        <div class="alert alert-info" role="alert">
            暂无举报记录
        </div>
    </c:if>

    <c:if test="${not empty myReports}">
        <table class="table table-bordered table-hover table-striped">
            <thead class="thead-light">
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
                        <button class="btn btn-sm btn-warning"
                                onclick="showEditModal(${r.id}, ${r.reportTypeId}, '${fn:escapeXml(r.description)}')">
                            <i class="bi bi-pencil-square"></i> 修改
                        </button>
                        <a class="btn btn-sm btn-danger"
                           href="${pageContext.request.contextPath}/reports/delete?id=${r.id}"
                           onclick="return confirm('确定要删除这条举报记录吗？');">
                            <i class="bi bi-trash"></i> 删除
                        </a>
                    </td>
                </tr>
            </c:forEach>
            </tbody>
        </table>
    </c:if>
</div>

<!-- 编辑举报的模态框 -->
<div class="modal fade" id="editModal" tabindex="-1" role="dialog" aria-labelledby="editModalLabel">
    <div class="modal-dialog" role="document">
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
                        <label for="editReportType">举报类型</label>
                        <select name="reportTypeId" id="editReportType" class="form-control" required>
                            <option value="" disabled>请选择举报类型</option>
                            <c:forEach var="t" items="${allTypes}">
                                <option value="${t.id}">${t.typeName}</option>
                            </c:forEach>
                        </select>
                    </div>

                    <div class="form-group">
                        <label for="editDescription">举报描述</label>
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

<script src="${pageContext.request.contextPath}/static/js/jquery.min.js"></script>
<script src="${pageContext.request.contextPath}/static/js/bootstrap.min.js"></script>
<script>
function showEditModal(id, reportTypeId, description) {
    // 设置模态框中的表单值
    $('#editReportId').val(id);
    $('#editReportType').val(reportTypeId);
    $('#editDescription').val(description);

    // 显示模态框
    $('#editModal').modal('show');
}
</script>
</body>
</html>
