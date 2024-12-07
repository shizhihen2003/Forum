package cn.edu.ujn.Forum.dao;

import cn.edu.ujn.Forum.dao.Fan;

public interface FanMapper {
    int deleteByPrimaryKey(Integer fanId);

    int insert(Fan row);

    int insertSelective(Fan row);

    Fan selectByPrimaryKey(Integer fanId);

    int updateByPrimaryKeySelective(Fan row);

    int updateByPrimaryKey(Fan row);
}