package com.meomureum.springboot.service; // 이 줄이 반드시 맨 위에 있어야 합니다!

import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Service;

import com.meomureum.springboot.dao.IMemberDAO;
import com.meomureum.springboot.dto.MemberDTO;

@Service
public class MemberService {

    @Autowired
    private IMemberDAO memberDAO;

    // 아이디 중복 확인
    public int idCheck(String m_id) {
        return memberDAO.checkId(m_id);
    }

//    // 회원가입
//    public int register(MemberDTO memberDto) {
//        if (memberDAO.checkId(memberDto.getM_id()) > 0) {
//            return 0;
//        }
//        return memberDAO.insertMember(memberDto);
//    }
//
//    // 로그인
//    public MemberDTO login(String m_id, String m_passwd) {
//        MemberDTO member = memberDAO.selectDAOById(m_id);
//        if (member != null && member.getM_passwd().equals(m_passwd)) {
//            member.setM_passwd(""); 
//            return member;
//        }
//        return null;
//    }
}