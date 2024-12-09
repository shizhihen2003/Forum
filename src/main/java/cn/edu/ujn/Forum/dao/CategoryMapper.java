package cn.edu.ujn.Forum.dao;

import org.apache.ibatis.annotations.Param;
import java.util.List;

public interface CategoryMapper {

    Category selectById(@Param("id") Long id);

    List<Category> selectList();

    int insert(Category category);

    int update(Category category);

    int deleteById(@Param("id") Long id);
}