package com.meomureum.springboot.dao;

import java.util.List;
import org.apache.ibatis.annotations.Mapper;
import com.meomureum.springboot.dto.MemberDTO;

@Mapper
public interface IMemberDAO {
    int insertMember(MemberDTO memberDto);
    int checkId(String m_id);
    
    List<MemberDTO> listDao(); 			  // 회원목록
  	MemberDTO viewDao(String m_code); 	// 회원정보 상세보기
	int updateDao(MemberDTO dto);		  // 회원 정보 수정
  	int deleteDao(String m_code);      // 회원 탈퇴
  	
    // 3. 로그인/상세조회
    MemberDTO selectDAOById(String m_id);	// 로그인/상세조회
    List<MemberDTO> searchMembers(String keyword); // 검색 목록 (추가)
    
    // [추가] 관리자용 등급 수정 메서드
    int updateGradeDao(String m_code, String m_grade);
    
    // 관리자 센터용 카운트 메서드
    int countAllMembers();		// 전체 회원 수
    int countNewMembersToday();	// 오늘 신규 가입자 수
    int countTodayBoards(); 
}