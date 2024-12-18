package cn.edu.ujn.Forum.dao;

import org.apache.ibatis.annotations.Mapper;

import java.util.List;

@Mapper
public interface LogsMapper {
    // 插入一条登录记录
    void insertLog(Logs logs);
    List<Logs> selectLogsByUserId(Integer userId);

}
