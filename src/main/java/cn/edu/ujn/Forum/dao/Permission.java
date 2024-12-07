package cn.edu.ujn.Forum.dao;

public class Permission {
    private Integer permissionid;

    private String userid;

    private Integer targetpermission;

    public Integer getPermissionid() {
        return permissionid;
    }

    public void setPermissionid(Integer permissionid) {
        this.permissionid = permissionid;
    }

    public String getUserid() {
        return userid;
    }

    public void setUserid(String userid) {
        this.userid = userid == null ? null : userid.trim();
    }

    public Integer getTargetpermission() {
        return targetpermission;
    }

    public void setTargetpermission(Integer targetpermission) {
        this.targetpermission = targetpermission;
    }
}