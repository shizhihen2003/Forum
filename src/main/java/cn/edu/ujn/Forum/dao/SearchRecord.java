package cn.edu.ujn.Forum.dao;

public class SearchRecord {
    private Integer searchrecordid;

    private String userid;

    private Integer searchtime;

    private Integer permissionid;

    public Integer getSearchrecordid() {
        return searchrecordid;
    }

    public void setSearchrecordid(Integer searchrecordid) {
        this.searchrecordid = searchrecordid;
    }

    public String getUserid() {
        return userid;
    }

    public void setUserid(String userid) {
        this.userid = userid == null ? null : userid.trim();
    }

    public Integer getSearchtime() {
        return searchtime;
    }

    public void setSearchtime(Integer searchtime) {
        this.searchtime = searchtime;
    }

    public Integer getPermissionid() {
        return permissionid;
    }

    public void setPermissionid(Integer permissionid) {
        this.permissionid = permissionid;
    }
}