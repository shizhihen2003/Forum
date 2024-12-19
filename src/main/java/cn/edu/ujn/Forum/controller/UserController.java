package cn.edu.ujn.Forum.controller;

import cn.edu.ujn.Forum.dao.*;
import cn.edu.ujn.Forum.service.ILogsService;
import cn.edu.ujn.Forum.service.IPostService;
import cn.edu.ujn.Forum.service.UserServiceImpl;
import cn.edu.ujn.Forum.util.PageResult;
import cn.edu.ujn.Forum.util.PostQuery;
import cn.edu.ujn.Forum.util.Result;
import jakarta.servlet.ServletContext;
import jakarta.servlet.http.HttpServletRequest;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Controller;
import org.springframework.ui.Model;
import org.springframework.web.bind.annotation.*;
import org.springframework.web.multipart.MultipartFile;
import jakarta.servlet.http.HttpSession;

import java.io.IOException;
import java.nio.file.Files;
import java.nio.file.Path;
import java.nio.file.Paths;
import java.util.Date;
import java.util.List;

@Controller
@RequestMapping("")
public class UserController {
    @Autowired
    private UserMapper userMapper;
    @Autowired
    private ILogsService logsService;
    @Autowired
    private UserServiceImpl userService;
    @Autowired
    private UserProfileMapper userProfileMapper;

    @Autowired
    private ServletContext servletContext;

    @Autowired
    private IPostService postService;

    // 映射根路径，返回index.jsp页面
    @RequestMapping(value = {"/", "/index"})
    public String index(Model model) {
        return "index";  // 返回 WEB-INF/jsp/index.jsp
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
                        HttpSession session,
                        HttpServletRequest request) {
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
                String contextPath = request.getContextPath();  // 获取上下文路径
                // 获取用户资料
                UserProfile userProfile = userProfileMapper.selectByUserId(user.getId());
                if (userProfile == null) {
                    // 如果没有资料，创建默认资料
                    userProfile = new UserProfile();
                    userProfile.setUserId(user.getId());
                    userProfile.setNickname(user.getUsername());
                    userProfile.setAvatar(contextPath + "/static/upload/avatars/default-avatar.jpg");
                    userProfile.setCreateTime(new Date());
                    userProfile.setUpdateTime(new Date());
                    userProfileMapper.insert(userProfile);
                }

                // 将用户信息和资料都存入 session
                session.setAttribute("loggedInUser", user);
                session.setAttribute("userProfile", userProfile);

                // 将登录信息记录到 logs 表
                Logs logs = new Logs();
                logs.setUserId(user.getId());   // 设置用户 ID
                logs.setLoginTime(new Date());  // 设置当前时间
                logsService.insertLog(logs);

                return "redirect:home"; // 重定向到主页
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
        // 将 "user" 改为 "loggedInUser" 以匹配登录时存储的属性名
        User user = (User) session.getAttribute("loggedInUser");
        if (user == null) {
            return "redirect:/login";
        }


        // 获取用户的所有帖子
        PostQuery query = new PostQuery();
        query.setUserId(user.getId().longValue());
        PageResult<Post> userPosts = postService.getPostList(query);

        // 将帖子列表和用户信息添加到model
        model.addAttribute("posts", userPosts.getList());

        // 使用正确的属性名将用户信息添加到模型中
        model.addAttribute("loggedInUser", user); // 这里也改为 loggedInUser 以保持一致
        return "home";
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
        return "redirect:/post";  // 重定向到登录页面
    }


