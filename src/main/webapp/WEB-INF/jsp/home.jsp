<%@ page contentType="text/html; charset=UTF-8" language="java" %>
<%@ taglib uri="http://java.sun.com/jsp/jstl/core" prefix="c" %>

<!DOCTYPE html>
<html lang="en">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>Home - Welcome</title>

    <!-- 下面是一些基本的 CSS 样式，用于页面美化 -->
    <style>
        body {
            font-family: Arial, sans-serif;
            background-color: #f0f8ff;  /* 浅蓝色背景 */
            margin: 0;
            padding: 0;
            display: flex;
            justify-content: center;
            align-items: center;
            height: 100vh;
        }

        .container {
            background-color: #ffffff;
            border-radius: 8px;
            box-shadow: 0 4px 8px rgba(0, 0, 0, 0.1);
            padding: 30px;
            width: 400px;
            text-align: center;
        }

        h1 {
            color: #007BFF;  /* 蓝色文字 */
            font-size: 24px;
            margin-bottom: 20px;
        }

        p {
            color: #333;
            font-size: 16px;
            margin: 10px 0;
        }

        .btn {
            background-color: #FF6347;  /* 番茄红按钮 */
            color: white;
            padding: 12px 20px;
            border: none;
            border-radius: 5px;
            font-size: 16px;
            cursor: pointer;
            text-decoration: none;
            margin-top: 40px;  /* 将按钮向下移动 40px，避免与链接重合 */
        }

        .btn:hover {
            background-color: #FF4500;  /* 悬停时改变按钮颜色 */
        }

        .link {
            text-decoration: none;
            color: #007BFF;  /* 蓝色链接 */
            font-size: 16px;
            margin-top: 20px;
            display: block;
            margin-bottom: 20px;  /* 增加与按钮的间距，避免重叠 */
        }

        .link:hover {
            text-decoration: underline;
        }
    </style>
</head>
<body>
    <div class="container">
        <h1>Welcome, ${user.username}!</h1>  <!-- 显示用户名 -->

        <p><strong>Email:</strong> ${user.email}</p>  <!-- 显示用户邮箱 -->

        <p><strong>Phone:</strong> ${user.phone}</p>  <!-- 显示用户手机号 -->

        <!-- 退出登录按钮 -->
        <a href="/Forum/api/user/" class="link">Logout</a>

        <!-- 重置密码按钮 -->
        <a href="/reset-password" class="btn">Reset Password</a>
    </div>
</body>
</html>