package com.meomureum.springboot.controller;

import java.io.File;
import java.util.List;

import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.security.core.Authentication;
import org.springframework.stereotype.Controller;
import org.springframework.ui.Model;
import org.springframework.web.bind.annotation.GetMapping;
import org.springframework.web.bind.annotation.PathVariable;
import org.springframework.web.bind.annotation.PostMapping;
import org.springframework.web.bind.annotation.RequestMapping;
import org.springframework.web.bind.annotation.RequestParam;
import org.springframework.web.bind.annotation.ResponseBody;
import org.springframework.web.multipart.MultipartFile;

import com.meomureum.springboot.dao.IBoardDAO;
import com.meomureum.springboot.dao.IFileuploadDAO;
import com.meomureum.springboot.dao.IMemberDAO;
import com.meomureum.springboot.dao.IReplyDAO;
import com.meomureum.springboot.dto.BoardDTO;
import com.meomureum.springboot.dto.FileuploadDTO;
import com.meomureum.springboot.dto.MemberDTO;
import com.meomureum.springboot.dto.ReplyDTO;

import jakarta.servlet.http.HttpServletResponse;
import jakarta.servlet.http.HttpSession;

@Controller
@RequestMapping("/user/board")
public class BoardController {

    @Autowired
    private IBoardDAO boardDAO;
    
    @Autowired
    private IFileuploadDAO fileuploadDAO;
    
    @Autowired
    private IReplyDAO replyDAO;
    
    @Autowired
    private IMemberDAO memberDAO;

    // 📍 게시판 목록 (캐시 방지 헤더 추가)
    @GetMapping("/list")
    public String list(Model model, HttpServletResponse resp) {
        resp.setHeader("Cache-Control", "no-store, no-cache, must-revalidate, max-age=0");
        resp.setHeader("Pragma", "no-cache");
        resp.setDateHeader("Expires", 0);

        List<BoardDTO> boardList = boardDAO.listDao();
        model.addAttribute("boardlist", boardList);
        return "user/board/list";
    }

    // 📍 게시글 상세 조회
    @GetMapping("/detail/{b_code}")
    public String detail(@PathVariable("b_code") String b_code,
                         Model model,
                         HttpServletResponse resp,
                         Authentication authentication,
                         HttpSession session) {
        resp.setHeader("Cache-Control", "no-store, no-cache, must-revalidate, max-age=0");
        resp.setHeader("Pragma", "no-cache");
        resp.setDateHeader("Expires", 0);

        boardDAO.increaseViewCount(b_code);
        BoardDTO board = boardDAO.selectDao(b_code);
        model.addAttribute("board", board);

        model.addAttribute("fileList", fileuploadDAO.selectFilesByTarget(b_code));
        model.addAttribute("replyList", replyDAO.getReplies(b_code));

        if (authentication != null) {
            String m_id = authentication.getName();
            MemberDTO member = memberDAO.selectDAOById(m_id);
            if (member != null) {
                session.setAttribute("m_code", member.getM_code());
                session.setAttribute("loginRole", member.getM_auth());
                // 상세 페이지에서 등급별 처리를 위해 grade도 세션에 담아두면 좋습니다.
                session.setAttribute("loginGrade", member.getM_grade());
            }
        }
        return "user/board/detail";
    }

    // 📍 글 작성 폼 이동
    @GetMapping("/writeForm")
    public String writeForm(Authentication authentication, Model model) {
        if (authentication == null) return "redirect:/guest/loginForm";
        
        // 작성 폼에 진입할 때도 미리 체크해서 막는 것이 좋습니다.
        MemberDTO member = memberDAO.selectDAOById(authentication.getName());
        if ("LIMIT".equals(member.getM_grade())) {
            model.addAttribute("msg", "현재 이용 제한 상태이므로 글 작성이 불가능합니다.");
            model.addAttribute("url", "/user/board/list");
            return "common/alert";
        }
        
        return "user/board/writeForm"; 
    }
    
