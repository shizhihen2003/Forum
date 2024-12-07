package cn.edu.ujn.Forum.service;

import cn.edu.ujn.Forum.dao.Report;

import cn.edu.ujn.Forum.util.Page; // 引入Page类


import java.util.List;

public interface IReportService {
    List<Report> getAllReports();            // 查询所有举报记录
    Report getReportById(Integer id);        // 根据主键查询举报记录
    void addReport(Report report);           // 添加举报记录
    void updateReport(Report report);        // 更新举报记录
    void deleteReportById(Integer id);       // 删除举报记录
    /**
     * 分页查询举报记录
     * @param page 当前页码
     * @param size 每页显示的记录数
     * @return 分页结果，包括总记录数、当前页、每页数量和记录列表
     */
    Page<Report> getReportsPaged(int page, int size); // 返回值类型为Page<Report>

    
}
