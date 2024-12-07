package cn.edu.ujn.Forum.dao;

import cn.edu.ujn.Forum.dao.Report;

public interface ReportMapper {
    int deleteByPrimaryKey(Integer id);

    int insert(Report row);

    int insertSelective(Report row);

    Report selectByPrimaryKey(Integer id);

    int updateByPrimaryKeySelective(Report row);

    int updateByPrimaryKey(Report row);
}