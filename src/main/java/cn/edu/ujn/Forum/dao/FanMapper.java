package cn.edu.ujn.Forum.dao;

import java.util.List;
import org.apache.ibatis.annotations.Param;

public interface FanMapper {

    void insertFollow(@Param("fanId") Integer fanId, @Param("authorId") Integer authorId);

    void deleteFollow(@Param("fanId") Integer fanId, @Param("authorId") Integer authorId);

    int isFollowing(@Param("fanId") Integer fanId, @Param("authorId") Integer authorId);

    List<Integer> getFollowingList(@Param("fanId") Integer fanId);

    List<Integer> getFollowers(@Param("authorId") Integer authorId);

    List<Fan> findFansByFanGroupId(@Param("groupId") Integer groupId);

    List<Fan> findAllFans();
}

