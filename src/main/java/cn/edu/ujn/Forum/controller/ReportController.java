package cn.edu.ujn.Forum.controller;

import cn.edu.ujn.Forum.dao.Report;
import cn.edu.ujn.Forum.service.IReportService;
import cn.edu.ujn.Forum.util.Page;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Controller;
import org.springframework.ui.Model;
import org.springframework.web.bind.annotation.*;

@Controller
public class ReportController {

    @Autowired
    private IReportService reportService;

    /**
     * 在用户页面集成举报信息
     */
    @GetMapping("/user/reports")
    public String listReportsInUserPage(@RequestParam(value = "page", defaultValue = "1") Integer page,
                                        @RequestParam(value = "rows", defaultValue = "10") Integer rows,
                                        Model model) {
        // 参数校验
        if (page < 1) {
            page = 1; // 默认页码为1
        }
        if (rows < 1) {
            rows = 10; // 默认每页10条
        }

        Page<Report> pageData = reportService.getReportsPaged(page, rows);
        model.addAttribute("reportsPage", pageData); // 将分页数据传递到前端
        return "user"; // 返回用户页面
    }

    /**
     * 新增举报信息
     */
    @PostMapping("/user/reports")
    @ResponseBody
    public String create(@RequestBody Report report) {
        try {
            reportService.addReport(report);
            return "OK";
        } catch (Exception e) {
            return "FAIL";
        }
    }

    /**
     * 根据ID获取举报信息
     */
    @GetMapping("/user/reports/{id}")
    @ResponseBody
    public Report getReportById(@PathVariable("id") Integer id) {
        return reportService.getReportById(id);
    }

    /**
     * 更新举报信息
     */
    @PutMapping("/user/reports")
    @ResponseBody
    public String update(@RequestBody Report report) {
        try {
            reportService.updateReport(report);
            return "OK";
        } catch (Exception e) {
            return "FAIL";
        }
    }

    /**
     * 删除举报信息
     */
    @DeleteMapping("/user/reports/{id}")
    @ResponseBody
    public String delete(@PathVariable("id") Integer id) {
        try {
            reportService.deleteReportById(id);
            return "OK";
        } catch (Exception e) {
            return "FAIL";
        }
    }
}
