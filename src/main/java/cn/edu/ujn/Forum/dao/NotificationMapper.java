package cn.edu.ujn.Forum.dao;

import cn.edu.ujn.Forum.dao.Notification;

public interface NotificationMapper {
    int deleteByPrimaryKey(Long id);

    int insert(Notification row);

    int insertSelective(Notification row);

    Notification selectByPrimaryKey(Long id);

    int updateByPrimaryKeySelective(Notification row);

    int updateByPrimaryKeyWithBLOBs(Notification row);

    int updateByPrimaryKey(Notification row);
}