package com.meomureum.springboot.dao;

import java.util.List;
import org.apache.ibatis.annotations.Mapper;
import com.meomureum.springboot.dto.MemberDTO;

@Mapper
public interface IMemberDAO {
    public int insertMember(MemberDTO memberDto);
    public int checkId(String m_id);
    public List<MemberDTO> listDao(); 			  // 회원목록
  	public MemberDTO viewDao(String m_code); 	// 회원정보 상세보기
	  public int updateDao(MemberDTO dto);		  // 회원 정보 수정
  	public int deleteDao(String m_code);      // 회원 탈퇴
    // 3. 로그인/상세조회
    public MemberDTO selectDAOById(String m_id);
    
    // [추가] 관리자용 등급 수정 메서드
    public int updateGradeDao(String m_code, String m_grade);
}