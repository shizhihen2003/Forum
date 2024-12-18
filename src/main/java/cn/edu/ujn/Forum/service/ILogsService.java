package cn.edu.ujn.Forum.service;

import cn.edu.ujn.Forum.dao.Logs;

import java.util.List;

public interface ILogsService {
    void insertLog(Logs logs);

    List<Logs> getLogsByUserId(Integer userId);
}
