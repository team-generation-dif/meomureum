package com.meomureum.springboot.dao;

import java.util.List;

import org.apache.ibatis.annotations.Mapper;

import com.meomureum.springboot.dto.QualifyDTO;


@Mapper
public interface IQualifyDAO {
	public List<QualifyDTO> listDao(); // 게시글
	public QualifyDTO selectDao(String qual_code); // 상세보기
	public int insertDao(QualifyDTO dto); // 사유 작성
	public int deleteDao(String qual_code); // 삭제
	public int updateDao(QualifyDTO dto); // 수정(비밀글)
	public QualifyDTO memberCode(String m_code); // 회원(코드) 조회
}
