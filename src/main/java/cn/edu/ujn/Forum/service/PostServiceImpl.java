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
import org.springframework.util.StringUtils;
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

        // 设置摘要
        String summary = postDTO.getSummary();
        if(StringUtils.isEmpty(summary)) {
            // 如果没有提供摘要，从正文提取
            summary = extractSummary(postDTO.getContent(), 500);
        }
        post.setSummary(summary);

        // 设置其他信息
        post.setUserId(getCurrentUserId());
        post.setViewCount(0);
        post.setLikeCount(0);
        post.setCommentCount(0);
        post.setIsTop(0);
        post.setIsEssence(0);
        post.setStatus(postDTO.getStatus() != null ? postDTO.getStatus().byteValue() : (byte)0);
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
        if(!oldPost.getUserId().equals(getCurrentUserId()) && !isAdmin()) {
            throw new IllegalStateException("没有修改权限");
        }

        // 更新帖子
        Post post = new Post();
        post.setId(id);
        post.setCategoryId(postDTO.getCategoryId());
        post.setTitle(postDTO.getTitle());
        post.setContent(postDTO.getContent());

        String summary = postDTO.getSummary();
        if(StringUtils.isEmpty(summary)) {
            summary = extractSummary(postDTO.getContent(), 500);
        }
        post.setSummary(summary);

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
        if(!post.getUserId().equals(getCurrentUserId()) && !isAdmin()) {
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
    @Transactional
    public boolean setTopStatus(Long id, Integer isTop) {
        if(!isAdmin()) {
            throw new IllegalStateException("没有置顶权限");
        }
        return postMapper.updateTopStatus(id, isTop) > 0;
    }

    @Override
    @Transactional
    public boolean setEssenceStatus(Long id, Integer isEssence) {
        if(!isAdmin()) {
            throw new IllegalStateException("没有设置精华权限");
        }
        return postMapper.updateEssenceStatus(id, isEssence) > 0;
    }

    @Override
    @Transactional
    public boolean batchDelete(List<Long> ids) {
        if(!isAdmin()) {
            throw new IllegalStateException("没有批量删除权限");
        }
        return postMapper.batchDelete(ids) > 0;
    }

    @Override
    public List<Post> getHotPosts(int limit) {
        return postMapper.selectHotPosts(limit);
    }

    @Override
    public List<Post> getRelatedPosts(Long postId, int limit) {
        Post current = postMapper.selectById(postId);
        if(current == null) {
            return new ArrayList<>();
        }
        return postMapper.selectRelatedPosts(current.getCategoryId(), postId, limit);
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
        File dest = new File(uploadPath + fileName);
        if(!dest.getParentFile().exists()) {
            dest.getParentFile().mkdirs();
        }
        file.transferTo(dest);

        // 返回访问URL
        return uploadUrl + fileName;
    }

    @Override
    @Transactional
    public boolean batchAudit(List<Long> ids, Integer status, String reason) {
        if(!isAdmin()) {
            throw new IllegalStateException("没有审核权限");
        }
        return postMapper.batchUpdateStatus(ids, status) > 0;
    }

    // 提取摘要
    private String extractSummary(String content, int length) {
        if(StringUtils.isEmpty(content)) {
            return "";
        }
        // 移除HTML标签
        content = content.replaceAll("<[^>]+>", "");
        // 移除Markdown标记
        content = content.replaceAll("\\[([^\\]]*)\\]\\([^\\)]*\\)", "$1");
        content = content.replaceAll("[*_~`]", "");

        if(content.length() <= length) {
            return content;
        }
        return content.substring(0, length);
    }

    // 获取当前用户ID - 需要实际实现
    private Long getCurrentUserId() {
        // TODO: 实现获取当前用户ID的逻辑
        return 1L;
    }

    // 检查是否是管理员 - 需要实际实现
    private boolean isAdmin() {
        // TODO: 实现管理员检查逻辑
        return true;
    }
}