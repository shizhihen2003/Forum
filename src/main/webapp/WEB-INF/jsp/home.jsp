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
    </style>
</head>
<body>
    <div class="container">
        <div class="profile-card">
            <div class="profile-header">
                <div class="avatar-container">

                    <label for="avatarInput" class="avatar-upload" title="更换头像">
                        <i class="bi bi-camera-fill"></i>
                    </label>
                    <input type="file" id="avatarInput" name="file" accept="image/*" style="display: none" onchange="uploadAvatar(this)">
                </div>
                <div class="profile-name">${sessionScope.loggedInUser.username}</div>
                <div class="profile-bio">这个人很懒，还没有填写个人简介</div>
                <div class="profile-stats">
                    <div class="stat-item">
                        <div class="stat-value">0</div>
                        <div class="stat-label">帖子</div>
                    </div>
                    <div class="stat-item">
                        <div class="stat-value">0</div>
                        <div class="stat-label">评论</div>
                    </div>
                    <div class="stat-item">
                        <div class="stat-value">0</div>
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

                <div style="text-align: center; margin-top: 30px;">
                    <button class="edit-button" onclick="editProfile()">编辑资料</button>
                    退出登录
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
    </script>
</body>
</html>