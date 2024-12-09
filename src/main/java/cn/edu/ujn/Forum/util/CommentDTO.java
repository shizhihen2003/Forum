package cn.edu.ujn.Forum.util;

import java.io.Serializable;

/**
 * 评论数据传输对象
 * @author [你的名字]
 */
public class CommentDTO implements Serializable {
    private static final long serialVersionUID = 1L;

    private Long postId;      // 帖子ID
    private Long parentId;    // 父评论ID
    private String content;   // 评论内容

    // Getter和Setter方法
    public Long getPostId() {
        return postId;
    }

    public void setPostId(Long postId) {
        this.postId = postId;
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

    // 参数校验方法
    public String validate() {
        if(postId == null) {
            return "帖子ID不能为空";
        }
        if(content == null || content.trim().isEmpty()) {
            return "评论内容不能为空";
        }
        if(content.length() > 1000) {
            return "评论内容不能超过1000字符";
        }
        return null;  // 返回null表示验证通过
    }

    @Override
    public String toString() {
        return "CommentDTO{" +
                "postId=" + postId +
                ", parentId=" + parentId +
                ", content='" + content + '\'' +
                '}';
    }
}