package com.meomureum.springboot.controller;

import java.util.List;

import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.security.core.Authentication;
import org.springframework.stereotype.Controller;
import org.springframework.ui.Model;
import org.springframework.web.bind.annotation.GetMapping;
import org.springframework.web.bind.annotation.ModelAttribute;
import org.springframework.web.bind.annotation.PostMapping;
import org.springframework.web.bind.annotation.RequestMapping;
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
    public String listReports(@RequestParam(name="status", defaultValue="PENDING") String status,
    						  @RequestParam(name = "page", defaultValue = "1") int page,
            				  @RequestParam(name = "size", defaultValue = "10") int size,
            				  @RequestParam(name="keyword", required=false) String keyword,
            			      Model model) {
    	int startRow = (page - 1) * size + 1;
        int endRow = page * size;
        
        List<ReportDTO> reports;
        int totalReports = 0;
        
        // 상태별 분기
        if ("DONE".equalsIgnoreCase(status)) {
            reports = reportDAO.listDoneReports(startRow, endRow, keyword);
            totalReports = reportDAO.countDoneReports(keyword);
        } else if ("IGNORE".equalsIgnoreCase(status)) {
            reports = reportDAO.listIgnoredReports(startRow, endRow, keyword);
            totalReports = reportDAO.countIgnoredReports(keyword);
        } else {
            reports = reportDAO.listPendingReports(startRow, endRow, keyword);
            totalReports = reportDAO.countPendingReports(keyword);
            status = "PENDING"; // 기본값
        }

        int totalPages = (int) Math.ceil((double) totalReports / size);

        // 모델에 담기
        model.addAttribute("reports", reports);
        model.addAttribute("currentPage", page);
        model.addAttribute("pageSize", size);
        model.addAttribute("totalPages", totalPages);
        model.addAttribute("keyword", keyword);
        model.addAttribute("status", status);

        return "admin/board/listReports";
    }


    // 신고 처리 (예: 삭제)
    @PostMapping("/admin/board/listreports/process")
    public String processReport(@RequestParam("rep_code") String rep_code,
                                @RequestParam("action") String action,
                                Authentication authentication) {
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
               
        return "redirect:/admin/board/listreports?status=PENDING";
    }


    @PostMapping("/report/submit")
    public String submitReport(@ModelAttribute ReportDTO dto, Authentication authentication) {
        String m_id = authentication.getName();
        MemberDTO member = memberDAO.selectDAOById(m_id);
        dto.setM_code(member.getM_code());
                                   
        reportDAO.insertReport(dto);
        
        String redirectUrl;
        // 카테고리에 맞춰 리다이렉트 경로 설정
        if ("BOARD".equalsIgnoreCase(dto.getRep_category())) {
            redirectUrl = "/user/board/detail/" + dto.getTarget_code();
        } else if ("REPLY".equalsIgnoreCase(dto.getRep_category())) {
            String b_code = replyDAO.findBoardCodeByReply(dto.getTarget_code());
            redirectUrl = "/user/board/detail/" + b_code;
        } else {
            redirectUrl = "/user/board/list";
        }

        return "redirect:" + redirectUrl;
    }
}