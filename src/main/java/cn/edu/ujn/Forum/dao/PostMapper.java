package cn.edu.ujn.Forum.dao;

import cn.edu.ujn.Forum.util.PostQuery;
import org.apache.ibatis.annotations.Mapper;
import org.apache.ibatis.annotations.Param;
import java.util.List;
@Mapper
public interface PostMapper {
    /**
     * 根据ID查询帖子
     */
    Post selectById(@Param("id") Long id);

    /**
     * 查询帖子列表
     */
    List<Post> selectList(PostQuery query);

    /**
     * 统计帖子总数
     */
    int countList(PostQuery query);

    /**
     * 插入帖子
     */
    int insert(Post post);

    /**
     * 更新帖子
     */
    int update(Post post);

    /**
     * 更新帖子状态
     */
    int updateStatus(@Param("id") Long id, @Param("status") Integer status);

    /**
     * 增加浏览次数
     */
    int increaseViewCount(@Param("id") Long id);

    /**
     * 更新点赞次数
     */
    int updateLikeCount(@Param("id") Long id, @Param("delta") Integer delta);

    /**
     * 更新评论次数
     */
    int updateCommentCount(@Param("id") Long id, @Param("delta") Integer delta);

    /**
     * 获取热门帖子
     */
    List<Post> selectHotPosts(@Param("limit") int limit);

    /**
     * 获取相关帖子
     */
    List<Post> selectRelatedPosts(@Param("categoryId") Long categoryId,
                                  @Param("currentId") Long currentId,
                                  @Param("limit") int limit);

    /**
     * 更新置顶状态
     */
    int updateTopStatus(@Param("id") Long id, @Param("isTop") Integer isTop);

    /**
     * 更新精华状态
     */
    int updateEssenceStatus(@Param("id") Long id, @Param("isEssence") Integer isEssence);

    /**
     * 批量更新状态
     */
    int batchUpdateStatus(@Param("ids") List<Long> ids, @Param("status") Integer status);

    /**
     * 物理删除帖子
     */
    int deleteById(@Param("id") Long id);

    /**
     * 批量物理删除帖子
     */
    int batchDelete(@Param("ids") List<Long> ids);
}