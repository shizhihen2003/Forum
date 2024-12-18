package cn.edu.ujn.Forum.service;

// 导入必要的类和接口
import cn.edu.ujn.Forum.dao.*;
import org.springframework.beans.factory.annotation.Autowired; // 用于依赖注入
import org.springframework.stereotype.Service; // 标识为服务层组件
import org.springframework.transaction.annotation.Transactional; // 管理事务

import java.util.List;

/**
 * Service 层实现类 - LikeServiceImpl
 * 负责处理与点赞（Like）相关的业务逻辑。
 */
@Service // 标识该类为 Spring 服务组件
public class LikeServiceImpl implements ILikeService {

    @Autowired // 自动注入 LikeMapper，用于数据库操作
    private LikeMapper likeMapper;

    @Autowired // 自动注入 UserMapper，用于用户相关数据库操作
    private UserMapper userMapper;

    @Autowired // 自动注入 INotificationService，用于创建通知
    private INotificationService notificationService;

    @Autowired // 自动注入 IPostService，用于帖子相关操作
    private IPostService postService;

    /**
     * 取消点赞操作。
     *
     * @param userId 当前用户的ID
     * @param postId 被点赞的帖子的ID
     * @return 取消点赞是否成功
     */
    @Override
    public boolean unlikePost(Integer userId, Integer postId) {
        try {
            // 调用 Mapper 删除点赞记录
            int result = likeMapper.deleteLike(userId, postId);
            return result > 0; // 返回操作是否成功
        } catch (Exception e) {
            // 记录错误信息
            System.err.println("Error unliking post: " + e.getMessage());
            return false; // 操作失败
        }
    }

    /**
     * 获取指定帖子的点赞数量。
     *
     * @param postId 帖子的ID
     * @return 点赞数量
     */
    @Override
    public int getLikeCountByPostId(Integer postId) {
        try {
            // 调用 Mapper 统计点赞数
            return likeMapper.countLikesByPostId(postId);
        } catch (Exception e) {
            // 记录错误信息
            System.err.println("Error retrieving like count: " + e.getMessage());
            return 0; // 出错时返回0
        }
    }

    /**
     * 获取点赞指定帖子的所有用户的ID列表。
     *
     * @param postId 帖子的ID
     * @return 用户ID列表
     */
    @Override
    public List<Integer> getUsersWhoLikedPost(Integer postId) {
        try {
            // 调用 Mapper 获取用户ID列表
            return likeMapper.findUsersByPostId(postId);
        } catch (Exception e) {
            // 记录错误信息
            System.err.println("Error retrieving users who liked post: " + e.getMessage());
            return List.of(); // 出错时返回空列表
        }
    }

    /**
     * 获取指定用户点赞过的所有帖子的ID列表。
     *
     * @param userId 用户的ID
     * @return 帖子ID列表
     */
    @Override
    public List<Integer> getLikedPostsByUserId(Integer userId) {
        try {
            // 调用 Mapper 获取帖子ID列表
            return likeMapper.findPostsByUserId(userId);
        } catch (Exception e) {
            // 记录错误信息
            System.err.println("Error retrieving posts liked by user: " + e.getMessage());
            return List.of(); // 出错时返回空列表
        }
    }

    /**
     * 检查用户是否已点赞指定帖子。
     *
     * @param userId 用户的ID
     * @param postId 帖子的ID
     * @return 是否已点赞
     */
    @Override
    public boolean hasUserLikedPost(Integer userId, Integer postId) {
        try {
            // 调用 Mapper 检查点赞记录
            int result = likeMapper.checkIfUserLikedPost(userId, postId);
            return result > 0; // 返回是否存在点赞记录
        } catch (Exception e) {
            // 记录错误信息
            System.err.println("Error checking if user liked post: " + e.getMessage());
            return false; // 出错时默认未点赞
        }
    }

    /**
     * 获取点赞指定帖子的所有用户的用户名列表。
     *
     * @param postId 帖子的ID
     * @return 用户名列表
     */
    @Override
    public List<String> getUsernamesWhoLikedPost(Integer postId) {
        // 直接调用 Mapper 获取用户名列表
        return likeMapper.selectUsernamesByPostId(postId);
    }

    /**
     * 处理点赞操作，包括保存点赞记录和发送通知。
     *
     * @param userId 当前用户的ID
     * @param postId 被点赞的帖子的ID
     * @return 点赞是否成功
     */
    @Override
    @Transactional // 确保操作的事务性
    public boolean likePost(Integer userId, Integer postId) {
        try {
            // 检查用户是否已点赞
            if (hasUserLikedPost(userId, postId)) {
                return false; // 已点赞则返回失败
            }

            // 插入点赞记录
            int result = likeMapper.insertLike(userId, postId);

            if (result > 0) {
                // 获取被点赞的帖子详情
                Post post = postService.getPostDetail(postId.longValue());
                if (post != null) {
                    // 如果点赞者不是帖子作者，发送通知
                    if (!userId.equals(post.getUserId().intValue())) {
                        // 获取点赞者信息
                        User liker = userMapper.selectByPrimaryKey(userId);
                        if (liker != null) {
                            try {
                                // 创建点赞通知
                                notificationService.createLikeNotification(
                                        post.getUserId().intValue(),
                                        liker.getUsername(),
                                        post.getTitle(),
                                        post.getId()
                                );
                            } catch (Exception e) {
                                // 记录通知创建失败的错误，但不影响点赞操作
                                e.printStackTrace();
                            }
                        }
                    }
                    return true; // 点赞成功
                }
            }
            return false; // 点赞失败
        } catch (Exception e) {
            // 记录错误信息并回滚事务
            e.printStackTrace();
            throw e;
        }
    }
}
