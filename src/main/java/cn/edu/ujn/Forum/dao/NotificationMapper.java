package cn.edu.ujn.Forum.dao;

import org.apache.ibatis.annotations.Param;
import java.util.List;

public interface NotificationMapper {

    /**
     * 插入新通知
     */
    int insert(Notification notification);

    /**
     * 根据ID删除通知
     */
    int deleteByPrimaryKey(Long id);

    /**
     * 根据ID选择性更新通知
     */
    int updateByPrimaryKeySelective(Notification notification);

    /**
     * 根据ID更新通知全部字段
     */
    int updateByPrimaryKey(Notification notification);

    /**
     * 根据ID查询通知
     */
    Notification selectByPrimaryKey(Long id);

    /**
     * 根据用户ID查询所有通知，按创建时间倒序排序
     */
    List<Notification> selectByUserId(@Param("userId") Long userId);

    /**
     * 统计用户未读通知数量
     */
    int countUnreadByUserId(@Param("userId") Long userId);

    /**
     * 标记用户所有通知为已读
     */
    int markAllAsRead(@Param("userId") Long userId);

    /**
     * 删除用户所有通知
     */
    int deleteByUserId(@Param("userId") Long userId);

    /**
     * 根据条件查询通知列表
     */
    List<Notification> selectByCondition(Notification notification);
}