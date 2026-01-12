package com.meomureum.springboot.dao;

import java.util.List;
import org.apache.ibatis.annotations.Mapper;
import com.meomureum.springboot.dto.MemberDTO;

@Mapper
public interface IMemberDAO {
    public int insertMember(MemberDTO memberDto);
    public int checkId(String m_id);
    public List<MemberDTO> listDao(); 
    public MemberDTO viewDao(String m_code); 
    public int updateDao(MemberDTO dto);
    public int deleteDao(String m_code);     
    public MemberDTO selectDAOById(String m_id);
    
    // [추가] 관리자용 등급 수정 메서드
    public int updateGradeDao(String m_code, String m_grade);
}