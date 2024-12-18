<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core"%>
<%@ taglib prefix="fmt" uri="http://java.sun.com/jsp/jstl/fmt"%>
<!DOCTYPE html>
<html>
<head>
  <title>帖子管理</title>
  <link href="${pageContext.request.contextPath}/static/css/bootstrap.min.css" rel="stylesheet">
  <link href="${pageContext.request.contextPath}/static/css/bootstrap-table.min.css" rel="stylesheet">
  <style>
    .search-box {
      margin-bottom: 20px;
      padding: 15px;
      background: #f8f9fa;
      border-radius: 4px;
    }
    .title-cell {
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
      <select class="form-control mr-2" name="categoryId">
        <option value="">所有分类</option>
        <c:forEach items="${categories}" var="category">
          <option value="${category.id}">${category.name}</option>
        </c:forEach>
      </select>
      <select class="form-control mr-2" name="status">
        <option value="">全部状态</option>
        <option value="0">待审核</option>
        <option value="1">已发布</option>
        <option value="2">已拒绝</option>
      </select>
      <input type="text" class="form-control mr-2" name="keyword" placeholder="搜索标题或内容">
      <button type="button" class="btn btn-primary" onclick="searchPosts()">搜索</button>
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
  <table id="postTable" class="table table-bordered table-hover">
    <thead>
    <tr>
      <th data-checkbox="true"></th>
      <th data-field="id">ID</th>
      <th data-field="title" data-formatter="titleFormatter">标题</th>
      <th data-field="authorName">作者</th>
      <th data-field="categoryName">分类</th>
      <th data-field="viewCount">阅读数</th>
      <th data-field="commentCount">评论数</th>
      <th data-field="status" data-formatter="statusFormatter">状态</th>
      <th data-field="createTime" data-formatter="dateFormatter">发布时间</th>
      <th data-field="operate" data-formatter="operateFormatter"
          data-events="operateEvents">操作</th>
    </tr>
    </thead>
  </table>
</div>

<!-- 审核模态框 -->
<div class="modal fade" id="auditModal">
  <div class="modal-dialog">
    <div class="modal-content">
      <div class="modal-header">
        <h5 class="modal-title">帖子审核</h5>
        <button type="button" class="close" data-dismiss="modal">
          <span>&times;</span>
        </button>
      </div>
      <div class="modal-body">
        <form id="auditForm">
          <input type="hidden" name="postId">
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

<!-- 查看内容模态框 -->
<div class="modal fade" id="viewModal">
  <div class="modal-dialog modal-lg">
    <div class="modal-content">
      <div class="modal-header">
        <h5 class="modal-title">帖子内容</h5>
        <button type="button" class="close" data-dismiss="modal">
          <span>&times;</span>
        </button>
      </div>
      <div class="modal-body">
        <div id="postContent"></div>
      </div>
    </div>
  </div>
</div>

<script src="${pageContext.request.contextPath}/static/js/jquery.min.js"></script>
<script src="${pageContext.request.contextPath}/static/js/bootstrap.min.js"></script>
<script src="${pageContext.request.contextPath}/static/js/bootstrap-table.min.js"></script>
<script>
  // 初始化表格
  $('#postTable').bootstrapTable({
    url: '/admin/post/list',
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

  // 搜索帖子
  function searchPosts() {
    $('#postTable').bootstrapTable('refresh');
  }

  // 重置搜索
  function resetSearch() {
    $('#searchForm')[0].reset();
    searchPosts();
  }

  // 标题格式化
  function titleFormatter(value, row) {
    return '<div class="title-cell">' + value +
            (row.isTop ? '<span class="badge badge-danger ml-1">置顶</span>' : '') +
            (row.isEssence ? '<span class="badge badge-warning ml-1">精华</span>' : '') +
            '</div>';
  }

  // 状态格式化
  function statusFormatter(value) {
    switch(value) {
      case 0: return '<span class="badge badge-warning">待审核</span>';
      case 1: return '<span class="badge badge-success">已发布</span>';
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
    var html = '<button class="btn btn-info btn-sm view mr-1" title="查看">查看</button>';
    if(row.status === 0) {
      html += '<button class="btn btn-success btn-sm audit mr-1" title="通过">通过</button>';
      html += '<button class="btn btn-danger btn-sm reject mr-1" title="拒绝">拒绝</button>';
    }
    html += '<button class="btn btn-warning btn-sm setTop mr-1" title="置顶">' +
            (row.isTop ? '取消置顶' : '置顶') + '</button>';
    html += '<button class="btn btn-warning btn-sm setEssence mr-1" title="加精">' +
            (row.isEssence ? '取消加精' : '加精') + '</button>';
    html += '<button class="btn btn-danger btn-sm delete" title="删除">删除</button>';
    return html;
  }

  // 操作事件
  window.operateEvents = {
    'click .view': function (e, value, row) {
      viewPost(row);
    },
    'click .audit': function (e, value, row) {
      auditPost(row.id, 1);
    },
    'click .reject': function (e, value, row) {
      auditPost(row.id, 2);
    },
    'click .setTop': function (e, value, row) {
      setTop(row.id, !row.isTop);
    },
    'click .setEssence': function (e, value, row) {
      setEssence(row.id, !row.isEssence);
    },
    'click .delete': function (e, value, row) {
      deletePost(row.id);
    }
  };

  // 查看帖子
  function viewPost(row) {
    $('#postContent').html(row.content);
    $('#viewModal').modal('show');
  }

  // 审核帖子
  function auditPost(id, status) {
    $('#auditForm input[name="postId"]').val(id);
    $('#auditForm input[name="status"]').val(status);
    $('#auditModal').modal('show');
  }

  // 提交审核
  function submitAudit() {
    var formData = new FormData(document.getElementById('auditForm'));
    $.ajax({
      url: '/admin/post/audit',
      type: 'POST',
      data: formData,
      processData: false,
      contentType: false,
      success: function(res) {
        if(res.code === 200) {
          $('#auditModal').modal('hide');
          searchPosts();
        } else {
          alert(res.message);
        }
      }
    });
  }

  // 设置置顶
  function setTop(id, isTop) {
    $.post('/admin/post/setTop/' + id, {isTop: isTop}, function(res) {
      if(res.code === 200) {
        searchPosts();
      } else {
        alert(res.message);
      }
    });
  }

  // 设置加精
  function setEssence(id, isEssence) {
    $.post('/admin/post/setEssence/' + id, {isEssence: isEssence}, function(res) {
      if(res.code === 200) {
        searchPosts();
      } else {
        alert(res.message);
      }
    });
  }

  // 删除帖子
  function deletePost(id) {
    if(confirm('确定要删除这篇帖子吗？删除后相关评论也会被删除！')) {
      $.post('/admin/post/delete/' + id, function(res) {
        if(res.code === 200) {
          searchPosts();
        } else {
          alert(res.message);
        }
      });
    }
  }

  // 批量审核
  function batchAudit(status) {
    var rows = $('#postTable').bootstrapTable('getSelections');
    if(rows.length === 0) {
      alert('请选择要审核的帖子');
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
    var rows = $('#postTable').bootstrapTable('getSelections');
    if(rows.length === 0) {
      alert('请选择要删除的帖子');
      return;
    }

    if(confirm('确定要删除选中的帖子吗？')) {
      var ids = rows.map(function(row) {
        return row.id;
      });

      $.ajax({
        url: '/admin/post/delete/batch',
        type: 'POST',
        contentType: 'application/json',
        data: JSON.stringify(ids),
        success: function(res) {
          if(res.code === 200) {
            searchPosts();
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