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
    </style>
</head>
<body>
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
