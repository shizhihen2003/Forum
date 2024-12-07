package cn.edu.ujn.Forum.dao;

import cn.edu.ujn.Forum.dao.SearchRecord;

public interface SearchRecordMapper {
    int deleteByPrimaryKey(Integer searchrecordid);

    int insert(SearchRecord row);

    int insertSelective(SearchRecord row);

    SearchRecord selectByPrimaryKey(Integer searchrecordid);

    int updateByPrimaryKeySelective(SearchRecord row);

    int updateByPrimaryKey(SearchRecord row);
}