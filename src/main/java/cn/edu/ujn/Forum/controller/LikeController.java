package cn.edu.ujn.Forum.controller;

// 导入必要的类和接口
import cn.edu.ujn.Forum.dao.User; // 导入 User 类，用于获取当前登录用户的信息
import cn.edu.ujn.Forum.service.ILikeService; // 导入 ILikeService 接口，服务层接口
import org.springframework.beans.factory.annotation.Autowired; // 导入 Autowired 注解，用于依赖注入
import org.springframework.web.bind.annotation.*; // 导入 Spring MVC 的注解，如 @RestController, @RequestMapping 等
import jakarta.servlet.http.HttpSession; // 导入 HttpSession，用于获取和操作用户会话

import java.util.HashMap; // 导入 HashMap，用于构建响应数据
import java.util.List; // 导入 List，用于存储用户名列表
import java.util.Map; // 导入 Map，作为响应数据的容器

/**
 * 点赞功能的控制器，处理与帖子点赞相关的所有请求。
 * 提供点赞、取消点赞、获取点赞数量、获取点赞用户列表以及检查用户是否点赞某帖子的功能。
 */
@RestController // 标识该类为 REST 控制器，所有方法返回的数据将直接作为响应体
@RequestMapping("/likes") // 定义该控制器处理的请求路径前缀为 /likes
public class LikeController {

    @Autowired // 自动注入 ILikeService 接口的实现类
    private ILikeService likeService;

    /**
     * 处理用户对指定帖子的点赞操作。
     *
     * @param postId 需要点赞的帖子ID，从请求参数中获取
     * @param session 当前用户的会话，用于获取用户信息
     * @return 包含操作结果的Map，包含状态码、消息和当前点赞数量
     */
    @PostMapping("/like") // 映射 POST 请求到 /likes/like 路径
    public Map<String, Object> likePost(@RequestParam("postId") Integer postId,
                                        HttpSession session) {
        // 创建一个 HashMap 用于存储响应数据
        Map<String, Object> response = new HashMap<>();
        try {
            // 从会话中获取当前登录的用户对象
            User user = (User) session.getAttribute("loggedInUser");
            if (user == null) {
                // 如果用户未登录，设置响应状态码为 401（未授权）并返回提示信息
                response.put("code", 401);
                response.put("message", "请先登录再点赞");
                return response; // 终止方法执行，返回响应
            }

            // 获取当前用户的ID
            Integer userId = user.getId();

            // 检查用户是否已经点赞过该帖子
            boolean hasLiked = likeService.hasUserLikedPost(userId, postId);
            if (hasLiked) {
                // 如果用户已点赞，设置响应状态码为 400（请求错误）并返回提示信息
                response.put("code", 400);
                response.put("message", "您已经点赞过该帖子");
                return response; // 终止方法执行，返回响应
            }

            // 执行点赞操作，通过服务层方法保存点赞记录
            boolean result = likeService.likePost(userId, postId);
            if (result) {
                // 如果点赞成功，设置响应状态码为 200（成功），返回成功消息和最新的点赞数量
                response.put("code", 200);
                response.put("message", "点赞成功");
                response.put("likeCount", likeService.getLikeCountByPostId(postId));
            } else {
                // 如果点赞失败，设置响应状态码为 400（请求错误）并返回失败消息
                response.put("code", 400);
                response.put("message", "点赞失败");
            }
        } catch (Exception e) {
            // 捕获任何异常，打印堆栈跟踪以便调试，并设置响应状态码为 500（服务器错误）
            e.printStackTrace(); // 打印异常堆栈跟踪
            response.put("code", 500);
            response.put("message", "点赞操作异常：" + e.getMessage());
        }
        // 返回响应数据
        return response;
    }

    /**
     * 处理用户对指定帖子的取消点赞操作。
     *
     * @param postId 需要取消点赞的帖子ID，从请求参数中获取
     * @param session 当前用户的会话，用于获取用户信息
     * @return 包含操作结果的Map，包含状态码、消息和当前点赞数量
     */
    @PostMapping("/unlike") // 映射 POST 请求到 /likes/unlike 路径
    public Map<String, Object> unlikePost(@RequestParam("postId") Integer postId,
                                          HttpSession session) {
        // 创建一个 HashMap 用于存储响应数据
        Map<String, Object> response = new HashMap<>();
        try {
            // 从会话中获取当前登录的用户对象
            User user = (User) session.getAttribute("loggedInUser");
            if (user == null) {
                // 如果用户未登录，设置响应状态码为 401（未授权）并返回提示信息
                response.put("code", 401);
                response.put("message", "请先登录再取消点赞");
                return response; // 终止方法执行，返回响应
            }

            // 获取当前用户的ID
            Integer userId = user.getId();

            // 执行取消点赞操作，通过服务层方法删除点赞记录
            boolean result = likeService.unlikePost(userId, postId);
            if (result) {
                // 如果取消点赞成功，设置响应状态码为 200（成功），返回成功消息和最新的点赞数量
                response.put("code", 200);
                response.put("message", "取消点赞成功");
                response.put("likeCount", likeService.getLikeCountByPostId(postId)); // 返回最新点赞数量
            } else {
                // 如果取消点赞失败，设置响应状态码为 400（请求错误）并返回失败消息
                response.put("code", 400);
                response.put("message", "取消点赞失败");
            }
        } catch (Exception e) {
            // 捕获任何异常，设置响应状态码为 500（服务器错误）并返回异常信息
            response.put("code", 500);
            response.put("message", "取消点赞操作异常：" + e.getMessage());
        }
        // 返回响应数据
        return response;
    }

