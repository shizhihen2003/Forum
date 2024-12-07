package cn.edu.ujn.Forum.dao;

import cn.edu.ujn.Forum.dao.File;

public interface FileMapper {
    int deleteByPrimaryKey(Long id);

    int insert(File row);

    int insertSelective(File row);

    File selectByPrimaryKey(Long id);

    int updateByPrimaryKeySelective(File row);

    int updateByPrimaryKey(File row);
}