package com.meomureum.springboot.controller;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Controller;
import org.springframework.ui.Model;
import org.springframework.web.bind.annotation.PostMapping;
import org.springframework.web.bind.annotation.RequestMapping;
import org.springframework.web.bind.annotation.RequestParam;

import com.meomureum.springboot.dao.IFaqDAO;
import com.meomureum.springboot.dao.IMemberDAO;
import com.meomureum.springboot.dto.FaqDTO;

@Controller
public class FaqController {

    @Autowired
    private IFaqDAO faqDAO;
    
    @Autowired
    private IMemberDAO memberDAO;

    // [유저] 마이페이지 내 FAQ 조회 (경로: user/mypage/faq)
    @RequestMapping("/user/mypage/faq")
    public String userFaq(Model model) {
        model.addAttribute("faqList", faqDAO.getAllFaqs());
        // 최종 요청 경로: user/mypage/faq.jsp
        return "user/mypage/faq"; 
    }

    // [관리자] FAQ 관리 페이지 (경로: admin/faq/faqManage)
 // [관리자] FAQ 관리 페이지 (검색 기능 추가)
    @RequestMapping("/admin/faq/faqManage")
    public String adminFaq(
        @RequestParam(value="keyword", required=false) String keyword, 
        Model model) {
        
        if (keyword != null && !keyword.isEmpty()) {
            // 검색어가 있을 때: 검색 쿼리 실행
            model.addAttribute("faqList", faqDAO.searchFaqs(keyword));
            model.addAttribute("keyword", keyword); // 검색창에 입력한 단어 유지
        } else {
            // 검색어가 없을 때: 전체 리스트 출력
            model.addAttribute("faqList", faqDAO.getAllFaqs());
        }
        
        return "admin/faq/faqManage"; 
    }

    // 등록/삭제 로직은 이전과 동일
    @PostMapping("/admin/faq/insert")
    public String insert(FaqDTO dto) {
        faqDAO.insertFaq(dto);
        return "redirect:/admin/faq/faqManage";
    }

    @PostMapping("/admin/faq/delete")
    public String delete(@RequestParam("faq_code") String faq_code) {
        faqDAO.deleteFaq(faq_code);
        return "redirect:/admin/faq/faqManage";
    }
}