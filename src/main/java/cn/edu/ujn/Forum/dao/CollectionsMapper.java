package cn.edu.ujn.Forum.dao;

import org.apache.ibatis.annotations.Mapper;
import org.apache.ibatis.annotations.Param;

import java.util.List;

@Mapper
public interface CollectionsMapper {
    int insertCollection(Collections collection);

    int deleteCollection(@Param("userId") Integer userId, @Param("postId") Long postId);

    int isCollected(@Param("userId") Integer userId, @Param("postId") Long postId);

    List<Long> getUserCollections(@Param("userId") Integer userId); // 返回 List<Long>

    int countCollections(@Param("postId") Long postId);

    List<String> getCollectionUsers(@Param("postId") Long postId);
}
