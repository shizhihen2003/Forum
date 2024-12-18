<%@ page contentType="text/html; charset=UTF-8" language="java" %>
<%@ page pageEncoding="UTF-8" %>
<%@ taglib uri="http://java.sun.com/jsp/jstl/core" prefix="c" %>
<%@ taglib uri="http://java.sun.com/jsp/jstl/fmt" prefix="fmt" %>
<!DOCTYPE html>
<html lang="zh">
<head>
    <meta charset="UTF-8">
    <title>登录记录</title>
</head>
<body>
    <h1>登录记录</h1>

    <c:if test="${not empty loggedInUser}">
        <p>欢迎，用户ID：<strong>${loggedInUser.id}</strong>！以下是您的登录记录：</p>
    </c:if>

    <!-- 如果没有记录 -->
    <c:if test="${empty loginLogs}">
        <p>您还没有任何登录记录。</p>
    </c:if>

    <!-- 显示登录记录 -->
    <c:if test="${not empty loginLogs}">
        <table border="1" cellspacing="0" cellpadding="8">
            <thead>
                <tr>
                    <th>登录时间</th>
                </tr>
            </thead>
            <tbody>
                <c:forEach var="log" items="${loginLogs}">
                    <tr>
                        <!-- 格式化登录时间 -->
                        <td>
                            <fmt:formatDate value="${log.loginTime}" pattern="yyyy-MM-dd HH:mm:ss" />
                        </td>
                    </tr>
                </c:forEach>
            </tbody>
        </table>
    </c:if>

    <a href="<c:url value='/home'/>">返回主页</a>
</body>
</html>
