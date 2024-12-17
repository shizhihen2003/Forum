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
  </style>
</head>

<body>

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

        <button class="btn btn-info ml-2" data-toggle="modal" data-target="#reportModal">
          <i class="bi bi-star"></i> 举报
        </button>

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
          <c:if test="${not empty sessionScope.loggedInUser and sessionScope.loggedInUser.id ne post.userId}">
            <button class="btn btn-outline-primary btn-sm" onclick="followAuthor(${post.userId})">
              <i class="bi bi-plus"></i> 关注作者
            </button>
          </c:if>
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
<div class="modal fade" id="reportModal">
    <div class="modal-dialog">
        <div class="modal-content">
            <div class="modal-header">
                <h5 class="modal-title">举报帖子</h5>
                <button type="button" class="close" data-dismiss="modal">
                    <span>&times;</span>
                </button>
            </div>
            <div class="modal-body">
                <form id="reportForm">
                    <input type="hidden" id="postId" value="${post.id}">
                    <div class="form-group">
                        <label for="reportType">举报类型</label>
                        <select id="reportType" class="form-control">
                            <!-- 举报类型通过js动态加载 -->
                        </select>
                    </div>
                    <div class="form-group">
                        <label for="reportContent">举报内容</label>
                        <textarea id="reportContent" class="form-control" rows="3" placeholder="请描述举报原因"></textarea>
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

  // 加载举报类型
  function loadReportTypes() {
    $.get("${pageContext.request.contextPath}/reports/types", function (res) {
      if (res.code === 200) {
        const reportTypeSelect = $('#reportType');
        res.data.forEach(function (type) {
          reportTypeSelect.append('<option value="' + type + '">' + type + '</option>');
        });
      } else {
        alert(res.message || '举报类型加载失败');
      }
    }).fail(function () {
      alert('举报类型加载失败，请稍后重试');
    });
  }

  // 提交举报
  function submitReport() {
      const postId = ${post.id};
      const reportType = $('#reportType').val();
      const reportContent = $('#reportContent').val();

      if (!reportType || !reportContent) {
          alert('举报类型和内容不能为空！');
          return;
      }

      $.ajax({
          url: '${pageContext.request.contextPath}/reports',
          type: 'POST',
          contentType: 'application/json',
          data: JSON.stringify({
              postId: postId,
              type: reportType,
              content: reportContent
          }),
          success: function (res) {
              if(res.code === 200) {
                  alert('举报提交成功！');
                  $('#reportModal').modal('hide');
              } else {
                  alert('举报提交失败，请稍后重试');
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
  function followAuthor() {
    alert('关注功能开发中...');
  }
</script>
</body>
</html>
