<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core"%>
<%@ taglib prefix="fmt" uri="http://java.sun.com/jsp/jstl/fmt"%>
<!DOCTYPE html>
<html>
<head>
  <title>${post.title}</title>
  <link href="${pageContext.request.contextPath}/static/css/bootstrap.min.css" rel="stylesheet">
  <link href="${pageContext.request.contextPath}/static/plugins/editor.md/css/editormd.min.css" rel="stylesheet">
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
<div class="container mt-4">
  <div class="row">
    <!-- 主内容区 -->
    <div class="col-md-9">
      <!-- 帖子内容 -->
      <div class="post-container">
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
            <span><i class="bi bi-person"></i> ${post.authorName}</span>
            <span class="ml-3"><i class="bi bi-folder"></i> ${post.categoryName}</span>
            <span class="ml-3">
                            <i class="bi bi-clock"></i>
                            <fmt:formatDate value="${post.createTime}" pattern="yyyy-MM-dd HH:mm"/>
                        </span>
            <span class="ml-3"><i class="bi bi-eye"></i> ${post.viewCount} 浏览</span>
            <span class="ml-3"><i class="bi bi-chat"></i> ${post.commentCount} 评论</span>
            <span class="ml-3"><i class="bi bi-heart"></i> ${post.likeCount} 点赞</span>
          </div>
        </div>

        <div id="content" class="post-content markdown-body">
          <textarea style="display:none;">${post.content}</textarea>
        </div>

        <div class="post-actions">
          <button class="btn btn-primary" onclick="likePost()">
            <i class="bi bi-heart"></i> 点赞
          </button>
          <button class="btn btn-info ml-2">
            <i class="bi bi-star"></i> 收藏
          </button>
          <button class="btn btn-success ml-2" onclick="showCommentForm()">
            <i class="bi bi-chat"></i> 评论
          </button>
          <c:if test="${sessionScope.user.id eq post.userId}">
            <a href="${pageContext.request.contextPath}/post/edit/${post.id}" class="btn btn-warning ml-2">
              <i class="bi bi-pencil"></i> 编辑
            </a>
          </c:if>
        </div>
      </div>
      <!-- 评论区域 -->
      <div class="comment-section">
        <h4>评论列表 (${post.commentCount})</h4>

        <!-- 评论表单 -->
        <div class="comment-form">
          <textarea class="form-control" id="commentContent" rows="3" placeholder="发表评论..."></textarea>
          <button class="btn btn-primary mt-2" onclick="submitComment()">发表评论</button>
        </div>

        <!-- 评论列表 -->
        <div id="commentList">
          <c:forEach items="${comments}" var="comment">
            <div class="comment-item" id="comment-${comment.id}">
              <div class="comment-user">
                <img src="${comment.authorAvatar}" class="comment-avatar" alt="user avatar">
                <div>
                  <span class="font-weight-bold">${comment.authorName}</span>
                  <small class="text-muted ml-2">
                    <fmt:formatDate value="${comment.createTime}" pattern="yyyy-MM-dd HH:mm"/>
                  </small>
                </div>
              </div>
              <div id="comment-content-${comment.id}" class="comment-content markdown-body">
                <textarea style="display:none;">${comment.content}</textarea>
              </div>
              <div class="comment-actions">
                <a href="javascript:void(0)" onclick="likeComment(${comment.id})">
                  <i class="bi bi-heart"></i> 赞(${comment.likeCount})
                </a>
                <a href="javascript:void(0)" onclick="replyComment(${comment.id})">
                  <i class="bi bi-reply"></i> 回复
                </a>
              </div>

              <!-- 评论回复列表 -->
              <c:if test="${not empty comment.children}">
                <div class="comment-replies">
                  <c:forEach items="${comment.children}" var="reply">
                    <div class="comment-reply">
                      <div class="comment-user">
                        <img src="${reply.authorAvatar}" class="comment-avatar" alt="user avatar">
                        <div>
                          <span class="font-weight-bold">${reply.authorName}</span>
                          <small class="text-muted ml-2">
                            <fmt:formatDate value="${reply.createTime}" pattern="yyyy-MM-dd HH:mm"/>
                          </small>
                        </div>
                      </div>
                      <div id="comment-content-${reply.id}" class="comment-content markdown-body">
                        <textarea style="display:none;">${reply.content}</textarea>
                      </div>
                      <div class="comment-actions">
                        <a href="javascript:void(0)" onclick="likeComment(${reply.id})">
                          <i class="bi bi-heart"></i> 赞(${reply.likeCount})
                        </a>
                        <a href="javascript:void(0)" onclick="replyComment(${reply.id})">
                          <i class="bi bi-reply"></i> 回复
                        </a>
                      </div>
                    </div>
                  </c:forEach>
                </div>
              </c:if>
            </div>
          </c:forEach>
        </div>
      </div>
    </div>

    <!-- 侧边栏 -->
    <div class="col-md-3">
      <!-- 作者信息 -->
      <div class="card mb-3">
        <div class="card-body text-center">
          <img src="${post.authorAvatar}" class="rounded-circle mb-3" style="width: 80px; height: 80px;" alt="author avatar">
          <h5 class="card-title">${post.authorName}</h5>
          <button class="btn btn-outline-primary btn-sm" onclick="followAuthor()">
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

<!-- 基础脚本 -->
<script src="${pageContext.request.contextPath}/static/js/jquery.min.js"></script>
<script src="${pageContext.request.contextPath}/static/js/bootstrap.min.js"></script>

<!-- Editor.md 相关脚本 -->
<script src="${pageContext.request.contextPath}/static/plugins/editor.md/lib/marked.min.js"></script>
<script src="${pageContext.request.contextPath}/static/plugins/editor.md/lib/prettify.min.js"></script>
<script src="${pageContext.request.contextPath}/static/plugins/editor.md/lib/raphael.min.js"></script>
<script src="${pageContext.request.contextPath}/static/plugins/editor.md/lib/underscore.min.js"></script>
<script src="${pageContext.request.contextPath}/static/plugins/editor.md/lib/sequence-diagram.min.js"></script>
<script src="${pageContext.request.contextPath}/static/plugins/editor.md/lib/flowchart.min.js"></script>
<script src="${pageContext.request.contextPath}/static/plugins/editor.md/lib/jquery.flowchart.min.js"></script>
<script src="${pageContext.request.contextPath}/static/plugins/editor.md/editormd.min.js"></script>

<script>
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

  // 点赞帖子
  function likePost() {
    $.post('${pageContext.request.contextPath}/post/like/${post.id}', function(res) {
      if(res.code === 200) {
        alert('点赞成功');
        location.reload();
      } else {
        alert(res.message);
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
    });
  }

  // 显示评论表单
  function showCommentForm() {
    $('#commentContent').focus();
  }

  // 关注作者
  function followAuthor() {
    alert('关注功能开发中...');
  }
</script>
</body>
</html>