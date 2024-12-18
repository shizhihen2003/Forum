package cn.edu.ujn.Forum.dao;

import java.util.List;

public interface SearchRecordMapper {
    int deleteByPrimaryKey(Integer searchrecordid);

    int insert(SearchRecord row);

    int insertSelective(SearchRecord row);

    SearchRecord selectByPrimaryKey(Integer searchrecordid);

    int updateByPrimaryKeySelective(SearchRecord row);

    int updateByPrimaryKey(SearchRecord row);
    List<SearchRecord> selectAll();
}