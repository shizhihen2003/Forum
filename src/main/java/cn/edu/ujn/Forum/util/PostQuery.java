package cn.edu.ujn.Forum.util;

public class PostQuery {
    private Long categoryId;    // 分类ID
    private Long userId;        // 用户ID
    private String keyword;     // 关键字
    private Integer status;     // 状态
    private Integer page = 1;   // 当前页码，默认第1页
    private Integer pageSize = 10;  // 每页条数，默认10条
    private Integer limit;      // 查询限制数
    private String orderBy;     // 排序规则
    private Long excludeId;     // 需要排除的帖子ID

    // 获取offset
    public Integer getOffset() {
        return (page - 1) * (limit != null ? limit : pageSize);
    }

    // 获取limit
    public Integer getLimit() {
        return limit != null ? limit : pageSize;
    }

    // Getter和Setter方法
    public Long getCategoryId() {
        return categoryId;
    }

    public void setCategoryId(Long categoryId) {
        this.categoryId = categoryId;
    }

    public Long getUserId() {
        return userId;
    }

    public void setUserId(Long userId) {
        this.userId = userId;
    }

    public String getKeyword() {
        return keyword;
    }

    public void setKeyword(String keyword) {
        this.keyword = keyword;
    }

    public Integer getStatus() {
        return status;
    }

    public void setStatus(Integer status) {
        this.status = status;
    }

    public Integer getPage() {
        return page;
    }

    public void setPage(Integer page) {
        this.page = page != null ? page : 1;
    }

    public Integer getPageSize() {
        return pageSize;
    }

    public void setPageSize(Integer pageSize) {
        this.pageSize = pageSize != null ? pageSize : 10;
    }

    public void setLimit(Integer limit) {
        this.limit = limit;
        this.pageSize = limit;  // 设置limit的同时更新pageSize
    }

    public String getOrderBy() {
        return orderBy;
    }

    public void setOrderBy(String orderBy) {
        this.orderBy = orderBy;
    }

    public Long getExcludeId() {
        return excludeId;
    }

    public void setExcludeId(Long excludeId) {
        this.excludeId = excludeId;
    }

    @Override
    public String toString() {
        return "PostQuery{" +
                "categoryId=" + categoryId +
                ", userId=" + userId +
                ", keyword='" + keyword + '\'' +
                ", status=" + status +
                ", page=" + page +
                ", pageSize=" + pageSize +
                ", limit=" + limit +
                ", orderBy='" + orderBy + '\'' +
                ", excludeId=" + excludeId +
                '}';
    }
}