package cn.edu.ujn.Forum.controller;

import cn.edu.ujn.Forum.dao.Fan;
import cn.edu.ujn.Forum.dao.FanGroup;
import cn.edu.ujn.Forum.dao.User; // 确保导入 User 类
import cn.edu.ujn.Forum.service.IFanGroupService;
import jakarta.servlet.http.HttpSession;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Controller;
import org.springframework.ui.Model;
import org.springframework.web.bind.annotation.*;

import java.util.List;

@Controller
@RequestMapping("/fanGroup")
public class FanGroupController {

    @Autowired
    private IFanGroupService fanGroupService;

    /**
     * 辅助方法：从会话中获取当前登录用户的 userId
     */
    private Integer getCurrentUserId(HttpSession session) {
        User user = (User) session.getAttribute("loggedInUser");
        if (user == null) {
            return null;
        }
        return user.getId(); // 假设 User 类有 getId() 方法
    }

    @GetMapping
    public String showFanGroupPage(Model model, HttpSession session) {
        Integer userId = getCurrentUserId(session);
        if (userId == null) {
            return "redirect:/login";
        }
        List<FanGroup> fanGroups = fanGroupService.getFanGroupsByUserId(userId);
        model.addAttribute("fanGroups", fanGroups);
        return "fanGroupManagement"; // 返回粉丝管理页面
    }

    @GetMapping("/createFanGroup")
    public String createFanGroupPage(HttpSession session) {
        // 可选：检查用户是否已登录
        if (getCurrentUserId(session) == null) {
            return "redirect:/login";
        }
        return "createFanGroup"; // 显示创建分组页面
    }

    @PostMapping("/createFanGroup")
    public String createFanGroup(@RequestParam String groupName, HttpSession session, Model model) {
        Integer userId = getCurrentUserId(session);
        if (userId == null) {
            return "redirect:/login";
        }
        fanGroupService.createFanGroup(userId, groupName);
        return "redirect:/fanGroup"; // 返回粉丝管理页面
    }

    @GetMapping("/viewFanGroup")
    public String viewFanGroup(@RequestParam Integer groupId, Model model, HttpSession session) {
        if (getCurrentUserId(session) == null) {
            return "redirect:/login";
        }
        List<Fan> fans = fanGroupService.getFansByFanGroupId(groupId);
        model.addAttribute("fans", fans);
        return "viewFanGroup"; // 显示分组下的粉丝
    }

    @GetMapping("/deleteFanGroup")
    public String deleteFanGroup(@RequestParam Integer groupId, HttpSession session) {
        if (getCurrentUserId(session) == null) {
            return "redirect:/login";
        }
        fanGroupService.deleteFanGroup(groupId);
        return "redirect:/fanGroup"; // 返回粉丝管理页面
    }
}
