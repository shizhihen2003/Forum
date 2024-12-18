package cn.edu.ujn.Forum.dao;

public class Permission {

    private Integer permissionId;

    private String userId;

    private Integer start;

    public String getUser() {
        return user;
    }

    @Override
    public String toString() {
        return "Permission{" +
                "permissionId=" + permissionId +
                ", userId='" + userId + '\'' +
                ", start=" + start +
                ", user='" + user + '\'' +
                ", rows=" + rows +
                ", username='" + username + '\'' +
                ", targetPermission=" + targetPermission +
                '}';
    }

    public void setUser(String user) {
        this.user = user;
    }

    private String user;

    public String getUsername() {
        return username;
    }

    public void setUsername(String username) {
        this.username = username;
    }

    private Integer rows;

    private String username;

    public Permission() {
    }

    public Permission( String userId, Integer targetPermission) {

        this.userId = userId;
        this.targetPermission = targetPermission;
    }

    public Integer getPermissionId() {
        return permissionId;
    }

    public void setPermissionId(Integer permissionId) {
        this.permissionId = permissionId;
    }

    public String getUserId() {
        return userId;
    }

    public void setUserId(String userId) {
        this.userId = userId;
    }

    public Integer getTargetPermission() {
        return targetPermission;
    }

    public void setTargetPermission(Integer targetPermission) {
        this.targetPermission = targetPermission;
    }

    public Integer getStart() {
        return start;
    }

    public void setStart(Integer start) {
        this.start = start;
    }

    public Integer getRows() {
        return rows;
    }

    public void setRows(Integer rows) {
        this.rows = rows;
    }

    private Integer targetPermission;


}