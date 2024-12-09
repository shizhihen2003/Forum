<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core"%>
<%@ taglib prefix="fmt" uri="http://java.sun.com/jsp/jstl/fmt"%>
<!DOCTYPE html>
<html>
<head>
  <title>评论管理</title>
  <link href="/Forum/static/css/bootstrap.min.css" rel="stylesheet">
  <link href="/Forum/static/css/font-awesome.min.css" rel="stylesheet">
  <style>
    .search-box {
      background: #f8f9fa;
      padding: 15px;
      margin-bottom: 20px;
      border-radius: 4px;
    }
    .comment-content {
      max-width: 300px;
      overflow: hidden;
      text-overflow: ellipsis;
      white-space: nowrap;
    }
    .action-buttons .btn {
      padding: 2px 8px;
      margin: 0 2px;
    }
    .status-badge {
      padding: 3px 8px;
      border-radius: 12px;
      font-size: 12px;
      color: #fff;
    }
    .status-pending { background: #ffc107; }
    .status-approved { background: #28a745; }
    .status-rejected { background: #dc3545; }
    .status-deleted { background: #6c757d; }
    .table td { vertical-align: middle; }
  </style>
</head>
<body>
<div class="container-fluid mt-4">
  <h2>评论管理</h2>

  <!-- 搜索区域 -->
  <div class="search-box">
    <form id="searchForm" class="form-inline">
      <select class="form-control mr-2" name="status">
        <option value="">全部状态</option>
        <option value="0">待审核</option>
        <option value="1">已通过</option>
        <option value="2">已拒绝</option>
        <option value="3">已删除</option>
      </select>
      <input type="text" class="form-control mr-2" name="keyword" placeholder="评论内容">
      <input type="text" class="form-control mr-2" name="postTitle" placeholder="帖子标题">
      <button type="button" class="btn btn-primary" onclick="searchComments()">搜索</button>
      <button type="button" class="btn btn-secondary ml-2" onclick="resetSearch()">重置</button>
    </form>
  </div>

  <!-- 工具栏 -->
  <div class="mb-3">
    <button class="btn btn-success" onclick="batchAudit(1)">
      <i class="fa fa-check"></i> 批量通过
    </button>
    <button class="btn btn-danger ml-2" onclick="batchAudit(2)">
      <i class="fa fa-times"></i> 批量拒绝
    </button>
    <button class="btn btn-danger ml-2" onclick="batchDelete()">
      <i class="fa fa-trash"></i> 批量删除
    </button>
  </div>

  <!-- 评论列表 -->
  <table class="table table-bordered table-hover">
    <thead>
    <tr>
      <th width="40">
        <input type="checkbox" id="checkAll" onclick="toggleCheckAll(this)">
      </th>
      <th>ID</th>
      <th width="300">评论内容</th>
      <th>所属帖子</th>
      <th>评论用户</th>
      <th>状态</th>
      <th>评论时间</th>
      <th>操作</th>
    </tr>
    </thead>
    <tbody id="commentList">
    <!-- 评论数据将通过AJAX加载 -->
    </tbody>
  </table>

  <!-- 分页 -->
  <nav aria-label="Page navigation">
    <ul class="pagination justify-content-end" id="pagination">
      <!-- 分页将通过AJAX加载 -->
    </ul>
  </nav>
</div>

<!-- 审核模态框 -->
<div class="modal fade" id="auditModal">
  <div class="modal-dialog">
    <div class="modal-content">
      <div class="modal-header">
        <h5 class="modal-title">评论审核</h5>
        <button type="button" class="close" data-dismiss="modal">
          <span>&times;</span>
        </button>
      </div>
      <div class="modal-body">
        <form id="auditForm">
          <input type="hidden" name="commentId">
          <input type="hidden" name="status">
          <div class="form-group">
            <label>审核意见</label>
            <textarea class="form-control" name="reason" rows="3"></textarea>
          </div>
        </form>
      </div>
      <div class="modal-footer">
        <button type="button" class="btn btn-secondary" data-dismiss="modal">取消</button>
        <button type="button" class="btn btn-primary" onclick="submitAudit()">确定</button>
      </div>
    </div>
  </div>
</div>

<script src="/Forum/static/js/jquery.min.js"></script>
<script src="/Forum/static/js/bootstrap.min.js"></script>
<script>
  // 页面加载完成后加载数据
  $(function() {
    loadComments(1);
  });

  // 加载评论列表
  function loadComments(page) {
    var params = $('#searchForm').serialize();
    if(page) {
      params += '&page=' + page;
    }

    $.get('/Forum/admin/content/comments/list?' + params, function(res) {
      if(res.code === 200) {
        renderComments(res.data.list);
        renderPagination(res.data);
      } else {
        alert(res.message);
      }
    });
  }

  // 渲染评论列表
  function renderComments(comments) {
    var html = '';
    comments.forEach(function(comment) {
      html += '<tr>';
      html += '<td><input type="checkbox" name="commentIds" value="' + comment.id + '"></td>';
      html += '<td>' + comment.id + '</td>';
      html += '<td class="comment-content">' + comment.content + '</td>';
      html += '<td><a href="/Forum/post/' + comment.postId + '" target="_blank">' +
              comment.postTitle + '</a></td>';
      html += '<td>' + comment.authorName + '</td>';
      html += '<td>' + getStatusBadge(comment.status) + '</td>';
      html += '<td>' + formatDate(comment.createTime) + '</td>';
      html += '<td class="action-buttons">';
      if(comment.status === 0) {
        html += '<button class="btn btn-success btn-sm" onclick="auditComment(' +
                comment.id + ', 1)">通过</button>';
        html += '<button class="btn btn-danger btn-sm ml-1" onclick="auditComment(' +
                comment.id + ', 2)">拒绝</button>';
      }
      html += '<button class="btn btn-danger btn-sm ml-1" onclick="deleteComment(' +
              comment.id + ')">删除</button>';
      html += '</td>';
      html += '</tr>';
    });
    $('#commentList').html(html);
  }

  // 渲染分页
  function renderPagination(data) {
    var html = '';
    if(data.hasPrevious) {
      html += '<li class="page-item">';
      html += '<a class="page-link" href="javascript:void(0)" onclick="loadComments(' +
              (data.current - 1) + ')">上一页</a>';
      html += '</li>';
    }

    for(var i = 1; i <= data.pages; i++) {
      html += '<li class="page-item ' + (i === data.current ? 'active' : '') + '">';
      html += '<a class="page-link" href="javascript:void(0)" onclick="loadComments(' +
              i + ')">' + i + '</a>';
      html += '</li>';
    }

    if(data.hasNext) {
      html += '<li class="page-item">';
      html += '<a class="page-link" href="javascript:void(0)" onclick="loadComments(' +
              (data.current + 1) + ')">下一页</a>';
      html += '</li>';
    }

    $('#pagination').html(html);
  }

  // 搜索评论
  function searchComments() {
    loadComments(1);
  }

  // 重置搜索
  function resetSearch() {
    $('#searchForm')[0].reset();
    searchComments();
  }

  // 获取状态标签
  function getStatusBadge(status) {
    var className = '';
    var text = '';
    switch(status) {
      case 0:
        className = 'status-pending';
        text = '待审核';
        break;
      case 1:
        className = 'status-approved';
        text = '已通过';
        break;
      case 2:
        className = 'status-rejected';
        text = '已拒绝';
        break;
      case 3:
        className = 'status-deleted';
        text = '已删除';
        break;
    }
    return '<span class="status-badge ' + className + '">' + text + '</span>';
  }

  // 全选/取消全选
  function toggleCheckAll(checkbox) {
    $('input[name="commentIds"]').prop('checked', checkbox.checked);
  }

  // 批量审核
  function batchAudit(status) {
    var ids = getSelectedIds();
    if(ids.length === 0) {
      alert('请选择要审核的评论');
      return;
    }

    $('#auditForm input[name="commentId"]').val(ids.join(','));
    $('#auditForm input[name="status"]').val(status);
    $('#auditModal').modal('show');
  }

  // 批量删除
  function batchDelete() {
    var ids = getSelectedIds();
    if(ids.length === 0) {
      alert('请选择要删除的评论');
      return;
    }

    if(confirm('确定要删除选中的评论吗？')) {
      $.ajax({
        url: '/Forum/admin/content/comment/delete/batch',
        type: 'POST',
        contentType: 'application/json',
        data: JSON.stringify(ids),
        success: function(res) {
          if(res.code === 200) {
            alert('删除成功');
            loadComments(1);
          } else {
            alert(res.message);
          }
        }
      });
    }
  }

  // 获取选中的评论ID
  function getSelectedIds() {
    var ids = [];
    $('input[name="commentIds"]:checked').each(function() {
      ids.push($(this).val());
    });
    return ids;
  }

  // 审核单条评论
  function auditComment(id, status) {
    $('#auditForm input[name="commentId"]').val(id);
    $('#auditForm input[name="status"]').val(status);
    $('#auditModal').modal('show');
  }

  // 提交审核
  function submitAudit() {
    var formData = new FormData(document.getElementById('auditForm'));
    $.ajax({
      url: '/Forum/admin/content/comment/audit',
      type: 'POST',
      data: formData,
      processData: false,
      contentType: false,
      success: function(res) {
        if(res.code === 200) {
          $('#auditModal').modal('hide');
          alert('审核成功');
          loadComments(1);
        } else {
          alert(res.message);
        }
      }
    });
  }

  // 删除单条评论
  function deleteComment(id) {
    if(confirm('确定要删除这条评论吗？')) {
      $.post('/Forum/admin/content/comment/delete/' + id, function(res) {
        if(res.code === 200) {
          alert('删除成功');
          loadComments(1);
        } else {
          alert(res.message);
        }
      });
    }
  }

  // 格式化日期
  function formatDate(timestamp) {
    var date = new Date(timestamp);
    return date.getFullYear() + '-' +
            padNumber(date.getMonth() + 1) + '-' +
            padNumber(date.getDate()) + ' ' +
            padNumber(date.getHours()) + ':' +
            padNumber(date.getMinutes());
  }

  // 数字补零
  function padNumber(num) {
    return num < 10 ? '0' + num : num;
  }
</script>
</body>
</html>