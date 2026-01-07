package com.meomureum.springboot.controller;

import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Controller;
import org.springframework.ui.Model;
import org.springframework.web.bind.annotation.*;
import com.meomureum.springboot.dto.MemberDTO;
import com.meomureum.springboot.service.MemberService;
import jakarta.servlet.http.HttpSession;

@Controller
@RequestMapping("/guest") // 모든 요청 주소의 접두사를 /guest로 고정
public class MemberController {

    @Autowired
    private MemberService memberService;

    // 1. 회원가입 폼 이동 (GET /guest/join)
    @GetMapping("/join")
    public String joinForm() {
        return "guest/join";
    }

    // 2. 아이디 중복 확인 팝업 (GET /guest/idCheck)
    @GetMapping("/idCheck")
    public String idCheckPage(@RequestParam(value="m_id", required=false) String m_id, Model model) {
        if (m_id != null && !m_id.trim().isEmpty()) {
            int result = memberService.idCheck(m_id);
            model.addAttribute("result", result);
            model.addAttribute("m_id", m_id);
        }
        return "guest/idCheck"; 
    }

    // 3. 회원가입 DB 처리 (POST /guest/join)
    @PostMapping("/join")
    public String join(MemberDTO memberDto, Model model) {
        int result = memberService.register(memberDto);
        
        if (result > 0) {
            // 성공 시 로그인 페이지(/guest/login)로 보냄
            return "redirect:/guest/login"; 
        } else if (result == -1) {
            model.addAttribute("error", "이미 사용 중인 정보가 있습니다.");
            return "guest/join"; 
        } else {
            return "redirect:/guest/join?error=1";
        }
    }

    // 4. 로그인 폼 이동 (GET /guest/login)
    // [중요] 기존 /loginForm에서 /login으로 주소를 수정하여 리다이렉트와 일치시킴
    @GetMapping("/login")
    public String loginForm() {
        return "guest/login"; // 파일명이 login.jsp인 경우
    }

    // 5. 로그인 인증 처리 (POST /guest/login)
    @PostMapping("/login")
    public String login(@RequestParam("m_id") String m_id, 
                        @RequestParam("m_passwd") String m_passwd, 
                        HttpSession session, Model model) {
        
        MemberDTO loginMember = memberService.login(m_id, m_passwd);
        
        if (loginMember != null) {
            session.setAttribute("loginMember", loginMember);
            return "redirect:/"; // 메인 페이지로 이동
        } else {
            model.addAttribute("error", "아이디 또는 비밀번호를 확인해주세요.");
            return "guest/login";
        }
    }

    // 6. 로그아웃 처리 (GET /guest/logout)
    @GetMapping("/logout")
    public String logout(HttpSession session) {
        session.invalidate(); 
        return "redirect:/";
    }
}