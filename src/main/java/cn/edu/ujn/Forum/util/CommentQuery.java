package cn.edu.ujn.Forum.util;

import lombok.Data;

// CommentQuery.java - 评论查询条件
@Data
public class CommentQuery {
    private Long postId;
    private Long userId;
    private Long parentId;
    private Integer status;
    private Integer offset = 0;
    private Integer limit = 10;
}
