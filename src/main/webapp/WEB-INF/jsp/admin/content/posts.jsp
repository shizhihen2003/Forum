<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core"%>
<%@ taglib prefix="fmt" uri="http://java.sun.com/jsp/jstl/fmt"%>
<!DOCTYPE html>
<html>
<head>
    <title>帖子管理</title>
    <link href="/Forum/static/css/bootstrap.min.css" rel="stylesheet">
    <link href="/Forum/static/css/font-awesome.min.css" rel="stylesheet">
    <style>
        .search-box {
            margin-bottom: 20px;
            padding: 15px;
            background: #f8f9fa;
            border-radius: 4px;
        }
        .action-buttons .btn {
            padding: 2px 8px;
            margin: 0 2px;
        }
        .title-cell {
            max-width: 300px;
            overflow: hidden;
            text-overflow: ellipsis;
            white-space: nowrap;
        }
        .batch-actions {
            margin-bottom: 15px;
        }
        .status-badge {
            padding: 4px 8px;
            border-radius: 12px;
            font-size: 12px;
            color: #fff;
        }
        .status-pending { background: #ffc107; }
        .status-approved { background: #28a745; }
        .status-rejected { background: #dc3545; }
        .status-deleted { background: #6c757d; }
    </style>
</head>
<body>
<div class="container-fluid mt-4">
    <!-- 搜索条件 -->
    <div class="search-box">
        <form id="searchForm" class="form-inline">
            <div class="form-group mb-2 mr-3">
                <select class="form-control" name="categoryId">
                    <option value="">所有分类</option>
                    <c:forEach items="${categories}" var="category">
                        <option value="${category.id}">${category.name}</option>
                    </c:forEach>
                </select>
            </div>
            <div class="form-group mb-2 mr-3">
                <select class="form-control" name="status">
                    <option value="">全部状态</option>
                    <option value="0">待审核</option>
                    <option value="1">已发布</option>
                    <option value="2">已拒绝</option>
                </select>
            </div>
            <div class="form-group mb-2 mr-3">
                <input type="text" class="form-control" name="keyword" placeholder="搜索标题">
            </div>
            <button type="button" class="btn btn-primary mb-2" onclick="searchPosts()">
                <i class="fa fa-search"></i> 搜索
            </button>
            <button type="button" class="btn btn-secondary mb-2 ml-2" onclick="resetSearch()">
                <i class="fa fa-refresh"></i> 重置
            </button>
        </form>
    </div>

    <!-- 批量操作按钮 -->
    <div class="batch-actions">
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

    <!-- 数据表格 -->
    <table class="table table-bordered table-hover">
        <thead>
        <tr>
            <th width="40">
                <input type="checkbox" id="checkAll" onclick="toggleCheckAll(this)">
            </th>
            <th>ID</th>
            <th>标题</th>
            <th>作者</th>
            <th>分类</th>
            <th>状态</th>
            <th>发布时间</th>
            <th>操作</th>
        </tr>
        </thead>
        <tbody id="postList">
        <!-- 数据将通过AJAX加载 -->
        </tbody>
    </table>

    <!-- 分页 -->
    <div id="pagination" class="d-flex justify-content-between align-items-center">
        <!-- 分页内容将通过AJAX更新 -->
    </div>
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
                    <input type="hidden" name="ids">
                    <input type="hidden" name="status">

                    <div class="form-group">
                        <label>审核意见</label>
                        <textarea class="form-control" name="reason" rows="3"
                                  placeholder="请输入审核意见"></textarea>
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
    // 加载帖子列表
    function loadPosts(page) {
        var formData = new FormData(document.getElementById('searchForm'));
        formData.append('page', page || 1);

        $.ajax({
            url: '/Forum/admin/content/post/list',
            type: 'GET',
            data: formData,
            processData: false,
            contentType: false,
            success: function(res) {
                if(res.code === 200) {
                    renderPosts(res.data);
                } else {
                    alert(res.message);
                }
            }
        });
    }

    // 渲染帖子列表
    function renderPosts(pageResult) {
        var html = '';
        pageResult.list.forEach(function(post) {
            html += '<tr>';
            html += '<td><input type="checkbox" name="postIds" value="' + post.id + '"></td>';
            html += '<td>' + post.id + '</td>';
            html += '<td class="title-cell">' + post.title + '</td>';
            html += '<td>' + post.authorName + '</td>';
            html += '<td>' + post.categoryName + '</td>';
            html += '<td>' + getStatusBadge(post.status) + '</td>';
            html += '<td>' + formatDate(post.createTime) + '</td>';
            html += '<td>' + getActionButtons(post) + '</td>';
            html += '</tr>';
        });
        $('#postList').html(html);

        // 渲染分页
        renderPagination(pageResult);
    }

    // 渲染分页
    function renderPagination(pageResult) {
        var html = '<div>共 ' + pageResult.total + ' 条记录，第 ' +
            pageResult.current + '/' + pageResult.pages + ' 页</div>';
        html += '<ul class="pagination mb-0">';

        // 上一页
        if(pageResult.current > 1) {
            html += '<li class="page-item">';
            html += '<a class="page-link" href="javascript:void(0)" onclick="loadPosts(' +
                (pageResult.current - 1) + ')">上一页</a>';
            html += '</li>';
        }

        // 页码
        for(var i = 1; i <= pageResult.pages; i++) {
            if(i === pageResult.current) {
                html += '<li class="page-item active">';
                html += '<span class="page-link">' + i + '</span>';
                html += '</li>';
            } else {
                html += '<li class="page-item">';
                html += '<a class="page-link" href="javascript:void(0)" onclick="loadPosts(' +
                    i + ')">' + i + '</a>';
                html += '</li>';
            }
        }

        // 下一页
        if(pageResult.current < pageResult.pages) {
            html += '<li class="page-item">';
            html += '<a class="page-link" href="javascript:void(0)" onclick="loadPosts(' +
                (pageResult.current + 1) + ')">下一页</a>';
            html += '</li>';
        }

        html += '</ul>';
        $('#pagination').html(html);
    }

    // 获取状态徽章
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
                text = '已发布';
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

    // 获取操作按钮
    function getActionButtons(post) {
        var html = '<div class="action-buttons">';
        html += '<a href="/Forum/post/' + post.id + '" target="_blank" ' +
            'class="btn btn-info btn-sm">查看</a>';

        if(post.status === 0) {
            html += '<button class="btn btn-success btn-sm ml-1" onclick="auditPost(' +
                post.id + ', 1)">通过</button>';
            html += '<button class="btn btn-danger btn-sm ml-1" onclick="auditPost(' +
                post.id + ', 2)">拒绝</button>';
        }

        html += '<button class="btn btn-danger btn-sm ml-1" onclick="deletePost(' +
            post.id + ')">删除</button>';
        html += '</div>';
        return html;
    }

    // 格式化日期
    function formatDate(timestamp) {
        return new Date(timestamp).toLocaleString();
    }

    // 搜索帖子
    function searchPosts() {
        loadPosts(1);
    }

    // 重置搜索
    function resetSearch() {
        document.getElementById('searchForm').reset();
        searchPosts();
    }

    // 全选/取消全选
    function toggleCheckAll(checkbox) {
        $('input[name="postIds"]').prop('checked', checkbox.checked);
    }

    // 审核帖子
    function auditPost(id, status) {
        $('#auditForm input[name="ids"]').val(id);
        $('#auditForm input[name="status"]').val(status);
        $('#auditModal').modal('show');
    }

    // 提交审核
    function submitAudit() {
        var formData = new FormData(document.getElementById('auditForm'));
        $.ajax({
            url: '/Forum/admin/content/post/audit/batch',
            type: 'POST',
            data: formData,
            processData: false,
            contentType: false,
            success: function(res) {
                $('#auditModal').modal('hide');
                if(res.code === 200) {
                    alert('审核成功');
                    loadPosts();
                } else {
                    alert(res.message);
                }
            }
        });
    }

    // 删除帖子
    function deletePost(id) {
        if(confirm('确定要删除这篇帖子吗？')) {
            $.post('/Forum/admin/content/post/delete/batch', {
                'ids[]': [id]
            }, function(res) {
                if(res.code === 200) {
                    alert('删除成功');
                    loadPosts();
                } else {
                    alert(res.message);
                }
            });
        }
    }

    // 批量审核
    function batchAudit(status) {
        var ids = getSelectedIds();
        if(ids.length === 0) {
            alert('请选择要审核的帖子');
            return;
        }

        $('#auditForm input[name="ids"]').val(ids.join(','));
        $('#auditForm input[name="status"]').val(status);
        $('#auditModal').modal('show');
    }

    // 批量删除
    function batchDelete() {
        var ids = getSelectedIds();
        if(ids.length === 0) {
            alert('请选择要删除的帖子');
            return;
        }

        if(confirm('确定要删除选中的帖子吗？')) {
            $.post('/Forum/admin/content/post/delete/batch', {
                'ids[]': ids
            }, function(res) {
                if(res.code === 200) {
                    alert('删除成功');
                    loadPosts();
                } else {
                    alert(res.message);
                }
            });
        }
    }

    // 获取选中的帖子ID
    function getSelectedIds() {
        var ids = [];
        $('input[name="postIds"]:checked').each(function() {
            ids.push($(this).val());
        });
        return ids;
    }

    // 页面加载完成后加载帖子列表
    $(function() {
        loadPosts();
    });
</script>
</body>
</html>