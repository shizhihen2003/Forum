package cn.edu.ujn.Forum.dao;

import java.sql.Timestamp;

public class Fan {
    private Integer id;            // 主键ID
    private Integer fanId;         // 粉丝ID
    private Integer authorId;      // 作者ID
    private Timestamp createdAt;   // 关注时间

    // Getter 和 Setter 方法
    public Integer getId() {
        return id;
    }

    public void setId(Integer id) {
        this.id = id;
    }

    public Integer getFanId() {
        return fanId;
    }

    public void setFanId(Integer fanId) {
        this.fanId = fanId;
    }

    public Integer getAuthorId() {
        return authorId;
    }

    public void setAuthorId(Integer authorId) {
        this.authorId = authorId;
    }

    public Timestamp getCreatedAt() {
        return createdAt;
    }

    public void setCreatedAt(Timestamp createdAt) {
        this.createdAt = createdAt;
    }

    // 重写 toString 方法，方便调试
    @Override
    public String toString() {
        return "Fan{" +
                "id=" + id +
                ", fanId=" + fanId +
                ", authorId=" + authorId +
                ", createdAt=" + createdAt +
                '}';
    }
}
