package com.meomureum.springboot.dao;

import java.util.List;
import com.meomureum.springboot.dto.ReplyDTO;
import org.apache.ibatis.annotations.Mapper;

@Mapper
public interface IReplyDAO {
    void insertReply(ReplyDTO dto);              // 댓글 등록
    List<ReplyDTO> getReplies(String b_code);    // 댓글 목록 조회
}

