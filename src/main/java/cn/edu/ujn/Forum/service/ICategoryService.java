package cn.edu.ujn.Forum.service;

import cn.edu.ujn.Forum.dao.Category;
import java.util.List;

public interface ICategoryService {

    /**
     * 获取所有分类
     */
    List<Category> getAllCategories();

    /**
     * 根据ID获取分类
     */
    Category getCategoryById(Long id);

    /**
     * 创建分类
     */
    Category createCategory(Category category);

    /**
     * 更新分类
     */
    boolean updateCategory(Category category);

    /**
     * 删除分类
     */
    boolean deleteCategory(Long id);
}