package cn.edu.ujn.Forum.dao;

import cn.edu.ujn.Forum.dao.Comment;
import cn.edu.ujn.Forum.util.CommentQuery;
import org.apache.ibatis.annotations.Param;

import java.util.List;

public interface CommentMapper {
    // 根据ID查询评论
    Comment selectById(@Param("id") Long id);

    // 查询评论列表
    List<Comment> selectList(CommentQuery query);

    // 根据帖子ID查询评论
    List<Comment> selectByPostId(@Param("postId") Long postId);

    // 查询子评论列表
    List<Comment> selectByParentId(@Param("parentId") Long parentId);

    // 统计评论总数
    int countList(CommentQuery query);

    // 插入评论
    int insert(Comment comment);

    // 更新评论
    int update(Comment comment);

    // 更新评论状态
    int updateStatus(@Param("id") Long id, @Param("status") Integer status);

    // 更新点赞次数
    int updateLikeCount(@Param("id") Long id, @Param("delta") Integer delta);
}