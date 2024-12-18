package cn.edu.ujn.Forum.controller;

// 导入必要的类和接口
import cn.edu.ujn.Forum.dao.Report; // 导入 Report 实体类，用于处理举报记录
import cn.edu.ujn.Forum.dao.ReportType; // 导入 ReportType 实体类，用于处理举报类型
import cn.edu.ujn.Forum.dao.User; // 导入 User 实体类，用于获取用户信息
import cn.edu.ujn.Forum.service.IReportService; // 导入 IReportService 接口，服务层接口
import org.springframework.beans.factory.annotation.Autowired; // 导入 Autowired 注解，用于依赖注入
import org.springframework.stereotype.Controller; // 导入 Controller 注解，标识为 Spring MVC 控制器
import org.springframework.ui.Model; // 导入 Model 接口，用于传递数据到视图
import org.springframework.web.bind.annotation.*; // 导入 Spring MVC 的注解，如 @GetMapping, @PostMapping 等
import org.springframework.web.servlet.mvc.support.RedirectAttributes; // 导入 RedirectAttributes，用于传递重定向属性

import jakarta.servlet.http.HttpSession; // 导入 HttpSession，用于获取和操作用户会话

import java.util.Date; // 导入 Date 类，用于设置创建和更新时间
import java.util.HashMap; // 导入 HashMap，用于构建响应数据
import java.util.List; // 导入 List，用于存储举报类型和举报记录列表
import java.util.Map; // 导入 Map，作为响应数据的容器

/**
 * Controller 层 - ReportController
 * 负责处理与举报（Report）相关的 HTTP 请求。
 */
@Controller // 标识该类为 Spring MVC 控制器
@RequestMapping("/reports") // 定义该控制器处理的请求路径前缀为 /reports
public class ReportController {

    @Autowired // 自动注入 IReportService 接口的实现类
    private IReportService reportService;

    /**
     * 获取举报类型列表，用于动态加载举报类型下拉菜单。
     * 该方法通过 AJAX 请求调用，用于填充前端的举报类型选择框。
     * @return JSON格式的举报类型列表，包含状态码和数据
     */
    @GetMapping("/types") // 映射 GET 请求到 /reports/types 路径
    @ResponseBody // 表示返回的对象会自动序列化为 JSON 格式
    public Map<String, Object> getReportTypes() {
        // 创建一个 HashMap 用于存储响应数据
        Map<String, Object> response = new HashMap<>();
        try {
            // 调用服务层方法获取所有举报类型
            List<ReportType> types = reportService.getAllReportTypes();
            // 设置响应状态码为 200（成功）
            response.put("code", 200);
            // 将举报类型列表添加到响应中，键名为 "data"
            response.put("data", types);
        } catch (Exception e) {
            // 捕获任何异常，打印堆栈跟踪以便调试
            e.printStackTrace();
            // 设置响应状态码为 500（服务器错误）
            response.put("code", 500);
            // 添加错误消息到响应中
            response.put("message", "获取举报类型失败，请稍后重试。");
        }
        // 返回响应数据
        return response;
    }

    /**
     * 处理AJAX提交的举报请求。
     * 该方法通过 AJAX POST 请求调用，用于提交用户的举报信息。
     *
     * @param postId       当前帖子的ID，从请求参数中获取
     * @param reportTypeId 举报类型ID，从请求参数中获取
     * @param content      举报描述，从请求参数中获取
     * @param session      HTTP会话，用于获取登录用户信息
     * @return JSON格式的响应，包含状态码和消息
     */
    @PostMapping("/report") // 映射 POST 请求到 /reports/report 路径
    @ResponseBody // 表示返回的对象会自动序列化为 JSON 格式
    public Map<String, Object> submitReport(
            @RequestParam("postId") Integer postId, // 获取请求参数中的 postId
            @RequestParam("reportTypeId") Integer reportTypeId, // 获取请求参数中的 reportTypeId
            @RequestParam("content") String content, // 获取请求参数中的 content
            HttpSession session) { // 获取当前用户的会话
        // 创建一个 HashMap 用于存储响应数据
        Map<String, Object> response = new HashMap<>();

        // 检查用户是否登录
        Object userObj = session.getAttribute("loggedInUser"); // 从会话中获取 "loggedInUser" 属性
        if (userObj == null) {
            // 如果用户未登录，设置响应状态码为 401（未授权）并返回提示信息
            response.put("code", 401);
            response.put("message", "请先登录再举报。");
            return response; // 终止方法执行，返回响应
        }

        // 假设登录用户对象为 User，且具有 getId() 方法
        User loggedInUser = (User) userObj; // 将对象转换为 User 类型

        // 验证举报内容的有效性
        if (reportTypeId == null || content == null || content.trim().isEmpty()) {
            // 如果举报类型ID或内容为空，设置响应状态码为 400（请求错误）并返回提示信息
            response.put("code", 400);
            response.put("message", "举报类型和内容不能为空。");
            return response; // 终止方法执行，返回响应
        }
        if (content.length() < 5 || content.length() > 500) {
            // 如果举报内容长度不在5到500之间，设置响应状态码为 400（请求错误）并返回提示信息
            response.put("code", 400);
            response.put("message", "举报内容长度应在5到500之间。");
            return response; // 终止方法执行，返回响应
        }

        // 创建举报对象并设置相关信息
        Report report = new Report();
        report.setPostId(postId); // 设置被举报的帖子ID
        report.setUserId(loggedInUser.getId()); // 设置举报用户的ID
        report.setReportTypeId(reportTypeId); // 设置举报类型ID
        report.setDescription(content); // 设置举报描述
        report.setCreatedAt(new Date()); // 设置创建时间为当前时间
        report.setUpdatedAt(new Date()); // 设置更新时间为当前时间

        try {
            // 调用服务层方法添加举报记录
            reportService.addReport(report);
            // 如果添加成功，设置响应状态码为 200（成功）并返回成功消息
            response.put("code", 200);
            response.put("message", "举报提交成功！");
        } catch (Exception e) {
            // 捕获任何异常，打印堆栈跟踪以便调试
            e.printStackTrace();
            // 设置响应状态码为 500（服务器错误）并返回错误消息
            response.put("code", 500);
            response.put("message", "举报提交失败，请稍后重试。");
        }

        // 返回响应数据
        return response;
    }

