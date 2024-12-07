package cn.edu.ujn.Forum.dao;

import cn.edu.ujn.Forum.dao.Post;

public interface PostMapper {
    int deleteByPrimaryKey(Long id);

    int insert(Post row);

    int insertSelective(Post row);

    Post selectByPrimaryKey(Long id);

    int updateByPrimaryKeySelective(Post row);

    int updateByPrimaryKeyWithBLOBs(Post row);

    int updateByPrimaryKey(Post row);
}