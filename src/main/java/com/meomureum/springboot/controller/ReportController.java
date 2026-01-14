package com.meomureum.springboot.controller;

import java.util.List;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.security.core.Authentication;
import org.springframework.stereotype.Controller;
import org.springframework.ui.Model;
import org.springframework.web.bind.annotation.*;

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

    // 관리자: 신고 목록
    @GetMapping("/admin/report/listReports")
    public String listReports(Model model) {
        List<ReportDTO> reports = reportDAO.listReports();
        model.addAttribute("reports", reports);
        return "admin/board/listReports";
    }

    // 관리자: 신고 처리
    @PostMapping("/admin/report/process")
    public String processReport(@RequestParam("rep_code") String rep_code,
                                @RequestParam("target_code") String target_code,
                                @RequestParam(value="rep_category", required=false, defaultValue="BOARD") String rep_category,
                                @RequestParam("action") String action) {
        if ("DELETE".equals(action)) {
            if ("BOARD".equalsIgnoreCase(rep_category) || "게시글".equals(rep_category)) {
                boardDAO.deleteDao(target_code);
            } else if ("REPLY".equalsIgnoreCase(rep_category) || "댓글".equals(rep_category)) {
                replyDAO.deleteReply(target_code);
            }
        }
        reportDAO.deleteReport(rep_code);
        return "redirect:/admin/report/listReports";
    }

    // 유저: 신고 제출 처리 (에러 발생 지점)
    // 반드시 앞에 /가 붙어야 하며, JSP의 action과 일치해야 함
    @PostMapping("/report/submit")
    public String submitReport(@ModelAttribute ReportDTO dto, Authentication authentication) {
        if (authentication == null) return "redirect:/guest/loginForm";

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