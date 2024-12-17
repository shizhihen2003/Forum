package cn.edu.ujn.Forum.controller;

import cn.edu.ujn.Forum.dao.Report;
import cn.edu.ujn.Forum.dao.ReportType;
import cn.edu.ujn.Forum.dao.User;
import cn.edu.ujn.Forum.service.IReportService;
import cn.edu.ujn.Forum.util.Page;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Controller;
import org.springframework.ui.Model;
import org.springframework.web.bind.annotation.*;
import org.springframework.web.servlet.mvc.support.RedirectAttributes;

import jakarta.servlet.http.HttpSession;

import java.util.Date;
import java.util.HashMap;
import java.util.List;
import java.util.Map;

/**
 * Controller 层 - ReportController
 * 负责处理与举报（Report）相关的 HTTP 请求。
 */
@Controller
@RequestMapping("/reports")
public class ReportController {

    @Autowired
    private IReportService reportService;

    /**
     * 显示举报记录列表，支持分页。
     *
     * @param pageNum  当前页码，默认为1
     * @param pageSize 每页显示的记录数，默认为10
     * @param model    模型对象，用于传递数据到视图
     * @return 显示举报记录列表的 JSP 页面
     */
    @GetMapping
    public String listReports(
            @RequestParam(value = "page", defaultValue = "1") int pageNum,
            @RequestParam(value = "size", defaultValue = "10") int pageSize,
            Model model) {

        // 计算偏移量
        int offset = (pageNum - 1) * pageSize;

        // 获取分页数据
        Page<Report> page = new Page<>();
        page.setPage(pageNum);
        page.setSize(pageSize);
        page.setTotal(reportService.countReports());
        page.setRows(reportService.getReportsPaged(offset, pageSize));

        // 将 Page 对象添加到模型中
        model.addAttribute("page", page);

        return "reportList"; // JSP 页面名称，例如：reportList.jsp
    }

    /**
     * 显示创建举报记录的表单。
     *
     * @param model 模型对象，用于传递数据到视图
     * @return 显示创建举报记录表单的 JSP 页面
     */
    @GetMapping("/create")
    public String showCreateForm(Model model) {
        model.addAttribute("report", new Report());
        return "createReport"; // JSP 页面名称，例如：createReport.jsp
    }

    /**
     * 处理创建举报记录的表单提交。
     *
     * @param report             要创建的 Report 对象
     * @param redirectAttributes 重定向属性，用于传递提示消息
     * @return 重定向到举报记录列表页面
     */
    @PostMapping("/create")
    public String createReport(@ModelAttribute Report report, RedirectAttributes redirectAttributes) {
        // 手动验证举报内容
        if (report.getReportTypeId() == null || report.getDescription() == null || report.getDescription().trim().isEmpty()) {
            redirectAttributes.addFlashAttribute("errorMessage", "举报类型和内容不能为空。");
            return "redirect:/reports/create";
        }
        if (report.getDescription().length() < 5 || report.getDescription().length() > 500) {
            redirectAttributes.addFlashAttribute("errorMessage", "举报内容长度应在5到500之间。");
            return "redirect:/reports/create";
        }

        // 设置举报相关信息
        report.setCreatedAt(new Date());
        report.setUpdatedAt(new Date());

        try {
            reportService.addReport(report);
            redirectAttributes.addFlashAttribute("successMessage", "举报记录创建成功！");
        } catch (Exception e) {
            e.printStackTrace();
            redirectAttributes.addFlashAttribute("errorMessage", "举报记录创建失败，请稍后重试。");
        }

        return "redirect:/reports";
    }





    /**
     * 显示举报记录的详细信息。
     *
     * @param id                 要查看的举报记录的 ID
     * @param model              模型对象，用于传递数据到视图
     * @param redirectAttributes 重定向属性，用于传递提示消息
     * @return 显示举报记录详情的 JSP 页面
     */
    @GetMapping("/view")
    public String viewReport(@RequestParam("id") Integer id, Model model, RedirectAttributes redirectAttributes) {
        Report report = reportService.getReportById(id);
        if (report == null) {
            redirectAttributes.addFlashAttribute("errorMessage", "未找到指定的举报记录。");
            return "redirect:/reports";
        }
        model.addAttribute("report", report);
        return "viewReport"; // JSP 页面名称，例如：viewReport.jsp
    }

    /**
     * 获取举报类型列表，用于动态加载举报类型下拉菜单。
     *
     * @return JSON格式的举报类型列表
     */
    @GetMapping("/types")
    @ResponseBody
    public Map<String, Object> getReportTypes() {
        Map<String, Object> response = new HashMap<>();
        try {
            List<ReportType> types = reportService.getAllReportTypes();
            response.put("code", 200);
            response.put("data", types);
        } catch (Exception e) {
            e.printStackTrace();
            response.put("code", 500);
            response.put("message", "获取举报类型失败，请稍后重试。");
        }
        return response;
    }

