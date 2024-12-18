package cn.edu.ujn.Forum.controller;

import cn.edu.ujn.Forum.dao.User;
import cn.edu.ujn.Forum.service.IFanService;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.http.HttpStatus;
import org.springframework.http.ResponseEntity;
import org.springframework.web.bind.annotation.*;

import jakarta.servlet.http.HttpSession;

import java.util.Collections;
import java.util.HashMap;
import java.util.List;
import java.util.Map;

@RestController
@RequestMapping("/api/fan")
public class FanController {

    @Autowired
    private IFanService fanService;

    /**
     * 添加关注
     * 前端请求示例：
     * POST /Forum/api/fan/follow
     * 请求体：{"authorId": 123}
     */
    @PostMapping("/follow")
    public ResponseEntity<String> followAuthor(@RequestBody(required = false) Map<String, Integer> payload, HttpSession session) {
        System.out.println("收到的请求体：" + payload);

        if (payload == null || !payload.containsKey("authorId")) {
            System.out.println("请求体为空或缺少 authorId");
            return ResponseEntity.badRequest().body("无效的请求");
        }

        Integer fanId = getCurrentUserId(session);
        System.out.println("当前用户ID：" + fanId);
        if (fanId == null) {
            return ResponseEntity.badRequest().body("用户未登录");
        }

        Integer authorId = payload.get("authorId");
        System.out.println("被关注的作者ID：" + authorId);

        fanService.addFollow(fanId, authorId);
        return ResponseEntity.ok("关注成功");
    }

    /**
     * 取消关注
     * 前端请求示例：
     * DELETE /Forum/api/fan/unfollow?authorId=123
     */
    @DeleteMapping("/unfollow")
    public ResponseEntity<String> unfollowAuthor(
            @RequestParam(value = "authorId", required = true) String authorId,
            HttpSession session) {

        try {
            // 手动转换参数
            Integer authorIdInt = Integer.parseInt(authorId);

            // 打印接收到的参数
            System.out.println("接收到取消关注请求，作者ID: " + authorIdInt);

            Integer fanId = getCurrentUserId(session);
            if (fanId == null) {
                return ResponseEntity.badRequest().body("用户未登录");
            }

            if (authorIdInt <= 0) {
                return ResponseEntity.badRequest().body("无效的作者ID");
            }

            fanService.removeFollow(fanId, authorIdInt);
            return ResponseEntity.ok("取消关注成功");

        } catch (NumberFormatException e) {
            System.out.println("参数转换错误: " + e.getMessage());
            return ResponseEntity.badRequest().body("作者ID格式不正确");
        } catch (Exception e) {
            System.out.println("取消关注失败: " + e.getMessage());
            return ResponseEntity.badRequest().body("取消关注失败: " + e.getMessage());
        }
    }

    /**
     * 检查是否已关注
     * 前端请求示例：
     * GET /Forum/api/fan/isFollowing?authorId=123
     * 返回：true 或 false
     */
    @GetMapping("/isFollowing")
    public ResponseEntity<Map<String, Boolean>> isFollowing(
            @RequestParam(name = "authorId", required = true) Integer authorId,
            HttpSession session) {
        try {
            System.out.println("检查关注状态，authorId: " + authorId);

            if (authorId == null) {
                System.out.println("authorId 为 null，返回 false");
                return ResponseEntity.badRequest().body(Collections.singletonMap("isFollowing", false));
            }

            Integer fanId = getCurrentUserId(session); // 获取当前用户的 ID
            System.out.println("当前用户ID：" + fanId);

            if (fanId == null) {
                System.out.println("用户未登录，返回 false");
                return ResponseEntity.ok(Collections.singletonMap("isFollowing", false));
            }

            // 检查当前用户是否已经关注了指定的作者
            boolean isFollowing = fanService.isFollowing(fanId, authorId);
            System.out.println("用户 " + fanId + " 是否关注作者 " + authorId + ": " + isFollowing);

            // 添加日志以确认返回结果
            System.out.println("返回 isFollowing 状态: " + isFollowing);

            return ResponseEntity.ok(Collections.singletonMap("isFollowing", isFollowing)); // 返回关注状态
        } catch (Exception e) {
            // 捕获并记录任何异常
            System.err.println("检查关注状态时发生异常: " + e.getMessage());
            e.printStackTrace();
            return ResponseEntity.status(HttpStatus.INTERNAL_SERVER_ERROR)
                    .body(Collections.singletonMap("isFollowing", false));
        }
    }









    /**
     * 获取当前用户关注的作者列表
     * 前端请求示例：
     * GET /Forum/api/fan/following
     * 返回：关注列表（整数ID的列表）
     */
    @GetMapping("/following")
    public ResponseEntity<List<Integer>> getFollowingList(HttpSession session) {
        Integer fanId = getCurrentUserId(session);
        if (fanId == null) {
            return ResponseEntity.badRequest().body(null);
        }

        List<Integer> followingList = fanService.getFollowingList(fanId);
        return ResponseEntity.ok(followingList);
    }

    /**
     * 获取某作者的粉丝列表
     * 前端请求示例：
     * GET /Forum/api/fan/followers/123
     * 返回：该作者的粉丝列表
     */
    @GetMapping("/followers/{authorId}")
    public ResponseEntity<List<Integer>> getFollowers(@PathVariable Integer authorId) {
        List<Integer> followers = fanService.getFollowers(authorId);
        return ResponseEntity.ok(followers);
    }

    /**
     * 从 HttpSession 获取当前用户 ID
     * 确保在用户登录后，将 "loggedInUser" 存入 session
     */
    private Integer getCurrentUserId(HttpSession session) {
        User user = (User) session.getAttribute("loggedInUser");
        if (user != null) {
            return user.getId();  // 返回当前登录用户的 ID
        }
        return null;  // 如果用户未登录，返回 null
    }

    @ExceptionHandler(Exception.class)
    public ResponseEntity<Map<String, String>> handleException(Exception ex) {
        Map<String, String> errorResponse = new HashMap<>();
        errorResponse.put("error", ex.getMessage());
        return ResponseEntity.badRequest().body(errorResponse);
    }

}
