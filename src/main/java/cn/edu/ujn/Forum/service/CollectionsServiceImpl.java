package cn.edu.ujn.Forum.service;

import cn.edu.ujn.Forum.dao.Collections;
import cn.edu.ujn.Forum.dao.CollectionsMapper;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Service;

import java.sql.Timestamp;
import java.util.List;

@Service
public class CollectionsServiceImpl implements ICollectionsService {

    @Autowired
    private CollectionsMapper collectionMapper;

    @Override
    public boolean addCollection(Integer userId, Long postId) {
        if (!isCollected(userId, postId)) {
            Collections collection = new Collections();
            collection.setUserId(userId);
            collection.setPostId(postId);
            collection.setCreatedAt(new Timestamp(System.currentTimeMillis()));
            return collectionMapper.insertCollection(collection) > 0;
        }
        return false; // 已经收藏，不能重复收藏
    }

    @Override
    public boolean removeCollection(Integer userId, Long postId) {
        if (isCollected(userId, postId)) {
            return collectionMapper.deleteCollection(userId, postId) > 0;
        }
        return false; // 未收藏，无法取消
    }

    @Override
    public boolean isCollected(Integer userId, Long postId) {
        return collectionMapper.isCollected(userId, postId) > 0;
    }

    @Override
    public List<Long> getUserCollections(Integer userId) {
        return collectionMapper.getUserCollections(userId);
    }

    @Override
    public int countCollections(Long postId) {
        return collectionMapper.countCollections(postId);
    }

    @Override
    public List<String> getCollectionUsers(Long postId) {
        return collectionMapper.getCollectionUsers(postId);
    }
}
