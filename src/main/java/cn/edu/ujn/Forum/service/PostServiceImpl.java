package cn.edu.ujn.Forum.service;

import cn.edu.ujn.Forum.dao.Post;
import cn.edu.ujn.Forum.dao.PostMapper;
import cn.edu.ujn.Forum.util.PageResult;
import cn.edu.ujn.Forum.util.PostDTO;
import cn.edu.ujn.Forum.util.PostQuery;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.beans.factory.annotation.Value;
import org.springframework.stereotype.Service;
import org.springframework.transaction.annotation.Transactional;
import org.springframework.web.multipart.MultipartFile;

import java.io.File;
import java.util.ArrayList;
import java.util.Date;
import java.util.List;
import java.util.UUID;

@Service
public class PostServiceImpl implements IPostService {

    @Autowired
    private PostMapper postMapper;

    @Value("${upload.path}")
    private String uploadPath;

    @Value("${upload.url}")
    private String uploadUrl;

    @Override
    @Transactional
    public Post createPost(PostDTO postDTO) {
        // 参数校验
        String error = postDTO.validate();
        if(error != null) {
            throw new IllegalArgumentException(error);
        }

        Post post = new Post();
        // 设置基础信息
        post.setCategoryId(postDTO.getCategoryId());
        post.setTitle(postDTO.getTitle());
        post.setContent(postDTO.getContent());
        post.setSummary(postDTO.getSummary());

        // 设置其他信息
        post.setUserId(getCurrentUserId());
        post.setViewCount(0);
        post.setLikeCount(0);
        post.setCommentCount(0);
        post.setStatus((byte) (postDTO.getStatus() != null ? postDTO.getStatus() : 0)); // 默认为待审核
        post.setCreateTime(new Date());

        // 插入数据库
        postMapper.insert(post);

        return post;
    }

    @Override
    @Transactional
    public boolean updatePost(Long id, PostDTO postDTO) {
        // 参数校验
        String error = postDTO.validate();
        if(error != null) {
            throw new IllegalArgumentException(error);
        }

        // 查询原帖子
        Post oldPost = postMapper.selectById(id);
        if(oldPost == null || oldPost.getStatus() == 3) {
            return false;
        }

        // 权限检查
        if(!oldPost.getUserId().equals(getCurrentUserId())) {
            throw new IllegalStateException("没有修改权限");
        }

        // 更新帖子
        Post post = new Post();
        post.setId(id);
        post.setCategoryId(postDTO.getCategoryId());
        post.setTitle(postDTO.getTitle());
        post.setContent(postDTO.getContent());
        post.setSummary(postDTO.getSummary());
        post.setUpdateTime(new Date());

        return postMapper.update(post) > 0;
    }

    @Override
    @Transactional
    public boolean deletePost(Long id) {
        // 查询帖子
        Post post = postMapper.selectById(id);
        if(post == null) {
            return false;
        }

        // 权限检查
        Long currentUserId = getCurrentUserId();
        if(!post.getUserId().equals(currentUserId) && !isAdmin()) {
            throw new IllegalStateException("没有删除权限");
        }

        // 逻辑删除
        return postMapper.updateStatus(id, 3) > 0;
    }

    @Override
    public Post getPostDetail(Long id) {
        Post post = postMapper.selectById(id);
        if(post == null || post.getStatus() == 3) {
            return null;
        }

        // 增加浏览次数
        postMapper.increaseViewCount(id);

        return post;
    }

    @Override
    public PageResult<Post> getPostList(PostQuery query) {
        // 查询数据
        List<Post> list = postMapper.selectList(query);
        int total = postMapper.countList(query);

        // 返回分页结果
        return new PageResult<>(list, total, query.getPage(), query.getPageSize());
    }

    @Override
    @Transactional
    public boolean auditPost(Long id, Integer status, String reason) {
        // 权限检查
        if(!isAdmin()) {
            throw new IllegalStateException("没有审核权限");
        }

        // 查询帖子
        Post post = postMapper.selectById(id);
        if(post == null || post.getStatus() == 3) {
            return false;
        }

        // 更新状态
        return postMapper.updateStatus(id, status) > 0;
    }

    @Override
    @Transactional
    public boolean likePost(Long id) {
        Post post = postMapper.selectById(id);
        if(post == null || post.getStatus() != 1) {
            return false;
        }

        return postMapper.updateLikeCount(id, 1) > 0;
    }

    @Override
    public List<Post> getHotPosts(int limit) {
        PostQuery query = new PostQuery();
        query.setStatus(1); // 已发布的帖子
        query.setOrderBy("view_count DESC"); // 按浏览量排序
        query.setLimit(limit);
        return postMapper.selectList(query);
    }

    @Override
    public List<Post> getRelatedPosts(Long postId, int limit) {
        Post current = postMapper.selectById(postId);
        if(current == null) {
            return new ArrayList<>();
        }

        // 获取同分类的其他帖子
        PostQuery query = new PostQuery();
        query.setCategoryId(current.getCategoryId());
        query.setStatus(1); // 已发布的帖子
        query.setExcludeId(postId); // 排除当前帖子
        query.setLimit(limit);
        query.setOrderBy("create_time DESC"); // 按创建时间倒序
        return postMapper.selectList(query);
    }

    @Override
    public String uploadImage(MultipartFile file) throws Exception {
        if(file.isEmpty()) {
            throw new IllegalArgumentException("请选择图片文件");
        }

        // 检查文件类型
        String contentType = file.getContentType();
        if(contentType == null || !contentType.startsWith("image/")) {
            throw new IllegalArgumentException("只能上传图片文件");
        }

        // 生成文件名
        String originalFilename = file.getOriginalFilename();
        String extension = originalFilename.substring(originalFilename.lastIndexOf("."));
        String fileName = UUID.randomUUID().toString() + extension;

        // 保存文件
        File uploadDir = new File(uploadPath);
        if(!uploadDir.exists()) {
            uploadDir.mkdirs();
        }
        File dest = new File(uploadPath + fileName);
        file.transferTo(dest);

        // 返回访问URL
        return uploadUrl + fileName;
    }

    // 获取当前用户ID方法
    private Long getCurrentUserId() {
        // TODO: 实现获取当前用户ID的逻辑
        return 1L; // 临时返回值
    }

    // 检查是否是管理员
    private boolean isAdmin() {
        // TODO: 实现管理员检查逻辑
        return false; // 临时返回值
    }
}