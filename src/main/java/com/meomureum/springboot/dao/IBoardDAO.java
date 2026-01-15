package com.meomureum.springboot.dao;
import java.util.List;

import org.apache.ibatis.annotations.Mapper;

import com.meomureum.springboot.dto.BoardDTO;

@Mapper
public interface IBoardDAO {
    public List<BoardDTO> listDao();  
    public BoardDTO selectDao(String b_code); 
    public int insertDao(BoardDTO dto);  
    public int deleteDao(String b_code); 
    public int updateDao(BoardDTO dto);  
    public BoardDTO boardTitle(String b_title); 
    public int increaseViewCount(String b_code); 
    void deleteBoard(String b_code);
 // 사용자가 작성한 최근 게시물 3개 가져오기
    public List<BoardDTO> getMyRecentPosts(String m_code);
    // 📍 오늘 작성된 게시글 수 조회를 위한 메서드 추가
    public int countTodayBoards(); 
}