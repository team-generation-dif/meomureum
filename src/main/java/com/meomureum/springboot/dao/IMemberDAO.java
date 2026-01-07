package com.meomureum.springboot.dao;

import org.apache.ibatis.annotations.Mapper;
import com.meomureum.springboot.dto.MemberDTO;

@Mapper
public interface IMemberDAO {
    // 1. 회원가입
    int insertMember(MemberDTO memberDto);

    // 2. 아이디 중복 체크 (DB 쿼리용)
    int checkId(String m_id);

    // 3. 로그인/상세조회
    MemberDTO getMemberById(String m_id);
    
}
