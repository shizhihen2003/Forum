package cn.edu.ujn.Forum.dao;

import org.springframework.stereotype.Component;

import java.util.Date;
@Component
public class Logs {
    private Integer userId;
    private Date loginTime;

    public Integer getUserId() {
        return userId;
    }

    public void setUserId(Integer userId) {
        this.userId = userId;
    }

    public Date getLoginTime() {
        return loginTime;
    }

    public void setLoginTime(Date loginTime) {
        this.loginTime = loginTime;
    }

    @Override
    public String toString() {
        return "Logs{" +
                "userId=" + userId +
                ", loginTime=" + loginTime +
                '}';
    }
}
