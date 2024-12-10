package cn.edu.ujn.Forum.dao;

import cn.edu.ujn.Forum.dao.User;
import org.apache.ibatis.annotations.Insert;
import org.apache.ibatis.annotations.Param;

public interface UserMapper {
    int deleteByPrimaryKey(Integer id);

    int insert(User row);

    int insertSelective(User row);

    User selectByPrimaryKey(Integer id);

    int updateByPrimaryKeySelective(User row);

    int updateByPrimaryKey(User row);

    // 根据邮箱或手机号查询用户（用于登录）
    User selectByEmailOrPhone(String emailOrPhone);

    // 根据手机号查询用户（用于验证手机号）
    User selectByPhone(String phone);

    // 根据邮箱查询用户
    User selectByEmail(String email);

    // 更新密码
    int updatePassword(Integer id, String passwordHash);

    // 插入新用户
    @Insert("INSERT INTO users (username, email, phone, password, verification_code) VALUES (#{username}, #{email}, #{phone}, #{password}, #{verification_code})")
    void insertUser(User user);

    // 更新密码重置令牌
    int updateResetToken(Integer id, String resetToken, String resetTokenExpiration);
    User selectByEmailOrPhone(@Param("email") String email, @Param("phone") String phone);
}