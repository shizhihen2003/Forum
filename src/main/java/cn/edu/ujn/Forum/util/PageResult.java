package cn.edu.ujn.Forum.util;

import java.util.List;

public class PageResult<T> {
    private List<T> list;      // 数据列表
    private int total;         // 总记录数
    private int pages;         // 总页数
    private int current;       // 当前页
    private int pageSize;      // 每页记录数

    public PageResult() {
    }

    public PageResult(List<T> list, int total, int current, int pageSize) {
        this.list = list;
        this.total = total;
        this.current = current;
        this.pageSize = pageSize;
        this.pages = (total + pageSize - 1) / pageSize;  // 计算总页数
    }

    // getter和setter方法
    public List<T> getList() {
        return list;
    }

    public void setList(List<T> list) {
        this.list = list;
    }

    public int getTotal() {
        return total;
    }

    public void setTotal(int total) {
        this.total = total;
    }

    public int getPages() {
        return pages;
    }

    public void setPages(int pages) {
        this.pages = pages;
    }

    public int getCurrent() {
        return current;
    }

    public void setCurrent(int current) {
        this.current = current;
    }

    public int getPageSize() {
        return pageSize;
    }

    public void setPageSize(int pageSize) {
        this.pageSize = pageSize;
    }

    // 是否有上一页
    public boolean hasPrevious() {
        return current > 1;
    }

    // 是否有下一页
    public boolean hasNext() {
        return current < pages;
    }

    @Override
    public String toString() {
        return "PageResult{" +
                "total=" + total +
                ", pages=" + pages +
                ", current=" + current +
                ", pageSize=" + pageSize +
                ", list.size=" + (list != null ? list.size() : 0) +
                '}';
    }
}