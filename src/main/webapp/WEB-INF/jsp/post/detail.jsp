<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core"%>
<%@ taglib prefix="fmt" uri="http://java.sun.com/jsp/jstl/fmt"%>
<!DOCTYPE html>
<html>
<head>
  <title>${post.title}</title>
  <link href="${pageContext.request.contextPath}/static/css/bootstrap.min.css" rel="stylesheet">
  <link href="${pageContext.request.contextPath}/static/plugins/editor.md/css/editormd.min.css" rel="stylesheet">
  <link href="https://cdnjs.cloudflare.com/ajax/libs/bootstrap-icons/1.10.3/font/bootstrap-icons.min.css" rel="stylesheet">
  <link href="${pageContext.request.contextPath}/static/plugins/editor.md/css/editormd.preview.css" rel="stylesheet">

  <style>
    .post-container {
      background: #fff;
      padding: 20px;
      border-radius: 4px;
      box-shadow: 0 1px 3px rgba(0,0,0,0.1);
    }
    .post-header {
      border-bottom: 1px solid #eee;
      padding-bottom: 15px;
      margin-bottom: 20px;
    }
    .post-title {
      font-size: 24px;
      margin-bottom: 15px;
    }
    .post-info {
      color: #666;
      font-size: 14px;
    }
    .post-content {
      padding: 20px 0;
      min-height: 200px;
    }
    .post-actions {
      padding: 15px 0;
      border-top: 1px solid #eee;
      margin-top: 20px;
    }
    .comment-section {
      margin-top: 30px;
    }
    .comment-form {
      margin-bottom: 20px;
    }
    .comment-item {
      padding: 15px;
      border: 1px solid #eee;
      border-radius: 4px;
      margin-bottom: 15px;
    }
    .comment-reply {
      margin-left: 40px;
      margin-top: 15px;
      padding: 10px;
      background: #f8f9fa;
      border-radius: 4px;
    }
    .comment-user {
      display: flex;
      align-items: center;
      margin-bottom: 10px;
    }
    .comment-avatar {
      width: 40px;
      height: 40px;
      border-radius: 50%;
      margin-right: 10px;
    }
    .comment-actions {
      margin-top: 10px;
    }
    .comment-actions a {
      color: #666;
      margin-right: 15px;
      text-decoration: none;
    }
    .badge-top {
      background: #ff4d4f;
      color: white;
    }
    .badge-essence {
      background: #ffa940;
      color: white;
    }
    /* Markdown 相关样式 */
    .editormd-preview-container,
    .editormd-html-preview {
      width: 100%;
      margin: 0;
      padding: 0;
      border: none;
    }
    .markdown-body {
      padding: 20px 0;
    }
    .markdown-body pre {
      background-color: #f6f8fa;
      border-radius: 3px;
      padding: 16px;
    }
    .markdown-body img {
      max-width: 100%;
      height: auto;
    }
    .markdown-body table {
      display: table;
      width: 100%;
      margin: 15px 0;
      border-collapse: collapse;
    }
    .markdown-body table th,
    .markdown-body table td {
      padding: 8px;
      border: 1px solid #ddd;
    }
    .markdown-body blockquote {
      padding: 0 1em;
      color: #6a737d;
      border-left: 0.25em solid #dfe2e5;
    }
    .markdown-body code {
      padding: 0.2em 0.4em;
      background-color: rgba(27,31,35,0.05);
      border-radius: 3px;
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

<c:if test="${not empty sessionScope.loggedInUser}">
  <script>
    var currentUserId = ${sessionScope.loggedInUser.id};
  </script>
</c:if>
<c:if test="${empty sessionScope.loggedInUser}">
  <script>
    var currentUserId = null;
  </script>
</c:if>

<div class="container mt-4">
  <div class="row">
    <!-- 主内容区 -->
    <div class="col-md-9">
      <!-- 帖子内容 -->
      <div class="post-container">
        <!-- 帖子头部信息 -->
        <div class="post-header">
          <h1 class="post-title">
            ${post.title}
            <c:if test="${post.isTop == 1}">
              <span class="badge badge-top">置顶</span>
            </c:if>
            <c:if test="${post.isEssence == 1}">
              <span class="badge badge-essence">精华</span>
            </c:if>
          </h1>
          <div class="post-info">
            <span><i class="bi bi-person"></i> ${post.author.username}</span>
            <span class="ml-3"><i class="bi bi-folder"></i> ${post.category.name}</span>
            <span class="ml-3">
            <i class="bi bi-clock"></i>
            <fmt:formatDate value="${post.createTime}" pattern="yyyy-MM-dd HH:mm"/>
        </span>
            <span class="ml-3"><i class="bi bi-eye"></i> ${post.viewCount} 浏览</span>
            <span class="ml-3"><i class="bi bi-chat"></i> ${post.commentCount} 评论</span>
            <span class="ml-3"><i class="bi bi-heart"></i> <span id="likeCount">${post.likeCount}</span> 点赞</span>
          </div>
        </div>

        <div id="content" class="post-content markdown-body">
          <textarea style="display:none;">${post.content}</textarea>
        </div>

        <!-- 点赞按钮初始先设为“点赞”，待页面加载后根据checkLikeStatus接口更新状态 -->
        <button class="btn btn-primary" id="likeButton" onclick="toggleLike(${post.id}, false)">
          <i class="bi bi-heart"></i> 点赞
        </button>

        <button id="collectionButton-${post.id}" class="btn btn-outline-warning collectionButton" data-post-id="${post.id}">
          <i class="bi bi-star"></i> 收藏
        </button>


           <!-- 举报按钮仅对登录用户可见 -->
            <c:if test="${not empty sessionScope.loggedInUser}">
                <button class="btn btn-info ml-2" data-toggle="modal" data-target="#reportModal">
                    <i class="bi bi-flag-fill"></i> 举报
                </button>
            </c:if>

            <c:if test="${empty sessionScope.loggedInUser}">
                <button class="btn btn-info ml-2" onclick="promptLoginToReport()">
                    <i class="bi bi-flag-fill"></i> 举报
                </button>
            </c:if>

        <button class="btn btn-success ml-2" onclick="showCommentForm()">
          <i class="bi bi-chat"></i> 评论
        </button>
        <c:if test="${not empty sessionScope.loggedInUser and sessionScope.loggedInUser.id eq post.userId}">
          <a href="${pageContext.request.contextPath}/post/edit/${post.id}" class="btn btn-warning ml-2">
            <i class="bi bi-pencil"></i> 编辑
          </a>
        </c:if>
      </div>

      <div class="likes-section mt-4">
        <h4>点赞用户列表</h4>
        <ul id="likeUsersList" class="list-group">
          <!-- 点赞用户将通过 JavaScript 动态加载 -->
        </ul>
      </div>

      <!-- 评论区域 -->
      <div class="comment-section">
        <h4>评论列表 (${post.commentCount})</h4>

        <!-- 评论表单 -->
        <div class="comment-form">
          <textarea class="form-control" id="commentContent" rows="3" placeholder="发表评论..."></textarea>
          <button class="btn btn-primary mt-2" onclick="submitComment()">发表评论</button>
        </div>

        <!-- 评论列表部分 -->
        <div id="commentList">
          <c:forEach items="${comments}" var="comment">
            <div class="comment-item" id="comment-${comment.id}">
              <!-- 评论用户信息 -->
              <div class="comment-user">
                <img src="${comment.authorAvatar}" class="comment-avatar" alt="user avatar">
                <div>
                  <span class="font-weight-bold">${comment.authorName}</span>
                  <small class="text-muted ml-2">
                    <fmt:formatDate value="${comment.createTime}" pattern="yyyy-MM-dd HH:mm"/>
                  </small>
                </div>
              </div>

              <!-- 评论内容部分 -->
              <div class="comment-content">
                  ${comment.content}
              </div>

              <!-- 评论操作按钮 -->
              <div class="comment-actions">
                <a href="javascript:void(0)" onclick="likeComment(${comment.id})">
                  <i class="bi bi-heart"></i> 赞(${comment.likeCount})
                </a>
                <a href="javascript:void(0)" onclick="replyComment(${comment.id})">
                  <i class="bi bi-reply"></i> 回复
                </a>
              </div>
            </div>
          </c:forEach>
        </div>
      </div>
    </div>

    <!-- 侧边栏 -->
    <div class="col-md-3">
      <!-- 作者信息卡片 -->
      <!-- 作者信息卡片 -->
      <div class="card mb-3">
        <div class="card-body text-center">
          <c:choose>
            <c:when test="${not empty post.author.profile.avatar}">
              <img src="${post.author.profile.avatar}" class="rounded-circle mb-3"
                   style="width: 80px; height: 80px;" alt="author avatar">
            </c:when>
            <c:otherwise>
              <img src="${pageContext.request.contextPath}/static/upload/avatars/default-avatar.jpg"
                   class="rounded-circle mb-3" style="width: 80px; height: 80px;"
                   alt="default avatar">
            </c:otherwise>
          </c:choose>
          <h5 class="card-title">${post.author.username}</h5>
          <c:if test="${post.author.profile != null && not empty post.author.profile.bio}">
            <p class="card-text">${post.author.profile.bio}</p>
          </c:if>

            <!-- 动态关注按钮 -->
                <!-- 直接在按钮上设置 data-author-id 属性存储作者ID -->
                <button id="followButton" class="btn btn-outline-primary btn-sm"
                        data-author-id="${post.userId}"
                        onclick="toggleFollow(${post.userId})">
                    <i class="bi bi-plus"></i> 关注作者
                </button>

        </div>
      </div>


      <!-- 相关帖子 -->
      <div class="card">
        <div class="card-header">相关帖子</div>
        <div class="card-body">
          <div class="list-group list-group-flush">
            <c:forEach items="${relatedPosts}" var="related">
              <a href="${pageContext.request.contextPath}/post/detail/${related.id}"
                 class="list-group-item list-group-item-action">
                  ${related.title}
              </a>
            </c:forEach>
          </div>
        </div>
      </div>
    </div>
  </div>
</div>

<!-- 回复评论的模态框 -->
<div class="modal fade" id="replyModal">
  <div class="modal-dialog">
    <div class="modal-content">
      <div class="modal-header">
        <h5 class="modal-title">回复评论</h5>
        <button type="button" class="close" data-dismiss="modal">
          <span>&times;</span>
        </button>
      </div>
      <div class="modal-body">
        <input type="hidden" id="replyCommentId">
        <textarea class="form-control" id="replyContent" rows="3"></textarea>
      </div>
      <div class="modal-footer">
        <button type="button" class="btn btn-secondary" data-dismiss="modal">取消</button>
        <button type="button" class="btn btn-primary" onclick="submitReply()">回复</button>
      </div>
    </div>
  </div>
</div>

<!-- 举报模态框 -->
<div class="modal fade" id="reportModal" tabindex="-1" role="dialog" aria-labelledby="reportModalLabel" aria-hidden="true">
    <div class="modal-dialog" role="document">
        <div class="modal-content">
            <div class="modal-header">
                <h5 class="modal-title">举报帖子</h5>
                <button type="button" class="close" data-dismiss="modal" aria-label="关闭">
                    <span aria-hidden="true">&times;</span>
                </button>
            </div>
            <div class="modal-body">
                <form id="reportForm">
                    <input type="hidden" id="postId" name="postId" value="${post.id}">
                    <div class="form-group">
                        <label for="reportType">举报类型</label>
                        <select id="reportType" class="form-control" name="reportTypeId" required>
                            <option value="" disabled selected>请选择举报类型</option>
                            <!-- 举报类型通过 JavaScript 动态加载 -->
                        </select>
                    </div>
                    <div class="form-group">
                        <label for="reportContent">举报内容</label>
                        <textarea id="reportContent" class="form-control" rows="3" placeholder="请描述举报原因" name="content" required minlength="5" maxlength="500"></textarea>
                    </div>
                    <button type="button" class="btn btn-primary" onclick="submitReport()">提交举报</button>
                </form>
            </div>
        </div>
    </div>
</div>


<script src="${pageContext.request.contextPath}/static/js/jquery.min.js"></script>
<script src="${pageContext.request.contextPath}/static/js/bootstrap.min.js"></script>
<script src="${pageContext.request.contextPath}/static/plugins/editor.md/lib/marked.min.js"></script>
<script src="${pageContext.request.contextPath}/static/plugins/editor.md/lib/prettify.min.js"></script>
<script src="${pageContext.request.contextPath}/static/plugins/editor.md/lib/raphael.min.js"></script>
<script src="${pageContext.request.contextPath}/static/plugins/editor.md/lib/underscore.min.js"></script>
<script src="${pageContext.request.contextPath}/static/plugins/editor.md/lib/sequence-diagram.min.js"></script>
<script src="${pageContext.request.contextPath}/static/plugins/editor.md/lib/flowchart.min.js"></script>
<script src="${pageContext.request.contextPath}/static/plugins/editor.md/lib/jquery.flowchart.min.js"></script>
<script src="${pageContext.request.contextPath}/static/plugins/editor.md/editormd.min.js"></script>
<script>
  // 初始化 Markdown 渲染
  $(function() {
    console.log('Initializing Markdown rendering...');

    // 初始化帖子内容的Markdown渲染
    editormd.markdownToHTML("content", {
      htmlDecode: "style,script,iframe",
      emoji: true,
      taskList: true,
      tex: true,
      flowChart: true,
      sequenceDiagram: true,
      previewCodeHighlight: true,
      tocm: true,
      toc: true,
      tocContainer: "",
      tocDropdown: false,
      atLink: true,
      emailLink: true,
      imageLink: true,
      theme: "default",
      mode: "markdown"
    });

    // 初始化所有评论的Markdown渲染
    $('.comment-content').each(function() {
      var $this = $(this);
      var commentId = $this.attr('id');
      if (!commentId) return;

      console.log('Rendering comment:', commentId);

      editormd.markdownToHTML(commentId, {
        htmlDecode: "style,script,iframe",
        emoji: true,
        taskList: true,
        tex: true,
        flowChart: true,
        sequenceDiagram: true,
        previewCodeHighlight: true,
        theme: "default",
        mode: "markdown"
      });
    });

    console.log('Markdown rendering completed');
  });

  // 点赞功能相关
  $(document).ready(function() {
    const postId = ${post.id};
    fetchLikeCount(postId); // 获取点赞数
    fetchLikeUsers(postId); // 获取点赞用户列表
    checkLikeStatus(postId); // 检查用户点赞状态
    loadReportTypes(); // 加载举报类型
  });

  // 检查用户是否点赞该帖
  function checkLikeStatus(postId) {
    $.get('${pageContext.request.contextPath}/likes/check', {postId: postId}, function(res) {
      if(res.code === 200) {
        var isLiked = res.isLiked;
        updateLikeButtonUI(isLiked);
      } else if(res.code === 401) {
        updateLikeButtonUI(false);
      } else {
        alert(res.message || '检查点赞状态失败');
      }
    }).fail(function() {
      alert('检查点赞状态失败，请稍后重试');
    });
  }

  // 根据是否点赞更新按钮UI
  function updateLikeButtonUI(isLiked) {
    var likeButton = $('#likeButton');
    if(isLiked) {
      likeButton.html('<i class="bi bi-heart"></i> 已点赞')
        .removeClass('btn-primary')
        .addClass('btn-danger')
        .attr('onclick', 'toggleLike(' + ${post.id} + ', true)');
    } else {
      likeButton.html('<i class="bi bi-heart"></i> 点赞')
        .removeClass('btn-danger')
        .addClass('btn-primary')
        .attr('onclick', 'toggleLike(' + ${post.id} + ', false)');
    }
  }

  // 点赞帖子
  function likePost(postId) {
    $.ajax({
      url: '${pageContext.request.contextPath}/likes/like',
      type: 'POST',
      data: {
        postId: postId
      },
      success: function(res) {
        if (res.code === 200) {
          $('#likeCount').text(res.likeCount);
          updateLikeButtonUI(true);
          fetchLikeUsers(postId); // 点赞成功后更新点赞用户列表
        } else if (res.code === 401) {
          alert(res.message || '请先登录再点赞');
          window.location.href = '${pageContext.request.contextPath}/login';
        } else {
          alert(res.message || '点赞失败');
        }
      },
      error: function() {
        alert('点赞失败，请稍后重试');
      }
    });
  }

  // 取消点赞
  function unlikePost(postId) {
    $.ajax({
      url: '${pageContext.request.contextPath}/likes/unlike',
      type: 'POST',
      data: {
        postId: postId
      },
      success: function(res) {
        if (res.code === 200) {
          $('#likeCount').text(res.likeCount);
          updateLikeButtonUI(false);
          fetchLikeUsers(postId); // 取消点赞后也更新用户列表
        } else if (res.code === 401) {
          alert(res.message || '请先登录再取消点赞');
          window.location.href = '${pageContext.request.contextPath}/login';
        } else {
          alert(res.message || '取消点赞失败');
        }
      },
      error: function() {
        alert('取消点赞失败，请稍后重试');
      }
    });
  }

  // 切换点赞状态
  function toggleLike(postId, isLiked) {
    if (isLiked) {
      // 已点赞则取消点赞
      unlikePost(postId);
    } else {
      // 未点赞则点赞
      likePost(postId);
    }
  }

  // 动态获取点赞数量
  function fetchLikeCount(postId) {
    $.get('${pageContext.request.contextPath}/likes/count/' + postId, function(res) {
      if (res.code === 200) {
        $('#likeCount').text(res.likeCount);
      } else {
        alert(res.message || '获取点赞数量失败');
      }
    }).fail(function() {
      alert('获取点赞数量失败，请稍后重试');
    });
  }

  // 获取点赞用户列表（用户名）
  function fetchLikeUsers(postId) {
    $.get('${pageContext.request.contextPath}/likes/users/' + postId, function(res) {
      if (res.code === 200) {
        const usersList = $('#likeUsersList');
        usersList.empty();
        if (res.users && res.users.length > 0) {
          res.users.forEach(function(username) {
            usersList.append('<li class="list-group-item">用户名: ' + username + '</li>');
          });
        } else {
          usersList.append('<li class="list-group-item">暂无用户点赞</li>');
        }
      } else {
        alert(res.message || '获取点赞用户失败');
      }
    }).fail(function() {
      alert('获取点赞用户失败，请稍后重试');
    });
  }

  function promptLoginToReport() {
      // 使用confirm询问用户是否跳转到登录页面
      if (confirm('请先登录再举报，点击确定进入登录页面')) {
          // 确认后跳转到登录页面
          window.location.href = '${pageContext.request.contextPath}/login';
      }
  }


   /**
       * 加载举报类型并填充到下拉菜单中
       */
      function loadReportTypes() {
          $.ajax({
              url: '${pageContext.request.contextPath}/reports/types',
              type: 'GET',
              success: function(res) {
                  if(res.code === 200) {
                      const reportTypeSelect = $('#reportType');
                      res.data.forEach(function(type) {
                          reportTypeSelect.append('<option value="' + type.id + '">' + type.typeName + '</option>');
                      });
                  } else {
                      alert('举报类型加载失败，请稍后重试。');
                  }
              },
              error: function() {
                  alert('举报类型加载失败，请稍后重试。');
              }
          });
      }

      /**
         * 提交举报
         */
       function submitReport() {
           const postId = $('#postId').val();
           const reportType = $('#reportType').val();
           const reportContent = $('#reportContent').val();

           if (!reportType || !reportContent) {
               alert('举报类型和内容不能为空！');
               return;
           }

           $.ajax({
               url: '${pageContext.request.contextPath}/reports/report',
               type: 'POST',
               data: {
                   postId: postId,
                   reportTypeId: reportType,
                   content: reportContent
               },
               success: function (res) {
                   if(res.code === 200) {
                       alert('举报提交成功！');
                       $('#reportModal').modal('hide');
                       $('#reportForm')[0].reset();
                   } else if(res.code === 401) {
                       // 用户未登录
                       // 提示用户，然后跳转登录页面
                       if(confirm('请先登录再举报，点击确定进入登录页面')) {
                           window.location.href = '${pageContext.request.contextPath}/login.jsp';
                       }
                   } else {
                       alert(res.message || '举报提交失败，请稍后重试');
                   }
               },
               error: function () {
                   alert('举报提交失败，请稍后重试');
               }
           });
       }

  // 提交评论
  function submitComment() {
    var content = $('#commentContent').val();
    if(!content) {
      alert('请输入评论内容');
      return;
    }

    $.ajax({
      url: '${pageContext.request.contextPath}/comment/create',
      type: 'POST',
      contentType: 'application/json',
      data: JSON.stringify({
        postId: ${post.id},
        content: content
      }),
      success: function(res) {
        if(res.code === 200) {
          alert('评论成功');
          location.reload();
        } else {
          alert(res.message);
        }
      }
    });
  }

  // 回复评论
  function replyComment(commentId) {
    $('#replyCommentId').val(commentId);
    $('#replyModal').modal('show');
  }

  // 提交回复
  function submitReply() {
    var content = $('#replyContent').val();
    if(!content) {
      alert('请输入回复内容');
      return;
    }

    $.ajax({
      url: '${pageContext.request.contextPath}/comment/create',
      type: 'POST',
      contentType: 'application/json',
      data: JSON.stringify({
        postId: ${post.id},
        parentId: $('#replyCommentId').val(),
        content: content
      }),
      success: function(res) {
        if(res.code === 200) {
          alert('回复成功');
          location.reload();
        } else {
          alert(res.message);
        }
      }
    });
  }

  // 点赞评论
  function likeComment(commentId) {
    $.post('${pageContext.request.contextPath}/comment/like/' + commentId, function(res) {
      if(res.code === 200) {
        alert('点赞成功');
        location.reload();
      } else {
        alert(res.message);
      }
    }).fail(function() {
      alert('点赞失败，请稍后重试');
    });
  }

  // 显示评论表单
  function showCommentForm() {
    $('#commentContent').focus();
  }

  // 关注作者（待实现）
 function toggleFollow(authorId) {
     authorId = Number(authorId);
     console.log('当前操作的作者ID:', authorId);

     if (!authorId || isNaN(authorId)) {
         console.error('无效的作者ID');
         alert('无法获取有效的作者ID');
         return;
     }

     const button = document.getElementById('followButton');
     const isFollowing = button.classList.contains('btn-success');

     if (isFollowing) {
        // 删除关注
        fetch('/Forum/api/fan/unfollow?authorId=' + authorId, {
            method: 'DELETE',
            credentials: 'same-origin', // 保持 session 信息
            headers: {
                'Accept': 'application/json',
                'Content-Type': 'application/json'
            }
        })
        .then(response => {
            if (!response.ok) {
                return response.text().then(text => {
                    throw new Error(text || '取消关注失败');
                });
            }
            console.log('取消关注成功');
            button.classList.remove('btn-success');
            button.classList.add('btn-outline-primary');
            button.innerHTML = '<i class="bi bi-plus"></i> 关注作者';
        })
        .catch(err => {
            console.error('取消关注请求失败:', err);
            alert('取消关注失败：' + err.message);
        });

     } else {
         // 添加关注操作
         fetch('/Forum/api/fan/follow', {
             method: 'POST',
             headers: { 'Content-Type': 'application/json' },
             body: JSON.stringify({ authorId: authorId }),
             credentials: 'same-origin'
         })
         .then(response => {
             if (response.status === 401) {
                 alert('请先登录再操作');
                 window.location.href = '/Forum/login';
                 return;
             }
             if (!response.ok) {
                 return response.text().then(text => {
                     throw new Error(text || '关注失败');
                 });
             }
             console.log('成功关注作者');
             button.classList.remove('btn-outline-primary');
             button.classList.add('btn-success');
             button.innerHTML = '<i class="bi bi-check"></i> 已关注';
         })
         .catch(err => {
             console.error('关注错误:', err);
             alert(err.message || '关注时发生错误');
         });
     }
 }


    document.addEventListener('DOMContentLoaded', function() {
        const button = document.getElementById('followButton');

        if (!button) {
            console.error('没有找到 id 为 "followButton" 的按钮');
            return;
        }

        const authorId = button.getAttribute('data-author-id');
        if (!authorId) {
            console.error('按钮缺少 data-author-id 属性');
            return;
        }

        // 检查关注状态
        fetch(`/Forum/api/fan/isFollowing?authorId=${authorId}`, {
            credentials: 'same-origin'
        })
        .then(response => {
            console.log('响应状态:', response.status);
            console.log('响应头 Content-Type:', response.headers.get('Content-Type'));
            if (!response.ok) {
                throw new Error(`HTTP error! 状态码: ${response.status}`);
            }
            return response.json();
        })
        .then(isFollowingData => {
            console.log('接收到的响应数据:', isFollowingData);

            const isFollowing = isFollowingData.isFollowing;  // 获取关注状态

            console.log('接收到的 isFollowing 值:', isFollowing, '类型:', typeof isFollowing);

            // 确保 isFollowing 是布尔值
            const isFollowingBool = Boolean(isFollowing);

            console.log('转换后的 isFollowingBool:', isFollowingBool);

            if (isFollowingBool) {
                button.classList.remove('btn-outline-primary');
                button.classList.add('btn-success');
                button.innerHTML = '<i class="bi bi-check"></i> 已关注';
            } else {
                // 如果未关注，设置为“关注”状态
                button.classList.remove('btn-success');
                button.classList.add('btn-outline-primary');
                button.innerHTML = '<i class="bi bi-plus"></i> 关注';
            }
            console.log('初始关注状态 (布尔值):', isFollowingBool);
        })
        .catch(err => console.error('检查关注状态失败:', err));
    });




/**
 * 切换收藏状态
 * @param {number} postId - 帖子ID
 * @param {boolean} initialLoad - 是否为初始化加载
 */
// 检查用户是否收藏该帖
 // 检查用户是否收藏该帖
 var contextPath = '${pageContext.request.contextPath}';
   function checkCollectionStatus(postId) {
     $.get(contextPath + '/api/collection/isCollected', { postId: postId }, function(res) {
       if (res.isCollected !== undefined) {
         updateCollectionButtonUI(postId, res.isCollected);
       } else {
         alert('检查收藏状态失败');
       }
     }).fail(function() {
       alert('检查收藏状态失败，请稍后重试');
     });
   }

   // 根据是否收藏更新按钮UI
   function updateCollectionButtonUI(postId, isCollected) {
     var collectionButton = $('#collectionButton-' + postId);
     if (isCollected) {
       collectionButton.html('<i class="bi bi-star-fill"></i> 已收藏')
         .removeClass('btn-outline-warning')
         .addClass('btn-warning')
         .attr('onclick', 'toggleCollection(' + postId + ', true)');
     } else {
       collectionButton.html('<i class="bi bi-star"></i> 收藏')
         .removeClass('btn-warning')
         .addClass('btn-outline-warning')
         .attr('onclick', 'toggleCollection(' + postId + ', false)');
     }
   }

   // 收藏帖子
  // 收藏帖子
  // 收藏帖子
 function collectPost(postId) {
     $.ajax({
         url: '${pageContext.request.contextPath}/api/collection/add',
         type: 'POST',
         contentType: 'application/json',
         data: JSON.stringify({ postId: postId }),
         success: function(res) {
             if (res.code === 200) {
                 $('#collectionCount-' + postId).text(res.collectionCount);
                 updateCollectionButtonUI(postId, true);

                 alert(res.message); // 显示 "收藏成功"
             } else {
                 alert(res.message || '收藏失败');
             }
         },
         error: function(xhr, status, error) {
             console.error("收藏失败:", xhr, status, error);
             // 判断是 401 错误并处理
             if (xhr.status === 401) {
                 alert('请先登录再收藏');
                 window.location.href = '${pageContext.request.contextPath}/login';
             } else {
                 alert('收藏失败，请稍后重试');
             }
         }
     });
 }



  // 取消收藏
 // 取消收藏
 function uncollectPost(postId) {
     $.ajax({
         url: '${pageContext.request.contextPath}/api/collection/remove?postId=' + postId,
         type: 'DELETE',
         success: function(res) {
             if (res.code === 200) {
                 $('#collectionCount-' + postId).text(res.collectionCount);
                 updateCollectionButtonUI(postId, false);

                 alert(res.message); // 显示 "取消收藏成功"
             } else if (res.code === 401) {
                 alert(res.message || '请先登录再取消收藏');
                 window.location.href = '${pageContext.request.contextPath}/login';
             } else {
                 alert(res.message || '取消收藏失败');
             }
         },
         error: function(xhr, status, error) {
             console.error("取消收藏失败:", xhr, status, error);
             alert('取消收藏失败，请稍后重试');
         }
     });
 }




   // 切换收藏状态
   function toggleCollection(postId, isCollected) {
     if (isCollected) {
       // 已收藏则取消收藏
       uncollectPost(postId);
     } else {
       // 未收藏则收藏
       collectPost(postId);
     }
   }

   // 动态获取收藏数量
   function fetchCollectionCount(postId) {
     $.get('${pageContext.request.contextPath}/api/collection/count', { postId: postId }, function(res) {
       if (res.code === 200) {
         $('#collectionCount-' + postId).text(res.count);
       } else {
         alert(res.message || '获取收藏数量失败');
       }
     }).fail(function() {
       alert('获取收藏数量失败，请稍后重试');
     });
   }



   // 页面加载时检查所有帖子是否已收藏
   document.addEventListener('DOMContentLoaded', function () {
     const collectionButtons = document.querySelectorAll('.collectionButton');
     collectionButtons.forEach(button => {
       const postId = button.getAttribute('data-post-id');
       if (postId) {
         checkCollectionStatus(postId); // 初始化收藏按钮状态
       }
     });
   });
</script>
</body>
</html>
