package cn.edu.ujn.Forum.dao;

import java.util.List;

public interface PermissionMapper {
    int deleteByPrimaryKey(String userId);

    int insert(Permission row);

    int insertSelective(Permission row);

    Permission selectByPrimaryKey(Integer permissionId);

    int updateByPrimaryKeySelective(Permission row);

    int updateByPrimaryKey(Permission row);

    List<Permission> selectAll1();
    List<Permission> selectAll(Permission permission);
    Integer selectCount();

    int selectById(String id);

    int updateByPhone(Permission permission);
    Permission selectByuserId(String userId);

}