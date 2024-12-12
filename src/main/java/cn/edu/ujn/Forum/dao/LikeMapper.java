package cn.edu.ujn.Forum.dao;

import org.apache.ibatis.annotations.Param;

import java.util.List;

public interface LikeMapper {

    /**
     * 插入一条点赞记录
     *
     * @param userId 用户ID
     * @param postId 帖子ID
     * @return 插入成功返回1，失败返回0
     */
    int insertLike(@Param("userId") Integer userId, @Param("postId") Integer postId);

    /**
     * 删除一条点赞记录
     *
     * @param userId 用户ID
     * @param postId 帖子ID
     * @return 删除成功返回1，失败返回0
     */
    int deleteLike(@Param("userId") Integer userId, @Param("postId") Integer postId);

    /**
     * 查询某个帖子的点赞数量
     *
     * @param postId 帖子ID
     * @return 点赞数量
     */
    int countLikesByPostId(@Param("postId") Integer postId);

    /**
     * 查询某个帖子被哪些用户点赞
     *
     * @param postId 帖子ID
     * @return 点赞用户的ID列表
     */
    List<Integer> findUsersByPostId(@Param("postId") Integer postId);

    /**
     * 查询某个用户点赞过的所有帖子
     *
     * @param userId 用户ID
     * @return 用户点赞过的帖子ID列表
     */
    List<Integer> findPostsByUserId(@Param("userId") Integer userId);

    /**
     * 检查某用户是否点赞某帖子
     *
     * @param userId 用户ID
     * @param postId 帖子ID
     * @return 返回1表示已点赞，0表示未点赞
     */
    int checkIfUserLikedPost(@Param("userId") Integer userId, @Param("postId") Integer postId);

    List<String> selectUsernamesByPostId(@Param("postId") Integer postId); // 返回用户名列表
}

