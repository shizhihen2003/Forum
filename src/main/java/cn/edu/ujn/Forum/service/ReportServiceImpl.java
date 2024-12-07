package cn.edu.ujn.Forum.service;

import cn.edu.ujn.Forum.dao.Report;
import cn.edu.ujn.Forum.dao.ReportMapper;
import cn.edu.ujn.Forum.util.Page; // 引入Page工具类
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Service;

import java.util.List;

@Service
public class ReportServiceImpl implements IReportService {

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
    public Page<Report> getReportsPaged(int page, int size) { // 修改分页方法
        // 计算分页偏移量
        int offset = (page - 1) * size;

        // 查询分页数据
        List<Report> reports = reportMapper.selectAllPaged(offset, size);

        // 查询总记录数
        int total = reportMapper.countReports();


        // 封装分页结果
        Page<Report> result = new Page<>();
        result.setPage(page);    // 当前页
        result.setSize(size);    // 每页记录数
        result.setTotal(total);  // 总记录数
        result.setRows(reports); // 当前页的记录列表

        return result;
    }
}
