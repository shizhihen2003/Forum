package cn.edu.ujn.Forum.service;

import cn.edu.ujn.Forum.dao.Post;
import cn.edu.ujn.Forum.util.PageResult;
import cn.edu.ujn.Forum.util.PostDTO;
import cn.edu.ujn.Forum.util.PostQuery;

public interface IPostService {
    Post createPost(PostDTO postDTO);

    // 更新帖子
    boolean updatePost(Long id, PostDTO postDTO);

    // 删除帖子
    boolean deletePost(Long id);

    // 获取帖子详情
    Post getPostDetail(Long id);

    // 分页查询帖子列表
    PageResult<Post> getPostList(PostQuery query);

    // 审核帖子
    boolean auditPost(Long id, Integer status, String reason);

    // 点赞帖子
    boolean likePost(Long id);
}
