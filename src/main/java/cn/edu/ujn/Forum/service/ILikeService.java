package cn.edu.ujn.Forum.service;

import java.util.List;

public interface ILikeService {

    /**
     * 用户点赞某个帖子
     *
     * @param userId 用户ID
     * @param postId 帖子ID
     * @return 成功返回 true，失败返回 false
     */
    boolean likePost(Integer userId, Integer postId);

    /**
     * 用户取消对某个帖子的点赞
     *
     * @param userId 用户ID
     * @param postId 帖子ID
     * @return 成功返回 true，失败返回 false
     */
    boolean unlikePost(Integer userId, Integer postId);

    /**
     * 查询某个帖子的点赞数量
     *
     * @param postId 帖子ID
     * @return 点赞数量
     */
    int getLikeCountByPostId(Integer postId);

    /**
     * 查询某个帖子被哪些用户点赞
     *
     * @param postId 帖子ID
     * @return 点赞用户的ID列表
     */
    List<Integer> getUsersWhoLikedPost(Integer postId);

    /**
     * 查询某个用户点赞过的所有帖子
     *
     * @param userId 用户ID
     * @return 用户点赞过的帖子ID列表
     */
    List<Integer> getLikedPostsByUserId(Integer userId);

    /**
     * 检查某用户是否点赞了某帖子
     *
     * @param userId 用户ID
     * @param postId 帖子ID
     * @return 已点赞返回 true，未点赞返回 false
     */
    boolean hasUserLikedPost(Integer userId, Integer postId);
}
