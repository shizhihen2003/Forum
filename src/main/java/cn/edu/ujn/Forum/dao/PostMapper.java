package cn.edu.ujn.Forum.dao;

import cn.edu.ujn.Forum.dao.Post;
import cn.edu.ujn.Forum.util.PostQuery;
import org.apache.ibatis.annotations.Param;

import java.util.List;

public interface PostMapper {
    // 根据ID查询帖子
    Post selectById(@Param("id") Long id);

    // 查询帖子列表
    List<Post> selectList(PostQuery query);

    // 统计帖子总数
    int countList(PostQuery query);

    // 插入帖子
    int insert(Post post);

    // 更新帖子
    int update(Post post);

    // 更新帖子状态
    int updateStatus(@Param("id") Long id, @Param("status") Integer status);

    // 增加浏览次数
    int increaseViewCount(@Param("id") Long id);

    // 更新点赞次数
    int updateLikeCount(@Param("id") Long id, @Param("delta") Integer delta);

    // 更新评论次数
    int updateCommentCount(@Param("id") Long id, @Param("delta") Integer delta);
}