    /**
     * 显示当前登录用户的所有举报记录。
     * 该方法处理 GET 请求，用于渲染 "我的举报记录" 页面。
     *
     * @param session              当前用户的会话，用于获取用户信息
     * @param model                模型对象，用于传递数据到视图
     * @param redirectAttributes   重定向属性，用于传递提示消息
     * @return 显示 "我的举报记录" 的 JSP 页面
     */
    @GetMapping("/myReports") // 映射 GET 请求到 /reports/myReports 路径
    public String myReports(HttpSession session, Model model, RedirectAttributes redirectAttributes) {
        // 从会话中获取当前登录的用户对象
        User loggedInUser = (User) session.getAttribute("loggedInUser");
        if (loggedInUser == null) {
            // 如果用户未登录，设置错误消息并重定向到登录页面
            redirectAttributes.addFlashAttribute("errorMessage", "请先登录查看自己的举报记录");
            return "redirect:/login.jsp"; // 重定向到登录页面
        }

        // 调用服务层方法获取当前用户的所有举报记录
        List<Report> myReports = reportService.getReportsByUserId(loggedInUser.getId());
        // 将举报记录列表添加到模型中，键名为 "myReports"
        model.addAttribute("myReports", myReports);

        // 调用服务层方法获取所有举报类型列表
        List<ReportType> allTypes = reportService.getAllReportTypes();
        // 创建一个 HashMap，用于将举报类型ID映射到举报类型名称
        Map<Integer, String> typeMap = new HashMap<>();
        for (ReportType t : allTypes) {
            // 假设 ReportType 类中有 getId() 和 getTypeName() 方法
            typeMap.put(t.getId(), t.getTypeName()); // 将类型ID和类型名称添加到映射中
        }
        // 将类型映射添加到模型中，键名为 "typeMap"
        model.addAttribute("typeMap", typeMap);
        // 将所有举报类型列表添加到模型中，键名为 "allTypes"（用于下拉选择）
        model.addAttribute("allTypes", allTypes);

        // 返回 "reports.jsp" 页面，用于显示当前用户的举报记录
        return "reports";
    }


