package com.meomureum.springboot.controller;

import java.util.Collection;
import java.util.Collections;
import java.util.List;
import java.util.stream.Collectors;

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
import com.meomureum.springboot.dao.IQualifyDAO;
import com.meomureum.springboot.dao.IReportDAO;
import com.meomureum.springboot.dao.IScheduleDAO;
import com.meomureum.springboot.dto.BoardDTO;
import com.meomureum.springboot.dto.MemberDTO;
import com.meomureum.springboot.dto.PlaceDTO;
import com.meomureum.springboot.dto.QualifyDTO;
import com.meomureum.springboot.dto.ReportDTO;
import com.meomureum.springboot.dto.ScheduleDTO;

@Controller
public class MemberController {

    @Autowired private IMemberDAO memberDAO;
    @Autowired private IScheduleDAO scheduleDAO;
    @Autowired private IBoardDAO boardDAO;
    @Autowired private IQualifyDAO qualDAO;
    @Autowired private IReportDAO reportDAO;
    @Autowired private PasswordEncoder passwordEncoder;
    
    // [0] 로그인 성공 후 분기 처리
    @RequestMapping("/loginSuccess")
    public String loginSuccess(Authentication authentication) {
        Collection<? extends GrantedAuthority> authorities = authentication.getAuthorities();
        String roles = authorities.toString();
        
        if (roles.contains("ADMIN") || roles.contains("ROLE_ADMIN")) {
            return "redirect:/admin/member/main";
        }
        return "redirect:/user/mypage/main";
    }
    
    // 추천 장소 3개 뽑기
    private List<PlaceDTO> getRecommendedPlaces() {
        List<PlaceDTO> topPlaces = scheduleDAO.listDAOByCntPcode();
        if (topPlaces.size() <= 3) return topPlaces;
        Collections.shuffle(topPlaces);
        return topPlaces.stream().limit(3).collect(Collectors.toList());
    }
    
    @RequestMapping("/Home")
    public String homeIntro(Model model) {
        model.addAttribute("bestPosts", boardDAO.listDao());
        model.addAttribute("recommends", getRecommendedPlaces());
        return "common/Home";
    }

    @RequestMapping("/")
    public String index(Model model) {
        model.addAttribute("recommends", getRecommendedPlaces());
        return "guest/main"; 
    }

    // ==========================================
    // 1. 게스트 영역 (Join & Login)
    // ==========================================

    @RequestMapping(value = "/guest/join", method = RequestMethod.GET)
    public String joinForm() { return "guest/join"; }

    @RequestMapping(value = "/guest/join", method = RequestMethod.POST)
    public String join(MemberDTO memberDto, Model model) {
        // [재가입 방지] 블랙리스트 테이블 조회
        int isBlocked = qualDAO.checkBlocked(memberDto.getM_email(), memberDto.getM_tel());
        
        if (isBlocked > 0) {
            model.addAttribute("msg", "운영 정책 위반으로 인해 해당 정보로는 재가입이 불가합니다.");
            model.addAttribute("url", "/guest/loginForm");
            return "common/alert"; 
        }

        memberDto.setM_passwd(passwordEncoder.encode(memberDto.getM_passwd()));
        memberDto.setM_auth(memberDto.getM_id().equals("admin") ? "ADMIN" : "USER");
        memberDto.setM_grade("BASIC");
        memberDAO.insertMember(memberDto);
        return "redirect:/guest/SignUpComplete";
    }

    @RequestMapping(value = "/guest/idCheck", method = RequestMethod.GET)
    public String idCheck(@RequestParam(value="m_id", required=false) String m_id, Model model) {
        if (m_id != null && !m_id.trim().isEmpty()) {
            model.addAttribute("result", memberDAO.checkId(m_id));
            model.addAttribute("m_id", m_id);
        }
        return "guest/idCheck";
    }
  
    @RequestMapping("/guest/SignUpComplete")
    public String signUpComplete() { return "guest/SignUpComplete"; }

    @RequestMapping("/guest/loginForm")
    public String loginForm() { return "guest/loginForm"; }

    // ==========================================
    // 2. 유저 영역 (Mypage)
    // ==========================================

