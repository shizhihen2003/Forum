package cn.edu.ujn.Forum.service;

import cn.edu.ujn.Forum.dao.User;
import cn.edu.ujn.Forum.dao.UserMapper;
import cn.edu.ujn.Forum.util.Page;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Service;

import java.util.Date;
import java.util.List;

@Service
public class UserServiceImpl implements IUserService {
    @Autowired
    private UserMapper userMapper;

    @Override
    public boolean verifyPhone(String phone, String verificationCode) {
        return false;
    }

    @Override
    public void registerUser(String username, String email, String phone, String password) {
        // 检查邮箱或手机号是否已存在
        User existingUser = userMapper.selectByEmailOrPhone(email, phone);  // 修改这里，传入两个参数
        if (existingUser != null) {
            throw new IllegalArgumentException("Email or phone already exists");
        }

        // 插入新用户
        User user = new User();
        user.setUsername(username);
        user.setEmail(email);
        user.setPhone(phone);
        user.setPassword(password);
        userMapper.insert(user);
    }

    public String getUserGreeting(String username) {
        return "Hello, " + username + "!";
    }

    @Override
    public boolean login(String emailOrPhone, String password) {
        // 根据邮箱或手机号查询用户
        User user = userMapper.selectByEmailOrPhone(emailOrPhone, emailOrPhone); // 同时作为email和phone进行查询
        if (user == null) {
            return false; // 用户不存在
        }

        // 校验密码
        return user.getPassword().equals(password);
    }

    @Override
    public void sendVerificationCode(String phone) {
    }

    @Override
    public void resetPassword(String resetToken, String newPassword) {
    }
    @Override
    public User getUserById(Integer userId) {
        if (userId == null) {
            return null;
        }
        return userMapper.selectByPrimaryKey(userId.intValue());
    }
    @Override
    public Page<User> selectAll(User user) {

        List<User> users= userMapper.selectAll(user);
        Page<User> page = new Page<>();
        page.setPage(user.getStart());
        page.setRows(users);
        page.setSize(user.getRows());
        page.setTotal(userMapper.selectCount());
        return page;

    }


    @Override
    public User selectByphone1(String phone) {
        return userMapper.selectByPhone(phone);
    }

    @Override
    public int deleteByPrimarye(int id) {
        return userMapper.deleteByPrimaryKey(id);
    }

    @Override
    public void update(User user) {
        userMapper.updateUsernameByPhone(user);
    }

    @Override
    public List<User> select() {
        return userMapper.select();
    }

    @Override
    public int delete(String phone) {
        return userMapper.deleteByPrimarye(phone);
    }
    @Override
    public int insert1(String username, String email, String phone, String password) {

        User existingUser = userMapper.selectByPhone(email);
        if (existingUser != null) {
            throw new IllegalArgumentException("Email or phone already exists");
        }
        User user = new User();
        user.setUsername(username);
        user.setEmail(email);
        user.setPhone(phone);
        user.setPassword(password);
        return userMapper.insert1(user);
    }

}