package com.meomureum.springboot.dao;

import java.util.List;

import org.apache.ibatis.annotations.Mapper;

import com.meomureum.springboot.dto.ReplyDTO;


@Mapper
public interface IReplyDAO {
	public List<ReplyDTO> listDao(); // 게시글 목록
	public ReplyDTO selectDao(String re_code); // 상세보기
	public int insertDao(ReplyDTO dto); // 글 작성
	public int deleteDao(String re_code); // 삭제
	public int updateDao(ReplyDTO dto); // 수정(비밀글)
	public ReplyDTO boardCode(String b_code); // 게시(코드) 조회
}
