package cn.edu.ujn.Forum.dao;

import cn.edu.ujn.Forum.dao.ReportType;

import java.util.List;

public interface ReportTypeMapper {
    int deleteByPrimaryKey(Integer id);

    int insert(ReportType row);

    int insertSelective(ReportType row);

    ReportType selectByPrimaryKey(Integer id);

    int updateByPrimaryKeySelective(ReportType row);

    int updateByPrimaryKey(ReportType row);

    List<ReportType> selectAllReportTypes();
}