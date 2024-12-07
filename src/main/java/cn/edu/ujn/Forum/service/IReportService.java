package cn.edu.ujn.Forum.service;

import cn.edu.ujn.Forum.dao.Report;
import java.util.List;

public interface IReportService {
    List<Report> getAllReports();            // 查询所有举报记录
    Report getReportById(Integer id);        // 根据主键查询举报记录
    void addReport(Report report);           // 添加举报记录
    void updateReport(Report report);        // 更新举报记录
    void deleteReportById(Integer id);       // 删除举报记录
    /**
     * 分页查询举报记录
     * @param offset 起始记录的偏移量
     * @param limit 每页显示的记录数
     * @return 分页后的举报记录列表
     */
    List<Report> getReportsPaged(int offset, int limit);

}
