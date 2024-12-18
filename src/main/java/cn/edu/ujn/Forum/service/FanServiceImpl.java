package cn.edu.ujn.Forum.service;

import cn.edu.ujn.Forum.dao.Fan;
import cn.edu.ujn.Forum.dao.FanMapper;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Service;

import java.util.List;

@Service
public class FanServiceImpl implements IFanService {

    @Autowired
    private FanMapper fanMapper;

    @Override
    public void addFollow(Integer fanId, Integer authorId) {
        if (!isFollowing(fanId, authorId)) {
            fanMapper.insertFollow(fanId, authorId);
        }
    }

    @Override
    public void removeFollow(Integer fanId, Integer authorId) {
        if (isFollowing(fanId, authorId)) {
            fanMapper.deleteFollow(fanId, authorId);
        }
    }

    @Override
    public boolean isFollowing(Integer fanId, Integer authorId) {
        // 假设 fanMapper.isFollowing 返回 int 类型，1 表示已关注，0 表示未关注
        return fanMapper.isFollowing(fanId, authorId) == 1;
    }

    @Override
    public List<Integer> getFollowingList(Integer fanId) {
        return fanMapper.getFollowingList(fanId);
    }

    @Override
    public List<Integer> getFollowers(Integer authorId) {
        return fanMapper.getFollowers(authorId);
    }

    @Override
    public List<Fan> getAllFans() {
        // 调用 FanMapper 查询所有粉丝
        return fanMapper.findAllFans();
    }
}


