<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<!DOCTYPE html>
<html>
<head>
    <meta charset="UTF-8">
    <title>粉丝管理</title>
    <link rel="stylesheet" href="${pageContext.request.contextPath}/css/bootstrap.min.css">
</head>
<body>
    <div class="container mt-4">
        <h2>粉丝管理</h2>
        <div class="mb-3">
            <a href="${pageContext.request.contextPath}/fanGroup/add" class="btn btn-primary">添加分组</a>
        </div>
        <table class="table table-bordered">
            <thead>
                <tr>
                    <th>ID</th>
                    <th>分组名称</th>
                    <th>粉丝</th>
                    <th>作者</th>
                    <th>创建时间</th>
                    <th>操作</th>
                </tr>
            </thead>
            <tbody>
                <c:forEach items="${fanGroups}" var="group">
                    <tr>
                        <td>${group.id}</td>
                        <td>${group.groupName}</td>
                        <td>${group.fan.username}</td>
                        <td>${group.author.username}</td>
                        <td>${group.createdAt}</td>
                        <td>
                            <a href="${pageContext.request.contextPath}/fanGroup/edit/${group.id}"
                               class="btn btn-sm btn-warning">编辑</a>
                            <a href="${pageContext.request.contextPath}/fanGroup/delete/${group.id}"
                               class="btn btn-sm btn-danger"
                               onclick="return confirm('确定要删除吗？')">删除</a>
                        </td>
                    </tr>
                </c:forEach>
            </tbody>
        </table>
    </div>
    <script src="${pageContext.request.contextPath}/js/bootstrap.min.js"></script>
</body>
</html>