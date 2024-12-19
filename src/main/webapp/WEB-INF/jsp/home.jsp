<%@ page contentType="text/html; charset=UTF-8" language="java" %>
<%@ taglib uri="http://java.sun.com/jsp/jstl/core" prefix="c" %>
<%@ taglib prefix="fmt" uri="http://java.sun.com/jsp/jstl/fmt" %>

<!DOCTYPE html>
<html lang="zh-CN">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>个人主页</title>
    <link href="${pageContext.request.contextPath}/static/css/bootstrap.min.css" rel="stylesheet">
    <style>
        body {
            font-family: 'Microsoft YaHei', sans-serif;
            background-color: #f0f2f5;
            color: #333;
        }

        .container {
            max-width: 1000px;
            margin: 40px auto;
            padding: 0 20px;
        }

        .profile-card {
            background: #fff;
            border-radius: 15px;
            box-shadow: 0 2px 15px rgba(0, 0, 0, 0.1);
            overflow: hidden;
        }

        .profile-header {
            background: linear-gradient(135deg, #00b4db, #0083b0);
            padding: 30px;
            text-align: center;
            color: white;
        }

        .avatar-container {
            position: relative;
            width: 150px;
            height: 150px;
            margin: 0 auto;
        }

        .avatar {
            width: 150px;
            height: 150px;
            border-radius: 50%;
            border: 4px solid white;
            box-shadow: 0 2px 10px rgba(0, 0, 0, 0.2);
            object-fit: cover;
        }

        .avatar-upload {
            position: absolute;
            bottom: 5px;
            right: 5px;
            background: rgba(0, 0, 0, 0.6);
            color: white;
            width: 36px;
            height: 36px;
            border-radius: 50%;
            display: flex;
            align-items: center;
            justify-content: center;
            cursor: pointer;
            transition: all 0.3s ease;
        }

        .avatar-upload:hover {
            background: rgba(0, 0, 0, 0.8);
        }

        .profile-name {
            font-size: 24px;
            font-weight: bold;
            margin-top: 15px;
        }

        .profile-bio {
            font-size: 16px;
            margin-top: 10px;
            opacity: 0.9;
        }

        .profile-stats {
            display: flex;
            justify-content: center;
            margin-top: 20px;
        }

        .stat-item {
            text-align: center;
            margin: 0 20px;
        }

        .stat-value {
            font-size: 20px;
            font-weight: bold;
        }

        .stat-label {
            font-size: 14px;
            opacity: 0.8;
        }

        .profile-content {
            padding: 30px;
        }

        .info-section {
            margin-bottom: 30px;
        }

        .section-title {
            font-size: 18px;
            font-weight: bold;
            margin-bottom: 15px;
            color: #333;
            border-bottom: 2px solid #f0f2f5;
            padding-bottom: 10px;
        }

        .info-item {
            display: flex;
            margin-bottom: 15px;
            align-items: center;
        }

        .info-label {
            width: 100px;
            color: #666;
        }

        .info-value {
            flex: 1;
            color: #333;
        }
.edit-button {
            background-color: #1890ff;
            color: white;
            border: none;
            padding: 8px 20px;
            border-radius: 5px;
            cursor: pointer;
            transition: all 0.3s ease;
        }

        .edit-button:hover {
            background-color: #40a9ff;
        }

        .logout-button {
            background-color: #f5222d;
            color: white;
            border: none;
            padding: 8px 20px;
            border-radius: 5px;
            cursor: pointer;
            transition: all 0.3s ease;
        }

        .logout-button:hover {
            background-color: #ff4d4f;
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
    <div class="container">
        <div class="profile-card">
            <div class="profile-header">
                <div class="avatar-container">
                    <img src="${sessionScope.userProfile.avatar}" class="avatar" id="currentAvatar" alt="用户头像">
                    <label for="avatarInput" class="avatar-upload" title="更换头像">
                        <i class="bi bi-camera-fill"></i>
                    </label>
                    <input type="file" id="avatarInput" name="file" accept="image/*" style="display: none" onchange="uploadAvatar(this)">
                </div>

                <div class="profile-name">${sessionScope.userProfile.nickname}</div>
                <div class="profile-bio">${empty sessionScope.userProfile.bio ? '这个人很懒，还没有填写个人简介' : sessionScope.userProfile.bio}</div>
                <div class="profile-stats">
                    <div class="stat-item">
                        <div class="stat-value">
                            <!-- 显示帖子总数 -->
                            ${posts.size()}
                        </div>
                        <div class="stat-label">帖子</div>
                    </div>
                    <div class="stat-item">
                        <div class="stat-value">
                            <!-- 累加所有帖子的评论数 -->
                            <c:set var="totalComments" value="0" />
                            <c:forEach items="${posts}" var="post">
                                <c:set var="totalComments" value="${totalComments + post.commentCount}" />
                            </c:forEach>
                            ${totalComments}
                        </div>
                        <div class="stat-label">评论</div>
                    </div>
                    <div class="stat-item">
                        <div class="stat-value">
                            <!-- 累加所有帖子的点赞数 -->
                            <c:set var="totalLikes" value="0" />
                            <c:forEach items="${posts}" var="post">
                                <c:set var="totalLikes" value="${totalLikes + post.likeCount}" />
                            </c:forEach>
                            ${totalLikes}
                        </div>
                        <div class="stat-label">获赞</div>
                    </div>
                </div>
            </div>



            <div class="profile-content">
                <div class="info-section">
                    <div class="section-title">基本信息</div>
                    <div class="info-item">
                        <div class="info-label">用户名</div>
                        <div class="info-value">${sessionScope.loggedInUser.username}</div>
                    </div>
                    <div class="info-item">
                        <div class="info-label">邮箱</div>
                        <div class="info-value">${sessionScope.loggedInUser.email}</div>
                    </div>
                    <div class="info-item">
                        <div class="info-label">手机号</div>
                        <div class="info-value">${sessionScope.loggedInUser.phone}</div>
                    </div>
                </div>

                <div class="card mb-4">
                    <div class="card-header">
                        <h5 class="mb-0">
                            <i class="bi bi-bell"></i> 消息通知
                            <span id="unreadNotificationCount" class="badge badge-danger" style="display: none;">0</span>
                        </h5>
                    </div>
                    <div class="card-body">
                        <a href="${pageContext.request.contextPath}/notifications" class="btn btn-primary" target="_self">
                            查看所有通知
                        </a>
                    </div>


                </div>
                <div style="text-align: center; margin-top: 30px;">
                 <button class="edit-button" onclick="window.open('p', '_blank')">权限设置</button>
                    <button class="edit-button" onclick="editProfile()">编辑资料</button>
                    <button class="edit-button" onclick="goToLogs()">查看登录记录</button>
                    <button class="logout-button" onclick="window.location.href='${pageContext.request.contextPath}/logout'">
                        <i class="bi bi-box-arrow-right"></i> 退出登录
                    </button>
                </div>
            </div>
        </div>
    </div>

    <script src="${pageContext.request.contextPath}/static/js/jquery.min.js"></script>
    <script>
        function uploadAvatar(input) {
            if (input.files && input.files[0]) {
                var formData = new FormData();
                formData.append('file', input.files[0]);

                $.ajax({
                    url: '${pageContext.request.contextPath}/uploadAvatar',
                    type: 'POST',
                    data: formData,
                    processData: false,
                    contentType: false,
                    success: function(response) {
                        if (response.code === 200) {
                            $('#currentAvatar').attr('src', response.data);
                            alert('头像上传成功！');
                        } else {
                            alert(response.message || '头像上传失败');
                        }
                    },
                    error: function() {
                        alert('上传失败，请稍后重试');
                    }
                });
            }
        }

        function editProfile() {
            // TODO: 实现编辑资料功能
            alert('编辑资料功能开发中...');
        }
        function goToLogs() {
            window.location.href = '${pageContext.request.contextPath}/logs';
        }
    </script>
<script src="${pageContext.request.contextPath}/static/js/bootstrap.bundle.min.js"></script>
<script>
    // 初始化下拉菜单
    document.addEventListener('DOMContentLoaded', function() {
        var dropdowns = document.querySelectorAll('.dropdown-toggle');
        dropdowns.forEach(function(dropdown) {
            new bootstrap.Dropdown(dropdown);
        });
    });
</script>
</body>
</html>