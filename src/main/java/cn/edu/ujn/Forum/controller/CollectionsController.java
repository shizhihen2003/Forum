package cn.edu.ujn.Forum.controller;

import cn.edu.ujn.Forum.dao.User;
import cn.edu.ujn.Forum.service.ICollectionsService;
import jakarta.servlet.http.HttpSession;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.http.HttpStatus;
import org.springframework.http.ResponseEntity;
import org.springframework.web.bind.annotation.*;

import java.util.Collections;
import java.util.HashMap;
import java.util.List;
import java.util.Map;

@RestController
@RequestMapping("/api/collection")
public class CollectionsController {

    @Autowired
    private ICollectionsService collectionService;

    /**
     * 添加收藏
     * 前端请求示例：
     * POST /api/collection/add
     * 请求体：{"postId": 12}
     */
    @PostMapping("/add")
    public ResponseEntity<Map<String, Object>> addCollection(@RequestBody Map<String, Long> payload, HttpSession session) {


        if (payload == null || !payload.containsKey("postId") || payload.get("postId") <= 0) {

            Map<String, Object> response = new HashMap<>();
            response.put("code", 400);
            response.put("message", "无效的请求");
            return ResponseEntity.badRequest().body(response);
        }

        Integer userId = getCurrentUserId(session);

        if (userId == null) {
            Map<String, Object> response = new HashMap<>();
            response.put("code", 401);
            response.put("message", "用户未登录");
            return ResponseEntity.status(HttpStatus.UNAUTHORIZED).body(response);
        }

        Long postId = payload.get("postId");


        boolean success = collectionService.addCollection(userId, postId);
        Map<String, Object> response = new HashMap<>();
        if (success) {
            response.put("code", 200);
            response.put("message", "收藏成功");
            response.put("collectionCount", collectionService.countCollections(postId));
        } else {
            response.put("code", 400);
            response.put("message", "已收藏或收藏失败");
        }
        return ResponseEntity.status(success ? HttpStatus.OK : HttpStatus.BAD_REQUEST).body(response);
    }

    /**
     * 取消收藏
     * 前端请求示例：
     * DELETE /api/collection/remove?postId=12
     */
    @DeleteMapping("/remove")
    public ResponseEntity<Map<String, Object>> removeCollection(@RequestParam(value = "postId", required = true) Long postId, HttpSession session) {


        Integer userId = getCurrentUserId(session);
        if (userId == null) {
            Map<String, Object> response = new HashMap<>();
            response.put("code", 401);
            response.put("message", "用户未登录");
            return ResponseEntity.status(HttpStatus.UNAUTHORIZED).body(response);
        }

        boolean success = collectionService.removeCollection(userId, postId);
        Map<String, Object> response = new HashMap<>();
        if (success) {
            response.put("code", 200);
            response.put("message", "取消收藏成功");
            response.put("collectionCount", collectionService.countCollections(postId));
        } else {
            response.put("code", 400);
            response.put("message", "未收藏或取消收藏失败");
        }
        return ResponseEntity.status(success ? HttpStatus.OK : HttpStatus.BAD_REQUEST).body(response);
    }

    /**
     * 检查是否已收藏
     * 前端请求示例：
     * GET /api/collection/isCollected?postId=12
     * 返回：{"isCollected": true} 或 {"isCollected": false}
     */
    @GetMapping("/isCollected")
    public ResponseEntity<Map<String, Boolean>> isCollected(@RequestParam(name = "postId", required = true) Long postId, HttpSession session) {


        Integer userId = getCurrentUserId(session);
        if (userId == null) {

            return ResponseEntity.ok(Collections.singletonMap("isCollected", false));
        }

        boolean isCollected = collectionService.isCollected(userId, postId);


        return ResponseEntity.ok(Collections.singletonMap("isCollected", isCollected));
    }

    /**
     * 获取某个帖子的收藏数量
     * 前端请求示例：
     * GET /api/collection/count?postId=12
     * 返回：{"count": 5}
     */
    @GetMapping("/count")
    public ResponseEntity<Map<String, Integer>> countCollections(@RequestParam(name = "postId", required = true) Long postId) {
        int count = collectionService.countCollections(postId);
        return ResponseEntity.ok(Collections.singletonMap("count", count));
    }

    /**
     * 获取用户的所有收藏
     * 前端请求示例：
     * GET /api/collection/user
     * 返回：[12, 34, 56]
     */


    /**
     * 获取当前登录用户的ID
     * @param session 当前HTTP会话
     * @return 当前用户ID，如果未登录则返回null
     */
    private Integer getCurrentUserId(HttpSession session) {
        User user = (User) session.getAttribute("loggedInUser");
        if (user != null) {
            return user.getId();  // 返回当前登录用户的 ID
        }
        return null;  // 如果用户未登录，返回 null
    }

    /**
     * 全局异常处理
     * @param ex 捕获到的异常
     * @return 错误响应
     */
    @ExceptionHandler(Exception.class)
    public ResponseEntity<Map<String, String>> handleException(Exception ex) {
        Map<String, String> errorResponse = new HashMap<>();
        errorResponse.put("error", ex.getMessage());
        return ResponseEntity.badRequest().body(errorResponse);
    }
}
