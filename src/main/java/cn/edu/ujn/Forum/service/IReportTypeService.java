package cn.edu.ujn.Forum.service;

import cn.edu.ujn.Forum.dao.ReportType;

import java.util.List;

/**
 * 服务层接口 - IReportTypeService
 * 提供与举报类型（ReportType）相关的读取操作方法。
 */
public interface IReportTypeService {

    /**
     * 获取所有举报类型。
     *
     * @return 包含所有 ReportType 对象的列表。
     */
    List<ReportType> getAllReportTypes();

    /**
     * 根据主键 ID 获取指定的举报类型。
     *
     * @param id 举报类型的主键 ID。
     * @return 对应的 ReportType 对象，如果不存在则返回 null。
     */
    ReportType getReportTypeById(Integer id);
}
