package com.meomureum.springboot.controller;

import java.util.List;

import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.security.core.Authentication;
import org.springframework.stereotype.Controller;
import org.springframework.ui.Model;
import org.springframework.web.bind.annotation.GetMapping;
import org.springframework.web.bind.annotation.ModelAttribute;
import org.springframework.web.bind.annotation.PostMapping;
import org.springframework.web.bind.annotation.RequestParam;

import com.meomureum.springboot.dao.IBoardDAO;
import com.meomureum.springboot.dao.IMemberDAO;
import com.meomureum.springboot.dao.IReplyDAO;
import com.meomureum.springboot.dao.IReportDAO;
import com.meomureum.springboot.dto.MemberDTO;
import com.meomureum.springboot.dto.ReportDTO;

@Controller
public class ReportController {

    @Autowired
    private IReportDAO reportDAO;

    @Autowired
    private IMemberDAO memberDAO;
    
    @Autowired
    private IBoardDAO boardDAO;

    @Autowired
    private IReplyDAO replyDAO;

    // 📍 관리자: 신고 목록 조회
    @GetMapping("/admin/board/listreports")
    public String listReports(@RequestParam(name = "page", defaultValue = "1") int page,
            				  @RequestParam(name = "size", defaultValue = "10") int size,
            			      Model model) {
    	int startRow = (page - 1) * size + 1;
        int endRow = page * size;

        model.addAttribute("pendingReports", reportDAO.listPendingReports(startRow, endRow));
        model.addAttribute("doneReports", reportDAO.listDoneReports(startRow, endRow));
        model.addAttribute("ignoredReports", reportDAO.listIgnoredReports(startRow, endRow));
        // doneReports, ignoredReports도 동일하게 처리

        model.addAttribute("currentPage", page);
        model.addAttribute("pageSize", size);
        model.addAttribute("totalPages", 10); // 실제 전체 페이지 수 계산해서 넣어야 함

        return "admin/board/listReports";

    }

    // 신고 처리 (예: 삭제)
    @PostMapping("/admin/board/listreports/process")
    public String processReport(@RequestParam("rep_code") String rep_code,
                                @RequestParam("action") String action) {
        ReportDTO dto = new ReportDTO();
        dto.setRep_code(rep_code);
        
        ReportDTO report = reportDAO.findReportByCode(rep_code);

        if ("DELETE".equals(action)) {
            // 신고 수용 → 실제 콘텐츠 삭제 + 상태 DONE
            dto.setRep_status("DONE");
            // 카테고리에 따라 실제 삭제 처리
            if ("BOARD".equals(report.getRep_category())) {
                boardDAO.deleteBoard(report.getTarget_code());
            } else if ("REPLY".equals(report.getRep_category())) {
                replyDAO.deleteReply(report.getTarget_code());
            }
            reportDAO.updateReportStatus(dto);

        } else if ("IGNORE".equals(action)) {
            // 신고 무시 → 콘텐츠 유지 + 상태 IGNORE
            dto.setRep_status("IGNORE");
            reportDAO.updateReportStatus(dto);
        }

        return "redirect:/admin/board/listreports";
    }


    @PostMapping("/report/submit")
    public String submitReport(@ModelAttribute ReportDTO dto, Authentication authentication) {
        String m_id = authentication.getName();
        MemberDTO member = memberDAO.selectDAOById(m_id);
        dto.setM_code(member.getM_code());
        
        // 게시글 신고면 게시글 코드, 댓글 신고면 댓글 코드가 target_code에 들어가야 함
        // 이미 JSP에서 hidden input으로 target_code를 넘기고 있다면 그대로 dto에 매핑됨
        // 만약 없다면 여기서 직접 세팅 필요
                               
        reportDAO.insertReport(dto);
        
        String redirectUrl;
        if ("BOARD".equals(dto.getRep_category())) {
            // 게시글 신고 → 그대로 게시글 상세로
            redirectUrl = "/user/board/detail/" + dto.getTarget_code();
        } else if ("REPLY".equals(dto.getRep_category())) {
            // 댓글 신고 → 댓글의 부모 게시글 코드 찾아서 이동
            String b_code = replyDAO.findBoardCodeByReply(dto.getTarget_code());
            redirectUrl = "/user/board/detail/" + b_code;
        } else {
            redirectUrl = "/user/board/list"; // fallback
        }

        return "redirect:" + redirectUrl;
    }
}
