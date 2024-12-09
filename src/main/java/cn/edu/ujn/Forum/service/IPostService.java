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
     * 置顶帖子
     */
    boolean setTopStatus(Long id, Integer isTop);

    /**
     * 设置精华
     */
    boolean setEssenceStatus(Long id, Integer isEssence);

    /**
     * 批量删除帖子
     */
    boolean batchDelete(List<Long> ids);

    /**
     * 获取热门帖子
     */
    List<Post> getHotPosts(int limit);

    /**
     * 获取相关帖子
     */
    List<Post> getRelatedPosts(Long postId, int limit);

    /**
     * 上传图片
     */
    String uploadImage(MultipartFile file) throws Exception;

    /**
     * 批量审核帖子
     */
    boolean batchAudit(List<Long> ids, Integer status, String reason);
}