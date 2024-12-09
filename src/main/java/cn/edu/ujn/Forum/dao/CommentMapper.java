package cn.edu.ujn.Forum.dao;

import org.apache.ibatis.annotations.Mapper;
import org.apache.ibatis.annotations.Param;
import java.util.List;

@Mapper
public interface CommentMapper {
    // 根据ID查询评论
    Comment selectById(Long id);

    // 获取帖子的评论列表
    List<Comment> getPostComments(Long postId);

    // 根据父评论ID查询回复列表
    List<Comment> selectByParentId(Long parentId);

    // 根据帖子ID查询评论
    List<Comment> selectByPostId(Long postId);

    // 根据评论ID批量查询
    List<Comment> selectByIds(@Param("ids") List<Long> ids);

    // 删除评论
    int deleteById(Long id);

    // 插入评论（全字段）
    int insertWithAll(Comment record);

    // 插入评论（动态字段）
    int insert(Comment record);

    // 更新评论（动态字段）
    int updateSelective(Comment record);

    // 更新评论（带BLOB字段）
    int updateWithBLOBs(Comment record);

    // 更新评论（基础字段）
    int updateBasic(Comment record);

    // 更新评论状态
    int updateStatus(@Param("id") Long id, @Param("status") Integer status);

    // 更新点赞次数
    int updateLikeCount(@Param("id") Long id, @Param("delta") Integer delta);

    // 根据帖子ID更新评论状态
    int updateStatusByPostId(@Param("postId") Long postId, @Param("status") Integer status);

    // 根据帖子ID删除评论
    int deleteByPostId(@Param("postId") Long postId);

    // 批量删除评论
    int batchDelete(@Param("ids") List<Long> ids);

    // 批量更新评论状态
    int updateStatusBatch(@Param("ids") List<Long> ids, @Param("status") Integer status);
}