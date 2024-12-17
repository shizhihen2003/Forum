package cn.edu.ujn.Forum.dao;

import java.util.Date;
import java.util.List;

public class Comment {
    private Long id;
    private Long postId;
    private Long userId;
    private Long parentId;
    private String content;
    private Integer likeCount;
    private Integer status;
    private Date createTime;
    private Date updateTime;

    // 关联属性
    private User author;
    private List<Comment> children;

    // 基本属性的 getters 和 setters
    public Long getId() {
        return id;
    }

    public void setId(Long id) {
        this.id = id;
    }

    public Long getPostId() {
        return postId;
    }

    public void setPostId(Long postId) {
        this.postId = postId;
    }

    public Long getUserId() {
        return userId;
    }

    public void setUserId(Long userId) {
        this.userId = userId;
    }

    public Long getParentId() {
        return parentId;
    }

    public void setParentId(Long parentId) {
        this.parentId = parentId;
    }

    public String getContent() {
        return content;
    }

    public void setContent(String content) {
        this.content = content;
    }

    public Integer getLikeCount() {
        return likeCount;
    }

    public void setLikeCount(Integer likeCount) {
        this.likeCount = likeCount;
    }

    public Integer getStatus() {
        return status;
    }

    public void setStatus(Integer status) {
        this.status = status;
    }

    public Date getCreateTime() {
        return createTime;
    }

    public void setCreateTime(Date createTime) {
        this.createTime = createTime;
    }

    public Date getUpdateTime() {
        return updateTime;
    }

    public void setUpdateTime(Date updateTime) {
        this.updateTime = updateTime;
    }

    // 关联属性的 getters 和 setters
    public User getAuthor() {
        return author;
    }

    public void setAuthor(User author) {
        this.author = author;
    }

    public List<Comment> getChildren() {
        return children;
    }

    public void setChildren(List<Comment> children) {
        this.children = children;
    }

    // 辅助方法，用于在JSP中获取作者信息
    public String getAuthorName() {
        if (author != null) {
            if (author.getProfile() != null && author.getProfile().getNickname() != null) {
                return author.getProfile().getNickname();
            }
            return author.getUsername();
        }
        return "匿名用户";
    }

    public String getAuthorAvatar() {
        if (author != null && author.getProfile() != null && author.getProfile().getAvatar() != null) {
            return author.getProfile().getAvatar();
        }
        return "/static/upload/avatars/default-avatar.jpg";
    }
}