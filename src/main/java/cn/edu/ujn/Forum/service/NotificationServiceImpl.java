package cn.edu.ujn.Forum.service;

import cn.edu.ujn.Forum.dao.Notification;
import cn.edu.ujn.Forum.dao.NotificationMapper;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Service;
import org.springframework.transaction.annotation.Transactional;

import java.util.Date;
import java.util.List;

@Service
public class NotificationServiceImpl implements INotificationService {

    @Autowired
    private NotificationMapper notificationMapper;

    @Override
    public List<Notification> getUserNotifications(Integer userId) {
        return notificationMapper.selectByUserId(userId.longValue());
    }

    @Override
    @Transactional
    public void createNotification(Integer userId, String type, String title, String content) {
        Notification notification = new Notification();
        notification.setUserId(userId.longValue());
        notification.setType(type);
        notification.setTitle(title);
        notification.setContent(content);
        notification.setIsRead(false);
        notification.setCreatedAt(new Date());
        notificationMapper.insert(notification);
    }

    @Override
    @Transactional
    public boolean markAsRead(Long id) {
        Notification notification = notificationMapper.selectByPrimaryKey(id);
        if (notification == null) {
            return false;
        }
        notification.setIsRead(true);
        return notificationMapper.updateByPrimaryKeySelective(notification) > 0;
    }

    @Override
    public int getUnreadCount(Integer userId) {
        return notificationMapper.countUnreadByUserId(userId.longValue());
    }

    @Override
    @Transactional
    public boolean markAllAsRead(Integer userId) {
        return notificationMapper.markAllAsRead(userId.longValue()) > 0;
    }

    @Override
    @Transactional
    public boolean deleteNotification(Long id) {
        return notificationMapper.deleteByPrimaryKey(id) > 0;
    }

    @Override
    @Transactional
    public void createLikeNotification(Integer userId, String likerName, String postTitle, Long postId) {
        String title = "收到新的点赞";
        String content = String.format("用户 %s 点赞了你的帖子《%s》", likerName, postTitle);
        createNotification(userId, "like", title, content);
    }

    @Override
    @Transactional
    public void createCommentNotification(Integer userId, String commenterName, String postTitle, Long postId) {
        String title = "收到新的评论";
        String content = String.format("用户 %s 评论了你的帖子《%s》", commenterName, postTitle);
        createNotification(userId, "comment", title, content);
    }

    @Override
    @Transactional
    public void createReplyNotification(Integer userId, String replierName, String postTitle, Long postId) {
        String title = "收到新的回复";
        String content = String.format("用户 %s 回复了你在帖子《%s》中的评论", replierName, postTitle);
        createNotification(userId, "reply", title, content);
    }
}