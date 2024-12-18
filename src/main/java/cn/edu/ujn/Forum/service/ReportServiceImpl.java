package cn.edu.ujn.Forum.service;

// 导入必要的类和接口
import cn.edu.ujn.Forum.dao.Report; // 导入 Report 实体类，用于处理举报记录
import cn.edu.ujn.Forum.dao.ReportMapper; // 导入 ReportMapper，用于数据库操作
import cn.edu.ujn.Forum.dao.ReportType; // 导入 ReportType 实体类，用于处理举报类型
import cn.edu.ujn.Forum.dao.ReportTypeMapper; // 导入 ReportTypeMapper，用于数据库操作
import org.springframework.beans.factory.annotation.Autowired; // 用于依赖注入
import org.springframework.stereotype.Service; // 标识为服务层组件

import java.util.List;

/**
 * Service 层实现类 - ReportServiceImpl
 * 负责处理与举报（Report）相关的业务逻辑。
 * 实现了 IReportService 接口，提供举报记录的增删改查操作。
 */
@Service // 标识该类为 Spring 服务组件，便于 Spring 容器管理
public class ReportServiceImpl implements IReportService {

    @Autowired // 自动注入 ReportMapper，用于与数据库交互
    private ReportMapper reportMapper;

    @Autowired // 自动注入 ReportTypeMapper，用于处理举报类型相关的数据库操作
    private ReportTypeMapper reportTypeMapper;

    /**
     * 根据用户ID获取该用户的所有举报记录。
     *
     * @param userId 用户的ID
     * @return 用户的举报记录列表
     */
    @Override
    public List<Report> getReportsByUserId(int userId) {
        return reportMapper.getReportsByUserId(userId);
    }


    /**
     * 获取所有举报记录。
     *
     * @return 所有举报记录的列表
     */
    @Override
    public List<Report> getAllReports() {
        return reportMapper.selectAll();
    }

    /**
     * 根据举报记录的ID获取具体的举报记录。
     *
     * @param id 举报记录的ID
     * @return 对应的举报记录对象，如果不存在则返回null
     */
    @Override
    public Report getReportById(Integer id) {
        return reportMapper.selectByPrimaryKey(id);
    }

    /**
     * 添加一条新的举报记录。
     *
     * @param report 要添加的举报记录对象
     */
    @Override
    public void addReport(Report report) {
        reportMapper.insert(report);
    }

    /**
     * 更新现有的举报记录。
     * 仅更新非空字段。
     *
     * @param report 要更新的举报记录对象
     */
    @Override
    public void updateReport(Report report) {
        reportMapper.updateByPrimaryKeySelective(report);
    }

    /**
     * 删除指定ID的举报记录。
     *
     * @param id 要删除的举报记录的ID
     */
    @Override
    public void deleteReport(Integer id) {
        reportMapper.deleteByPrimaryKey(id);
    }


    /**
     * 统计举报记录的总数。
     *
     * @return 举报记录的总数
     */
    @Override
    public int countReports() {
        return reportMapper.countReports();
    }

    /**
     * 获取所有举报类型。
     *
     * @return 所有举报类型的列表
     */
    @Override
    public List<ReportType> getAllReportTypes() {
        return reportTypeMapper.selectAllReportTypes();
    }
}
