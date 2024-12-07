package cn.edu.ujn.Forum.dao;

import cn.edu.ujn.Forum.dao.Comment;

public interface CommentMapper {
    int deleteByPrimaryKey(Long id);

    int insert(Comment row);

    int insertSelective(Comment row);

    Comment selectByPrimaryKey(Long id);

    int updateByPrimaryKeySelective(Comment row);

    int updateByPrimaryKeyWithBLOBs(Comment row);

    int updateByPrimaryKey(Comment row);
}