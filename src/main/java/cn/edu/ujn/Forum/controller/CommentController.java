package cn.edu.ujn.Forum.controller;

import cn.edu.ujn.Forum.dao.Comment;
import cn.edu.ujn.Forum.service.ICommentService;
import cn.edu.ujn.Forum.util.CommentDTO;
import cn.edu.ujn.Forum.util.Result;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Controller;
import org.springframework.web.bind.annotation.*;

import java.util.List;

/**
 * 评论控制器
 * @author [你的名字]
 */
@Controller
@RequestMapping("/comment")
public class CommentController {

    @Autowired
    private ICommentService commentService;

    /**
     * 发表评论
     */
    @PostMapping("/create")
    @ResponseBody
    public Result<Comment> createComment(@RequestBody CommentDTO commentDTO) {
        try {
            Comment comment = commentService.createComment(commentDTO);
            return Result.success(comment);
        } catch (IllegalArgumentException e) {
            return Result.fail(e.getMessage());
        } catch (Exception e) {
            return Result.fail("发表评论失败");
        }
    }

    /**
     * 删除评论
     */
    @PostMapping("/delete/{id}")
    @ResponseBody
    public Result<Boolean> deleteComment(@PathVariable Long id) {
        try {
            boolean success = commentService.deleteComment(id);
            return success ? Result.success(true) : Result.fail("删除评论失败");
        } catch (IllegalStateException e) {
            return Result.fail(e.getMessage());
        } catch (Exception e) {
            return Result.fail("删除评论失败");
        }
    }

    /**
     * 获取帖子的评论列表
     */
    @GetMapping("/list/{postId}")
    @ResponseBody
    public Result<List<Comment>> getPostComments(@PathVariable("postId") Long postId) {
        try {
            List<Comment> comments = commentService.getPostComments(postId);
            return Result.success(comments);
        } catch (Exception e) {
            return Result.fail("获取评论列表失败");
        }
    }

    /**
     * 审核评论
     */
    @PostMapping("/audit/{id}")
    @ResponseBody
    public Result<Boolean> auditComment(
            @PathVariable Long id,
            @RequestParam Integer status,
            @RequestParam(required = false) String reason) {
        try {
            boolean success = commentService.auditComment(id, status, reason);
            return success ? Result.success(true) : Result.fail("审核评论失败");
        } catch (IllegalStateException e) {
            return Result.fail(e.getMessage());
        } catch (Exception e) {
            return Result.fail("审核评论失败");
        }
    }

    /**
     * 点赞评论
     */
    @PostMapping("/like/{id}")
    @ResponseBody
    public Result<Boolean> likeComment(@PathVariable Long id) {
        try {
            boolean success = commentService.likeComment(id);
            return success ? Result.success(true) : Result.fail("点赞失败");
        } catch (Exception e) {
            return Result.fail("点赞失败");
        }
    }
}