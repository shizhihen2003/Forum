package cn.edu.ujn.Forum.dao;

import org.apache.ibatis.annotations.Mapper;
import org.apache.ibatis.annotations.Param;

@Mapper
public interface UserProfileMapper {
    // 根据用户ID查询用户资料
    UserProfile selectByUserId(Integer userId);

    // 插入用户资料
    int insert(UserProfile userProfile);

    // 更新用户资料
    int update(UserProfile userProfile);

    // 更新头像
    int updateAvatar(@Param("userId") Integer userId, @Param("avatar") String avatar);

    // 删除用户资料
    int deleteByUserId(Integer userId);
}