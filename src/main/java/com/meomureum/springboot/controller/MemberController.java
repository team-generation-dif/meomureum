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
import com.meomureum.springboot.dao.IReportDAO;
import com.meomureum.springboot.dao.IScheduleDAO;
import com.meomureum.springboot.dto.BoardDTO;
import com.meomureum.springboot.dto.MemberDTO;
import com.meomureum.springboot.dto.ReportDTO;
import com.meomureum.springboot.dto.ScheduleDTO;

@Controller
public class MemberController {

    @Autowired private IMemberDAO memberDAO;
    @Autowired private IScheduleDAO scheduleDAO;
    @Autowired private IBoardDAO boardDAO;
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

    @RequestMapping("/Home")
    public String homeIntro(Model model) {
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
        
        // [수정] 여정 리스트 가져오기
        List<ScheduleDTO> scheduleDTO = scheduleDAO.listDAOByMCode(dto.getM_code());
        model.addAttribute("schedules", scheduleDTO);

        // [추가] 내가 쓴 최근 게시글 3개 가져오기
        List<BoardDTO> myRecentPosts = boardDAO.getMyRecentPosts(dto.getM_code());
        model.addAttribute("myRecentPosts", myRecentPosts);

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

    @RequestMapping("/admin/member/main") 
    public String adminMain(Model model) {
        java.text.SimpleDateFormat sdf = new java.text.SimpleDateFormat("yyyy-MM-dd");
        String todayStr = sdf.format(new java.util.Date());

        // --- [1] 전체 회원 및 오늘 신규 가입자 ---
        List<MemberDTO> members = memberDAO.listDao();
        long todayNewMembers = 0;
        if (members != null) {
            todayNewMembers = members.stream()
                .filter(m -> {
                    if (m.getCreated_at() == null) return false;
                    return String.valueOf(m.getCreated_at()).startsWith(todayStr);
                }).count();
        }

        // --- [2] 오늘 새로운 게시글 수 (DB 직접 카운트) ---
        int todayNewBoards = boardDAO.countTodayBoards();

        // --- [3] 미처리 신고 건수 ---
        List<ReportDTO> reports = reportDAO.listReports();
        long pendingReportCount = 0;
        if (reports != null) {
            pendingReportCount = reports.stream()
                .filter(r -> {
                    String status = r.getRep_status();
                    return status == null || "PENDING".equalsIgnoreCase(status.trim()) || status.isEmpty();
                }).count();
        }

        // 4. 모델에 데이터 전달
        model.addAttribute("memberCount", (members != null) ? members.size() : 0);
        model.addAttribute("newCount", todayNewMembers);       
        model.addAttribute("newBoardCount", todayNewBoards);   
        model.addAttribute("reportCount", pendingReportCount); 

        // [에러 해결] boards 변수 대신 todayNewBoards를 직접 출력하도록 수정
        System.out.println("====== 대시보드 검증 ======");
        System.out.println("기준 날짜: " + todayStr);
        System.out.println("오늘 신규 게시글: " + todayNewBoards);
        System.out.println("미처리 신고 건수: " + pendingReportCount);

        return "admin/member/main"; 
    }

    @RequestMapping("/admin/member/memberList") 
    public String memberList(@RequestParam(value="keyword", required=false) String keyword, Model model) {
        List<MemberDTO> allMembers = (keyword != null && !keyword.isEmpty()) ? memberDAO.searchMembers(keyword) : memberDAO.listDao();

        java.text.SimpleDateFormat sdf = new java.text.SimpleDateFormat("yyyy-MM-dd");
        String todayStr = sdf.format(new java.util.Date());
        long newMemberCount = 0;
        
        if (allMembers != null) {
            newMemberCount = allMembers.stream()
                .filter(m -> {
                    Object createdAt = m.getCreated_at();
                    if (createdAt == null) return false;
                    String memberJoinDate = (createdAt instanceof java.util.Date) ? sdf.format(createdAt) : createdAt.toString().substring(0, 10);
                    return todayStr.equals(memberJoinDate);
                }).count();
        }
        
        model.addAttribute("newCount", newMemberCount);
        model.addAttribute("members", allMembers);
        model.addAttribute("keyword", keyword);
        return "admin/member/memberList"; 
    }

    @PostMapping("/admin/updateGrade")
    public String updateGrade(@RequestParam("m_code") String m_code, @RequestParam("m_grade") String m_grade) {
        memberDAO.updateGradeDao(m_code, m_grade);
        return "redirect:/admin/member/memberList"; 
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

      List<ReportDTO> pendingReports = reportDAO.listPendingReports(startRow, endRow, keyword);
      int totalReports = reportDAO.countPendingReports(keyword);
      int totalPages = (int) Math.ceil((double) totalReports / size);

      model.addAttribute("pendingReports", pendingReports);
      model.addAttribute("currentPage", page);
      model.addAttribute("pageSize", size);
      model.addAttribute("totalPages", totalPages);
      model.addAttribute("keyword", keyword);

      return "admin/board/listReports";
    }
}