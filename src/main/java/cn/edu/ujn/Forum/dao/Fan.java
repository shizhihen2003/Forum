package cn.edu.ujn.Forum.dao;

import java.util.Date;

public class Fan {
    private Integer fanId;

    private String starName;

    private String fanName;

    private Date followTime;

    public Integer getFanId() {
        return fanId;
    }

    public void setFanId(Integer fanId) {
        this.fanId = fanId;
    }

    public String getStarName() {
        return starName;
    }

    public void setStarName(String starName) {
        this.starName = starName == null ? null : starName.trim();
    }

    public String getFanName() {
        return fanName;
    }

    public void setFanName(String fanName) {
        this.fanName = fanName == null ? null : fanName.trim();
    }

    public Date getFollowTime() {
        return followTime;
    }

    public void setFollowTime(Date followTime) {
        this.followTime = followTime;
    }
}