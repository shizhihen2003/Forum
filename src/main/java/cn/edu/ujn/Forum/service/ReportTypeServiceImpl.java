package cn.edu.ujn.Forum.service;

import cn.edu.ujn.Forum.dao.ReportType;
import cn.edu.ujn.Forum.dao.ReportTypeMapper;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Service;

import java.util.List;

@Service
public class ReportTypeServiceImpl implements IReportTypeService{
    @Autowired
    private ReportTypeMapper reportTypeMapper;
    @Override
    public List<ReportType> getAllReportTypes() {
        return reportTypeMapper.selectAllReportTypes();
    }

    @Override
    public ReportType getReportTypeById(Integer id) {
        return reportTypeMapper.selectByPrimaryKey(id);
    }
}
