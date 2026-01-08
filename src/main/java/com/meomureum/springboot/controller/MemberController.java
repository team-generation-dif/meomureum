package com.meomureum.springboot.controller;

import java.util.List;

import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Controller;
import org.springframework.ui.Model;
import org.springframework.web.bind.annotation.PathVariable;
import org.springframework.web.bind.annotation.RequestMapping;
import org.springframework.web.bind.annotation.RequestMethod;
import org.springframework.web.bind.annotation.RequestParam;

import com.meomureum.springboot.dao.IMemberDAO;
import com.meomureum.springboot.dto.MemberDTO;

@Controller
@RequestMapping("/guest")
public class MemberController {

    @Autowired
    private IMemberDAO memberDAO;

    // 1. 회원가입 폼 이동
    @RequestMapping(value = "/join", method = RequestMethod.GET)
    public String joinForm() {
        return "guest/join";
    }

    // 2. 아이디 중복 확인
    @RequestMapping(value = "/idCheck", method = RequestMethod.GET)
    public String idCheckPage(@RequestParam(value="m_id", required=false) String m_id, Model model) {
        if (m_id != null && !m_id.trim().isEmpty()) {
            int result = memberDAO.checkId(m_id);
            model.addAttribute("result", result);
            model.addAttribute("m_id", m_id);
        }
        return "guest/idCheck";
    }

    // 3. 회원가입 처리
    @RequestMapping(value = "/join", method = RequestMethod.POST)
    public String join(MemberDTO memberDto, Model model) {
        int result = memberDAO.insertMember(memberDto);
        if (result > 0) {
            return "redirect:/guest/SignUpComplete";
        } else {
            model.addAttribute("error", "회원가입에 실패했습니다.");
            return "guest/join";
        }
    }

    // 4. 회원 목록 조회
    @RequestMapping(value = "/list", method = RequestMethod.GET)
    public String list(Model model) {
        List<MemberDTO> members = memberDAO.listDao();
        model.addAttribute("members", members);
        return "admin/member/memberList";
    }

    // 5. 회원 상세 조회
    @RequestMapping(value = "/view/{m_code}", method = RequestMethod.GET)
    public String view(@PathVariable("m_code") String m_code, Model model) {
        MemberDTO member = memberDAO.viewDao(m_code);
        model.addAttribute("member", member);
        return "admin/member/memberView";
    }

    // 6. 회원 정보 수정 처리
    @RequestMapping(value = "/update", method = RequestMethod.POST)
    public String update(MemberDTO dto) {
        int result = memberDAO.updateDao(dto);
        // 수정 성공 시 완료 페이지를 보여주는 메서드로 리다이렉트
        return (result > 0) ? "redirect:/user/mypage/myUpdate" 
                            : "redirect:/user/mypage/view/" + dto.getM_code() + "?error=update";
    }

    // 6-1. 수정 완료 결과 페이지 (404 방지용 추가)
    @RequestMapping(value = "/myUpdateView", method = RequestMethod.GET)
    public String myUpdateView() {
        return "user/mypage/myUpdateView";
    }

    // 7. 회원 탈퇴 처리
    @RequestMapping(value = "/delete/{m_code}", method = RequestMethod.GET)
    public String delete(@PathVariable("m_code") String m_code) {
        int result = memberDAO.deleteDao(m_code);
        // 탈퇴 성공 시 완료 페이지를 보여주는 메서드로 리다이렉트
        return (result > 0) ? "redirect:/user/mypage/mydelete" 
                            : "redirect:/guest/view/" + m_code + "?error=delete";
    }

    // 7-1. 탈퇴 완료 결과 페이지 (404 방지용 추가)
    @RequestMapping(value = "/mydeleteView", method = RequestMethod.GET)
    public String mydeleteView() {
        return "user/mypage/mydelete";
    }

    // 8. 로그인 폼 이동
    @RequestMapping(value = "/loginForm", method = RequestMethod.GET)
    public String loginForm() {
        return "guest/loginForm";
    }

    // 9. 회원가입 완료 페이지
    @RequestMapping(value = "/SignUpComplete", method = RequestMethod.GET)
    public String signUpComplete() {
        return "guest/SignUpComplete";
    }
}