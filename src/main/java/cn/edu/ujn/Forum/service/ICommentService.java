// ICommentService.java
package cn.edu.ujn.Forum.service;

import cn.edu.ujn.Forum.dao.Comment;
import cn.edu.ujn.Forum.util.CommentDTO;
import cn.edu.ujn.Forum.util.PageResult;

import java.util.List;


public interface ICommentService {
    Comment createComment(CommentDTO commentDTO);
    boolean deleteComment(Long id);
    List<Comment> getPostComments(Long postId);
    boolean auditComment(Long id, Integer status, String reason);
    boolean likeComment(Long id);
}


