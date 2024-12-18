<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core"%>
<%@ taglib prefix="fmt" uri="http://java.sun.com/jsp/jstl/fmt"%>
<!DOCTYPE html>
<html lang="en">
<head>
    <meta charset="UTF-8">
    <title>Login</title>
    <link href="${pageContext.request.contextPath}/static/css/bootstrap.min.css" rel="stylesheet">
    <link href="${pageContext.request.contextPath}/static/plugins/editor.md/css/editormd.min.css" rel="stylesheet">
    <link href="https://cdnjs.cloudflare.com/ajax/libs/bootstrap-icons/1.10.3/font/bootstrap-icons.min.css" rel="stylesheet">
    <link href="${pageContext.request.contextPath}/static/plugins/editor.md/css/editormd.preview.css" rel="stylesheet">
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