package cn.edu.ujn.Forum.service;

import cn.edu.ujn.Forum.dao.Comment;
import cn.edu.ujn.Forum.dao.CommentMapper;
import cn.edu.ujn.Forum.dao.Post;
import cn.edu.ujn.Forum.dao.PostMapper;
import cn.edu.ujn.Forum.dao.User;
import cn.edu.ujn.Forum.dao.UserMapper;
import cn.edu.ujn.Forum.util.CommentDTO;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Service;
import org.springframework.transaction.annotation.Transactional;

import java.util.Date;
import java.util.List;

@Service
public class CommentServiceImpl implements ICommentService {

    @Autowired
    private CommentMapper commentMapper;

    @Autowired
    private PostMapper postMapper;

    @Autowired
    private UserMapper userMapper;

    @Autowired
    private INotificationService notificationService;

    @Autowired
    private IPostService postService;

    @Override
    @Transactional
    public Comment createComment(CommentDTO commentDTO) {
        // 参数校验
        if(commentDTO.getPostId() == null) {
            throw new IllegalArgumentException("帖子ID不能为空");
        }
        if(commentDTO.getContent() == null || commentDTO.getContent().trim().isEmpty()) {
            throw new IllegalArgumentException("评论内容不能为空");
        }
        if(commentDTO.getContent().length() > 1000) {
            throw new IllegalArgumentException("评论内容不能超过1000字符");
        }

        // 创建评论对象
        Comment comment = new Comment();
        comment.setPostId(commentDTO.getPostId());
        comment.setContent(commentDTO.getContent());
        comment.setParentId(commentDTO.getParentId());
        comment.setUserId(getCurrentUserId());
        comment.setLikeCount(0);
        comment.setStatus(1);  // 默认状态为已发布
        comment.setCreateTime(new Date());
        comment.setUpdateTime(new Date());

        // 插入评论
        commentMapper.insert(comment);

        // 更新帖子评论数
        postMapper.updateCommentCount(commentDTO.getPostId(), 1);

        // 发送通知
        User commenter = userMapper.selectByPrimaryKey(getCurrentUserId().intValue());
        Post post = postService.getPostDetail(commentDTO.getPostId());

        if (comment.getParentId() == null) {
            // 如果是评论帖子
            if (!getCurrentUserId().equals(post.getUserId())) { // 不给自己发通知
                notificationService.createCommentNotification(
                        post.getUserId().intValue(),
                        commenter.getUsername(),
                        post.getTitle(),
                        post.getId()
                );
            }
        } else {
            // 如果是回复评论
            Comment parentComment = commentMapper.selectById(comment.getParentId());
            if (parentComment != null && !getCurrentUserId().equals(parentComment.getUserId())) {
                notificationService.createReplyNotification(
                        parentComment.getUserId().intValue(),
                        commenter.getUsername(),
                        post.getTitle(),
                        post.getId()
                );
            }
        }

        return comment;
    }

    @Override
    @Transactional
    public boolean deleteComment(Long id) {
        // 查询评论
        Comment comment = commentMapper.selectById(id);
        if(comment == null) {
            return false;
        }

        // 权限检查
        if(!comment.getUserId().equals(getCurrentUserId()) && !isAdmin()) {
            throw new IllegalStateException("没有删除权限");
        }

        // 删除评论
        commentMapper.updateStatus(id, 3);  // 状态改为已删除

        // 更新帖子评论数
        postMapper.updateCommentCount(comment.getPostId(), -1);

        return true;
    }

    @Override
    public List<Comment> getPostComments(Long postId) {
        return commentMapper.getPostComments(postId);
    }

    @Override
    @Transactional
    public boolean likeComment(Long id) {
        Comment comment = commentMapper.selectById(id);
        if(comment == null || comment.getStatus() != 1) {
            return false;
        }

        return commentMapper.updateLikeCount(id, 1) > 0;
    }

    @Override
    @Transactional
    public boolean auditComment(Long id, Integer status, String reason) {
        // 权限检查
        if(!isAdmin()) {
            throw new IllegalStateException("没有审核权限");
        }

        Comment comment = commentMapper.selectById(id);
        if(comment == null) {
            return false;
        }

        // 更新评论状态
        return commentMapper.updateStatus(id, status) > 0;
    }

    @Override
    @Transactional
    public boolean batchAudit(List<Long> ids, Integer status, String reason) {
        if(!isAdmin()) {
            throw new IllegalStateException("没有审核权限");
        }
        return commentMapper.updateStatusBatch(ids, status) > 0;
    }

    @Override
    public Comment getCommentDetail(Long id) {
        return commentMapper.selectById(id);
    }

    @Override
    @Transactional
    public boolean updateComment(Long id, CommentDTO commentDTO) {
        // 查询原评论
        Comment oldComment = commentMapper.selectById(id);
        if(oldComment == null || oldComment.getStatus() == 3) {
            return false;
        }

        // 权限检查
        if(!oldComment.getUserId().equals(getCurrentUserId()) && !isAdmin()) {
            throw new IllegalStateException("没有修改权限");
        }

        // 更新评论
        Comment comment = new Comment();
        comment.setId(id);
        comment.setContent(commentDTO.getContent());
        comment.setUpdateTime(new Date());

        return commentMapper.updateSelective(comment) > 0;
    }

    // 获取当前用户ID - 需要实际实现
    private Long getCurrentUserId() {
        // TODO: 实现获取当前用户ID的逻辑
        return 1L;
    }

    // 检查是否是管理员 - 需要实际实现
    private boolean isAdmin() {
        // TODO: 实现管理员检查逻辑
        return true;
    }
}