package cn.edu.ujn.Forum.dao;

import org.apache.ibatis.annotations.Mapper;

@Mapper
public interface LogsMapper {
    // 插入一条登录记录
    void insertLog(Logs logs);
}
