package com.meomureum.springboot.controller;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Controller;
import org.springframework.ui.Model;
import org.springframework.web.bind.annotation.PostMapping;
import org.springframework.web.bind.annotation.RequestMapping;
import org.springframework.web.bind.annotation.RequestParam;

import com.meomureum.springboot.dao.IMemberDAO;
import com.meomureum.springboot.dao.INoticeDAO;
import com.meomureum.springboot.dto.NoticeDTO;

@Controller
public class NoticeController {

    @Autowired
    private INoticeDAO noticeDAO;
    
    @Autowired
    private IMemberDAO memberDAO;

    // [유저] 마이페이지 내 공지사항 조회
    @RequestMapping("/user/mypage/notice")
    public String userNotice(Model model) {
        model.addAttribute("noticeList", noticeDAO.getAllNotices());
        return "user/mypage/notice"; 
    }

    // [관리자] 공지사항 관리 페이지
    @RequestMapping("/admin/notice/noticeManage")
    public String adminFaq(
        @RequestParam(value="keyword", required=false) String keyword, 
        Model model) {
        
        if (keyword != null && !keyword.isEmpty()) {
            // 검색어가 있을 때: 검색 결과 가져오기 (DAO에 searchNotices 메서드 필요)
            model.addAttribute("noticeList", noticeDAO.searchNotices(keyword));
        } else {
            // 검색어가 없을 때: 전체 목록 가져오기
            model.addAttribute("noticeList", noticeDAO.getAllNotices());
        }
        return "admin/notice/noticeManage"; 
    }
    // 등록/삭제 로직은 이전과 동일
    @PostMapping("/admin/notice/insert")
    public String insert(NoticeDTO dto) {
        noticeDAO.insertNotice(dto);
        return "redirect:/admin/notice/noticeManage";
    }

    @PostMapping("/admin/notice/delete")
    public String delete(@RequestParam("notice_code") String notice_code) {
        noticeDAO.deleteNotice(notice_code);
        return "redirect:/admin/notice/noticeManage";
    }
}