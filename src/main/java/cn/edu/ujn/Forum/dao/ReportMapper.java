package cn.edu.ujn.Forum.dao;

import cn.edu.ujn.Forum.dao.Report;
import org.apache.ibatis.annotations.Param;

import java.util.List;

public interface ReportMapper {

    List<Report> selectAll();

    int deleteByPrimaryKey(Integer id);

    int insert(Report row);

    int insertSelective(Report row);

    Report selectByPrimaryKey(Integer id);

    int updateByPrimaryKeySelective(Report row);

    int updateByPrimaryKey(Report row);


    // 统计总记录数的方法
    int countReports();

    List<Report> getReportsByUserId(@Param("userId") int userId);
}


