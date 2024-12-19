<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core"%>
<%@ taglib prefix="fmt" uri="http://java.sun.com/jsp/jstl/fmt"%>
<!DOCTYPE html>
<html>
<head>
  <title>论坛首页</title>
  <link href="${pageContext.request.contextPath}/static/bootstrap5/css/bootstrap.min.css" rel="stylesheet">
  <link href="https://cdn.jsdelivr.net/npm/bootstrap-icons@1.7.2/font/bootstrap-icons.css" rel="stylesheet">
  <style>
    body {
      background-color: #f5f5f5;
      font-family: -apple-system, BlinkMacSystemFont, "Segoe UI", Roboto, "Helvetica Neue", Arial, sans-serif;
    }

    .post-card {
      background: #fff;
      margin-bottom: 20px;
      border-radius: 8px;
      padding: 20px;
      box-shadow: 0 2px 4px rgba(0,0,0,0.05);
      transition: all 0.3s ease;
    }

    .post-card:hover {
      box-shadow: 0 4px 8px rgba(0,0,0,0.1);
      transform: translateY(-2px);
    }

    .post-title {
      font-size: 18px;
      font-weight: 600;
      margin-bottom: 12px;
    }

    .post-title a {
      color: #2c3e50;
      text-decoration: none;
    }

    .post-title a:hover {
      color: #0056b3;
    }

    .post-meta {
      color: #666;
      font-size: 14px;
      margin-bottom: 12px;
    }

    .post-summary {
      color: #666;
      margin-bottom: 15px;
      line-height: 1.6;
      font-size: 14px;
    }

    .post-footer {
      display: flex;
      justify-content: space-between;
      align-items: center;
      color: #666;
      font-size: 13px;
      padding-top: 12px;
      border-top: 1px solid #eee;
    }

    .category-box {
      background: white;
      padding: 20px;
      border-radius: 8px;
      margin-bottom: 25px;
      box-shadow: 0 2px 4px rgba(0,0,0,0.05);
    }

    .category-title {
      font-size: 16px;
      font-weight: bold;
      margin-bottom: 15px;
      color: #2c3e50;
    }

    .category-list {
      display: flex;
      flex-wrap: wrap;
      gap: 10px;
    }

    .category-item {
      text-decoration: none;
      padding: 8px 16px;
      border-radius: 20px;
      color: #666;
      background: #f8f9fa;
      border: 1px solid #eee;
      transition: all 0.3s ease;
      font-size: 14px;
      cursor: pointer;
    }

    .category-item:hover {
      background: #e9ecef;
      color: #333;
    }

    .category-item.active {
      background: #0056b3;
      color: white;
      border-color: #0056b3;
    }

    .badge-top {
      background: #ff4d4f;
      color: white;
      padding: 3px 8px;
      border-radius: 4px;
      font-size: 12px;
      margin-left: 8px;
    }

    .badge-essence {
      background: #ffa940;
      color: white;
      padding: 3px 8px;
      border-radius: 4px;
      font-size: 12px;
      margin-left: 8px;
    }

    .search-box {
      background: white;
      padding: 20px;
      border-radius: 8px;
      margin-bottom: 25px;
      box-shadow: 0 2px 4px rgba(0,0,0,0.05);
    }

    .btn-primary {
      background-color: #0056b3;
      border-color: #0056b3;
    }

    .btn-primary:hover {
      background-color: #004494;
      border-color: #004494;
    }

    .stat-icon {
      margin-right: 5px;
      color: #666;
    }

    .pagination {
      margin-top: 30px;
      justify-content: center;
    }

    .sidebar-card {
      background: white;
      border-radius: 8px;
      padding: 20px;
      margin-bottom: 20px;
      box-shadow: 0 2px 4px rgba(0,0,0,0.05);
    }

    .sidebar-title {
      font-size: 16px;
      font-weight: bold;
      margin-bottom: 15px;
      color: #2c3e50;
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
  <!-- 分类导航 -->
  <div class="category-box">
    <div class="category-title">分类导航</div>
    <div class="category-list">
      <div class="category-item ${empty param.categoryId ? 'active' : ''}"
           data-id="" onclick="loadPosts(null)">
        全部
      </div>
      <c:forEach items="${categories}" var="category">
        <div class="category-item ${param.categoryId eq category.id ? 'active' : ''}"
             data-id="${category.id}" onclick="loadPosts(${category.id})">
            ${category.name}
        </div>
      </c:forEach>
    </div>
  </div>

  <div class="row">
    <!-- 主内容区 -->
    <div class="col-md-9">
      <!-- 搜索栏 -->
      <div class="search-box">
        <form class="form-inline" id="searchForm" onsubmit="return handleSearch(event)">
          <div class="input-group w-100">
            <input type="text" class="form-control" id="searchInput" name="keyword"
                   value="${param.keyword}" placeholder="搜索帖子标题或内容">
            <div class="input-group-append">
              <button class="btn btn-primary" type="submit">搜索</button>
            </div>
          </div>
        </form>
      </div>

      <!-- 帖子列表容器 -->
      <div id="postContainer">
        <c:forEach items="${pageResult.list}" var="post">
          <div class="post-card">
            <div class="post-title">
              <a href="${pageContext.request.contextPath}/post/detail/${post.id}">${post.title}</a>
              <c:if test="${post.isTop == 1}">
                <span class="badge badge-top">置顶</span>
              </c:if>
              <c:if test="${post.isEssence == 1}">
                <span class="badge badge-essence">精华</span>
              </c:if>
            </div>
            <div class="post-meta">
              <span>
                <i class="bi bi-person stat-icon"></i>
                <c:choose>
                  <c:when test="${not empty post.author}">
                    ${post.author.username}
                  </c:when>
                  <c:otherwise>
                    匿名用户
                  </c:otherwise>
                </c:choose>
              </span>
              <span class="ml-3">
                <i class="bi bi-folder stat-icon"></i>
                <c:choose>
                  <c:when test="${not empty post.category}">
                    ${post.category.name}
                  </c:when>
                  <c:otherwise>
                    未分类
                  </c:otherwise>
                </c:choose>
              </span>
              <span class="ml-3">
                <i class="bi bi-clock stat-icon"></i>
                <fmt:formatDate value="${post.createTime}" pattern="yyyy-MM-dd HH:mm"/>
              </span>
            </div>
            <div class="post-summary">${post.summary}</div>
            <div class="post-footer">
              <div>
                <span><i class="bi bi-eye stat-icon"></i>${post.viewCount} 浏览</span>
                <span class="ml-3"><i class="bi bi-chat stat-icon"></i>${post.commentCount} 评论</span>
                <span class="ml-3"><i class="bi bi-heart stat-icon"></i>${post.likeCount} 点赞</span>
              </div>
            </div>
          </div>
        </c:forEach>
      </div>

      <!-- 分页导航 -->
      <div id="paginationContainer"></div>
    </div>

    <!-- 侧边栏 -->
    <div class="col-md-3">
      <!-- 快捷操作 -->
      <div class="sidebar-card">
        <div class="sidebar-title">快捷操作</div>
        <c:choose>
          <c:when test="${not empty sessionScope.loggedInUser}">
            <a href="${pageContext.request.contextPath}/post/create" class="btn btn-primary btn-block">发布帖子</a>
          </c:when>
          <c:otherwise>
            <a href="${pageContext.request.contextPath}/login" class="btn btn-primary btn-block">登录发帖</a>
          </c:otherwise>
        </c:choose>
      </div>

      <!-- 热门帖子 -->
      <div class="sidebar-card">
        <div class="sidebar-title">热门帖子</div>
        <div class="list-group list-group-flush">
          <c:forEach items="${hotPosts}" var="post">
            <a href="${pageContext.request.contextPath}/post/detail/${post.id}"
               class="list-group-item list-group-item-action">
              <div class="d-flex justify-content-between align-items-center">
                <span class="text-truncate mr-2">${post.title}</span>
                <span class="badge badge-light">
                  <i class="bi bi-eye stat-icon"></i>${post.viewCount}
                </span>
              </div>
              <small class="text-muted">
                <c:choose>
                  <c:when test="${not empty post.author}">
                    ${post.author.username}
                  </c:when>
                  <c:otherwise>
                    匿名用户
                  </c:otherwise>
                </c:choose>
                ·
                <fmt:formatDate value="${post.createTime}" pattern="MM-dd"/>
              </small>
            </a>
          </c:forEach>
        </div>
      </div>
    </div>
  </div>
</div>
<script src="${pageContext.request.contextPath}/static/js/jquery.min.js"></script>
<script src="${pageContext.request.contextPath}/static/bootstrap5/js/bootstrap.bundle.min.js"></script>
<script>
  let currentCategoryId = null;
  let currentPage = 1;
  let currentKeyword = '';

  // 页面加载时的初始化
  $(document).ready(function() {
    const urlParams = new URLSearchParams(window.location.search);
    currentKeyword = urlParams.get('keyword') || '';
    currentCategoryId = urlParams.get('categoryId') || null;
    currentPage = parseInt(urlParams.get('page')) || 1;

    $('#searchInput').val(currentKeyword);
    loadPosts(currentCategoryId, currentPage, currentKeyword);
  });

  function loadPosts(categoryId, page = 1, keyword = '') {
    currentCategoryId = categoryId;
    currentPage = page;
    currentKeyword = keyword;

    $('.category-item').removeClass('active');
    if (categoryId === null) {
      $('.category-item[data-id=""]').addClass('active');
    } else {
      $('.category-item[data-id="' + categoryId + '"]').addClass('active');
    }

    const newUrl = updateURLParameter(window.location.href, {
      categoryId: categoryId || '',
      page: page,
      keyword: keyword
    });
    window.history.pushState({}, '', newUrl);

    $.ajax({
      url: '${pageContext.request.contextPath}/post/list',
      type: 'GET',
      data: {
        categoryId: categoryId,
        page: page,
        pageSize: 10,
        keyword: keyword
      },
      success: function(response) {
        if (response.code === 200) {
          updatePosts(response.data.list);
          updatePagination(response.data);
        } else {
          console.error('加载帖子失败:', response.message);
        }
      },
      error: function(xhr, status, error) {
        console.error('加载帖子失败:', error);
      }
    });
  }

  function updatePosts(posts) {
    const container = $('#postContainer');
    container.empty();

    posts.forEach(function(post) {
      const createTime = new Date(post.createTime);
      const formattedDate = formatDate(createTime);

      const postHtml =
              '<div class="post-card">' +
              '<div class="post-title">' +
              '<a href="' + '${pageContext.request.contextPath}/post/detail/' + post.id + '">' + post.title + '</a>' +
              (post.isTop === 1 ? '<span class="badge badge-top">置顶</span>' : '') +
              (post.isEssence === 1 ? '<span class="badge badge-essence">精华</span>' : '') +
              '</div>' +
              '<div class="post-meta">' +
              '<span><i class="bi bi-person stat-icon"></i>' +
              (post.author ? post.author.username : '匿名用户') + '</span>' +
              '<span class="ml-3"><i class="bi bi-folder stat-icon"></i>' +
              (post.category ? post.category.name : '未分类') + '</span>' +
              '<span class="ml-3"><i class="bi bi-clock stat-icon"></i>' + formattedDate + '</span>' +
              '</div>' +
              '<div class="post-summary">' + (post.summary || '暂无简介') + '</div>' +
              '<div class="post-footer">' +
              '<div>' +
              '<span><i class="bi bi-eye stat-icon"></i>' + (post.viewCount || 0) + ' 浏览</span>' +
              '<span class="ml-3"><i class="bi bi-chat stat-icon"></i>' + (post.commentCount || 0) + ' 评论</span>' +
              '<span class="ml-3"><i class="bi bi-heart stat-icon"></i>' + (post.likeCount || 0) + ' 点赞</span>' +
              '</div>' +
              '</div>' +
              '</div>';
      container.append(postHtml);
    });
  }

  function updatePagination(pageData) {
    const container = $('#paginationContainer');
    if (pageData.pages <= 1) {
      container.empty();
      return;
    }

    let html = '<nav aria-label="Page navigation"><ul class="pagination">';

    if (pageData.current > 1) {
      html += '<li class="page-item">' +
              '<a class="page-link" href="javascript:void(0)" onclick="loadPosts(currentCategoryId, ' +
              (pageData.current - 1) + ', currentKeyword)">上一页</a>' +
              '</li>';
    }

    for (let i = 1; i <= pageData.pages; i++) {
      html += '<li class="page-item ' + (i === pageData.current ? 'active' : '') + '">' +
              '<a class="page-link" href="javascript:void(0)" onclick="loadPosts(currentCategoryId, ' +
              i + ', currentKeyword)">' + i + '</a>' +
              '</li>';
    }

    if (pageData.current < pageData.pages) {
      html += '<li class="page-item">' +
              '<a class="page-link" href="javascript:void(0)" onclick="loadPosts(currentCategoryId, ' +
              (pageData.current + 1) + ', currentKeyword)">下一页</a>' +
              '</li>';
    }

    html += '</ul></nav>';
    container.html(html);
  }

  function handleSearch(event) {
    event.preventDefault();
    const keyword = $('#searchInput').val().trim();
    loadPosts(currentCategoryId, 1, keyword);
    return false;
  }

  function updateURLParameter(url, params) {
    const urlObj = new URL(url);
    Object.keys(params).forEach(key => {
      if (params[key]) {
        urlObj.searchParams.set(key, params[key]);
      } else {
        urlObj.searchParams.delete(key);
      }
    });
    return urlObj.toString();
  }

  function formatDate(date) {
    if (!date) return '--';
    try {
      date = new Date(date);
      const year = date.getFullYear();
      const month = String(date.getMonth() + 1).padStart(2, '0');
      const day = String(date.getDate()).padStart(2, '0');
      const hours = String(date.getHours()).padStart(2, '0');
      const minutes = String(date.getMinutes()).padStart(2, '0');
      return year + '-' + month + '-' + day + ' ' + hours + ':' + minutes;
    } catch (e) {
      console.error('Date formatting error:', e);
      return '--';
    }
  }
</script>
</body>
</html>