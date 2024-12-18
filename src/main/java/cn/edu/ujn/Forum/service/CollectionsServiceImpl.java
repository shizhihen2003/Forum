package cn.edu.ujn.Forum.service;

import cn.edu.ujn.Forum.dao.Collections;
import cn.edu.ujn.Forum.dao.CollectionsMapper;
import cn.edu.ujn.Forum.dao.Post;
import cn.edu.ujn.Forum.dao.User;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Service;
import org.springframework.transaction.annotation.Transactional;

import java.sql.Timestamp;
import java.util.List;

@Service
public class CollectionsServiceImpl implements ICollectionsService {

    @Autowired
    private CollectionsMapper collectionMapper;

    @Autowired
    private INotificationService notificationService;

    @Autowired
    private IPostService postService;

    @Autowired
    private IUserService userService; // 注入 IUserService

    @Override
    @Transactional
    public boolean addCollection(Integer userId, Long postId) {
        if (!isCollected(userId, postId)) {
            Collections collection = new Collections();
            collection.setUserId(userId);
            collection.setPostId(postId);
            collection.setCreatedAt(new Timestamp(System.currentTimeMillis()));
            boolean success = collectionMapper.insertCollection(collection) > 0;

            if (success) {
                // 获取帖子的详细信息以发送通知
                Post post = postService.getPostDetail(postId);
                if (post != null) {
                    try {
                        // 获取收藏者的用户信息
                        User collector = userService.getUserById(userId);
                        if (collector != null) {
                            notificationService.createCollectionNotification(
                                    post.getUserId().intValue(),
                                    collector.getUsername(),
                                    post.getTitle(),
                                    post.getId()
                            );
                        } else {
                            System.err.println("未找到用户ID为 " + userId + " 的用户信息");
                        }
                    } catch (Exception e) {
                        e.printStackTrace(); // 记录通知创建失败的错误
                    }
                }
            }

            return success;
        }
        return false; // 已经收藏，不能重复收藏
    }

    @Override
    @Transactional
    public boolean removeCollection(Integer userId, Long postId) {
        if (isCollected(userId, postId)) {
            return collectionMapper.deleteCollection(userId, postId) > 0;
        }
        return false; // 未收藏，无法取消
    }

    @Override
    public boolean isCollected(Integer userId, Long postId) {
        return collectionMapper.isCollected(userId, postId) > 0;
    }

    @Override
    public List<Long> getUserCollections(Integer userId) {
        return collectionMapper.getUserCollections(userId);
    }

    @Override
    public int countCollections(Long postId) {
        return collectionMapper.countCollections(postId);
    }

    @Override
    public List<String> getCollectionUsers(Long postId) {
        return collectionMapper.getCollectionUsers(postId);
    }
}