    @PostMapping("/uploadAvatar")
    @ResponseBody
    public Result<String> uploadAvatar(@RequestParam("file") MultipartFile file,
                                       HttpSession session,
                                       HttpServletRequest request) {
        try {
            User currentUser = (User) session.getAttribute("loggedInUser");
            if (currentUser == null) {
                return Result.fail("用户未登录");
            }

            // 检查文件类型
            String contentType = file.getContentType();
            if (contentType == null || !contentType.startsWith("image/")) {
                return Result.fail("只能上传图片文件");
            }

            // 获取上传目录的真实路径
            String projectPath = servletContext.getRealPath("/");
            String uploadDir = projectPath + "static/upload/avatars";
            Path uploadPath = Paths.get(uploadDir);

            // 如果目录不存在则创建
            if (!Files.exists(uploadPath)) {
                Files.createDirectories(uploadPath);
            }

            // 生成文件名
            String originalFilename = file.getOriginalFilename();
            String extension = originalFilename.substring(originalFilename.lastIndexOf("."));
            String fileName = "avatar_" + currentUser.getId() + "_" + System.currentTimeMillis() + extension;

            // 创建完整的文件路径
            Path filePath = uploadPath.resolve(fileName);

            // 保存文件
            Files.copy(file.getInputStream(), filePath);

            // 更新用户头像信息
            String contextPath = request.getContextPath();
            String avatarUrl = contextPath + "/static/upload/avatars/" + fileName;

            // 查询用户资料
            UserProfile profile = userProfileMapper.selectByUserId(currentUser.getId());
            if (profile == null) {
                // 如果不存在则创建新的用户资料
                profile = new UserProfile();
                profile.setUserId(currentUser.getId());
                profile.setAvatar(avatarUrl);
                profile.setNickname(currentUser.getUsername());
                userProfileMapper.insert(profile);
                // 添加到 session
                session.setAttribute("userProfile", profile);
            } else {
                // 更新现有用户资料的头像
                profile.setAvatar(avatarUrl);  // 先更新对象
                userProfileMapper.updateAvatar(currentUser.getId(), avatarUrl);
                // 更新 session 中的用户资料
                session.setAttribute("userProfile", profile);

                // 删除旧头像文件
                if (profile.getAvatar() != null) {
                    String oldAvatarPath = servletContext.getRealPath(profile.getAvatar());
                    Path oldFilePath = Paths.get(oldAvatarPath);
                    if (Files.exists(oldFilePath)) {
                        Files.delete(oldFilePath);
                    }
                }
            }

            return Result.success(avatarUrl);
        } catch (IOException e) {
            return Result.fail("头像上传失败：" + e.getMessage());
        }
    }
    @GetMapping("/logs")
    public String viewLoginLogs(HttpSession session, Model model) {
        // 从 session 中获取当前登录的用户信息
        User user = (User) session.getAttribute("loggedInUser");

        // 如果用户未登录，重定向到登录页面
        if (user == null) {
            return "redirect:/login";
        }

        // 获取当前用户的登录记录
        List<Logs> loginLogs = logsService.getLogsByUserId(user.getId());



        // 将登录记录传递给模型
        model.addAttribute("loginLogs", loginLogs);

        // 将当前登录用户的用户名传递给 JSP 页面
        model.addAttribute("loggedInUser", user);

        return "logs";  // 返回 logs.jsp 页面
    }
    @PostMapping("/editProfile")
    @ResponseBody
    public Result<String> editProfile(
            @RequestParam String username,
            @RequestParam(required = false) String bio,
            @RequestParam(required = false) String location,
            HttpSession session) {

        User currentUser = (User) session.getAttribute("loggedInUser");
        if (currentUser == null) {
            return Result.fail("请先登录");
        }

        try {
            // 更新用户基本信息
            currentUser.setUsername(username);
            userMapper.updateByPrimaryKeySelective(currentUser);

            // 更新用户详细资料
            UserProfile profile = userProfileMapper.selectByUserId(currentUser.getId());
            if (profile == null) {
                profile = new UserProfile();
                profile.setUserId(currentUser.getId());
                profile.setBio(bio);
                profile.setLocation(location);
                profile.setCreateTime(new Date());
                profile.setUpdateTime(new Date());
                userProfileMapper.insert(profile);
            } else {
                profile.setBio(bio);
                profile.setLocation(location);
                profile.setUpdateTime(new Date());
                userProfileMapper.update(profile);
            }

            // 更新 session 中的信息
            session.setAttribute("loggedInUser", currentUser);
            session.setAttribute("userProfile", profile);

            return Result.success("资料更新成功");
        } catch (Exception e) {
            e.printStackTrace();
            return Result.fail("更新失败：" + e.getMessage());
        }
    }
}

