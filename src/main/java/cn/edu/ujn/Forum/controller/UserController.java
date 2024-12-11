package cn.edu.ujn.Forum.controller;

import cn.edu.ujn.Forum.dao.Logs;
import cn.edu.ujn.Forum.dao.LogsMapper;
import cn.edu.ujn.Forum.dao.User;
import cn.edu.ujn.Forum.dao.UserMapper;
import cn.edu.ujn.Forum.service.ILogsService;
import cn.edu.ujn.Forum.service.UserServiceImpl;
import jakarta.servlet.http.HttpSession;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Controller;
import org.springframework.ui.Model;
import org.springframework.web.bind.annotation.*;

import java.security.Principal;
import java.util.Date;

@Controller
@RequestMapping("")
public class UserController {
    @Autowired
    private UserMapper userMapper;
    @Autowired
    private ILogsService logsService;
    @Autowired
    private UserServiceImpl userService;

    // 映射根路径，返回index.jsp页面
    @RequestMapping("/")
    public String index() {
        return "index";  // 这里不需要加文件路径，Spring 会自动映射到 WEB-INF/jsp/index.jsp
    }



    @RequestMapping("/login")
    public String showLoginPage() {
        return "login";  // 返回登录页面
    }
    // 用户登录
    @PostMapping("/login")
    public String login(@RequestParam String emailOrPhone,
                        @RequestParam String password,
                        Model model,
                        HttpSession session) {
        User user = null;

        // 判断输入的是 email 还是 phone
        if (emailOrPhone.contains("@")) {
            user = userMapper.selectByEmailOrPhone(emailOrPhone, null); // 查找邮箱
        } else {
            user = userMapper.selectByEmailOrPhone(null, emailOrPhone); // 查找手机号
        }

        if (user != null) {
            // 检查密码
            if (user.getPassword() != null && user.getPassword().equals(password)) {
                // 登录成功，将用户信息存入 Session
                session.setAttribute("loggedInUser", user);

                // 将登录信息记录到 logs 表
                Logs logs = new Logs();
                logs.setUserId(user.getId());   // 设置用户 ID
                logs.setLoginTime(new Date());  // 设置当前时间
                logsService.insertLog(logs);

                return "home"; // 重定向到主页
            } else {
                model.addAttribute("errorMessage", "Invalid email/phone or password.");
                return "login"; // 登录失败
            }
        } else {
            model.addAttribute("errorMessage", "User not found.");
            return "login"; // 用户未找到
        }
    }

    // 显示主页并将当前登录用户的用户名传递给服务层
    @GetMapping("/home")
    public String homePage(HttpSession session, Model model) {
        User user = (User) session.getAttribute("user");  // 从 session 获取用户信息
        if (user == null) {
            return "redirect:/login";  // 如果没有找到用户信息，跳转到登录页面
        }

        model.addAttribute("user", user);
        return "home";  // 用户信息存在，返回主页
    }


    // 重置密码
    @GetMapping("/reset-password")
    public String resetPasswordPage(Model model) {
        // 你可以添加用户当前的电子邮件或者用户名到模型中，便于用户查看
        return "resetPassword";  // 返回 resetPassword.jsp 页面
    }

    @GetMapping("/register")
    public String showRegistrationForm() {
        return "register";  // 返回注册页面
    }

    @PostMapping("/register")
    public String registerUser(
            @RequestParam String username,
            @RequestParam String email,
            @RequestParam String phone,
            @RequestParam String password,
            @RequestParam String verification_code,  // 验证码

            Model model) {

        // 校验手机号是否只包含数字
        if (!phone.matches("[0-9]+")) {
            model.addAttribute("error", "Phone number must contain only digits.");
            return "register";  // 如果手机号不合法，返回注册页面
        }

        // 校验验证码是否为 6 位
        if (verification_code.length() != 6) {
            model.addAttribute("error", "Verification code must be 6 digits long.");
            return "register";  // 如果验证码不符合要求，返回注册页面
        }

        // 校验其他信息（邮箱和手机号唯一性等）
        if (userMapper.selectByEmail(email) != null) {
            model.addAttribute("error", "Email is already registered.");
            return "register";
        }

        if (userMapper.selectByPhone(phone) != null) {
            model.addAttribute("error", "Phone number is already registered.");
            return "register";
        }



        // 创建新用户对象
        User newUser = new User();
        newUser.setUsername(username);
        newUser.setEmail(email);
        newUser.setPhone(phone);
        newUser.setPassword(password);
        newUser.setVerification_code(verification_code);  // 保存验证码（如果需要）

        // 输出调试日志
        System.out.println("Registering user: " + newUser);

        // 插入数据库
        userMapper.insertUser(newUser);

        model.addAttribute("message", "Registration successful, please login.");
        return "login";  // 注册成功，重定向到登录页面
    }

    @RequestMapping("/logout")
    public String logout(HttpSession session) {
        // 清除 session 中的用户数据
        session.invalidate();  // 使用 invalidate() 方法来清除整个 session
        return "redirect:/login";  // 重定向到登录页面
    }

}

