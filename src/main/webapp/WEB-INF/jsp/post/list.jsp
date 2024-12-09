<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core"%>
<%@ taglib prefix="fmt" uri="http://java.sun.com/jsp/jstl/fmt"%>
<!DOCTYPE html>
<html>
<head>
  <title>论坛首页</title>
  <link href="${pageContext.request.contextPath}/static/css/bootstrap.min.css" rel="stylesheet">
  <style>
    .post-card {
      margin-bottom: 20px;
      border: 1px solid #ddd;
      border-radius: 4px;
      padding: 15px;
      transition: all 0.3s ease;
    }
    .post-card:hover {
      box-shadow: 0 2px 5px rgba(0,0,0,0.1);
      transform: translateY(-2px);
    }
    .post-title {
      font-size: 18px;
      margin-bottom: 10px;
    }
    .post-title a {
      color: #333;
      text-decoration: none;
    }
    .post-title a:hover {
      color: #007bff;
    }
    .post-meta {
      color: #666;
      font-size: 13px;
      margin-bottom: 10px;
    }
    .post-summary {
      color: #666;
      margin-bottom: 10px;
      line-height: 1.5;
    }
    .post-footer {
      color: #999;
      font-size: 12px;
      display: flex;
      justify-content: space-between;
    }
    .badge-top {
      background: #ff4d4f;
      color: white;
    }
    .badge-essence {
      background: #ffa940;
      color: white;
    }
    .category-box {
      background: #f8f9fa;
      padding: 15px;
      border-radius: 4px;
      margin-bottom: 20px;
    }
    .category-title {
      font-size: 16px;
      font-weight: bold;
      margin-bottom: 10px;
    }
    .category-list {
      display: flex;
      flex-wrap: wrap;
    }
    .category-item {
      margin: 5px;
      padding: 5px 10px;
      background: white;
      border: 1px solid #ddd;
      border-radius: 15px;
      cursor: pointer;
    }
    .category-item.active {
      background: #007bff;
      color: white;
      border-color: #007bff;
    }
  </style>
</head>
<body>
<div class="container mt-4">
  <!-- 分类导航 -->
  <div class="category-box">
    <div class="category-title">分类导航</div>
    <div class="category-list">
      <div class="category-item ${empty param.categoryId ? 'active' : ''}"
           onclick="location.href='${pageContext.request.contextPath}/post/list'">全部</div>
      <c:forEach items="${categories}" var="category">
        <div class="category-item ${param.categoryId eq category.id ? 'active' : ''}"
             onclick="location.href='${pageContext.request.contextPath}/post/list?categoryId=${category.id}'">
            ${category.name}
        </div>
      </c:forEach>
    </div>
  </div>

  <div class="row">
    <!-- 帖子列表 -->
    <div class="col-md-9">
      <!-- 搜索栏 -->
      <div class="search-box mb-4">
        <form class="form-inline" method="get" action="${pageContext.request.contextPath}/post/list">
          <input type="hidden" name="categoryId" value="${param.categoryId}">
          <div class="input-group w-100">
            <input type="text" class="form-control" name="keyword"
                   value="${param.keyword}" placeholder="搜索帖子">
            <div class="input-group-append">
              <button class="btn btn-primary" type="submit">搜索</button>
            </div>
          </div>
        </form>
      </div>

      <!-- 帖子列表 -->
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
            <span><i class="bi bi-person"></i> ${post.authorName}</span>
            <span class="ml-3"><i class="bi bi-folder"></i> ${post.categoryName}</span>
            <span class="ml-3">
                                <i class="bi bi-clock"></i>
                                <fmt:formatDate value="${post.createTime}" pattern="yyyy-MM-dd HH:mm"/>
                            </span>
          </div>
          <div class="post-summary">${post.summary}</div>
          <div class="post-footer">
            <div>
              <span><i class="bi bi-eye"></i> ${post.viewCount} 浏览</span>
              <span class="ml-3"><i class="bi bi-chat"></i> ${post.commentCount} 评论</span>
              <span class="ml-3"><i class="bi bi-heart"></i> ${post.likeCount} 点赞</span>
            </div>
            <div>
              <c:if test="${not empty sessionScope.user}">
                <a href="${pageContext.request.contextPath}/post/create" class="btn btn-sm btn-primary">发帖</a>
              </c:if>
            </div>
          </div>
        </div>
      </c:forEach>

      <!-- 分页 -->
      <nav aria-label="Page navigation" class="mt-4">
        <ul class="pagination justify-content-center">
          <c:if test="${pageResult.current > 1}">
            <li class="page-item">
              <a class="page-link" href="?page=${pageResult.current-1}${queryString}">上一页</a>
            </li>
          </c:if>

          <c:forEach begin="1" end="${pageResult.pages}" var="p">
            <li class="page-item ${p eq pageResult.current ? 'active' : ''}">
              <a class="page-link" href="?page=${p}${queryString}">${p}</a>
            </li>
          </c:forEach>

          <c:if test="${pageResult.current < pageResult.pages}">
            <li class="page-item">
              <a class="page-link" href="?page=${pageResult.current+1}${queryString}">下一页</a>
            </li>
          </c:if>
        </ul>
      </nav>
    </div>

    <!-- 侧边栏 -->
    <div class="col-md-3">
      <!-- 快捷操作 -->
      <div class="card mb-4">
        <div class="card-body">
          <h5 class="card-title">快捷操作</h5>
          <a href="${pageContext.request.contextPath}/post/create" class="btn btn-primary btn-block">发布帖子</a>
        </div>
      </div>

      <!-- 热门帖子 -->
      <div class="card">
        <div class="card-body">
          <h5 class="card-title">热门帖子</h5>
          <div class="list-group list-group-flush">
            <c:forEach items="${hotPosts}" var="post">
              <a href="${pageContext.request.contextPath}/post/detail/${post.id}"
                 class="list-group-item list-group-item-action">
                  ${post.title}
                <span class="badge badge-light float-right">${post.viewCount}</span>
              </a>
            </c:forEach>
          </div>
        </div>
      </div>
    </div>
  </div>
</div>

<script src="${pageContext.request.contextPath}/static/js/jquery.min.js"></script>
<script src="${pageContext.request.contextPath}/static/js/bootstrap.min.js"></script>
</body>
</html>