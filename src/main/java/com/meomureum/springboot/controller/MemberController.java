package com.meomureum.springboot.controller;

import java.util.Collection;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.security.core.Authentication;
import org.springframework.security.core.GrantedAuthority;
import org.springframework.security.crypto.password.PasswordEncoder;
import org.springframework.stereotype.Controller;
import org.springframework.ui.Model;
import org.springframework.web.bind.annotation.*;
import com.meomureum.springboot.dao.IMemberDAO;
import com.meomureum.springboot.dto.MemberDTO;

import jakarta.servlet.http.HttpSession;

@Controller
public class MemberController {

    @Autowired private IMemberDAO memberDAO;
    @Autowired private PasswordEncoder passwordEncoder;

    // 0. 로그인 성공 후 분기 처리
    @RequestMapping("/loginSuccess")
    public String loginSuccess(Authentication authentication) {
        Collection<? extends GrantedAuthority> authorities = authentication.getAuthorities();
        String roles = authorities.toString();
        
        // ADMIN 권한 포함 여부 확인
        if (roles.contains("ADMIN") || roles.contains("ROLE_ADMIN")) {
            return "redirect:/admin/member/list";
        }
        return "redirect:/user/mypage/main";
    }
 // 공통 홈(소개) 페이지 매핑
    @RequestMapping("/Home")
    public String homeIntro() {
        return "common/Home"; // WEB-INF/views/common/home.jsp
    }

    // 1. 공통/게스트 영역 (Guest)
    @RequestMapping("/")
    public String index() { return "guest/main"; }

    @RequestMapping(value = "/guest/join", method = RequestMethod.GET)
    public String joinForm() { return "guest/join"; }

    @RequestMapping(value = "/guest/join", method = RequestMethod.POST)
    public String join(MemberDTO memberDto) {
        memberDto.setM_passwd(passwordEncoder.encode(memberDto.getM_passwd()));
        memberDto.setM_auth(memberDto.getM_id().equals("admin") ? "ADMIN" : "USER");
        memberDto.setM_grade("BASIC");
        memberDAO.insertMember(memberDto);
        return "redirect:/guest/SignUpComplete";
    }

    @RequestMapping(value = "/guest/idCheck", method = RequestMethod.GET)
    public String idCheck(@RequestParam(value="m_id", required=false) String m_id, Model model) {
        if (m_id != null && !m_id.trim().isEmpty()) {
            int result = memberDAO.checkId(m_id); 
            model.addAttribute("result", result);
            model.addAttribute("m_id", m_id);
        }
        return "guest/idCheck";
    }
  
    @RequestMapping("/guest/SignUpComplete")
    public String signUpComplete() { return "guest/SignUpComplete"; }

    @RequestMapping("/guest/loginForm")
    public String loginForm() { return "guest/loginForm"; }

 // ==========================================
 // 2. 유저 영역 (User)
 // ==========================================