    /**
     * 处理AJAX提交的举报请求。
     *
     * @param postId      当前帖子的ID
     * @param reportTypeId 举报类型ID
     * @param content     举报描述
     * @param session     HTTP会话，用于获取登录用户信息
     * @return JSON格式的响应
     */
    @PostMapping("/report")
    @ResponseBody
    public Map<String, Object> submitReport(
            @RequestParam("postId") Integer postId,
            @RequestParam("reportTypeId") Integer reportTypeId,
            @RequestParam("content") String content,
            HttpSession session) {

        Map<String, Object> response = new HashMap<>();

        // 检查用户是否登录
        Object userObj = session.getAttribute("loggedInUser");
        if (userObj == null) {
            response.put("code", 401);
            response.put("message", "请先登录再举报。");
            return response;
        }

        // 假设登录用户对象为 User，且具有 getId() 方法
        User loggedInUser = (User) userObj;

        // 验证举报内容
        if (reportTypeId == null || content == null || content.trim().isEmpty()) {
            response.put("code", 400);
            response.put("message", "举报类型和内容不能为空。");
            return response;
        }
        if (content.length() < 5 || content.length() > 500) {
            response.put("code", 400);
            response.put("message", "举报内容长度应在5到500之间。");
            return response;
        }

        // 创建举报对象
        Report report = new Report();
        report.setPostId(postId);
        report.setUserId(loggedInUser.getId());
        report.setReportTypeId(reportTypeId);
        report.setDescription(content);
        report.setCreatedAt(new Date());
        report.setUpdatedAt(new Date());

        try {
            reportService.addReport(report);
            response.put("code", 200);
            response.put("message", "举报提交成功！");
        } catch (Exception e) {
            e.printStackTrace();
            response.put("code", 500);
            response.put("message", "举报提交失败，请稍后重试。");
        }

        return response;
    }




    @GetMapping("/myReports")
    public String myReports(HttpSession session, Model model, RedirectAttributes redirectAttributes) {
        User loggedInUser = (User) session.getAttribute("loggedInUser");
        if (loggedInUser == null) {
            // 用户未登录，重定向到登录页面
            redirectAttributes.addFlashAttribute("errorMessage", "请先登录查看自己的举报记录");
            return "redirect:/login.jsp";
        }

        // 获取当前用户的所有举报记录
        List<Report> myReports = reportService.getReportsByUserId(loggedInUser.getId());
        model.addAttribute("myReports", myReports);

        // 获取所有举报类型列表，并构建一个类型ID到类型名称的映射
        List<ReportType> allTypes = reportService.getAllReportTypes();
        Map<Integer, String> typeMap = new HashMap<>();
        for (ReportType t : allTypes) {
            // 假设ReportType里字段名为id和typeName，请根据实际情况修改
            typeMap.put(t.getId(), t.getTypeName());
        }
        model.addAttribute("typeMap", typeMap);
        model.addAttribute("allTypes", allTypes); // 用于下拉选择

        return "reports"; // 返回reports.jsp页面
    }

    @PostMapping("/edit")
    public String updateReport(
            @RequestParam("id") Integer id,
            @RequestParam("reportTypeId") Integer reportTypeId,
            @RequestParam("description") String description,
            HttpSession session,
            RedirectAttributes redirectAttributes) {

        User loggedInUser = (User) session.getAttribute("loggedInUser");
        if (loggedInUser == null) {
            redirectAttributes.addFlashAttribute("errorMessage", "请先登录后再操作");
            return "redirect:/login.jsp";
        }

        Report report = reportService.getReportById(id);
        if (report == null) {
            redirectAttributes.addFlashAttribute("errorMessage", "未找到指定的举报记录。");
            return "redirect:/reports/myReports";
        }

        // 验证输入
        if (reportTypeId == null || description == null || description.trim().isEmpty()) {
            redirectAttributes.addFlashAttribute("errorMessage", "举报类型和内容不能为空。");
            return "redirect:/reports/myReports";
        }
        if (description.length() < 5 || description.length() > 500) {
            redirectAttributes.addFlashAttribute("errorMessage", "举报内容长度应在5到500之间。");
            return "redirect:/reports/myReports";
        }

        report.setReportTypeId(reportTypeId);
        report.setDescription(description);
        report.setUpdatedAt(new Date());

        try {
            reportService.updateReport(report);
            redirectAttributes.addFlashAttribute("successMessage", "举报记录更新成功！");
        } catch (Exception e) {
            e.printStackTrace();
            redirectAttributes.addFlashAttribute("errorMessage", "举报记录更新失败，请稍后重试。");
        }

        return "redirect:/reports/myReports";
    }

    // 删除指定的举报记录
    @GetMapping("/delete")
    public String deleteReport(@RequestParam("id") Integer id, HttpSession session, RedirectAttributes redirectAttributes) {
        User loggedInUser = (User) session.getAttribute("loggedInUser");
        if (loggedInUser == null) {
            redirectAttributes.addFlashAttribute("errorMessage", "请先登录后再操作");
            return "redirect:/login.jsp";
        }

        Report report = reportService.getReportById(id);
        if (report == null) {
            redirectAttributes.addFlashAttribute("errorMessage", "未找到指定的举报记录。");
            return "redirect:/reports/myReports";
        }

        try {
            reportService.deleteReport(id);
            redirectAttributes.addFlashAttribute("successMessage", "举报记录删除成功！");
        } catch (Exception e) {
            e.printStackTrace();
            redirectAttributes.addFlashAttribute("errorMessage", "举报记录删除失败，请稍后重试。");
        }
        return "redirect:/reports/myReports";
    }


}
