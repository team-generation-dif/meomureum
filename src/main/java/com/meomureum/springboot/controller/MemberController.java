package com.meomureum.springboot.controller;

import java.util.Collection;
import java.util.List;

import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.security.core.Authentication;
import org.springframework.security.core.GrantedAuthority;
import org.springframework.security.crypto.password.PasswordEncoder;
import org.springframework.stereotype.Controller;
import org.springframework.ui.Model;
import org.springframework.web.bind.annotation.PathVariable;
import org.springframework.web.bind.annotation.PostMapping;
import org.springframework.web.bind.annotation.RequestMapping;
import org.springframework.web.bind.annotation.RequestMethod;
import org.springframework.web.bind.annotation.RequestParam;

import com.meomureum.springboot.dao.IBoardDAO;
import com.meomureum.springboot.dao.IMemberDAO;
import com.meomureum.springboot.dao.IScheduleDAO;
import com.meomureum.springboot.dto.BoardDTO;
import com.meomureum.springboot.dto.MemberDTO;
import com.meomureum.springboot.dto.ScheduleDTO;

@Controller
public class MemberController {

    @Autowired private IMemberDAO memberDAO;
    @Autowired private IScheduleDAO scheduleDAO;
    @Autowired private IBoardDAO boardDAO;
    @Autowired private PasswordEncoder passwordEncoder;
    
    // 0. 로그인 성공 후 분기 처리
    @RequestMapping("/loginSuccess")
    public String loginSuccess(Authentication authentication) {
        Collection<? extends GrantedAuthority> authorities = authentication.getAuthorities();
        String roles = authorities.toString();
        
        if (roles.contains("ADMIN") || roles.contains("ROLE_ADMIN")) {
            return "redirect:/admin/member/main";
        }
        return "redirect:/user/mypage/main";
    }

    @RequestMapping("/Home")
    public String homeIntro(Model model) {
        // [수정] 실시간 인기 게시글 4개를 가져와서 모델에 담기
        // selectBestPosts()는 조회수(hit) 순으로 상위 4개를 가져오는 메서드라고 가정합니다.
        List<BoardDTO> bestPosts = boardDAO.listDao(); 
        model.addAttribute("bestPosts", bestPosts);
        
        return "common/Home";
    }
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

    @RequestMapping("/user/mypage/main")
    public String usermain(Authentication authentication, Model model) { 
    	String m_id = authentication.getName();
        MemberDTO dto = memberDAO.selectDAOById(m_id); 
        List<ScheduleDTO> scheduleDTO = scheduleDAO.listDAOByMCode(dto.getM_code());
        
        model.addAttribute("schedules", scheduleDTO);
        return "user/mypage/main"; 
    }

    @RequestMapping("/user/mypage/confirmPwForm")
    public String confirmPwForm(@RequestParam("mode") String mode, Model model) {
      model.addAttribute("mode", mode);
      return "user/mypage/confirmPw"; 
    }

    @PostMapping("/user/mypage/checkPw")
    public String checkPw(@RequestParam("m_passwd") String rawPassword, 
                        @RequestParam("mode") String mode,
                        Authentication authentication, 
                        jakarta.servlet.http.HttpServletRequest request,
                        Model model) {
      
      String m_id = authentication.getName();
      MemberDTO dto = memberDAO.selectDAOById(m_id);
      
      if (passwordEncoder.matches(rawPassword, dto.getM_passwd())) {
          if ("delete".equals(mode)) {
              memberDAO.deleteDao(dto.getM_code());
              request.getSession().invalidate();
              org.springframework.security.core.context.SecurityContextHolder.clearContext();
              return "redirect:/guest/loginForm?message=deleted";
          } else {
              model.addAttribute("edit", dto);
              return "user/mypage/myUpdateView"; 
          }
      } else {
          model.addAttribute("error", "비밀번호가 일치하지 않습니다.");
          model.addAttribute("mode", mode);
          return "user/mypage/confirmPw";
      }
    }

    @RequestMapping("/user/mypage/myView")
    public String myView(Authentication authentication, Model model) {
       String m_id = authentication.getName();
       MemberDTO dto = memberDAO.selectDAOById(m_id); 
       model.addAttribute("view", dto);
       return "user/mypage/myView"; 
    }

    @RequestMapping("/user/mypage/UpdateForm")
    public String updateForm(Authentication authentication, Model model) {
       String m_id = authentication.getName();
       MemberDTO dto = memberDAO.selectDAOById(m_id); 
       model.addAttribute("edit", dto);
       return "user/mypage/myUpdateView"; 
    }

    @PostMapping("/user/update")
    public String update(MemberDTO dto) {
        if (dto.getM_passwd() != null && !dto.getM_passwd().isEmpty()) {
            dto.setM_passwd(passwordEncoder.encode(dto.getM_passwd()));
        }
        memberDAO.updateDao(dto);
        return "redirect:/user/mypage/myView";
    }

    @PostMapping("/user/delete")
    public String userDelete(Authentication authentication, 
                             jakarta.servlet.http.HttpServletRequest request) {
        String m_id = authentication.getName();
        MemberDTO dto = memberDAO.selectDAOById(m_id);
        if (dto != null) {
            memberDAO.deleteDao(dto.getM_code());
        }
        request.getSession().invalidate();
        org.springframework.security.core.context.SecurityContextHolder.clearContext();
        return "redirect:/guest/loginForm?message=deleted"; 
    }

 // ==========================================
 // 4. 관리자 영역 (Admin)
 // ==========================================

 // [1] 관리자 메인 대시보드 페이지
 @RequestMapping("/admin/member/main") 
 public String adminMain(Model model) {
     // 요약 정보를 위해 전체 회원 수 등을 모델에 담습니다.
     model.addAttribute("memberCount", memberDAO.listDao().size());
     
     // 아까 만든 대시보드 JSP (adminMain.jsp)
     return "admin/member/main"; 
 }

 // [2] 전체 회원 리스트 페이지
 @RequestMapping("/admin/member/memberList") 
 public String memberList(
         @RequestParam(value="keyword", required=false) String keyword, 
         Model model) {
     
     if (keyword != null && !keyword.isEmpty()) {
         model.addAttribute("members", memberDAO.searchMembers(keyword));
         model.addAttribute("keyword", keyword);
     } else {
         model.addAttribute("members", memberDAO.listDao());
     }
     // 리스트 전용 JSP (memberList.jsp)
     return "admin/member/memberList"; 
 }

 // [3] 회원 등급 수정
 @PostMapping("/admin/updateGrade")
 public String updateGrade(@RequestParam("m_code") String m_code, 
                            @RequestParam("m_grade") String m_grade) {
     memberDAO.updateGradeDao(m_code, m_grade);
     return "redirect:/admin/member/memberList"; 
 }

//141행 근처
//[4] 회원 상세 보기
//기존: @RequestMapping("/admin/member/view/{m_code}")
//수정: 'view' 앞에 'member'를 붙여 'memberview'로 변경합니다.
@RequestMapping("/admin/member/memberview/{m_code}")
public String view(@PathVariable("m_code") String m_code, Model model) {
  model.addAttribute("member", memberDAO.viewDao(m_code));
  return "admin/member/memberView"; // 실제 JSP 파일 위치
}

 // [5] 관리자 권한으로 회원 삭제
 @PostMapping("/admin/delete")
 public String adminDelete(@RequestParam("m_code") String m_code) {
     memberDAO.deleteDao(m_code);
     return "redirect:/admin/member/memberList";
 }
}