package cn.edu.ujn.Forum.service;

import cn.edu.ujn.Forum.dao.LikeMapper;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Service;

import java.util.List;

@Service
public class LikeServiceImpl implements ILikeService{
    @Autowired
    private LikeMapper likeMapper;
    @Override
    public boolean likePost(Integer userId, Integer postId) {

        try {
            int result = likeMapper.insertLike(userId, postId);
            return result > 0;
        } catch (Exception e) {
            System.err.println("Error liking post: " + e.getMessage());
            return false;
        }
    }

    @Override
    public boolean unlikePost(Integer userId, Integer postId) {
        try {
            int result = likeMapper.deleteLike(userId, postId);
            return result > 0;
        } catch (Exception e) {
            System.err.println("Error unliking post: " + e.getMessage());
            return false;
        }
    }

    @Override
    public int getLikeCountByPostId(Integer postId) {
        try {
            return likeMapper.countLikesByPostId(postId);
        } catch (Exception e) {
            System.err.println("Error retrieving like count: " + e.getMessage());
            return 0;
        }
    }

    @Override
    public List<Integer> getUsersWhoLikedPost(Integer postId) {
        try {
            return likeMapper.findUsersByPostId(postId);
        } catch (Exception e) {
            System.err.println("Error retrieving users who liked post: " + e.getMessage());
            return List.of();
        }
    }

    @Override
    public List<Integer> getLikedPostsByUserId(Integer userId) {
        try {
            return likeMapper.findPostsByUserId(userId);
        } catch (Exception e) {
            System.err.println("Error retrieving posts liked by user: " + e.getMessage());
            return List.of();
        }
    }

    @Override
    public boolean hasUserLikedPost(Integer userId, Integer postId) {
        try {
            int result = likeMapper.checkIfUserLikedPost(userId, postId);
            return result > 0;
        } catch (Exception e) {
            System.err.println("Error checking if user liked post: " + e.getMessage());
            return false;
        }
    }
}
