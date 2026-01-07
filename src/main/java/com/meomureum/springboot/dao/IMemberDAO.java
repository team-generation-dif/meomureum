package com.meomureum.springboot.dao;

import java.util.List;

import org.apache.ibatis.annotations.Mapper;

import com.meomureum.springboot.dto.MemberDTO;


@Mapper
public interface IMemberDAO {
	public List<MemberDTO> listDao(); // 목록
	public MemberDTO selectDao(String m_code); // 멤버 조회 
	public int insertDao(MemberDTO dto); // 회원가입
	public int deleteDao(String m_code); // 삭제
	public int updateDao(MemberDTO dto); // 수정
	public MemberDTO memberId(String m_id); // 아이디 조회(특정 조건으로 데이터를 조회한다)
}