 // 유저 메인 페이지
 @RequestMapping("/user/mypage/main")
 public String usermain() { 
     return "user/mypage/main"; 
 }
//[1] 비밀번호 확인 폼으로 이동 (수정/탈퇴 공통)
@RequestMapping("/user/mypage/confirmPwForm")
public String confirmPwForm(@RequestParam("mode") String mode, Model model) {
  model.addAttribute("mode", mode); // 'update' 또는 'delete'
  return "user/mypage/confirmPw"; 
}

//[2] 비밀번호 확인 실행 및 분기 처리
@PostMapping("/user/mypage/checkPw")
public String checkPw(@RequestParam("m_passwd") String rawPassword, 
                    @RequestParam("mode") String mode,
                    Authentication authentication, 
                    jakarta.servlet.http.HttpServletRequest request,
                    Model model) {
  
  String m_id = authentication.getName();
  MemberDTO dto = memberDAO.selectDAOById(m_id);
  
  // 비밀번호 검증
  if (passwordEncoder.matches(rawPassword, dto.getM_passwd())) {
      
      if ("delete".equals(mode)) {
          // [탈퇴 모드]인 경우 바로 삭제 로직 진행
          memberDAO.deleteDao(dto.getM_code());
          request.getSession().invalidate();
          org.springframework.security.core.context.SecurityContextHolder.clearContext();
          return "redirect:/guest/loginForm?message=deleted";
          
      } else {
          // [수정 모드]인 경우 수정 페이지로 이동
          model.addAttribute("edit", dto);
          return "user/mypage/myUpdateView"; 
      }
      
  } else {
      // 비밀번호 틀린 경우
      model.addAttribute("error", "비밀번호가 일치하지 않습니다.");
      model.addAttribute("mode", mode); // mode 값 유지
      return "user/mypage/confirmPw";
  }
}

//[내 정보 보기]
@RequestMapping("/user/mypage/myView")
public String myView(Authentication authentication, Model model) {
   String m_id = authentication.getName(); // 로그인한 아이디 가져오기
   
   // [수정 포인트] viewDao 대신 selectDAOById 사용!
   MemberDTO dto = memberDAO.selectDAOById(m_id); 
   
   model.addAttribute("view", dto);
   return "user/mypage/myView"; 
}

// [정보 수정 폼]
@RequestMapping("/user/mypage/UpdateForm")
public String updateForm(Authentication authentication, Model model) {
   String m_id = authentication.getName();
   
   // [수정 포인트] 여기도 selectDAOById 사용!
   MemberDTO dto = memberDAO.selectDAOById(m_id); 
   
   model.addAttribute("edit", dto);
   return "user/mypage/myUpdateView"; 
}

 // [수정 실행]
 @PostMapping("/user/update")
 public String update(MemberDTO dto) {
     if (dto.getM_passwd() != null && !dto.getM_passwd().isEmpty()) {
         dto.setM_passwd(passwordEncoder.encode(dto.getM_passwd()));
     }
     memberDAO.updateDao(dto);
     return "redirect:/user/mypage/myView"; // 수정 후 상세보기 페이지로 이동
 }
 @PostMapping("/user/delete")
 public String userDelete(Authentication authentication, 
                          jakarta.servlet.http.HttpServletRequest request) {
     
     // 1. 현재 로그인한 사람의 ID를 인증 정보에서 직접 가져옴 (가장 정확함)
     String m_id = authentication.getName();
     System.out.println("### 탈퇴 시도 아이디: " + m_id);

     // 2. ID를 이용해 회원 정보를 먼저 조회 (m_code를 알아내기 위함)
     MemberDTO dto = memberDAO.selectDAOById(m_id);
     
     if (dto != null) {
         String m_code = dto.getM_code();
         System.out.println("### 삭제될 회원 코드: " + m_code);
         
         // 3. DB에서 삭제 실행
         memberDAO.deleteDao(m_code);
     }

     // 4. 로그아웃 및 인증 정보 파기
     request.getSession().invalidate();
     org.springframework.security.core.context.SecurityContextHolder.clearContext();
     
     return "redirect:/guest/loginForm?message=deleted"; 
 }

//[4] 관리자 영역
 @RequestMapping("/admin/member/list") // 소문자 list로 통일
 public String list(Model model) {
     model.addAttribute("members", memberDAO.listDao());
     return "admin/member/memberList";
 }

 @PostMapping("/admin/updateGrade")
 public String updateGrade(@RequestParam("m_code") String m_code, 
                           @RequestParam("m_grade") String m_grade) {
     memberDAO.updateGradeDao(m_code, m_grade);
     return "redirect:/admin/member/list";
 }

 @RequestMapping("/admin/view/{m_code}")
 public String view(@PathVariable("m_code") String m_code, Model model) {
     model.addAttribute("member", memberDAO.viewDao(m_code));
     return "admin/member/memberView";
 }

 @PostMapping("/admin/delete")
 public String adminDelete(@RequestParam("m_code") String m_code) {
     memberDAO.deleteDao(m_code);
     return "redirect:/admin/member/list";
 }
}