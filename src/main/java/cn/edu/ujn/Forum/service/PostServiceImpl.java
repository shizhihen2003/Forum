package cn.edu.ujn.Forum.service;

import cn.edu.ujn.Forum.dao.Post;
import cn.edu.ujn.Forum.dao.PostMapper;
import cn.edu.ujn.Forum.util.PageResult;
import cn.edu.ujn.Forum.util.PostDTO;
import cn.edu.ujn.Forum.util.PostQuery;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Service;

import java.util.Date;
import java.util.List;

@Service
public class PostServiceImpl implements IPostService{
    @Autowired
    private PostMapper postMapper;

    @Override
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
        post.setUserId(getCurrentUserId()); // 需要实现获取当前用户ID的方法
        post.setViewCount(0);
        post.setLikeCount(0);
        post.setCommentCount(0);
        post.setStatus((byte) 0); // 待审核
        post.setCreateTime(new Date());

        // 插入数据库
        postMapper.insert(post);

        return post;
    }

    @Override
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
    public boolean deletePost(Long id) {
        // 查询帖子
        Post post = postMapper.selectById(id);
        if(post == null) {
            return false;
        }

        // 权限检查
        if(!post.getUserId().equals(getCurrentUserId())) {
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
    public boolean auditPost(Long id, Integer status, String reason) {
        // 权限检查
        if(!isAdmin()) { // 需要实现管理员检查方法
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
    public boolean likePost(Long id) {
        Post post = postMapper.selectById(id);
        if(post == null || post.getStatus() != 1) {
            return false;
        }

        return postMapper.updateLikeCount(id, 1) > 0;
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
