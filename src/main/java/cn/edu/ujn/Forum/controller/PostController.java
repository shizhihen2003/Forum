package cn.edu.ujn.Forum.controller;

import cn.edu.ujn.Forum.dao.Post;
import cn.edu.ujn.Forum.service.IPostService;
import cn.edu.ujn.Forum.util.PageResult;
import cn.edu.ujn.Forum.util.PostDTO;
import cn.edu.ujn.Forum.util.PostQuery;
import cn.edu.ujn.Forum.util.Result;

import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Controller;
import org.springframework.ui.Model;
import org.springframework.web.bind.annotation.*;

/**
 * 帖子控制器
 * @author [你的名字]
 */
@Controller
@RequestMapping("/post")
public class PostController {

    @Autowired
    private IPostService postService;

    /**
     * 跳转到列表页面
     */
    @GetMapping("")
    public String toListPage(Model model, PostQuery query) {
        if(query.getPage() == null) {
            query.setPage(1);
        }
        if(query.getPageSize() == null) {
            query.setPageSize(10);
        }
        PageResult<Post> pageResult = postService.getPostList(query);
        model.addAttribute("pageResult", pageResult);
        return "post/list";
    }

    /**
     * 发布帖子
     */
    @PostMapping("/create")
    @ResponseBody
    public Result<Post> createPost(@RequestBody PostDTO postDTO) {
        try {
            Post post = postService.createPost(postDTO);
            return Result.success(post);
        } catch (IllegalArgumentException e) {
            return Result.fail(e.getMessage());
        } catch (Exception e) {
            return Result.fail("发布帖子失败");
        }
    }

    /**
     * 更新帖子
     */
    @PostMapping("/update/{id}")
    @ResponseBody
    public Result<Boolean> updatePost(@PathVariable Long id, @RequestBody PostDTO postDTO) {
        try {
            boolean success = postService.updatePost(id, postDTO);
            return success ? Result.success(true) : Result.fail("更新帖子失败");
        } catch (IllegalArgumentException e) {
            return Result.fail(e.getMessage());
        } catch (IllegalStateException e) {
            return Result.fail(e.getMessage());
        } catch (Exception e) {
            return Result.fail("更新帖子失败");
        }
    }

    /**
     * 删除帖子
     */
    @PostMapping("/delete/{id}")
    @ResponseBody
    public Result<Boolean> deletePost(@PathVariable Long id) {
        try {
            boolean success = postService.deletePost(id);
            return success ? Result.success(true) : Result.fail("删除帖子失败");
        } catch (IllegalStateException e) {
            return Result.fail(e.getMessage());
        } catch (Exception e) {
            return Result.fail("删除帖子失败");
        }
    }

    /**
     * 获取帖子详情
     */
    @GetMapping("/detail/{id}")
    @ResponseBody
    public Result<Post> getPostDetail(@PathVariable Long id) {
        try {
            Post post = postService.getPostDetail(id);
            return post != null ? Result.success(post) : Result.fail("帖子不存在或已删除");
        } catch (Exception e) {
            return Result.fail("获取帖子详情失败");
        }
    }

    /**
     * 获取帖子列表
     */
    @GetMapping("/list")
    @ResponseBody
    public Result<PageResult<Post>> getPostList(PostQuery query) {
        try {
            PageResult<Post> pageResult = postService.getPostList(query);
            return Result.success(pageResult);
        } catch (Exception e) {
            return Result.fail("获取帖子列表失败");
        }
    }

    /**
     * 审核帖子
     */
    @PostMapping("/audit/{id}")
    @ResponseBody
    public Result<Boolean> auditPost(
            @PathVariable Long id,
            @RequestParam Integer status,
            @RequestParam(required = false) String reason) {
        try {
            boolean success = postService.auditPost(id, status, reason);
            return success ? Result.success(true) : Result.fail("审核帖子失败");
        } catch (IllegalStateException e) {
            return Result.fail(e.getMessage());
        } catch (Exception e) {
            return Result.fail("审核帖子失败");
        }
    }

    /**
     * 点赞帖子
     */
    @PostMapping("/like/{id}")
    @ResponseBody
    public Result<Boolean> likePost(@PathVariable Long id) {
        try {
            boolean success = postService.likePost(id);
            return success ? Result.success(true) : Result.fail("点赞失败");
        } catch (Exception e) {
            return Result.fail("点赞失败");
        }
    }

    /**
     * 跳转到发帖页面
     */
    @GetMapping("/create")
    public String toCreatePage() {
        return "post/create";
    }

    /**
     * 跳转到编辑页面
     */
    @GetMapping("/edit/{id}")
    public String toEditPage(@PathVariable Long id) {
        return "post/edit";
    }

    /**
     * 跳转到详情页面
     */
    @GetMapping("/{id}")
    public String toDetailPage(@PathVariable Long id, Model model) {
        Post post = postService.getPostDetail(id);
        model.addAttribute("post", post);
        return "post/detail";
    }
}