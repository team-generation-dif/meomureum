package com.meomureum.springboot.dao;

import java.util.List;

import org.apache.ibatis.annotations.Mapper;
import com.meomureum.springboot.dto.MemberDTO;

@Mapper
public interface IMemberDAO {
    // 1. 회원가입
    public int insertMember(MemberDTO memberDto);
    // 2. 아이디 중복 체크 (DB 쿼리용)
    public int checkId(String m_id);
    public List<MemberDTO> listDao(); // 회원목록
	public MemberDTO viewDao(String m_code); // 회원정보 상세보기
	public int updateDao(MemberDTO dto);// 회원 정보 수정
	public int deleteDao(String m_code);              // 회원 탈퇴
    // 3. 로그인/상세조회
    MemberDTO getMemberById(String m_id);
    
}
