package cn.edu.ujn.Forum.service;

import cn.edu.ujn.Forum.dao.Logs;
import cn.edu.ujn.Forum.dao.LogsMapper;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Service;

@Service
public class LogsServiceImpl implements ILogsService{

    private final LogsMapper logsMapper;

    @Autowired
    public LogsServiceImpl(LogsMapper logsMapper) {
        this.logsMapper = logsMapper;
    }



    @Override
    public void insertLog(Logs logs) {
        logsMapper.insertLog(logs); // 调用 Mapper 方法插入日志
    }
}
