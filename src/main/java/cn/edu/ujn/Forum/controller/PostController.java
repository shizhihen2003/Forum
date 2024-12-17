package cn.edu.ujn.Forum.controller;

import cn.edu.ujn.Forum.dao.Comment;
import cn.edu.ujn.Forum.dao.Post;
import cn.edu.ujn.Forum.dao.Category;
import cn.edu.ujn.Forum.dao.User;
import cn.edu.ujn.Forum.service.ICommentService;
import cn.edu.ujn.Forum.service.IPostService;
import cn.edu.ujn.Forum.service.ICategoryService;
import cn.edu.ujn.Forum.util.PageResult;
import cn.edu.ujn.Forum.util.PostDTO;
import cn.edu.ujn.Forum.util.PostQuery;
import cn.edu.ujn.Forum.util.Result;
import jakarta.servlet.http.HttpSession;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Controller;
import org.springframework.ui.Model;
import org.springframework.web.bind.annotation.*;
import org.springframework.web.multipart.MultipartFile;

import java.util.List;

/**
 * 帖子控制器
 * @author [你的名字]
 */
@Controller
@RequestMapping("/post")
public class PostController {

    @Autowired
    private IPostService postService;

    @Autowired
    private ICategoryService categoryService;

    @Autowired
    private ICommentService commentService;

    /**
     * 跳转到首页帖子列表
     */
    @GetMapping("")
    public String toListPage(Model model, PostQuery query) {
        // 设置分页默认值
        if(query.getPage() == null) {
            query.setPage(1);
        }
        if(query.getPageSize() == null) {
            query.setPageSize(10);
        }

        // 获取帖子列表
        PageResult<Post> pageResult = postService.getPostList(query);
        model.addAttribute("pageResult", pageResult);

        // 获取分类列表
        List<Category> categories = categoryService.getAllCategories();
        model.addAttribute("categories", categories);

        // 获取热门帖子
        List<Post> hotPosts = postService.getHotPosts(10);
        model.addAttribute("hotPosts", hotPosts);

        // 构建分页查询参数
        StringBuilder queryString = new StringBuilder();
        if(query.getCategoryId() != null) {
            queryString.append("&categoryId=").append(query.getCategoryId());
        }
        if(query.getKeyword() != null && !query.getKeyword().isEmpty()) {
            queryString.append("&keyword=").append(query.getKeyword());
        }
        model.addAttribute("queryString", queryString.toString());

        return "post/list";
    }

    /**
     * 发布帖子页面
     */
    @GetMapping("/create")
    public String toCreatePage(Model model) {
        // 获取分类列表
        List<Category> categories = categoryService.getAllCategories();
        model.addAttribute("categories", categories);
        return "post/create";
    }

    /**
     * 发布帖子
     */
    @PostMapping("/create")
    @ResponseBody
    public Result<Post> createPost(@RequestBody PostDTO postDTO, HttpSession session) {
        User user = (User) session.getAttribute("loggedInUser");
        if (user == null) {
            return Result.fail("请先登录后再发帖");
        }

        try {
            Post post = postService.createPost(postDTO);
            return Result.success(post);
        } catch (IllegalArgumentException e) {
            return Result.fail(e.getMessage());
        } catch (IllegalStateException e) {
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
     * 获取帖子详情（返回JSON数据）
     */
    @GetMapping("/api/detail/{id}")  // 修改URL路径
    @ResponseBody
    public Result<Post> getPostDetail(@PathVariable("id") Long id) {
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
     * 跳转到编辑页面
     */
    @GetMapping("/edit/{id}")
    public String toEditPage(@PathVariable Long id, Model model) {
        Post post = postService.getPostDetail(id);
        model.addAttribute("post", post);

        List<Category> categories = categoryService.getAllCategories();
        model.addAttribute("categories", categories);

        return "post/edit";
    }

    /**
     * 跳转到详情页面（返回视图）
     */
    /**
     * 跳转到详情页面（返回视图）
     */
    @GetMapping("/detail/{id}")
    public String toDetailPage(@PathVariable("id") Long id, Model model) {
        // 获取帖子详情
        Post post = postService.getPostDetail(id);
        model.addAttribute("post", post);

        // 获取评论列表
        List<Comment> comments = commentService.getPostComments(id);
        model.addAttribute("comments", comments); // 添加到模型中

        // 获取相关帖子
        List<Post> relatedPosts = postService.getRelatedPosts(id, 5);
        model.addAttribute("relatedPosts", relatedPosts);

        return "post/detail";
    }

    /**
     * 上传图片
     */
    @PostMapping("/upload")
    @ResponseBody
    public Result<String> uploadImage(@RequestParam("editormd-image-file") MultipartFile file) {
        try {
            String url = postService.uploadImage(file);
            return Result.success(url);
        } catch (Exception e) {
            return Result.fail("图片上传失败: " + e.getMessage());
        }
    }

    /**
     * 保存草稿
     */
    @PostMapping("/draft")
    @ResponseBody
    public Result<Post> saveDraft(@RequestBody PostDTO postDTO) {
        try {
            postDTO.setStatus(0); // 设置为草稿状态
            Post post = postService.createPost(postDTO);
            return Result.success(post);
        } catch (IllegalArgumentException e) {
            return Result.fail(e.getMessage());
        } catch (Exception e) {
            return Result.fail("保存草稿失败");
        }
    }
}