package cn.edu.ujn.Forum.controller;

import cn.edu.ujn.Forum.dao.Notification;
import cn.edu.ujn.Forum.dao.User;
import cn.edu.ujn.Forum.service.INotificationService;
import cn.edu.ujn.Forum.util.Result;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Controller;
import org.springframework.ui.Model;
import org.springframework.web.bind.annotation.*;
import jakarta.servlet.http.HttpSession;

import java.util.List;

@Controller
@RequestMapping("/notifications")
public class NotificationController {

    @Autowired
    private INotificationService notificationService;

    /**
     * 显示当前用户的所有通知
     */
    @GetMapping("")
    public String listNotifications(Model model, HttpSession session) {
        User user = (User) session.getAttribute("loggedInUser");
        if (user == null) {
            return "redirect:/login";
        }

        List<Notification> notifications = notificationService.getUserNotifications(user.getId());
        model.addAttribute("notifications", notifications);
        return "notification/list";
    }

    /**
     * 标记通知为已读
     */
    @PostMapping("/read/{id}")
    @ResponseBody
    public Result<Boolean> markAsRead(@PathVariable Long id) {
        try {
            boolean success = notificationService.markAsRead(id);
            return success ? Result.success(true) : Result.fail("标记失败");
        } catch (Exception e) {
            return Result.fail("操作失败");
        }
    }

    /**
     * 获取未读通知数量
     */
    @GetMapping("/unread/count")
    @ResponseBody
    public Result<Integer> getUnreadCount(HttpSession session) {
        User user = (User) session.getAttribute("loggedInUser");
        if (user == null) {
            return Result.fail("未登录");
        }
        try {
            int count = notificationService.getUnreadCount(user.getId());
            return Result.success(count);
        } catch (Exception e) {
            return Result.fail("获取未读数量失败");
        }
    }

    /**
     * 批量标记为已读
     */
    @PostMapping("/read/all")
    @ResponseBody
    public Result<Boolean> markAllAsRead(HttpSession session) {
        User user = (User) session.getAttribute("loggedInUser");
        if (user == null) {
            return Result.fail("未登录");
        }
        try {
            boolean success = notificationService.markAllAsRead(user.getId());
            return success ? Result.success(true) : Result.fail("标记失败");
        } catch (Exception e) {
            return Result.fail("操作失败");
        }
    }

    /**
     * 删除通知
     */
    @PostMapping("/delete/{id}")
    @ResponseBody
    public Result<Boolean> deleteNotification(@PathVariable Long id) {
        try {
            boolean success = notificationService.deleteNotification(id);
            return success ? Result.success(true) : Result.fail("删除失败");
        } catch (Exception e) {
            return Result.fail("删除失败");
        }
    }
}