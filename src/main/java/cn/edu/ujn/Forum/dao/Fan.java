package cn.edu.ujn.Forum.dao;

import java.sql.Timestamp;

public class Fan {
    private Integer id;            // 主键ID
    private Integer fanId;         // 粉丝ID
    private Integer authorId;      // 作者ID
    private Timestamp createdAt;
    private User fan;      // 粉丝用户对象
    private User author;   // 作者用户对象// 关注时间

    // Getter 和 Setter 方法
    public Integer getId() {
        return id;
    }

    public void setId(Integer id) {
        this.id = id;
    }

    public User getFan() {
        return fan;
    }

    public void setFan(User fan) {
        this.fan = fan;
    }

    public User getAuthor() {
        return author;
    }

    public void setAuthor(User author) {
        this.author = author;
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

    @Override
    public String toString() {
        return "Fan{" +
                "id=" + id +
                ", fanId=" + fanId +
                ", authorId=" + authorId +
                ", createdAt=" + createdAt +
                ", fan=" + fan +
                ", author=" + author +
                '}';
    }
}
