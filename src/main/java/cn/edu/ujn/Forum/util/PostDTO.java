package cn.edu.ujn.Forum.util;

import java.io.Serializable;

public class PostDTO implements Serializable {
    private static final long serialVersionUID = 1L;

    private Long categoryId;     // 分类ID
    private String title;        // 标题
    private String content;      // 内容
    private String summary;      // 摘要
    private Integer status;      // 帖子状态: 0-草稿 1-已发布

    // Getter和Setter方法
    public Long getCategoryId() {
        return categoryId;
    }

    public void setCategoryId(Long categoryId) {
        this.categoryId = categoryId;
    }

    public String getTitle() {
        return title;
    }

    public void setTitle(String title) {
        this.title = title;
    }

    public String getContent() {
        return content;
    }

    public void setContent(String content) {
        this.content = content;
    }

    public String getSummary() {
        return summary;
    }

    public void setSummary(String summary) {
        this.summary = summary;
    }

    public Integer getStatus() {
        return status;
    }

    public void setStatus(Integer status) {
        this.status = status;
    }

    // 参数校验方法
    public String validate() {
        if(categoryId == null) {
            return "分类ID不能为空";
        }
        if(title == null || title.trim().isEmpty()) {
            return "标题不能为空";
        }
        if(title.length() > 200) {
            return "标题长度不能超过200字符";
        }
        if(content == null || content.trim().isEmpty()) {
            return "内容不能为空";
        }
        if(summary != null && summary.length() > 500) {
            return "摘要长度不能超过500字符";
        }
        return null;  // 返回null表示验证通过
    }

    @Override
    public String toString() {
        return "PostDTO{" +
                "categoryId=" + categoryId +
                ", title='" + title + '\'' +
                ", content='" + content + '\'' +
                ", summary='" + summary + '\'' +
                ", status=" + status +
                '}';
    }
}