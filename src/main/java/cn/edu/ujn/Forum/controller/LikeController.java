package cn.edu.ujn.Forum.controller;

import cn.edu.ujn.Forum.dao.User;
import cn.edu.ujn.Forum.service.ILikeService;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.web.bind.annotation.*;
import jakarta.servlet.http.HttpSession;

import java.util.HashMap;
import java.util.List;
import java.util.Map;

/**
 * 点赞控制器
 */
@RestController
@RequestMapping("/likes")
public class LikeController {

    @Autowired
    private ILikeService likeService;

    /**
     * 用户点赞
     *
     * @param postId  帖子ID
     * @param session 当前会话
     * @return 操作结果
     */
    @PostMapping("/like")
    public Map<String, Object> likePost(@RequestParam("postId") Integer postId,
                                        HttpSession session) {
        Map<String, Object> response = new HashMap<>();
        try {
            // 从会话中获取用户
            User user = (User) session.getAttribute("loggedInUser");
            if (user == null) {
                response.put("code", 401);
                response.put("message", "请先登录再点赞");
                return response;
            }

            Integer userId = user.getId();

            // 先检查是否已经点赞
            boolean hasLiked = likeService.hasUserLikedPost(userId, postId);
            if (hasLiked) {
                response.put("code", 400);
                response.put("message", "您已经点赞过该帖子");
                return response;
            }

            boolean result = likeService.likePost(userId, postId);
            if (result) {
                response.put("code", 200);
                response.put("message", "点赞成功");
                response.put("likeCount", likeService.getLikeCountByPostId(postId));
            } else {
                response.put("code", 400);
                response.put("message", "点赞失败");
            }
        } catch (Exception e) {
            e.printStackTrace(); // 添加详细的错误日志
            response.put("code", 500);
            response.put("message", "点赞操作异常：" + e.getMessage());
        }
        return response;
    }

    /**
     * 用户取消点赞
     *
     * @param postId  帖子ID
     * @param session 当前会话
     * @return 操作结果
     */
    @PostMapping("/unlike")
    public Map<String, Object> unlikePost(@RequestParam("postId") Integer postId,
                                          HttpSession session) {
        Map<String, Object> response = new HashMap<>();
        try {
            // 从会话中获取用户
            User user = (User) session.getAttribute("loggedInUser");
            if (user == null) {
                response.put("code", 401);
                response.put("message", "请先登录再取消点赞");
                return response;
            }

            Integer userId = user.getId();

            boolean result = likeService.unlikePost(userId, postId);
            if (result) {
                response.put("code", 200);
                response.put("message", "取消点赞成功");
                response.put("likeCount", likeService.getLikeCountByPostId(postId)); // 返回最新点赞数量
            } else {
                response.put("code", 400);
                response.put("message", "取消点赞失败");
            }
        } catch (Exception e) {
            response.put("code", 500);
            response.put("message", "取消点赞操作异常：" + e.getMessage());
        }
        return response;
    }

    /**
     * 获取某个帖子的点赞数量
     *
     * @param postId 帖子ID
     * @return 点赞数量
     */
    @GetMapping("/count/{postId}")
    public Map<String, Object> getLikeCount(@PathVariable("postId") Integer postId) {
        Map<String, Object> response = new HashMap<>();
        try {
            int likeCount = likeService.getLikeCountByPostId(postId);
            response.put("code", 200);
            response.put("message", "查询成功");
            response.put("likeCount", likeCount);
        } catch (Exception e) {
            response.put("code", 500);
            response.put("message", "查询点赞数量异常：" + e.getMessage());
        }
        return response;
    }

    /**
     * 获取点赞某个帖子的用户名列表
     *
     * @param postId 帖子ID
     * @return 点赞用户名列表
     */
    @GetMapping("/users/{postId}")
    public Map<String, Object> getUsersWhoLikedPost(@PathVariable("postId") Integer postId) {
        Map<String, Object> response = new HashMap<>();
        try {
            List<String> usernames = likeService.getUsernamesWhoLikedPost(postId); // 获取用户名列表
            response.put("code", 200);
            response.put("message", "查询成功");
            response.put("users", usernames);
        } catch (Exception e) {
            response.put("code", 500);
            response.put("message", "查询点赞用户异常：" + e.getMessage());
        }
        return response;
    }

    /**
     * 获取用户点赞过的帖子ID列表
     *
     * @param session 当前会话
     * @return 用户点赞过的帖子ID列表
     */
    @GetMapping("/posts")
    public Map<String, Object> getLikedPostsByUserId(HttpSession session) {
        Map<String, Object> response = new HashMap<>();
        try {
            // 从会话中获取用户
            User user = (User) session.getAttribute("loggedInUser");
            if (user == null) {
                response.put("code", 401);
                response.put("message", "请先登录再查询点赞的帖子");
                return response;
            }

            Integer userId = user.getId();

            List<Integer> posts = likeService.getLikedPostsByUserId(userId);
            response.put("code", 200);
            response.put("message", "查询成功");
            response.put("posts", posts);
        } catch (Exception e) {
            response.put("code", 500);
            response.put("message", "查询用户点赞帖子异常：" + e.getMessage());
        }
        return response;
    }

    /**
     * 检查用户是否点赞某帖子
     *
     * @param postId  帖子ID
     * @param session 当前会话
     * @return 是否点赞
     */
    @GetMapping("/check")
    public Map<String, Object> hasUserLikedPost(@RequestParam("postId") Integer postId,
                                                HttpSession session) {
        Map<String, Object> response = new HashMap<>();
        try {
            // 从会话中获取用户
            User user = (User) session.getAttribute("loggedInUser");
            if (user == null) {
                response.put("code", 401);
                response.put("message", "请先登录再检查点赞状态");
                return response;
            }

            Integer userId = user.getId();

            boolean isLiked = likeService.hasUserLikedPost(userId, postId);
            response.put("code", 200);
            response.put("message", "查询成功");
            response.put("isLiked", isLiked);
        } catch (Exception e) {
            response.put("code", 500);
            response.put("message", "检查点赞状态异常：" + e.getMessage());
        }
        return response;
    }
}