    @RequestMapping("/user/mypage/main")
    public String usermain(Authentication authentication, Model model) { 
        String m_id = authentication.getName();
        MemberDTO dto = memberDAO.selectDAOById(m_id); 
        model.addAttribute("schedules", scheduleDAO.listDAOByMCode(dto.getM_code()));
        model.addAttribute("myRecentPosts", boardDAO.getMyRecentPosts(dto.getM_code()));
        return "user/mypage/main"; 
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
          }
          model.addAttribute("edit", dto);
          return "user/mypage/myUpdateView"; 
      }
      model.addAttribute("error", "비밀번호가 일치하지 않습니다.");
      model.addAttribute("mode", mode);
      return "user/mypage/confirmPw";
    }

    @RequestMapping("/user/mypage/myView")
    public String myView(Authentication authentication, Model model) {
       MemberDTO dto = memberDAO.selectDAOById(authentication.getName()); 
       model.addAttribute("view", dto);
       return "user/mypage/myView"; 
    }

    @PostMapping("/user/update")
    public String update(MemberDTO dto) {
        if (dto.getM_passwd() != null && !dto.getM_passwd().isEmpty()) {
            dto.setM_passwd(passwordEncoder.encode(dto.getM_passwd()));
        }
        memberDAO.updateDao(dto);
        return "redirect:/user/mypage/myView";
    }

    // ==========================================
    // 3. 관리자 영역 (Admin)
    // ==========================================

    @RequestMapping("/admin/member/main") 
    public String adminMain(Model model) {
        try {
            model.addAttribute("memberCount", memberDAO.getTotalMemberCount());
            model.addAttribute("newCount", memberDAO.getTodayMemberCount());
            model.addAttribute("newBoardCount", boardDAO.countTodayBoards()); 
            model.addAttribute("reportCount", reportDAO.countPendingReports(null)); 
        } catch (Exception e) { e.printStackTrace(); }
        return "admin/member/main"; 
    }

    @PostMapping("/admin/updateGrade")
    public String updateGrade(@RequestParam("m_code") String m_code, 
                              @RequestParam("m_grade") String m_grade) {
        
        // 블랙리스트 선택 시: 강제 탈퇴 처리
        if ("BLACKLIST".equals(m_grade)) {
            MemberDTO member = memberDAO.viewDao(m_code);
            if (member != null) {
                QualifyDTO qual = new QualifyDTO();
                qual.setM_code(m_code);
                qual.setBlack_email(member.getM_email());
                qual.setBlack_tel(member.getM_tel());
                qual.setQual_reason("영구 블랙리스트 제명");
                qualDAO.insertDao(qual);
                memberDAO.deleteDao(m_code);
                return "redirect:/admin/member/memberList";
            }
        } 
        // 일반 및 이용제한 등급 변경
        memberDAO.updateGradeDao(m_code, m_grade);
        return "redirect:/admin/member/memberview/" + m_code;
    }

    @RequestMapping("/admin/member/memberList") 
    public String memberList(@RequestParam(value="keyword", required=false) String keyword, Model model) {
        List<MemberDTO> allMembers = (keyword != null && !keyword.isEmpty()) ? memberDAO.searchMembers(keyword) : memberDAO.listDao();
        model.addAttribute("members", allMembers);
        model.addAttribute("keyword", keyword);
        return "admin/member/memberList"; 
    }

    @RequestMapping("/admin/member/memberview/{m_code}")
    public String view(@PathVariable("m_code") String m_code, Model model) {
      model.addAttribute("member", memberDAO.viewDao(m_code));
      return "admin/member/memberView";
    }

    @PostMapping("/admin/delete")
    public String adminDelete(@RequestParam("m_code") String m_code) {
        memberDAO.deleteDao(m_code);
        return "redirect:/admin/member/memberList";
    }

    @RequestMapping("/admin/board/listReports")
    public String listReports(@RequestParam(name="page", defaultValue="1") int page,
                              @RequestParam(name="size", defaultValue="10") int size,
                              @RequestParam(name="keyword", required=false) String keyword,
                              Model model) {
      int startRow = (page - 1) * size + 1;
      int endRow = page * size;
      model.addAttribute("pendingReports", reportDAO.listPendingReports(startRow, endRow, keyword));
      model.addAttribute("totalPages", (int) Math.ceil((double) reportDAO.countPendingReports(keyword) / size));
      model.addAttribute("currentPage", page);
      return "admin/board/listReports";
    }
}