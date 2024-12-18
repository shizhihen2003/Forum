package cn.edu.ujn.Forum.service;

import cn.edu.ujn.Forum.dao.SearchRecord;
import cn.edu.ujn.Forum.dao.SearchRecordMapper;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Service;

import java.util.List;
@Service
public class SearchRecordServiceImpl implements ISearchRecordService{
    @Autowired
    private SearchRecordMapper searchRecordMapper;
    @Override
    public int deleteByPrimaryKey(Integer id) {
        return searchRecordMapper.deleteByPrimaryKey(id);
    }

    @Override
    public int insert(SearchRecord searchRecord) {
        return searchRecordMapper.insert(searchRecord);
    }

    @Override
    public SearchRecord selectByPrimaryKey(Integer id) {
        return searchRecordMapper.selectByPrimaryKey(id);
    }

    @Override
    public int updateByPrimaryKey(SearchRecord searchRecord) {
        return searchRecordMapper.updateByPrimaryKey(searchRecord);
    }

    @Override
    public List<SearchRecord> getAllSearchRecord() {
        return searchRecordMapper.selectAll();
    }
}
