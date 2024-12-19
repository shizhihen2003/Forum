package cn.edu.ujn.Forum.service;

import cn.edu.ujn.Forum.dao.Permission;
import cn.edu.ujn.Forum.util.Page;

import java.util.List;

public interface IPermissionService {

    int deleteByPrimaryKey(String id);
    int insert(Permission permission);
    Permission selectByPrimaryKey(Integer id);
    int updateByPrimaryKey(Permission permission);
    List<Permission> getAllPermission();
    Page<Permission> selectAll(Permission permission);
    List<Permission> selectAll1();
    int selecttarget(String id);

    int updateByPhone(Permission permission);

    Permission updateByUserId(String userId);

}
