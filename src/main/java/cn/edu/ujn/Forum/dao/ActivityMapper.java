package cn.edu.ujn.Forum.dao;

import cn.edu.ujn.Forum.dao.Activity;

public interface ActivityMapper {
    int deleteByPrimaryKey(Integer id);

    int insert(Activity row);

    int insertSelective(Activity row);

    Activity selectByPrimaryKey(Integer id);

    int updateByPrimaryKeySelective(Activity row);

    int updateByPrimaryKeyWithBLOBs(Activity row);

    int updateByPrimaryKey(Activity row);
}