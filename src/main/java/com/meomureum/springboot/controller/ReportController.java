package com.meomureum.springboot.controller;

import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.security.core.Authentication;
import org.springframework.stereotype.Controller;
import org.springframework.web.bind.annotation.ModelAttribute;
import org.springframework.web.bind.annotation.PostMapping;

import com.meomureum.springboot.dao.IMemberDAO;
import com.meomureum.springboot.dao.IReportDAO;
import com.meomureum.springboot.dto.MemberDTO;
import com.meomureum.springboot.dto.ReportDTO;

@Controller
public class ReportController {

    @Autowired
    private IReportDAO reportDAO;

    @Autowired
    private IMemberDAO memberDAO;

    @PostMapping("/report/submit")
    public String submitReport(@ModelAttribute ReportDTO dto,
                               Authentication authentication) {
        String m_id = authentication.getName();
        MemberDTO member = memberDAO.selectDAOById(m_id);

        dto.setM_code(member.getM_code());
        reportDAO.insertReport(dto);

        // 신고 후 원래 페이지로 리다이렉트
        return "redirect:/user/board/detail/" + dto.getTarget_code();
    }
}

