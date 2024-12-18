package cn.edu.ujn.Forum.service;

import cn.edu.ujn.Forum.dao.Notification;
import java.util.List;

public interface INotificationService {

    /**
     * 获取用户的所有通知
     * @param userId 用户ID
     * @return 通知列表
     */
    List<Notification> getUserNotifications(Integer userId);

    /**
     * 创建新通知
     * @param userId 目标用户ID
     * @param type 通知类型(如"点赞","评论"等)
     * @param title 通知标题
     * @param content 通知内容
     */
    void createNotification(Integer userId, String type, String title, String content);

    /**
     * 标记通知为已读
     * @param id 通知ID
     * @return 是否标记成功
     */
    boolean markAsRead(Long id);

    /**
     * 获取用户未读通知数量
     * @param userId 用户ID
     * @return 未读数量
     */
    int getUnreadCount(Integer userId);

    /**
     * 标记所有通知为已读
     * @param userId 用户ID
     * @return 是否标记成功
     */
    boolean markAllAsRead(Integer userId);

    /**
     * 删除通知
     * @param id 通知ID
     * @return 是否删除成功
     */
    boolean deleteNotification(Long id);

    /**
     * 创建点赞通知
     * @param userId 被点赞的用户ID
     * @param likerName 点赞者用户名
     * @param postTitle 被点赞的帖子标题
     * @param postId 被点赞的帖子ID
     */
    void createLikeNotification(Integer userId, String likerName, String postTitle, Long postId);

    /**
     * 创建评论通知
     * @param userId 被评论的用户ID
     * @param commenterName 评论者用户名
     * @param postTitle 被评论的帖子标题
     * @param postId 被评论的帖子ID
     */
    void createCommentNotification(Integer userId, String commenterName, String postTitle, Long postId);

    /**
     * 创建回复通知
     * @param userId 被回复的用户ID
     * @param replierName 回复者用户名
     * @param postTitle 帖子标题
     * @param postId 帖子ID
     */
    void createReplyNotification(Integer userId, String replierName, String postTitle, Long postId);

    void createCollectionNotification(Integer userId, String collectorName, String postTitle, Long postId);
}