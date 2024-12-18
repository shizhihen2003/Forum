package cn.edu.ujn.Forum.service;



import cn.edu.ujn.Forum.dao.SearchRecord;

import java.util.List;

public interface ISearchRecordService {
    int deleteByPrimaryKey(Integer id);
    int insert(SearchRecord searchRecord);
    SearchRecord selectByPrimaryKey(Integer id);
    int updateByPrimaryKey(SearchRecord searchRecord);
    List<SearchRecord> getAllSearchRecord();
}
