<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core"%>
<%@ taglib prefix="fmt" uri="http://java.sun.com/jsp/jstl/fmt"%>
<!DOCTYPE html>
<html>
<head>
  <title>评论管理</title>
  <link href="${pageContext.request.contextPath}/static/css/bootstrap.min.css" rel="stylesheet">
  <link href="${pageContext.request.contextPath}/static/css/bootstrap-table.min.css" rel="stylesheet">
  <style>
    .search-box {
      margin-bottom: 20px;
      padding: 15px;
      background: #f8f9fa;
      border-radius: 4px;
    }
    .comment-content {
      max-width: 300px;
      overflow: hidden;
      text-overflow: ellipsis;
      white-space: nowrap;
    }
  </style>
</head>
<body>
<div class="container-fluid mt-4">
  <!-- 搜索条件 -->
  <div class="search-box">
    <form id="searchForm" class="form-inline">
      <select class="form-control mr-2" name="status">
        <option value="">全部状态</option>
        <option value="0">待审核</option>
        <option value="1">已通过</option>
        <option value="2">已拒绝</option>
      </select>
      <input type="text" class="form-control mr-2" name="keyword" placeholder="搜索评论内容">
      <button type="button" class="btn btn-primary" onclick="searchComments()">搜索</button>
      <button type="button" class="btn btn-secondary ml-2" onclick="resetSearch()">重置</button>
    </form>
  </div>

  <!-- 工具栏 -->
  <div class="toolbar mb-3">
    <button class="btn btn-success" onclick="batchAudit(1)">
      <i class="bi bi-check"></i> 批量通过
    </button>
    <button class="btn btn-danger ml-2" onclick="batchAudit(2)">
      <i class="bi bi-x"></i> 批量拒绝
    </button>
    <button class="btn btn-danger ml-2" onclick="batchDelete()">
      <i class="bi bi-trash"></i> 批量删除
    </button>
  </div>

  <!-- 数据表格 -->
  <table id="commentTable" class="table table-bordered table-hover">
    <thead>
    <tr>
      <th data-checkbox="true"></th>
      <th data-field="id">ID</th>
      <th data-field="content">评论内容</th>
      <th data-field="authorName">评论人</th>
      <th data-field="postTitle">所属帖子</th>
      <th data-field="status" data-formatter="statusFormatter">状态</th>
      <th data-field="createTime" data-formatter="dateFormatter">评论时间</th>
      <th data-field="operate" data-formatter="operateFormatter">操作</th>
    </tr>
    </thead>
  </table>
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

<script src="${pageContext.request.contextPath}/static/js/jquery.min.js"></script>
<script src="${pageContext.request.contextPath}/static/js/bootstrap.min.js"></script>
<script src="${pageContext.request.contextPath}/static/js/bootstrap-table.min.js"></script>
<script>
  // 初始化表格
  $('#commentTable').bootstrapTable({
    url: '/admin/comment/list',
    method: 'get',
    pagination: true,
    sidePagination: 'server',
    pageSize: 10,
    pageList: [10, 25, 50, 100],
    search: false,
    showRefresh: true,
    showColumns: true,
    clickToSelect: true,
    uniqueId: 'id',
    queryParams: queryParams
  });

  // 查询参数
  function queryParams(params) {
    var searchForm = $('#searchForm').serializeArray();
    var query = {};
    searchForm.forEach(function(item) {
      query[item.name] = item.value;
    });
    query.page = (params.offset / params.limit) + 1;
    query.limit = params.limit;
    return query;
  }

  // 搜索评论
  function searchComments() {
    $('#commentTable').bootstrapTable('refresh');
  }

  // 重置搜索
  function resetSearch() {
    $('#searchForm')[0].reset();
    searchComments();
  }

  // 状态格式化
  function statusFormatter(value) {
    switch(value) {
      case 0: return '<span class="badge badge-warning">待审核</span>';
      case 1: return '<span class="badge badge-success">已通过</span>';
      case 2: return '<span class="badge badge-danger">已拒绝</span>';
      case 3: return '<span class="badge badge-secondary">已删除</span>';
      default: return '-';
    }
  }

  // 日期格式化
  function dateFormatter(value) {
    return value ? new Date(value).toLocaleString() : '-';
  }

  // 操作按钮格式化
  function operateFormatter(value, row) {
    var html = '';
    if(row.status === 0) {
      html += '<button class="btn btn-success btn-sm mr-1" onclick="auditComment(' +
              row.id + ', 1)">通过</button>';
      html += '<button class="btn btn-danger btn-sm mr-1" onclick="auditComment(' +
              row.id + ', 2)">拒绝</button>';
    }
    html += '<button class="btn btn-danger btn-sm" onclick="deleteComment(' +
            row.id + ')">删除</button>';
    return html;
  }

  // 审核评论
  function auditComment(id, status) {
    $('#auditForm input[name="commentId"]').val(id);
    $('#auditForm input[name="status"]').val(status);
    $('#auditModal').modal('show');
  }

  // 提交审核
  function submitAudit() {
    var formData = new FormData(document.getElementById('auditForm'));
    $.ajax({
      url: '/admin/comment/audit',
      type: 'POST',
      data: formData,
      processData: false,
      contentType: false,
      success: function(res) {
        if(res.code === 200) {
          $('#auditModal').modal('hide');
          searchComments();
        } else {
          alert(res.message);
        }
      }
    });
  }

  // 删除评论
  function deleteComment(id) {
    if(confirm('确定要删除这条评论吗？')) {
      $.post('/admin/comment/delete/' + id, function(res) {
        if(res.code === 200) {
          searchComments();
        } else {
          alert(res.message);
        }
      });
    }
  }

  // 批量审核
  function batchAudit(status) {
    var rows = $('#commentTable').bootstrapTable('getSelections');
    if(rows.length === 0) {
      alert('请选择要审核的评论');
      return;
    }

    var ids = rows.map(function(row) {
      return row.id;
    });

    $('#auditForm input[name="status"]').val(status);
    $('#auditModal').modal('show');
  }

  // 批量删除
  function batchDelete() {
    var rows = $('#commentTable').bootstrapTable('getSelections');
    if(rows.length === 0) {
      alert('请选择要删除的评论');
      return;
    }

    if(confirm('确定要删除选中的评论吗？')) {
      var ids = rows.map(function(row) {
        return row.id;
      });

      $.ajax({
        url: '/admin/comment/delete/batch',
        type: 'POST',
        contentType: 'application/json',
        data: JSON.stringify(ids),
        success: function(res) {
          if(res.code === 200) {
            searchComments();
          } else {
            alert(res.message);
          }
        }
      });
    }
  }
</script>
</body>
</html>