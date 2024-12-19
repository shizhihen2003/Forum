<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core"%>
<!DOCTYPE html>
<html>
<head>
    <meta charset="UTF-8">
    <title>Forum - 首页</title>
    <link href="${pageContext.request.contextPath}/static/bootstrap5/css/bootstrap.min.css" rel="stylesheet">
    <link href="https://cdn.jsdelivr.net/npm/bootstrap-icons@1.7.2/font/bootstrap-icons.css" rel="stylesheet">
    <style>
        body {
            background-color: #f8f9fa;
            font-family: -apple-system, BlinkMacSystemFont, "Segoe UI", Roboto, "Helvetica Neue", Arial, sans-serif;
        }

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

        .hero-section {
            background: linear-gradient(135deg, #667eea 0%, #764ba2 100%);
            padding: 100px 0;
            color: white;
            margin-bottom: 50px;
        }

        .hero-title {
            font-size: 3rem;
            font-weight: bold;
            margin-bottom: 20px;
        }

        .hero-subtitle {
            font-size: 1.2rem;
            opacity: 0.9;
            margin-bottom: 30px;
        }

        .feature-card {
            background: white;
            border-radius: 10px;
            padding: 30px;
            margin-bottom: 30px;
            transition: transform 0.3s ease;
            box-shadow: 0 4px 6px rgba(0,0,0,.05);
        }

        .feature-card:hover {
            transform: translateY(-5px);
        }

        .feature-icon {
            font-size: 2.5rem;
            color: #667eea;
            margin-bottom: 20px;
        }

        .feature-title {
            font-size: 1.5rem;
            font-weight: bold;
            margin-bottom: 15px;
            color: #2c3e50;
        }

        .feature-description {
            color: #666;
            line-height: 1.6;
        }

        .stats-section {
            background-color: white;
            padding: 50px 0;
            margin: 50px 0;
        }

        .stat-card {
            text-align: center;
            padding: 20px;
        }

        .stat-number {
            font-size: 2.5rem;
            font-weight: bold;
            color: #667eea;
            margin-bottom: 10px;
        }

        .stat-label {
            color: #666;
            font-size: 1.1rem;
        }

        .cta-section {
            background: linear-gradient(135deg, #764ba2 0%, #667eea 100%);
            padding: 80px 0;
            color: white;
            text-align: center;
            margin-top: 50px;
        }

        .cta-title {
            font-size: 2.5rem;
            font-weight: bold;
            margin-bottom: 20px;
        }

        .cta-description {
            font-size: 1.2rem;
            opacity: 0.9;
            margin-bottom: 30px;
        }

        .btn-primary {
            background-color: #667eea;
            border-color: #667eea;
            padding: 12px 30px;
            font-size: 1.1rem;
            border-radius: 30px;
            transition: all 0.3s ease;
        }

        .btn-primary:hover {
            background-color: #764ba2;
            border-color: #764ba2;
            transform: translateY(-2px);
        }

        .footer {
            background-color: #2c3e50;
            color: white;
            padding: 50px 0 20px;
        }

        .footer-title {
            font-size: 1.2rem;
            font-weight: bold;
            margin-bottom: 20px;
        }

        .footer-links {
            list-style: none;
            padding: 0;
        }

        .footer-links li {
            margin-bottom: 10px;
        }

        .footer-links a {
            color: rgba(255,255,255,0.8);
            text-decoration: none;
            transition: color 0.3s ease;
        }

        .footer-links a:hover {
            color: white;
            text-decoration: none;
        }

        .social-links {
            font-size: 1.5rem;
        }

        .social-links a {
            color: white;
            margin-right: 15px;
            transition: transform 0.3s ease;
        }

        .social-links a:hover {
            transform: translateY(-3px);
        }

        .copyright {
            text-align: center;
            padding-top: 30px;
            border-top: 1px solid rgba(255,255,255,0.1);
            margin-top: 30px;
            color: rgba(255,255,255,0.6);
        }

        /* 响应式调整 */
        @media (max-width: 991.98px) {
            .navbar-brand {
                margin-right: 0;
            }

            .hero-title {
                font-size: 2.5rem;
            }

            .feature-card {
                margin-bottom: 20px;
            }
            .dropdown-menu {
                width: 100%;
                margin-top: 0;
                border-radius: 0;
                box-shadow: none;
            }
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
                               role="button" data-bs-toggle="dropdown" aria-expanded="false">
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

<!-- 英雄区域 -->
<section class="hero-section">
    <div class="container">
        <div class="row">
            <div class="col-lg-8 mx-auto text-center">
                <h1 class="hero-title">欢迎来到我们的论坛</h1>
                <p class="hero-subtitle">加入我们的社区，分享你的想法，探索无限可能</p>
                <a href="${pageContext.request.contextPath}/post" class="btn btn-light btn-lg">开始探索</a>
            </div>
        </div>
    </div>
</section>

<!-- 特色功能 -->
<section class="container">
    <div class="row">
        <div class="col-md-4">
            <div class="feature-card">
                <div class="feature-icon">
                    <i class="bi bi-chat-dots"></i>
                </div>
                <h3 class="feature-title">畅所欲言</h3>
                <p class="feature-description">
                    在这里，你可以自由表达观点，分享经验，与志同道合的人交流探讨。
                </p>
            </div>
        </div>
        <div class="col-md-4">
            <div class="feature-card">
                <div class="feature-icon">
                    <i class="bi bi-people"></i>
                </div>
                <h3 class="feature-title">社区互动</h3>
                <p class="feature-description">
                    加入各种话题讨论，认识新朋友，建立属于你的社交圈。
                </p>
            </div>
        </div>
        <div class="col-md-4">
            <div class="feature-card">
                <div class="feature-icon">
                    <i class="bi bi-shield-check"></i>
                </div>
                <h3 class="feature-title">安全可靠</h3>
                <p class="feature-description">
                    我们致力于提供安全、友善的讨论环境，保护用户隐私。
                </p>
            </div>
        </div>
    </div>
</section>

<!-- 数据统计 -->
<section class="stats-section">
    <div class="container">
        <div class="row">
            <div class="col-md-3">
                <div class="stat-card">
                    <div class="stat-number">10,000+</div>
                    <div class="stat-label">活跃用户</div>
                </div>
            </div>
            <div class="col-md-3">
                <div class="stat-card">
                    <div class="stat-number">50,000+</div>
                    <div class="stat-label">话题讨论</div>
                </div>
            </div>
            <div class="col-md-3">
                <div class="stat-card">
                    <div class="stat-number">100,000+</div>
                    <div class="stat-label">互动评论</div>
                </div>
            </div>
            <div class="col-md-3">
                <div class="stat-card">
                    <div class="stat-number">99%</div>
                    <div class="stat-label">用户好评</div>
                </div>
            </div>
        </div>
    </div>
</section>

<!-- 号召性用语 -->
<section class="cta-section">
    <div class="container">
        <h2 class="cta-title">准备好加入我们了吗？</h2>
        <p class="cta-description">立即注册，开启你的社区之旅</p>
        <a href="${pageContext.request.contextPath}/register" class="btn btn-light btn-lg">立即注册</a>
    </div>
</section>

<!-- 页脚 -->
<footer class="footer">
    <div class="container">
        <div class="row">
            <div class="col-md-4">
                <h5 class="footer-title">关于我们</h5>
                <p>我们致力于打造一个开放、包容、友善的社区平台，让每个人都能找到归属感。</p>
                <div class="social-links">
                    <a href="#"><i class="bi bi-facebook"></i></a>
                    <a href="#"><i class="bi bi-twitter"></i></a>
                    <a href="#"><i class="bi bi-instagram"></i></a>
                    <a href="#"><i class="bi bi-linkedin"></i></a>
                </div>
            </div>
            <div class="col-md-4">
                <h5 class="footer-title">快速链接</h5>
                <ul class="footer-links">
                    <li><a href="${pageContext.request.contextPath}/post">论坛首页</a></li>
                    <li><a href="#">帮助中心</a></li>
                    <li><a href="#">隐私政策</a></li>
                    <li><a href="#">使用条款</a></li>
                </ul>
            </div>
            <div class="col-md-4">
                <h5 class="footer-title">联系我们</h5>
                <ul class="footer-links">
                    <li><i class="bi bi-envelope"></i> contact@ujn.edu.cn</li>
                    <li><i class="bi bi-telephone"></i> +1 234 567 890</li>
                    <li><i class="bi bi-geo-alt"></i> 山东省济南市济南大学</li>
                </ul>
            </div>
        </div>
        <div class="copyright">
            <p>&copy; 2024 Forum. All rights reserved.</p>
        </div>
    </div>
</footer>

<script src="${pageContext.request.contextPath}/static/js/jquery.min.js"></script>
<script src="${pageContext.request.contextPath}/static/bootstrap5/js/bootstrap.bundle.min.js"></script>
<script>
    // 初始化所有的下拉菜单
    document.addEventListener('DOMContentLoaded', function() {
        var dropdowns = document.querySelectorAll('.dropdown-toggle');
        dropdowns.forEach(function(dropdown) {
            new bootstrap.Dropdown(dropdown);
        });
    });
</script>
</body>
</html>