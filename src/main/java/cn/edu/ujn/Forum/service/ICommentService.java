package cn.edu.ujn.Forum.service;

import cn.edu.ujn.Forum.dao.Comment;
import cn.edu.ujn.Forum.util.CommentDTO;
import java.util.List;

public interface ICommentService {
    /**
     * 创建评论
     */
    Comment createComment(CommentDTO commentDTO);

    /**
     * 删除评论
     */
    boolean deleteComment(Long id);

    /**
     * 获取帖子评论列表
     */
    List<Comment> getPostComments(Long postId);

    /**
     * 点赞评论
     */
    boolean likeComment(Long id);

    /**
     * 审核评论
     */
    boolean auditComment(Long id, Integer status, String reason);

    /**
     * 批量审核评论
     */
    boolean batchAudit(List<Long> ids, Integer status, String reason);

    /**
     * 获取评论详情
     */
    Comment getCommentDetail(Long id);

    /**
     * 更新评论
     */
    boolean updateComment(Long id, CommentDTO commentDTO);
}