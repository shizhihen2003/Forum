package cn.edu.ujn.Forum.dao;

import java.sql.Timestamp;

public class FanGroup {
    private Integer groupId;   // 分组ID
    private Integer userId;    // 用户ID
    private String groupName;  // 分组名称
    private Timestamp createdAt; // 创建时间

    // Getter and Setter Methods
    public Integer getGroupId() {
        return groupId;
    }

    public void setGroupId(Integer groupId) {
        this.groupId = groupId;
    }

    public Integer getUserId() {
        return userId;
    }

    public void setUserId(Integer userId) {
        this.userId = userId;
    }

    public String getGroupName() {
        return groupName;
    }

    public void setGroupName(String groupName) {
        this.groupName = groupName;
    }

    public Timestamp getCreatedAt() {
        return createdAt;
    }

    public void setCreatedAt(Timestamp createdAt) {
        this.createdAt = createdAt;
    }
}