    // 📍 이미지 업로드 전용 API
    @PostMapping("/uploadImage")
    @ResponseBody 
    public String uploadImage(@RequestParam("file") MultipartFile file) throws Exception {
        if (!file.isEmpty()) {
            String fileName = java.util.UUID.randomUUID().toString() + "_" + file.getOriginalFilename();
            String uploadPath = "C:/upload/"; 
            
            File dest = new File(uploadPath + fileName);
            file.transferTo(dest); 

            return "/upload/" + fileName;
        }
        return "error";
    }
    
    // 📍 글 작성 처리 (등급 체크 반영)
    @PostMapping("/write")
    public String write(BoardDTO dto, Authentication authentication, Model model) {
        if (authentication == null) return "redirect:/guest/loginForm";
        
        String m_id = authentication.getName();
        MemberDTO memberDTO = memberDAO.selectDAOById(m_id);
        if (memberDTO == null) return "redirect:/guest/loginForm";

        // [활동 제한 체크]
        if ("RESTRICT".equals(memberDTO.getM_grade())) {
            model.addAttribute("msg", "운영 정책 위반으로 게시글 작성이 금지되었습니다.");
            model.addAttribute("url", "/user/board/list");
            return "common/alert";
        }

        dto.setM_code(memberDTO.getM_code()); 
        boardDAO.insertDao(dto); 
        return "redirect:/user/board/list?t=" + System.currentTimeMillis();
    }

    // 📍 글 수정 폼 이동
    @GetMapping("/updateForm/{b_code}")
    public String updateForm(@PathVariable("b_code") String b_code, Model model, Authentication authentication) {
        if (authentication == null) return "redirect:/guest/loginForm";
        
        BoardDTO board = boardDAO.selectDao(b_code);
        model.addAttribute("board", board);
        return "user/board/updateForm"; 
    }

    // 📍 글 수정 처리
    @PostMapping("/update")
    public String update(BoardDTO dto, Authentication authentication, Model model) {
        if (authentication == null) return "redirect:/guest/loginForm";
        String m_id = authentication.getName();
        MemberDTO member = memberDAO.selectDAOById(m_id);
        if (member == null) return "redirect:/guest/loginForm";

        // [활동 제한 체크] 수정도 글쓰기의 일부이므로 차단합니다.
        if ("RESTRICT".equals(member.getM_grade())) {
            model.addAttribute("msg", "이용 제한 상태에서는 게시글을 수정할 수 없습니다.");
            model.addAttribute("url", "/user/board/detail/" + dto.getB_code());
            return "common/alert";
        }

        String loginUser = member.getM_code();
        String role = member.getM_auth();

        BoardDTO origin = boardDAO.selectDao(dto.getB_code());
        if (origin == null) return "redirect:/user/board/list";

        if (loginUser.equals(origin.getM_code()) || role.equalsIgnoreCase("ADMIN") || role.equals("ROLE_ADMIN")) {
            boardDAO.updateDao(dto);
        }
        return "redirect:/user/board/detail/" + dto.getB_code() + "?t=" + System.currentTimeMillis();
    }

    // 📍 게시글 삭제
    @GetMapping("/delete/{b_code}")
    public String delete(@PathVariable("b_code") String b_code, Authentication authentication) {
        if (authentication == null) return "redirect:/guest/loginForm";
        String m_id = authentication.getName();
        MemberDTO member = memberDAO.selectDAOById(m_id);
        if (member == null) return "redirect:/guest/loginForm";

        String loginUser = member.getM_code();
        String role = member.getM_auth();

        BoardDTO origin = boardDAO.selectDao(b_code);
        if (origin == null) return "redirect:/user/board/list";

        if (loginUser.equals(origin.getM_code()) || role.equalsIgnoreCase("ADMIN") || role.equals("ROLE_ADMIN")) {
            boardDAO.deleteDao(b_code);
        }
        return "redirect:/user/board/list?t=" + System.currentTimeMillis();
    }

