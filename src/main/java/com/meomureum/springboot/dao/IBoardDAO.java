package com.meomureum.springboot.dao;

import java.util.List;

import org.apache.ibatis.annotations.Mapper;

import com.meomureum.springboot.dto.BoardDTO;



@Mapper
public interface IBoardDAO {
	public List<BoardDTO> listDao();  // 게시판 목록
	public BoardDTO selectDao(String b_code); // 목록(자세히)
	public int insertDao(BoardDTO dto); // 작성
	public int deleteDao(String b_code); 
	public int updateDao(BoardDTO dto); 
	public BoardDTO boardTitle(String b_title); // 제목 조회
}
