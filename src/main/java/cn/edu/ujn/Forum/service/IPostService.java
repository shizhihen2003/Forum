package cn.edu.ujn.Forum.service;

import cn.edu.ujn.Forum.dao.Post;
import cn.edu.ujn.Forum.util.PageResult;
import cn.edu.ujn.Forum.util.PostDTO;
import cn.edu.ujn.Forum.util.PostQuery;
import org.springframework.web.multipart.MultipartFile;

import java.util.List;

public interface IPostService {
    /**
     * 创建帖子
     */
    Post createPost(PostDTO postDTO);

    /**
     * 更新帖子
     */
    boolean updatePost(Long id, PostDTO postDTO);

    /**
     * 删除帖子
     */
    boolean deletePost(Long id);

    /**
     * 获取帖子详情
     */
    Post getPostDetail(Long id);

    /**
     * 分页查询帖子列表
     */
    PageResult<Post> getPostList(PostQuery query);

    /**
     * 审核帖子
     */
    boolean auditPost(Long id, Integer status, String reason);

    /**
     * 点赞帖子
     */
    boolean likePost(Long id);

    /**
     * 获取热门帖子
     * @param limit 获取数量
     * @return 热门帖子列表
     */
    List<Post> getHotPosts(int limit);

    /**
     * 获取相关帖子
     * @param postId 当前帖子ID
     * @param limit 获取数量
     * @return 相关帖子列表
     */
    List<Post> getRelatedPosts(Long postId, int limit);

    /**
     * 上传图片
     * @param file 图片文件
     * @return 图片URL
     */
    String uploadImage(MultipartFile file) throws Exception;
}