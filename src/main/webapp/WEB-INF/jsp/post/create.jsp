<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core"%>
<!DOCTYPE html>
<html>
<head>
  <title>发布帖子</title>
  <link href="https://cdn.jsdelivr.net/npm/bootstrap-icons@1.7.2/font/bootstrap-icons.css" rel="stylesheet">
  <link href="${pageContext.request.contextPath}/static/css/bootstrap.min.css" rel="stylesheet">
  <link href="${pageContext.request.contextPath}/static/plugins/editor.md/css/editormd.min.css" rel="stylesheet">
  <style>
    .form-container {
      background: #fff;
      padding: 20px;
      border-radius: 4px;
      box-shadow: 0 1px 3px rgba(0,0,0,0.1);
    }
    .preview-image {
      max-width: 200px;
      margin-top: 10px;
    }
    .tips-card {
      background: #f8f9fa;
      padding: 15px;
      border-radius: 4px;
      margin-bottom: 15px;
    }
    .tips-title {
      font-weight: bold;
      margin-bottom: 10px;
    }
    .required-mark {
      color: red;
      margin-left: 3px;
    }
    #editor {
      margin-bottom: 20px;
      z-index: 1000;
    }
    .char-count {
      margin-top: 5px;
      color: #6c757d;
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
<div class="container mt-4">
  <div class="row">
    <div class="col-md-9">
      <div class="form-container">
        <h3>发布帖子</h3>
        <hr>

        <!-- 提示信息 -->
        <div class="tips-card">
          <div class="tips-title"><i class="bi bi-info-circle"></i> 发帖提示</div>
          <ul class="mb-0">
            <li>标题应简明扼要，不超过200字符</li>
            <li>正文支持Markdown格式，可以插入图片</li>
            <li>请遵守社区规范，文明发帖</li>
          </ul>
        </div>

        <form id="postForm" onsubmit="return submitPost()">
          <!-- 标题 -->
          <div class="form-group">
            <label>标题<span class="required-mark">*</span></label>
            <input type="text" class="form-control" name="title"
                   required maxlength="200"
                   placeholder="请输入帖子标题，简明扼要">
            <div class="invalid-feedback">请输入标题</div>
            <div class="char-count">还可以输入<span id="titleCount">200</span>字</div>
          </div>

          <!-- 分类 -->
          <div class="form-group">
            <label>分类<span class="required-mark">*</span></label>
            <select class="form-control" name="categoryId" required>
              <option value="">请选择分类</option>
              <c:forEach items="${categories}" var="category">
                <option value="${category.id}">${category.name}</option>
              </c:forEach>
            </select>
            <div class="invalid-feedback">请选择分类</div>
          </div>

          <!-- 正文 -->
          <div class="form-group">
            <label>正文<span class="required-mark">*</span></label>
            <div id="editor">
              <textarea style="display:none;"></textarea>
            </div>
            <div class="invalid-feedback">请输入正文内容</div>
          </div>

          <!-- 摘要 -->
          <div class="form-group">
            <label>摘要</label>
            <textarea class="form-control" name="summary" rows="3"
                      maxlength="500"
                      placeholder="请输入帖子摘要，如不填写将自动提取正文前500字"></textarea>
            <div class="char-count">还可以输入<span id="summaryCount">500</span>字</div>
          </div>

          <div class="form-group">
            <button type="submit" class="btn btn-primary" id="submitBtn">
              <span class="spinner-border spinner-border-sm d-none" role="status" id="submitSpinner"></span>
              <i class="bi bi-send"></i> 发布帖子
            </button>
            <button type="button" class="btn btn-secondary ml-2" onclick="saveDraft()">
              <i class="bi bi-save"></i> 保存草稿
            </button>
            <button type="button" class="btn btn-light ml-2" onclick="history.back()">
              <i class="bi bi-arrow-left"></i> 返回
            </button>
          </div>
        </form>
      </div>
    </div>

    <!-- 右侧帮助信息 -->
    <div class="col-md-3">
      <div class="card">
        <div class="card-header">
          <i class="bi bi-markdown"></i> Markdown语法帮助
        </div>
        <div class="card-body">
          <p># 一级标题</p>
          <p>## 二级标题</p>
          <p>**加粗文字**</p>
          <p>*斜体文字*</p>
          <p>[链接文字](URL)</p>
          <p>![图片描述](图片URL)</p>
          <p>- 无序列表项</p>
          <p>1. 有序列表项</p>
          <p>```代码块```</p>
          <a href="https://www.markdown.xyz/basic-syntax/" target="_blank"
             class="btn btn-sm btn-info">
            查看完整语法
          </a>
        </div>
      </div>
    </div>
  </div>
</div>

<script src="${pageContext.request.contextPath}/static/js/jquery.min.js"></script>
<script src="${pageContext.request.contextPath}/static/js/bootstrap.bundle.min.js"></script>
<script src="${pageContext.request.contextPath}/static/plugins/editor.md/editormd.min.js"></script>
<script>
  var editor;

  $(function() {
    // 初始化Markdown编辑器
    editor = editormd("editor", {
      width: "100%",
      height: 500,
      path: "${pageContext.request.contextPath}/static/plugins/editor.md/lib/",
      placeholder: "请输入帖子正文，支持Markdown格式...",
      emoji: true,
      taskList: true,
      tex: true,
      tocm: true,
      flowChart: true,
      sequenceDiagram: true,
      htmlDecode: "style,script,iframe|on*",
      saveHTMLToTextarea: true,
      imageUpload: true,
      imageFormats: ["jpg", "jpeg", "gif", "png", "bmp", "webp"],
      imageUploadURL: "${pageContext.request.contextPath}/post/upload",
      toolbarIcons: function() {
        return [
          "undo", "redo", "|",
          "bold", "italic", "quote", "uppercase", "lowercase", "|",
          "h1", "h2", "h3", "h4", "h5", "h6", "|",
          "list-ul", "list-ol", "hr", "|",
          "link", "image", "code", "preformatted-text", "code-block",
          "table", "|",
          "watch", "preview", "fullscreen", "|",
          "help"
        ]
      }
    });

    // 添加字数统计功能
    $('input[name="title"]').on('input', function() {
      var remaining = 200 - $(this).val().length;
      $('#titleCount').text(remaining);
    });

    $('textarea[name="summary"]').on('input', function() {
      var remaining = 500 - $(this).val().length;
      $('#summaryCount').text(remaining);
    });
  });

  // 表单验证
  function validateForm() {
    var isValid = true;

    var title = $('input[name="title"]').val();
    if(!title) {
      showError('title', '请输入标题');
      isValid = false;
    }

    var categoryId = $('select[name="categoryId"]').val();
    if(!categoryId) {
      showError('categoryId', '请选择分类');
      isValid = false;
    }

    var content = editor.getMarkdown();
    if(!content) {
      alert('请输入正文内容');
      isValid = false;
    }

    return isValid;
  }

  // 显示错误信息
  function showError(field, message) {
    var input = $('[name="' + field + '"]');
    input.addClass('is-invalid');
    input.next('.invalid-feedback').text(message);
  }

  // 清除错误信息
  function clearError(field) {
    var input = $('[name="' + field + '"]');
    input.removeClass('is-invalid');
  }

  // 显示加载状态
  function setLoading(loading) {
    var btn = $('#submitBtn');
    var spinner = $('#submitSpinner');
    if(loading) {
      btn.prop('disabled', true);
      spinner.removeClass('d-none');
    } else {
      btn.prop('disabled', false);
      spinner.addClass('d-none');
    }
  }

  // 提交帖子
  function submitPost() {
    if(!validateForm()) {
      return false;
    }

    setLoading(true);

    // 构建JSON数据
    var postData = {
      title: $('input[name="title"]').val(),
      categoryId: $('select[name="categoryId"]').val(),
      content: editor.getMarkdown(),
      summary: $('textarea[name="summary"]').val()
    };

    $.ajax({
      url: '${pageContext.request.contextPath}/post/create',
      type: 'POST',
      data: JSON.stringify(postData),
      contentType: 'application/json',
      success: function(res) {
        setLoading(false);
        if(res.code === 200) {
          alert('发布成功');
          location.href = '${pageContext.request.contextPath}/post/detail/' + res.data.id;
        } else {
          alert(res.message || '发布失败');
        }
      },
      error: function() {
        setLoading(false);
        alert('发布失败，请稍后重试');
      }
    });

    return false;
  }

  // 保存草稿
  function saveDraft() {
    var postData = {
      title: $('input[name="title"]').val(),
      categoryId: $('select[name="categoryId"]').val(),
      content: editor.getMarkdown(),
      summary: $('textarea[name="summary"]').val(),
      status: 0
    };

    $.ajax({
      url: '${pageContext.request.contextPath}/post/draft',
      type: 'POST',
      data: JSON.stringify(postData),
      contentType: 'application/json',
      success: function(res) {
        if(res.code === 200) {
          alert('草稿保存成功');
        } else {
          alert(res.message || '保存失败');
        }
      },
      error: function() {
        alert('保存失败，请稍后重试');
      }
    });
  }

  // 监听输入事件，清除错误提示
  $('input, select').on('input', function() {
    clearError($(this).attr('name'));
  });
</script>
</body>
</html>