package com.meomureum.springboot.dao;
import java.util.List;

import org.apache.ibatis.annotations.Mapper;
import org.apache.ibatis.annotations.Param;

import com.meomureum.springboot.dto.QualifyDTO;

@Mapper
public interface IQualifyDAO {
    public List<QualifyDTO> listDao(); 
    public QualifyDTO selectDao(String qual_code); 
    public int insertDao(QualifyDTO dto); // 블랙리스트 정보 저장 시 사용
    public int deleteDao(String qual_code); 
    public int updateDao(QualifyDTO dto); 
    public QualifyDTO memberCode(String m_code); 
    
    // [추가] 재가입 방지를 위한 체크 메서드
    public int checkBlocked(@Param("black_email") String email, @Param("black_tel") String tel);
}