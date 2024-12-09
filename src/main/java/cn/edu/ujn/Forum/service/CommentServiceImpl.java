package cn.edu.ujn.Forum.service;

import cn.edu.ujn.Forum.dao.Comment;

import cn.edu.ujn.Forum.dao.CommentMapper;
import cn.edu.ujn.Forum.dao.PostMapper;
import cn.edu.ujn.Forum.dao.Comment;
import cn.edu.ujn.Forum.service.ICommentService;
import cn.edu.ujn.Forum.util.CommentDTO;
import cn.edu.ujn.Forum.util.PageResult;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Service;

import java.util.ArrayList;
import java.util.Date;
import java.util.List;
import java.util.Map;
import java.util.stream.Collectors;

@Service
public class CommentServiceImpl implements ICommentService {
    @Autowired
    private CommentMapper commentMapper;
    @Autowired
    private PostMapper postMapper;


    @Override
    public Comment createComment(CommentDTO commentDTO) {
        // 参数校验
        String error = commentDTO.validate();
        if(error != null) {
            throw new IllegalArgumentException(error);
        }

        // 检查帖子是否存在
        if(postMapper.selectById(commentDTO.getPostId()) == null) {
            throw new IllegalArgumentException("帖子不存在");
        }

        Comment comment = new Comment();
        // 设置基础信息
        comment.setPostId(commentDTO.getPostId());
        comment.setParentId(commentDTO.getParentId());
        comment.setContent(commentDTO.getContent());

        // 设置其他信息
        comment.setUserId(getCurrentUserId());
        comment.setLikeCount(0);
        comment.setStatus((byte) 0); // 待审核
        comment.setCreateTime(new Date());

        // 插入评论
        commentMapper.insert(comment);

        // 更新帖子评论数
        postMapper.updateCommentCount(comment.getPostId(), 1);

        return comment;
    }

    @Override
    public boolean deleteComment(Long id) {
        Comment comment = commentMapper.selectById(id);
        if(comment == null) {
            return false;
        }

        // 权限检查
        Long currentUserId = getCurrentUserId();
        if(!comment.getUserId().equals(currentUserId) && !isAdmin()) {
            throw new IllegalStateException("没有删除权限");
        }

        // 逻辑删除评论
        if(commentMapper.updateStatus(id, 3) > 0) {
            // 更新帖子评论数
            postMapper.updateCommentCount(comment.getPostId(), -1);
            return true;
        }

        return false;
    }

    @Override
    public List<Comment> getPostComments(Long postId) {
        // 获取所有评论
        List<Comment> allComments = commentMapper.selectByPostId(postId);

        // 按父评论ID分组
        Map<Long, List<Comment>> groupedComments = allComments.stream()
                .collect(Collectors.groupingBy(
                        comment -> comment.getParentId() == null ? -1 : comment.getParentId()
                ));

        // 获取顶级评论
        List<Comment> rootComments = groupedComments.getOrDefault(-1L, new ArrayList<>());

        // 递归设置子评论
        for(Comment comment : rootComments) {
            setChildComments(comment, groupedComments);
        }

        return rootComments;
    }

    // 递归设置子评论
    private void setChildComments(Comment comment, Map<Long, List<Comment>> groupedComments) {
        List<Comment> children = groupedComments.get(comment.getId());
        if(children != null) {
            comment.setChildren(children);
            for(Comment child : children) {
                setChildComments(child, groupedComments);
            }
        }
    }

    @Override
    public boolean auditComment(Long id, Integer status, String reason) {
        // 权限检查
        if(!isAdmin()) {
            throw new IllegalStateException("没有审核权限");
        }

        Comment comment = commentMapper.selectById(id);
        if(comment == null || comment.getStatus() == 3) {
            return false;
        }

        return commentMapper.updateStatus(id, status) > 0;
    }

    @Override
    public boolean likeComment(Long id) {
        Comment comment = commentMapper.selectById(id);
        if(comment == null || comment.getStatus() != 1) {
            return false;
        }

        return commentMapper.updateLikeCount(id, 1) > 0;
    }

    // 获取当前用户ID方法
    private Long getCurrentUserId() {
        // TODO: 实现获取当前用户ID的逻辑
        return 1L; // 临时返回值
    }

    // 检查是否是管理员
    private boolean isAdmin() {
        // TODO: 实现管理员检查逻辑
        return false; // 临时返回值
    }
}