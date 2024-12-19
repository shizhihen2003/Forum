<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ taglib prefix="c" uri="jakarta.tags.core"%>
<%@ taglib prefix="fmt" uri="http://java.sun.com/jsp/jstl/fmt"%>
<!DOCTYPE html>
<html>
<head>
  <meta charset="UTF-8">
  <title>消息通知 - 论坛</title>
  <!-- 引入Bootstrap和其他必要的CSS -->
  <link href="https://cdn.jsdelivr.net/npm/bootstrap-icons@1.7.2/font/bootstrap-icons.css" rel="stylesheet">
  <link href="${pageContext.request.contextPath}/static/css/bootstrap.min.css" rel="stylesheet">
  <style>
    body {
      background-color: #f5f5f5;
      padding: 20px;
    }

    .notification-container {
      max-width: 800px;
      margin: 0 auto;
      background: white;
      border-radius: 8px;
      box-shadow: 0 2px 4px rgba(0,0,0,0.1);
      padding: 20px;
    }

    .page-header {
      display: flex;
      justify-content: space-between;
      align-items: center;
      padding-bottom: 20px;
      border-bottom: 1px solid #eee;
      margin-bottom: 20px;
    }

    .notification-item {
      position: relative;
      padding: 15px;
      border-radius: 6px;
      margin-bottom: 15px;
      background: #fff;
      border: 1px solid #eee;
      transition: all 0.3s ease;
    }

    .notification-item:hover {
      box-shadow: 0 2px 8px rgba(0,0,0,0.1);
      transform: translateY(-1px);
    }

    .notification-unread {
      background-color: #f0f7ff;
      border-color: #d0e3ff;
    }

    .notification-unread::before {
      content: "";
      position: absolute;
      left: 0;
      top: 0;
      bottom: 0;
      width: 4px;
      background: #007bff;
      border-radius: 4px 0 0 4px;
    }

    .notification-header {
      display: flex;
      justify-content: space-between;
      align-items: start;
      margin-bottom: 10px;
    }

    .notification-title {
      font-size: 16px;
      font-weight: 500;
      margin: 0;
      color: #333;
    }

    .notification-meta {
      font-size: 12px;
      color: #666;
    }

    .notification-content {
      font-size: 14px;
      color: #666;
      margin: 10px 0;
      line-height: 1.5;
    }

    .notification-actions {
      display: flex;
      gap: 10px;
    }

    .notification-type {
      display: inline-block;
      padding: 2px 8px;
      border-radius: 12px;
      font-size: 12px;
      margin-left: 8px;
    }

    .notification-type-like {
      background-color: #fff1f0;
      color: #ff4d4f;
    }

    .notification-type-comment {
      background-color: #e6f7ff;
      color: #1890ff;
    }

    .notification-type-reply {
      background-color: #f6ffed;
      color: #52c41a;
    }

    .notification-empty {
      text-align: center;
      padding: 40px 20px;
      color: #999;
    }

    .notification-empty i {
      font-size: 48px;
      margin-bottom: 15px;
      display: block;
      color: #ddd;
    }

    .btn-back {
      color: #666;
      text-decoration: none;
    }

    .btn-back:hover {
      color: #333;
      text-decoration: none;
    }

    .btn-icon {
      display: inline-flex;
      align-items: center;
      gap: 5px;
    }

    .spinner {
      width: 100%;
      height: 100px;
      display: flex;
      justify-content: center;
      align-items: center;
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
<div class="notification-container">
  <!-- 页面头部 -->
  <div class="page-header">
    <h4 class="mb-0">
      <i class="bi bi-bell"></i> 消息通知
    </h4>
    <div>
      <button class="btn btn-outline-primary btn-sm btn-icon" onclick="markAllAsRead()">
        <i class="bi bi-check-all"></i>
        全部标为已读
      </button>
      <a href="${pageContext.request.contextPath}/home" class="btn btn-outline-secondary btn-sm btn-icon ml-2">
        <i class="bi bi-arrow-left"></i>
        返回主页
      </a>
    </div>
  </div>

  <!-- 通知列表 -->
  <div class="notification-list">
    <c:choose>
      <c:when test="${empty notifications}">
        <div class="notification-empty">
          <i class="bi bi-bell-slash"></i>
          <p>暂无通知消息</p>
        </div>
      </c:when>
      <c:otherwise>
        <c:forEach items="${notifications}" var="notification">
          <div class="notification-item ${notification.isRead ? '' : 'notification-unread'}"
               id="notification-${notification.id}">
            <div class="notification-header">
              <div>
                <h5 class="notification-title">
                    ${notification.title}
                  <span class="notification-type notification-type-${notification.type}">
                                            <c:choose>
                                              <c:when test="${notification.type == 'like'}">点赞</c:when>
                                              <c:when test="${notification.type == 'comment'}">评论</c:when>
                                              <c:when test="${notification.type == 'reply'}">回复</c:when>
                                              <c:when test="${notification.type == 'collection'}">收藏</c:when>
                                              <c:otherwise>${notification.type}</c:otherwise>
                                            </c:choose>
                                        </span>
                </h5>
                <div class="notification-meta">
                  <fmt:formatDate value="${notification.createdAt}"
                                  pattern="yyyy-MM-dd HH:mm:ss"/>
                </div>
              </div>
              <div class="notification-actions">
                <c:if test="${!notification.isRead}">
                  <button class="btn btn-outline-primary btn-sm"
                          onclick="markAsRead(${notification.id})">
                    <i class="bi bi-check-circle"></i> 标为已读
                  </button>
                </c:if>
                <button class="btn btn-outline-danger btn-sm"
                        onclick="deleteNotification(${notification.id})">
                  <i class="bi bi-trash"></i> 删除
                </button>
              </div>
            </div>
            <div class="notification-content">
                ${notification.content}
            </div>
          </div>
        </c:forEach>
      </c:otherwise>
    </c:choose>
  </div>
</div>

<!-- 引入必要的JavaScript -->
<script src="${pageContext.request.contextPath}/static/js/jquery.min.js"></script>
<script src="${pageContext.request.contextPath}/static/js/bootstrap.bundle.min.js"></script>
<script>
  // 标记单条通知为已读
  function markAsRead(id) {
    $.post('${pageContext.request.contextPath}/notifications/read/' + id, function(res) {
      if(res.code === 200) {
        $('#notification-' + id).removeClass('notification-unread')
                .find('.btn-outline-primary').remove();
        updateUnreadCount();
      } else {
        alert('标记已读失败：' + res.message);
      }
    });
  }

  // 标记所有通知为已读
  function markAllAsRead() {
    $.post('${pageContext.request.contextPath}/notifications/read/all', function(res) {
      if(res.code === 200) {
        $('.notification-item').removeClass('notification-unread');
        $('.notification-actions .btn-outline-primary').remove();
        updateUnreadCount();
      } else {
        alert('标记全部已读失败：' + res.message);
      }
    });
  }

  // 删除通知
  function deleteNotification(id) {
    if(!confirm('确定要删除这条通知吗？')) {
      return;
    }

    $.post('${pageContext.request.contextPath}/notifications/delete/' + id, function(res) {
      if(res.code === 200) {
        $('#notification-' + id).fadeOut(400, function() {
          $(this).remove();
          if($('.notification-item').length === 0) {
            $('.notification-list').html(`
                                <div class="notification-empty">
                                    <i class="bi bi-bell-slash"></i>
                                    <p>暂无通知消息</p>
                                </div>
                            `);
          }
        });
        updateUnreadCount();
      } else {
        alert('删除失败：' + res.message);
      }
    });
  }

  // 更新未读消息数量
  function updateUnreadCount() {
    $.get('${pageContext.request.contextPath}/notifications/unread/count', function(res) {
      if(res.code === 200) {
        // 如果在父页面存在未读消息计数器，就更新它
        if(window.parent && window.parent.document.getElementById('unreadNotificationCount')) {
          const badge = window.parent.document.getElementById('unreadNotificationCount');
          if(res.data > 0) {
            badge.innerText = res.data;
            badge.style.display = 'inline';
          } else {
            badge.style.display = 'none';
          }
        }
      }
    });
  }

  // 页面加载完成后更新未读消息数
  $(document).ready(function() {
    updateUnreadCount();
  });
</script>
</body>
</html>