    /**
     * 处理编辑举报记录的表单提交。
     * 该方法处理 POST 请求，用于更新指定的举报记录。
     *
     * @param id                  要编辑的举报记录的ID，从请求参数中获取
     * @param reportTypeId        新的举报类型ID，从请求参数中获取
     * @param description         新的举报描述，从请求参数中获取
     * @param session             当前用户的会话，用于获取用户信息
     * @param redirectAttributes  重定向属性，用于传递提示消息
     * @return 重定向到 "我的举报记录" 页面
     */
    @PostMapping("/edit") // 映射 POST 请求到 /reports/edit 路径
    public String updateReport(
            @RequestParam("id") Integer id, // 获取请求参数中的举报记录ID
            @RequestParam("reportTypeId") Integer reportTypeId, // 获取请求参数中的新的举报类型ID
            @RequestParam("description") String description, // 获取请求参数中的新的举报描述
            HttpSession session, // 获取当前用户的会话
            RedirectAttributes redirectAttributes) { // 用于传递重定向属性

        // 从会话中获取当前登录的用户对象
        User loggedInUser = (User) session.getAttribute("loggedInUser");
        if (loggedInUser == null) {
            // 如果用户未登录，设置错误消息并重定向到登录页面
            redirectAttributes.addFlashAttribute("errorMessage", "请先登录后再操作");
            return "redirect:/login.jsp"; // 重定向到登录页面
        }

        // 调用服务层方法获取要编辑的举报记录
        Report report = reportService.getReportById(id);
        if (report == null) {
            // 如果未找到指定的举报记录，设置错误消息并重定向到 "我的举报记录" 页面
            redirectAttributes.addFlashAttribute("errorMessage", "未找到指定的举报记录。");
            return "redirect:/reports/myReports"; // 重定向到 "我的举报记录" 页面
        }

        // 验证输入的有效性
        if (reportTypeId == null || description == null || description.trim().isEmpty()) {
            // 如果举报类型ID或描述为空，设置错误消息并重定向到 "我的举报记录" 页面
            redirectAttributes.addFlashAttribute("errorMessage", "举报类型和内容不能为空。");
            return "redirect:/reports/myReports"; // 重定向到 "我的举报记录" 页面
        }
        if (description.length() < 5 || description.length() > 500) {
            // 如果举报描述长度不在5到500之间，设置错误消息并重定向到 "我的举报记录" 页面
            redirectAttributes.addFlashAttribute("errorMessage", "举报内容长度应在5到500之间。");
            return "redirect:/reports/myReports"; // 重定向到 "我的举报记录" 页面
        }

        // 更新举报记录的类型ID和描述，并设置更新时间为当前时间
        report.setReportTypeId(reportTypeId); // 更新举报类型ID
        report.setDescription(description); // 更新举报描述
        report.setUpdatedAt(new Date()); // 设置更新时间为当前时间

        try {
            // 调用服务层方法更新举报记录
            reportService.updateReport(report);
            // 如果更新成功，设置成功消息并重定向到 "我的举报记录" 页面
            redirectAttributes.addFlashAttribute("successMessage", "举报记录更新成功！");
        } catch (Exception e) {
            // 捕获任何异常，打印堆栈跟踪以便调试
            e.printStackTrace();
            // 设置错误消息并重定向到 "我的举报记录" 页面
            redirectAttributes.addFlashAttribute("errorMessage", "举报记录更新失败，请稍后重试。");
        }

        // 重定向到 "我的举报记录" 页面
        return "redirect:/reports/myReports";
    }

    /**
     * 删除指定的举报记录。
     * 该方法处理 GET 请求，通过举报记录的ID删除相应的举报记录。
     *
     * @param id                  要删除的举报记录的ID，从请求参数中获取
     * @param session             当前用户的会话，用于获取用户信息
     * @param redirectAttributes  重定向属性，用于传递提示消息
     * @return 重定向到 "我的举报记录" 页面
     */
    @GetMapping("/delete") // 映射 GET 请求到 /reports/delete 路径
    public String deleteReport(
            @RequestParam("id") Integer id, // 获取请求参数中的举报记录ID
            HttpSession session, // 获取当前用户的会话
            RedirectAttributes redirectAttributes) { // 用于传递重定向属性

        // 从会话中获取当前登录的用户对象
        User loggedInUser = (User) session.getAttribute("loggedInUser");
        if (loggedInUser == null) {
            // 如果用户未登录，设置错误消息并重定向到登录页面
            redirectAttributes.addFlashAttribute("errorMessage", "请先登录后再操作");
            return "redirect:/login.jsp"; // 重定向到登录页面
        }

        // 调用服务层方法获取要删除的举报记录
        Report report = reportService.getReportById(id);
        if (report == null) {
            // 如果未找到指定的举报记录，设置错误消息并重定向到 "我的举报记录" 页面
            redirectAttributes.addFlashAttribute("errorMessage", "未找到指定的举报记录。");
            return "redirect:/reports/myReports"; // 重定向到 "我的举报记录" 页面
        }

        try {
            // 调用服务层方法删除举报记录
            reportService.deleteReport(id);
            // 如果删除成功，设置成功消息并重定向到 "我的举报记录" 页面
            redirectAttributes.addFlashAttribute("successMessage", "举报记录删除成功！");
        } catch (Exception e) {
            // 捕获任何异常，打印堆栈跟踪以便调试
            e.printStackTrace();
            // 设置错误消息并重定向到 "我的举报记录" 页面
            redirectAttributes.addFlashAttribute("errorMessage", "举报记录删除失败，请稍后重试。");
        }

        // 重定向到 "我的举报记录" 页面
        return "redirect:/reports/myReports";
    }
}
