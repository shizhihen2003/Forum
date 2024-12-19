package cn.edu.ujn.Forum.service;

import cn.edu.ujn.Forum.dao.Permission;
import cn.edu.ujn.Forum.dao.PermissionMapper;
import cn.edu.ujn.Forum.util.Page;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Service;

import java.util.List;
@Service
public class PermissionServiceImpl implements IPermissionService{

    @Autowired
    private PermissionMapper permissionMapper;
    @Override
    public int deleteByPrimaryKey(String id) {
        return permissionMapper.deleteByPrimaryKey(id);
    }

    @Override
    public int insert(Permission permission) {
        return permissionMapper.insert(permission);
    }

    @Override
    public Permission selectByPrimaryKey(Integer id) {
        return permissionMapper.selectByPrimaryKey(id);
    }

    @Override
    public int updateByPrimaryKey(Permission permission) {
        return permissionMapper.updateByPrimaryKey(permission);
    }

    @Override
    public List<Permission> getAllPermission() {
        return permissionMapper.selectAll1();
    }

    @Override
    public Page<Permission> selectAll(Permission permission) {
        List<Permission> permissions = permissionMapper.selectAll(permission);
        Page<Permission> page = new Page<>();
        page.setPage(permission.getStart());
        page.setRows(permissions);
        page.setSize(permission.getRows());
        page.setTotal(permissionMapper.selectCount());
        return page;
    }
    @Override
    public List<Permission> selectAll1() {
return permissionMapper.selectAll1();



    }

    @Override
    public int selecttarget(String id) {
        return permissionMapper.selectById(id);
    }

    @Override
    public int updateByPhone(Permission permission) {
        return permissionMapper.updateByPhone(permission);
    }

    @Override
    public Permission updateByUserId(String userId) {
        return permissionMapper.selectByuserId(userId);
    }


}



