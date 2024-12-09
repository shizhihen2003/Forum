<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core"%>
<!DOCTYPE html>
<html>
<head>
  <title>发布帖子</title>
  <link href="${pageContext.request.contextPath}/static/css/bootstrap.min.css" rel="stylesheet">
  <link href="${pageContext.request.contextPath}/static/css/editor.md.min.css" rel="stylesheet">
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
  </style>
</head>
<body>
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
            <input type="hidden" name="content">
            <div class="invalid-feedback">请输入正文内容</div>
          </div>

          <!-- 摘要 -->
          <div class="form-group">
            <label>摘要</label>
            <textarea class="form-control" name="summary" rows="3"
                      maxlength="500"
                      placeholder="请输入帖子摘要，如不填写将自动提取正文前500字"></textarea>
            <small class="text-muted">摘要长度不超过500字符</small>
          </div>

          <div class="form-group">
            <button type="submit" class="btn btn-primary">
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
<script src="${pageContext.request.contextPath}/static/js/bootstrap.min.js"></script>
<script src="${pageContext.request.contextPath}/static/js/editor.md.min.js"></script>
<script>
  var editor;

  $(function() {
    // 初始化Markdown编辑器
    editor = editormd("editor", {
      width: "100%",
      height: 500,
      path: "${pageContext.request.contextPath}/static/lib/",
      placeholder: "请输入帖子正文，支持Markdown格式...",
      emoji: true,
      taskList: true,
      tex: true,
      flowChart: true,
      sequenceDiagram: true,
      saveHTMLToTextarea: true,
      imageUpload: true,
      imageFormats: ["jpg", "jpeg", "gif", "png", "bmp", "webp"],
      imageUploadURL: "${pageContext.request.contextPath}/api/upload/image",
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
  });

  // 表单验证
  function validateForm() {
    var title = $('input[name="title"]').val();
    if(!title) {
      showError('title', '请输入标题');
      return false;
    }

    var categoryId = $('select[name="categoryId"]').val();
    if(!categoryId) {
      showError('categoryId', '请选择分类');
      return false;
    }

    var content = editor.getMarkdown();
    if(!content) {
      alert('请输入正文内容');
      return false;
    }

    return true;
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

  // 提交帖子
  function submitPost() {
    if(!validateForm()) {
      return false;
    }

    var formData = new FormData(document.getElementById('postForm'));
    formData.set('content', editor.getMarkdown());

    $.ajax({
      url: '${pageContext.request.contextPath}/post/create',
      type: 'POST',
      data: formData,
      processData: false,
      contentType: false,
      success: function(res) {
        if(res.code === 200) {
          alert('发布成功');
          location.href = '${pageContext.request.contextPath}/post/detail/' + res.data.id;
        } else {
          alert(res.message);
        }
      }
    });

    return false;
  }

  // 保存草稿
  function saveDraft() {
    var formData = new FormData(document.getElementById('postForm'));
    formData.set('content', editor.getMarkdown());
    formData.set('status', 0);  // 草稿状态

    $.ajax({
      url: '${pageContext.request.contextPath}/post/draft',
      type: 'POST',
      data: formData,
      processData: false,
      contentType: false,
      success: function(res) {
        if(res.code === 200) {
          alert('草稿保存成功');
        } else {
          alert(res.message);
        }
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