    /**
     * 获取指定帖子的当前点赞数量。
     *
     * @param postId 需要查询点赞数量的帖子ID，从路径变量中获取
     * @return 包含查询结果的Map，包含状态码、消息和点赞数量
     */
    @GetMapping("/count/{postId}") // 映射 GET 请求到 /likes/count/{postId} 路径
    public Map<String, Object> getLikeCount(@PathVariable("postId") Integer postId) {
        // 创建一个 HashMap 用于存储响应数据
        Map<String, Object> response = new HashMap<>();
        try {
            // 调用服务层方法获取指定帖子的点赞数量
            int likeCount = likeService.getLikeCountByPostId(postId);
            // 设置响应状态码为 200（成功），返回成功消息和点赞数量
            response.put("code", 200);
            response.put("message", "查询成功");
            response.put("likeCount", likeCount);
        } catch (Exception e) {
            // 捕获任何异常，设置响应状态码为 500（服务器错误）并返回异常信息
            response.put("code", 500);
            response.put("message", "查询点赞数量异常：" + e.getMessage());
        }
        // 返回响应数据
        return response;
    }

    /**
     * 获取点赞指定帖子的所有用户的用户名列表。
     *
     * @param postId 需要查询的帖子ID，从路径变量中获取
     * @return 包含查询结果的Map，包含状态码、消息和用户名列表
     */
    @GetMapping("/users/{postId}") // 映射 GET 请求到 /likes/users/{postId} 路径
    public Map<String, Object> getUsersWhoLikedPost(@PathVariable("postId") Integer postId) {
        // 创建一个 HashMap 用于存储响应数据
        Map<String, Object> response = new HashMap<>();
        try {
            // 调用服务层获取点赞该帖子的所有用户名
            List<String> usernames = likeService.getUsernamesWhoLikedPost(postId);
            // 设置响应状态码为 200（成功），返回成功消息和用户名列表
            response.put("code", 200);
            response.put("message", "查询成功");
            response.put("users", usernames);
        } catch (Exception e) {
            // 捕获任何异常，设置响应状态码为 500（服务器错误）并返回异常信息
            response.put("code", 500);
            response.put("message", "查询点赞用户异常：" + e.getMessage());
        }
        // 返回响应数据
        return response;
    }

    /**
     * 检查当前用户是否已对指定帖子进行点赞。
     *
     * @param postId 需要检查的帖子ID，从请求参数中获取
     * @param session 当前用户的会话，用于获取用户信息
     * @return 包含检查结果的Map，包含状态码、消息和是否点赞的布尔值
     */
    @GetMapping("/check") // 映射 GET 请求到 /likes/check 路径
    public Map<String, Object> hasUserLikedPost(@RequestParam("postId") Integer postId,
                                                HttpSession session) {
        // 创建一个 HashMap 用于存储响应数据
        Map<String, Object> response = new HashMap<>();
        try {
            // 从会话中获取当前登录的用户对象
            User user = (User) session.getAttribute("loggedInUser");
            if (user == null) {
                // 如果用户未登录，设置响应状态码为 401（未授权），返回提示信息和 isLiked 为 false
                response.put("code", 401);
                response.put("message", "请先登录再检查点赞状态");
                response.put("isLiked", false);
                return response; // 终止方法执行，返回响应
            }

            // 获取当前用户的ID
            Integer userId = user.getId();

            // 调用服务层方法检查用户是否已点赞指定帖子
            boolean isLiked = likeService.hasUserLikedPost(userId, postId);
            // 设置响应状态码为 200（成功），返回成功消息和点赞状态
            response.put("code", 200);
            response.put("message", "查询成功");
            response.put("isLiked", isLiked);
        } catch (Exception e) {
            // 捕获任何异常，设置响应状态码为 500（服务器错误）并返回异常信息
            response.put("code", 500);
            response.put("message", "检查点赞状态异常：" + e.getMessage());
        }
        // 返回响应数据
        return response;
    }
}
