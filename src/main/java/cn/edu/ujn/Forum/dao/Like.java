package cn.edu.ujn.Forum.dao;

import org.springframework.stereotype.Component;

@Component
public class Like {
    private Integer id;        // 主键ID
    private Integer userId;    // 用户ID
    private Integer postId;    // 帖子ID

    // Getter 和 Setter 方法
    public Integer getId() {
        return id;
    }

    public void setId(Integer id) {
        this.id = id;
    }

    public Integer getUserId() {
        return userId;
    }

    public void setUserId(Integer userId) {
        this.userId = userId;
    }

    public Integer getPostId() {
        return postId;
    }

    public void setPostId(Integer postId) {
        this.postId = postId;
    }

    // toString 方法
    @Override
    public String toString() {
        return "Like{" +
                "id=" + id +
                ", userId=" + userId +
                ", postId=" + postId +
                '}';
    }
}
