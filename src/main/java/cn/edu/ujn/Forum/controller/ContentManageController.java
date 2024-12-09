package cn.edu.ujn.Forum.controller;

import cn.edu.ujn.Forum.dao.Post;
import cn.edu.ujn.Forum.dao.Comment;
import cn.edu.ujn.Forum.service.IPostService;
import cn.edu.ujn.Forum.service.ICommentService;
import cn.edu.ujn.Forum.util.PostQuery;
import cn.edu.ujn.Forum.util.PageResult;
import cn.edu.ujn.Forum.util.Result;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Controller;
import org.springframework.ui.Model;
import org.springframework.web.bind.annotation.*;

/**
 * 内容管理控制器
 * @author [你的名字]
 */
@Controller
@RequestMapping("/admin/content")
public class ContentManageController {

    @Autowired
    private IPostService postService;

    @Autowired
    private ICommentService commentService;

    /**
     * 帖子管理页面
     */
    @GetMapping("/posts")
    public String posts(Model model) {
        return "admin/content/posts";
    }

    /**
     * 评论管理页面
     */
    @GetMapping("/comments")
    public String comments(Model model) {
        return "admin/content/comments";
    }

    /**
     * 获取帖子列表
     */
    @GetMapping("/post/list")
    @ResponseBody
    public Result<PageResult<Post>> getPostList(PostQuery query) {
        try {
            query.setLimit(10);  // 每页10条
            PageResult<Post> pageResult = postService.getPostList(query);
            return Result.success(pageResult);
        } catch (Exception e) {
            return Result.fail("获取帖子列表失败");
        }
    }

    /**
     * 批量审核帖子
     */
    @PostMapping("/post/audit/batch")
    @ResponseBody
    public Result<Boolean> batchAuditPosts(
            @RequestParam("ids[]") Long[] ids,
            @RequestParam Integer status,
            @RequestParam(required = false) String reason) {
        try {
            for (Long id : ids) {
                postService.auditPost(id, status, reason);
            }
            return Result.success(true);
        } catch (IllegalStateException e) {
            return Result.fail(e.getMessage());
        } catch (Exception e) {
            return Result.fail("批量审核失败");
        }
    }

    /**
     * 批量删除帖子
     */
    @PostMapping("/post/delete/batch")
    @ResponseBody
    public Result<Boolean> batchDeletePosts(@RequestParam("ids[]") Long[] ids) {
        try {
            for (Long id : ids) {
                postService.deletePost(id);
            }
            return Result.success(true);
        } catch (IllegalStateException e) {
            return Result.fail(e.getMessage());
        } catch (Exception e) {
            return Result.fail("批量删除失败");
        }
    }

    /**
     * 批量审核评论
     */
    @PostMapping("/comment/audit/batch")
    @ResponseBody
    public Result<Boolean> batchAuditComments(
            @RequestParam("ids[]") Long[] ids,
            @RequestParam Integer status,
            @RequestParam(required = false) String reason) {
        try {
            for (Long id : ids) {
                commentService.auditComment(id, status, reason);
            }
            return Result.success(true);
        } catch (IllegalStateException e) {
            return Result.fail(e.getMessage());
        } catch (Exception e) {
            return Result.fail("批量审核失败");
        }
    }
}