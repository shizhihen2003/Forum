<!DOCTYPE html>
<html lang="en">
<head>
    <meta charset="UTF-8">
    <title>Login</title>
    <style>
        body {
            font-family: Arial, sans-serif;
            text-align: center;
            padding-top: 50px;
        }
        form {
            display: inline-block;
            text-align: left;
        }
        input, button {
            margin: 10px 0;
            padding: 10px;
            width: 100%;
            box-sizing: border-box;
        }
        button {
            cursor: pointer;
            background-color: #4CAF50;
            color: white;
            border: none;
        }
    </style>
</head>
<body>
    <h1>Login</h1>
    <form action="/Forum/login" method="post">
        <label for="emailOrPhone">Email or Phone:</label>
        <input type="text" id="emailOrPhone" name="emailOrPhone" placeholder="Enter your email or phone" required>
        <br>
        <label for="password">Password:</label>
        <input type="password" id="password" name="password" placeholder="Enter your password" required>
        <br>
        <button type="submit">Login</button>
    </form>
    <!-- 显示错误消息 -->
            <c:if test="${not empty errorMessage}">
                <div style="color: red;">
                    <p>${errorMessage}</p>
                </div>
            </c:if>

    <p>Don't have an account? <a href="/Forum/register">Register here</a></p>
</body>
</html>