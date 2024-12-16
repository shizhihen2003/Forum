package cn.edu.ujn.Forum.service;

import cn.edu.ujn.Forum.dao.*;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Service;
import org.springframework.transaction.annotation.Transactional;

import java.util.List;

@Service
public class LikeServiceImpl implements ILikeService{
    @Autowired
    private LikeMapper likeMapper;
    @Autowired
    private UserMapper userMapper;
    @Autowired
    private INotificationService notificationService;


    @Autowired
    private IPostService postService;

//    @Override
//    public boolean likePost(Integer userId, Integer postId) {
//
//        try {
//            int result = likeMapper.insertLike(userId, postId);
//            return result > 0;
//        } catch (Exception e) {
//            System.err.println("Error liking post: " + e.getMessage());
//            return false;
//        }
//    }

    @Override
    public boolean unlikePost(Integer userId, Integer postId) {
        try {
            int result = likeMapper.deleteLike(userId, postId);
            return result > 0;
        } catch (Exception e) {
            System.err.println("Error unliking post: " + e.getMessage());
            return false;
        }
    }

    @Override
    public int getLikeCountByPostId(Integer postId) {
        try {
            return likeMapper.countLikesByPostId(postId);
        } catch (Exception e) {
            System.err.println("Error retrieving like count: " + e.getMessage());
            return 0;
        }
    }

    @Override
    public List<Integer> getUsersWhoLikedPost(Integer postId) {
        try {
            return likeMapper.findUsersByPostId(postId);
        } catch (Exception e) {
            System.err.println("Error retrieving users who liked post: " + e.getMessage());
            return List.of();
        }
    }

    @Override
    public List<Integer> getLikedPostsByUserId(Integer userId) {
        try {
            return likeMapper.findPostsByUserId(userId);
        } catch (Exception e) {
            System.err.println("Error retrieving posts liked by user: " + e.getMessage());
            return List.of();
        }
    }

    @Override
    public boolean hasUserLikedPost(Integer userId, Integer postId) {
        try {
            int result = likeMapper.checkIfUserLikedPost(userId, postId);
            return result > 0;
        } catch (Exception e) {
            System.err.println("Error checking if user liked post: " + e.getMessage());
            return false;
        }
    }

    @Override
    public List<String> getUsernamesWhoLikedPost(Integer postId) {
        return likeMapper.selectUsernamesByPostId(postId); // 调用 Mapper 方法
    }

    @Override
    @Transactional
    public boolean likePost(Integer userId, Integer postId) {
        try {
            // 先检查是否已经点赞
            if (hasUserLikedPost(userId, postId)) {
                return false;
            }

            // 插入点赞记录
            int result = likeMapper.insertLike(userId, postId);

            if (result > 0) {
                // 更新帖子点赞数 - 使用正确的方法名
                Post post = postService.getPostDetail(postId.longValue());  // 使用postService而不是直接使用mapper
                if (post != null) {
                    // 不给自己发送通知
                    if (!userId.equals(post.getUserId().intValue())) {
                        // 获取点赞用户信息
                        User liker = userMapper.selectByPrimaryKey(userId);
                        if (liker != null) {
                            try {
                                notificationService.createLikeNotification(
                                        post.getUserId().intValue(),
                                        liker.getUsername(),
                                        post.getTitle(),
                                        post.getId()
                                );
                            } catch (Exception e) {
                                e.printStackTrace(); // 记录通知创建失败的错误
                            }
                        }
                    }
                    return true;
                }
            }
            return false;
        } catch (Exception e) {
            e.printStackTrace();
            throw e;
        }
    }
}
