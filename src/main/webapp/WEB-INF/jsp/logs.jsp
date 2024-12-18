<%@ page contentType="text/html; charset=UTF-8" language="java" %>
<%@ page pageEncoding="UTF-8" %>
<%@ taglib uri="http://java.sun.com/jsp/jstl/core" prefix="c" %>
<%@ taglib uri="http://java.sun.com/jsp/jstl/fmt" prefix="fmt" %>
<!DOCTYPE html>
<html lang="zh">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>登录记录</title>
    <link href="${pageContext.request.contextPath}/static/css/bootstrap.min.css" rel="stylesheet">
    <style>
        body {
            font-family: 'Microsoft YaHei', Arial, sans-serif;
            background-color: #f8f9fa;
            margin: 0;
            padding: 0;
            color: #333;
        }

        .container {
            max-width: 800px;
            margin: 40px auto;
            background: #ffffff;
            border-radius: 10px;
            box-shadow: 0 4px 10px rgba(0, 0, 0, 0.1);
            overflow: hidden;
            padding: 20px;
        }

        h1 {
            text-align: center;
            margin-bottom: 20px;
            color: #007bff;
        }

        p {
            text-align: center;
            font-size: 16px;
        }

        table {
            width: 100%;
            border-collapse: collapse;
            margin-top: 20px;
            font-size: 16px;
        }

        th, td {
            padding: 12px;
            border: 1px solid #ddd;
            text-align: center;
        }

        th {
            background-color: #007bff;
            color: white;
            font-weight: bold;
        }

        tr:nth-child(even) {
            background-color: #f2f2f2;
        }

        tr:hover {
            background-color: #e9f6ff;
        }

        a {
            display: inline-block;
            margin-top: 20px;
            text-align: center;
            text-decoration: none;
            background-color: #007bff;
            color: white;
            padding: 10px 20px;
            border-radius: 5px;
            font-size: 16px;
            transition: background-color 0.3s ease;
        }

        a:hover {
            background-color: #0056b3;
        }

        .no-records {
            text-align: center;
            font-size: 18px;
            color: #666;
            margin-top: 30px;
        }
    </style>
</head>
<body>
    <div class="container">
        <h1>登录记录</h1>

        <c:if test="${not empty loggedInUser}">
            <p>欢迎，用户ID：<strong>${loggedInUser.id}</strong>！以下是您的登录记录：</p>
        </c:if>

        <!-- 如果没有记录 -->
        <c:if test="${empty loginLogs}">
            <div class="no-records">您还没有任何登录记录。</div>
        </c:if>

        <!-- 显示登录记录 -->
        <c:if test="${not empty loginLogs}">
            <table>
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

        <div style="text-align: center;">
            <a href="<c:url value='/home'/>">返回主页</a>
        </div>
    </div>
</body>
</html>
