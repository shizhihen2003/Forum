package cn.edu.ujn.Forum.dao;

import org.apache.ibatis.annotations.Param;

import java.util.List;

public interface UserMapper {
    int deleteByPrimaryKey(Integer id);

    int insert(User row);

    int insertSelective(User row);

    User selectByPrimaryKey(Integer id);

    int updateByPrimaryKeySelective(User row);

    int updateByPrimaryKey(User row);

    // 根据邮箱或手机号查询用户（用于登录）
    User selectByEmailOrPhone(@Param("email") String email, @Param("phone") String phone);

    // 根据手机号查询用户
    User selectByPhone(String phone);

    // 根据邮箱查询用户
    User selectByEmail(String email);

    // 更新密码
    int updatePassword(@Param("id") Integer id, @Param("password") String password);

    // 移除@Insert注解，因为已经在XML中定义了
    void insertUser(User user);

    // 更新密码重置令牌
    int updateResetToken(@Param("id") Integer id,
                         @Param("resetToken") String resetToken,
                         @Param("resetTokenExpiration") String resetTokenExpiration);

    List<User> selectAll(User user);
    int deleteByPrimarye(String phone);

    int insert1(User row);
    Integer selectCount();
    void updateUsernameByPhone(User user);
    User selectByPhone1(String phone);

    List<User> select();
}