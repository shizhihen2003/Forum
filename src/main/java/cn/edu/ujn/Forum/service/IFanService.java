package cn.edu.ujn.Forum.service;

import cn.edu.ujn.Forum.dao.Fan;

import java.util.List;

public interface IFanService {

    void addFollow(Integer fanId, Integer authorId);

    void removeFollow(Integer fanId, Integer authorId);

    boolean isFollowing(Integer fanId, Integer authorId);

    List<Integer> getFollowingList(Integer fanId);
    // 获取当前用户关注的作者列表
    List<Integer> getFollowers(Integer authorId);  // 获取某作者的粉丝列表
}
