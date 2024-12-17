package cn.edu.ujn.Forum.service;

import cn.edu.ujn.Forum.dao.Report;
import cn.edu.ujn.Forum.dao.ReportMapper;
import cn.edu.ujn.Forum.dao.ReportType;
import cn.edu.ujn.Forum.dao.ReportTypeMapper;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Service;

import java.util.List;
@Service
public class ReportServiceImpl implements IReportService{
    @Override
    public List<Report> getReportsByUserId(int userId) {
        return reportMapper.getReportsByUserId(userId);
    }

    @Autowired
    private ReportMapper reportMapper;

    @Autowired
    private ReportTypeMapper reportTypeMapper;

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
        reportMapper.insert(report);

    }

    @Override
    public void updateReport(Report report) {
        reportMapper.updateByPrimaryKeySelective(report);

    }

    @Override
    public void deleteReport(Integer id) {
        reportMapper.deleteByPrimaryKey(id);

    }

    @Override
    public List<Report> getReportsPaged(int offset, int limit) {
        return reportMapper.selectAllPaged(offset, limit);
    }

    @Override
    public int countReports() {
        return reportMapper.countReports();
    }

    @Override
    public List<ReportType> getAllReportTypes() {
        return reportTypeMapper.selectAllReportTypes();
    }
}
