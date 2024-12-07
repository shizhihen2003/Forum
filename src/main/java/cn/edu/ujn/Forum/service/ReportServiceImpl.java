package cn.edu.ujn.Forum.service;

import cn.edu.ujn.Forum.dao.Report;
import cn.edu.ujn.Forum.dao.ReportMapper;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Service;

import java.util.List;
@Service
public class ReportServiceImpl implements IReportService{

    @Autowired
    private ReportMapper reportMapper;
    @Override
    public List<Report> getAllReports() {
        return reportMapper.selectAll();
    }

    @Override
    public Report getReportById(Integer id) {
        return reportMapper.selectByPrimaryKey(id);
    }

    @Override
    public void addReport(Report report) {
        reportMapper.insertSelective(report);

    }

    @Override
    public void updateReport(Report report) {
        reportMapper.updateByPrimaryKeySelective(report);

    }

    @Override
    public void deleteReportById(Integer id) {
        reportMapper.deleteByPrimaryKey(id);

    }

    @Override
    public List<Report> getReportsPaged(int offset, int limit) {
        return reportMapper.selectAllPaged(offset, limit);
    }
}
