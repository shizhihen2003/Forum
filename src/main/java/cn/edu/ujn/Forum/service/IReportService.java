package cn.edu.ujn.Forum.service;

import cn.edu.ujn.Forum.dao.Report;
import cn.edu.ujn.Forum.dao.ReportType;

import java.util.List;

/**
 * 服务层接口 - IReportService
 * 提供与举报（Report）相关的业务操作方法。
 */
public interface IReportService {

    /**
     * 获取所有举报记录。
     *
     * @return 包含所有 Report 对象的列表。
     */
    List<Report> getAllReports();

    /**
     * 根据主键 ID 获取指定的举报记录。
     *
     * @param id 举报记录的主键 ID。
     * @return 对应的 Report 对象，如果不存在则返回 null。
     */
    Report getReportById(Integer id);

    /**
     * 添加一个新的举报记录。
     *
     * @param report 要添加的 Report 对象。
     */
    void addReport(Report report);

    /**
     * 更新现有的举报记录。
     *
     * @param report 要更新的 Report 对象，需包含有效的 ID。
     */
    void updateReport(Report report);

    /**
     * 删除指定的举报记录。
     *
     * @param id 要删除的举报记录的 ID。
     */
    void deleteReport(Integer id);

    /**
     * 统计举报记录总数。
     *
     * @return 举报记录的总数。
     */
    int countReports();

    List<ReportType> getAllReportTypes();

    List<Report> getReportsByUserId(int userId);



}
