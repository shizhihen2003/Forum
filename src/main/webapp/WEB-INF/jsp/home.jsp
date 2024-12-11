<%@ page contentType="text/html; charset=UTF-8" language="java" %>
<%@ taglib uri="http://java.sun.com/jsp/jstl/core" prefix="c" %>

<!DOCTYPE html>
<html lang="en">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>Home - Welcome</title>

    <style>
        body {
            font-family: 'Arial', sans-serif;
            background-color: #e9f5fc; /* 柔和的浅蓝背景 */
            margin: 0;
            display: flex;
            justify-content: center;
            align-items: center;
            min-height: 100vh;
        }

        .container {
            background: #fff;
            border-radius: 10px;
            box-shadow: 0 4px 10px rgba(0, 0, 0, 0.2);
            padding: 40px 30px;
            text-align: center;
            max-width: 400px;
            width: 100%;
        }

        .container h1 {
            color: #0078d4; /* 深蓝色标题 */
            font-size: 24px;
            margin-bottom: 20px;
        }

        .container p {
            font-size: 16px;
            color: #555;
            margin: 10px 0;
        }

        .btn {
            background-color: #28a745; /* 绿色按钮 */
            color: #fff;
            border: none;
            border-radius: 5px;
            font-size: 16px;
            padding: 12px 20px;
            cursor: pointer;
            margin-top: 20px;
            text-decoration: none;
            display: inline-block;
        }

        .btn:hover {
            background-color: #218838; /* 按钮悬停变色 */
        }

        .link {
            display: block;
            margin-top: 20px;
            color: #0078d4; /* 深蓝链接 */
            text-decoration: none;
            font-size: 14px;
        }

        .link:hover {
            text-decoration: underline;
        }
    </style>
</head>
<body>
    <div class="container">
        <h1>Welcome, ${sessionScope.loggedInUser.username}!</h1>
        <p><strong>Email:</strong> ${sessionScope.loggedInUser.email}</p>
        <p><strong>Phone:</strong> ${sessionScope.loggedInUser.phone}</p>

        <a href="/Forum/logout" class="btn">Logout</a>

    </div>
</body>
</html>
