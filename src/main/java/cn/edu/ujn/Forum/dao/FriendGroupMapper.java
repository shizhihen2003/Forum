package cn.edu.ujn.Forum.dao;

import cn.edu.ujn.Forum.dao.FriendGroup;

public interface FriendGroupMapper {
    int deleteByPrimaryKey(Integer id);

    int insert(FriendGroup row);

    int insertSelective(FriendGroup row);

    FriendGroup selectByPrimaryKey(Integer id);

    int updateByPrimaryKeySelective(FriendGroup row);

    int updateByPrimaryKey(FriendGroup row);
}