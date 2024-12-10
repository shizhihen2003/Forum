package cn.edu.ujn.Forum.service;

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
    }

