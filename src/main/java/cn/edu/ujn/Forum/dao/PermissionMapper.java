package cn.edu.ujn.Forum.dao;

import cn.edu.ujn.Forum.dao.Permission;

public interface PermissionMapper {
    int deleteByPrimaryKey(Integer permissionid);

    int insert(Permission row);

    int insertSelective(Permission row);

    Permission selectByPrimaryKey(Integer permissionid);

    int updateByPrimaryKeySelective(Permission row);

    int updateByPrimaryKey(Permission row);
}