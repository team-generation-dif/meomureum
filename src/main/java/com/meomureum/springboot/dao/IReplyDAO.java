package com.meomureum.springboot.dao;

import java.util.List;
import com.meomureum.springboot.dto.ReplyDTO;
import org.apache.ibatis.annotations.Mapper;

@Mapper
public interface IReplyDAO {
	ReplyDTO getReplyByCode(String re_code);     // 단일 댓글 조회
    void insertReply(ReplyDTO dto);              // 댓글 등록
    List<ReplyDTO> getReplies(String b_code);    // 댓글 목록 조회
    void updateReply(ReplyDTO dto);   // 댓글 수정
    void deleteReply(String re_code); // 댓길 삭제
    
}

