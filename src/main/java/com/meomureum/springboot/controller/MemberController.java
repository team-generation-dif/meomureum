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
    @Autowired private IReportDAO reportDAO; // 1. 신고 DAO 주입 필수!
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
        // 1. 오늘 날짜 구하기 (yyyy-MM-dd)
        java.text.SimpleDateFormat sdf = new java.text.SimpleDateFormat("yyyy-MM-dd");
        String todayStr = sdf.format(new java.util.Date());

        // --- [1] 전체 회원 및 오늘 신규 가입자 ---
        List<MemberDTO> members = memberDAO.listDao();
        long todayNewMembers = 0;
        if (members != null) {
            todayNewMembers = members.stream()
                .filter(m -> {
                    if (m.getCreated_at() == null) return false;
                    // 날짜 객체든 문자열이든 yyyy-MM-dd 부분만 비교
                    return String.valueOf(m.getCreated_at()).startsWith(todayStr);
                }).count();
        }

        // --- [2] 오늘 새로운 게시글 수 (수정됨) ---
        List<BoardDTO> boards = boardDAO.listDao(); 
        long todayNewBoards = 0;
        if (boards != null) {
            todayNewBoards = boards.stream()
                .filter(b -> {
                    // b.getCreated_at()이 날짜 타입인 경우 toString() 하면 "2024-05-20 ..." 형식이 됨
                    Object boardDate = b.getCreated_at(); 
                    return boardDate != null && String.valueOf(boardDate).startsWith(todayStr);
                }).count();
        }

        // --- [3] 미처리 신고 건수 (rep_status가 'PENDING' 혹은 null/빈값인 경우) ---
        List<ReportDTO> reports = reportDAO.listReports();
        long pendingReportCount = 0;
        if (reports != null) {
            pendingReportCount = reports.stream()
                .filter(r -> {
                    String status = r.getRep_status();
                    // 상태가 없거나(null), PENDING인 경우 모두 미처리로 간주
                    return status == null || "PENDING".equalsIgnoreCase(status.trim()) || status.isEmpty();
                }).count();
        }

        // 4. 모델에 데이터 전달
        model.addAttribute("memberCount", (members != null) ? members.size() : 0);
        model.addAttribute("newCount", todayNewMembers);       
        model.addAttribute("newBoardCount", todayNewBoards);   
        model.addAttribute("reportCount", pendingReportCount); 

        // 디버깅: 데이터가 안 나올 경우 이클립스 Console 창을 확인하세요.
        System.out.println("====== 대시보드 검증 ======");
        System.out.println("기준 날짜: " + todayStr);
        System.out.println("전체 게시글 수: " + (boards != null ? boards.size() : "null"));
        System.out.println("오늘 신규 게시글: " + todayNewBoards);
        System.out.println("전체 신고 건수: " + (reports != null ? reports.size() : "null"));
        System.out.println("미처리 신고 건수: " + pendingReportCount);

        return "admin/member/main"; 
    }
//[2] 전체 회원 리스트 페이지
 @RequestMapping("/admin/member/memberList") 
 public String memberList(
         @RequestParam(value="keyword", required=false) String keyword, 
         Model model) {
     
     List<MemberDTO> allMembers;
     if (keyword != null && !keyword.isEmpty()) {
         allMembers = memberDAO.searchMembers(keyword);
     } else {
         allMembers = memberDAO.listDao();
     }

     // --- [날짜 비교 로직 시작] ---
     java.text.SimpleDateFormat sdf = new java.text.SimpleDateFormat("yyyy-MM-dd");
     String todayStr = sdf.format(new java.util.Date());

     long newMemberCount = 0;
     
     if (allMembers != null) {
         newMemberCount = allMembers.stream()
             .filter(m -> {
                 Object createdAt = m.getCreated_at(); // 데이터를 Object로 받음
                 if (createdAt == null) return false;
                 
                 String memberJoinDate = "";
                 if (createdAt instanceof java.util.Date) {
                     memberJoinDate = sdf.format(createdAt);
                 } else {
                     // String 타입일 경우 앞의 10자(yyyy-MM-dd)만 추출
                     memberJoinDate = createdAt.toString().substring(0, 10);
                 }
                 return todayStr.equals(memberJoinDate);
             })
             .count();
     }
     
     // 콘솔창에서 확인용 (숫자가 나오는지 꼭 확인해보세요!)
     System.out.println("오늘 날짜: " + todayStr);
     System.out.println("오늘 가입자 수: " + newMemberCount);

     model.addAttribute("newCount", newMemberCount); // JSP에서 ${newCount}와 일치해야 함
     model.addAttribute("members", allMembers);
     model.addAttribute("keyword", keyword);
     
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
//[6] 신고 리스트 페이지 (수정)
@RequestMapping("/admin/board/listReports")
public String listReports(@RequestParam(name="page", defaultValue="1") int page,
                          @RequestParam(name="size", defaultValue="10") int size,
                          @RequestParam(name="keyword", required=false) String keyword,
                        Model model) {
  int startRow = (page - 1) * size + 1;
  int endRow = page * size;

  // 상태별로 DAO 호출
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