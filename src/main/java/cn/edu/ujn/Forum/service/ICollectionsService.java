package cn.edu.ujn.Forum.service;

import java.util.List;

public interface ICollectionsService {
    boolean addCollection(Integer userId, Long postId);
    boolean removeCollection(Integer userId, Long postId);
    boolean isCollected(Integer userId, Long postId);
    List<Long> getUserCollections(Integer userId);
    int countCollections(Long postId);
    List<String> getCollectionUsers(Long postId);
}
