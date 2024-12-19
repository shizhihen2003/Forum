package cn.edu.ujn.Forum.service;

import cn.edu.ujn.Forum.dao.User;
import cn.edu.ujn.Forum.util.Page;

import java.util.List;

public interface IUserService {

        // 用户注册
        void registerUser(String username, String email, String phone, String password);

        // 用户登录（通过邮箱或手机号）
        boolean login(String emailOrPhone, String password);

        // 获取当前登录用户的用户名

        // 发送验证码
        void sendVerificationCode(String phone);

        // 验证手机
        boolean verifyPhone(String phone, String verificationCode);

        // 重置密码
        void resetPassword(String resetToken, String newPassword);

        User getUserById(Integer userId);
        Page<User> selectAll(User user);

        void update(User user);

        List<User> select();

        int delete(String id);

        int insert1(String username, String email, String phone, String password);
        User selectByphone1(String phone);
        int deleteByPrimarye(int id);
    }

