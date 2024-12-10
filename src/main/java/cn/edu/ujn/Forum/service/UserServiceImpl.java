package cn.edu.ujn.Forum.service;

import cn.edu.ujn.Forum.dao.User;
import cn.edu.ujn.Forum.dao.UserMapper;
import org.springframework.stereotype.Service;

import java.util.Date;

@Service
public class UserServiceImpl implements IUserService{
    @Override
    public boolean verifyPhone(String phone, String verificationCode) {
        return false;
    }

    private UserMapper userMapper;

    @Override
    public void registerUser(String username, String email, String phone, String password) {
        // 检查邮箱或手机号是否已存在
        User existingUser = userMapper.selectByEmailOrPhone(email);
        if (existingUser != null) {
            throw new IllegalArgumentException("Email or phone already exists");
        }

        // 插入新用户
        User user = new User();
        user.setUsername(username);
        user.setEmail(email);
        user.setPhone(phone);
        user.setPassword(password); // 这里简化，实际应用中需要进行密码哈希处理
        userMapper.insert(user);
    }


    public String getUserGreeting(String username) {
        // 假设你通过用户名从数据库中查询用户信息，获取更多信息
        // 这里仅仅是返回一个简单的问候语
        return "Hello, " + username + "!";
    }
    @Override
    public boolean login(String emailOrPhone, String password) {
        // 根据邮箱或手机号查询用户
        User user = userMapper.selectByEmailOrPhone(emailOrPhone);
        if (user == null) {
            return false; // 用户不存在
        }

        // 校验密码，实际应用中需要对比密码的哈希
        return user.getPassword().equals(password); // 假设密码存储为明文
    }

    @Override
    public void sendVerificationCode(String phone) {


    }


    @Override
    public void resetPassword(String resetToken, String newPassword) {

        }

}