 // 📍 댓글 등록 (LIMIT 등급 차단 버전)
    @PostMapping("/reply/write")
    public String writeReply(ReplyDTO dto, Authentication authentication, Model model) {
        if (authentication == null) return "redirect:/guest/loginForm";
        
        String m_id = authentication.getName();
        // 1. 실시간으로 DB에서 유저 정보를 다시 조회
        MemberDTO member = memberDAO.selectDAOById(m_id);

        // 2. [강력 디버깅] 공백 제거 후 비교 결과가 true인지 콘솔에서 꼭 확인하세요.
        if (member != null && member.getM_grade() != null) {
            String grade = member.getM_grade().trim(); // 앞뒤 공백 완전 제거
            System.out.println("가져온 등급: [" + grade + "]");
            
            // 3. 차단 로직 (대소문자 구분 없이 LIMIT과 비교)
            if ("LIMIT".equalsIgnoreCase(grade)) {
                model.addAttribute("msg", "현재 이용 제한(LIMIT) 상태이므로 댓글 작성이 불가능합니다.");
                model.addAttribute("url", "/user/board/detail/" + dto.getB_code());
                return "common/alert"; // ◀ 여기서 return이 실행되면 아래 insertReply는 절대 실행 안 됨
            }
        }

        // 4. 등급이 LIMIT이 아닌 경우에만 실행됨
        dto.setM_code(member.getM_code()); 
        if (dto.getRe_secret() == null) dto.setRe_secret("N");
        dto.setRe_depth(0);
        
        replyDAO.insertReply(dto);
        return "redirect:/user/board/detail/" + dto.getB_code();
    }

    // 📍 댓글 수정
    @PostMapping("/reply/update")
    public String updateReply(ReplyDTO dto, Authentication authentication, Model model) {
        if (authentication == null) return "redirect:/guest/loginForm";
        String m_id = authentication.getName();
        MemberDTO member = memberDAO.selectDAOById(m_id);
        if (member == null) return "redirect:/guest/loginForm";

        // [활동 제한 체크]
        if ("RESTRICT".equals(member.getM_grade())) {
            model.addAttribute("msg", "제한 등급 유저는 댓글 수정을 할 수 없습니다.");
            model.addAttribute("url", "/user/board/detail/" + dto.getB_code());
            return "common/alert";
        }

        String loginUser = member.getM_code();
        String role = member.getM_auth();

        ReplyDTO origin = replyDAO.getReplyByCode(dto.getRe_code());
        if (origin == null) return "redirect:/user/board/detail/" + dto.getB_code();

        if (dto.getRe_secret() == null) dto.setRe_secret("N");

        if (loginUser.equals(origin.getM_code()) || role.equalsIgnoreCase("ADMIN") || role.equals("ROLE_ADMIN")) {
            replyDAO.updateReply(dto);
        }
        return "redirect:/user/board/detail/" + dto.getB_code() + "?t=" + System.currentTimeMillis();
    }

    // 📍 댓글 삭제
    @GetMapping("/reply/delete/{re_code}/{b_code}")
    public String deleteReply(@PathVariable("re_code") String re_code,
                              @PathVariable("b_code") String b_code,
                              Authentication authentication) {
        if (authentication == null) return "redirect:/guest/loginForm";
        String m_id = authentication.getName();
        MemberDTO member = memberDAO.selectDAOById(m_id);
        if (member == null) return "redirect:/guest/loginForm";

        String loginUser = member.getM_code();
        String role = member.getM_auth();

        ReplyDTO origin = replyDAO.getReplyByCode(re_code);

        if (origin != null && loginUser != null &&
            (loginUser.equals(origin.getM_code()) ||
             role.equalsIgnoreCase("ADMIN") ||
             role.equals("ROLE_ADMIN"))) {
            replyDAO.deleteReply(re_code);
        }

        return "redirect:/user/board/detail/" + b_code + "?t=" + System.currentTimeMillis();
    }
}