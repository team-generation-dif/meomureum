package com.meomureum.springboot.controller;

import java.io.File;
import java.util.List;

import org.springframework.beans.factory.annotation.Autowired;
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


    // 📍 게시글 상세 조회 (조회수 증가 포함)
    @GetMapping("/detail/{b_code}")
    public String detail(@PathVariable("b_code") String b_code, Model model, HttpServletResponse resp) {
        resp.setHeader("Cache-Control", "no-store, no-cache, must-revalidate, max-age=0");
        resp.setHeader("Pragma", "no-cache");
        resp.setDateHeader("Expires", 0);

        boardDAO.increaseViewCount(b_code);
        List<FileuploadDTO> fileList = fileuploadDAO.selectFilesByTarget(b_code);
        model.addAttribute("fileList", fileList);

        BoardDTO board = boardDAO.selectDao(b_code);
        model.addAttribute("board", board);

        List<ReplyDTO> replyList = replyDAO.getReplies(b_code);
        model.addAttribute("replyList", replyList);

        return "user/board/detail";
    }


    // 📍 글 작성 폼 이동
    @GetMapping("/writeForm")
    public String writeForm() {
        return "user/board/writeForm"; // writeForm.jsp
    }
    
    
    // [추가] 이미지 업로드 전용 API
    @PostMapping("/uploadImage")
    @ResponseBody // 페이지 이동 없이 문자열(URL)만 리턴하기 위해 필수!
    public String uploadImage(@RequestParam("file") MultipartFile file) throws Exception {
        if (!file.isEmpty()) {
            // 파일명 중복 방지를 위한 UUID 랜덤 이름 생성
            String fileName = java.util.UUID.randomUUID().toString() + "_" + file.getOriginalFilename();
            String uploadPath = "C:/upload/";
            
            File dest = new File(uploadPath + fileName);
            file.transferTo(dest); // C드라이브에 저장

            // 웹에서 접근 가능한 경로 리턴 (WebConfig 설정값과 일치해야 함)
            return "/upload/" + fileName;
        }
        return "error";
    }
    
    
    // 📍 글 작성 처리
    @PostMapping("/write")
    public String write(BoardDTO dto) {
        // 이제 dto.getB_content() 안에는 글과 <img src="..."> 태그가 섞여서 들어옵니다.
        boardDAO.insertDao(dto); 
        return "redirect:/user/board/list";
    }


    // 📍 글 수정 폼 이동
    @GetMapping("/updateForm/{b_code}")
    public String updateForm(@PathVariable("b_code") String b_code, Model model) {
        BoardDTO board = boardDAO.selectDao(b_code); // 기존 글 조회
        model.addAttribute("board", board);
        return "user/board/updateForm"; // updateForm.jsp (추가 필요)
    }

    // 📍 게시글 수정 처리(권한 체크 + 캐시 회피 파라미터)
    @PostMapping("/update")
    public String update(BoardDTO dto, @RequestParam("m_id") String m_id) {
        MemberDTO member = memberDAO.selectDAOById(m_id);
        if (member == null) return "redirect:/guest/loginForm";

        String loginUser = member.getM_code();
        String role = member.getM_auth();

        BoardDTO origin = boardDAO.selectDao(dto.getB_code());
        if (origin == null) return "redirect:/user/board/list";

        if (loginUser != null && (loginUser.equals(origin.getM_code()) || "ADMIN".equals(role))) {
            boardDAO.updateDao(dto);
        }

        return "redirect:/user/board/detail/" + dto.getB_code() + "?t=" + System.currentTimeMillis();
    }

  


    // 📍 글 삭제(권한 체크 + 캐시 회피 파라미터)
    @GetMapping("/delete/{b_code}")
    public String delete(@PathVariable("b_code") String b_code, @RequestParam("m_id") String m_id) {
        MemberDTO member = memberDAO.selectDAOById(m_id);
        if (member == null) return "redirect:/guest/loginForm";

        String loginUser = member.getM_code();
        String role = member.getM_auth();

        BoardDTO origin = boardDAO.selectDao(b_code);
        if (origin != null && loginUser != null &&
            (loginUser.equals(origin.getM_code()) || "ADMIN".equals(role))) {
            boardDAO.deleteDao(b_code);
        }

        return "redirect:/user/board/list?t=" + System.currentTimeMillis();
    }

    // 📍 댓글 등록
    @PostMapping("/reply/write")
    public String writeReply(ReplyDTO dto, @RequestParam("m_id") String m_id) {
        // 로그인한 회원 조회
        MemberDTO member = memberDAO.selectDAOById(m_id);
        if (member == null) {
            // 아이디가 없으면 로그인 페이지로 이동
            return "redirect:/guest/loginForm";
        }
        
        // 작성자 코드 주입
        dto.setM_code(member.getM_code());

        // 비밀댓글 체크박스 미선택 시 기본값 처리
        if (dto.getRe_secret() == null) {
            dto.setRe_secret("N");
        }

        // 댓글 깊이 기본값
        dto.setRe_depth(0);
        

        // 댓글 저장(DB)
        replyDAO.insertReply(dto);

        return "redirect:/user/board/detail/" + dto.getB_code() + "?t=" + System.currentTimeMillis();
    }

    // 📍 댓글 수정
    @PostMapping("/reply/update")
    public String updateReply(ReplyDTO dto, @RequestParam("m_id") String m_id) {
        MemberDTO member = memberDAO.selectDAOById(m_id);
        if (member == null) {
            return "redirect:/guest/loginForm";
        }
   	
        String loginUser = member.getM_code();
        String role = member.getM_auth(); // 예: "USER" / "ADMIN"

        // 원본 댓글 조회
        ReplyDTO origin = replyDAO.getReplyByCode(dto.getRe_code());
        if (origin == null) {
            return "redirect:/user/board/detail/" + dto.getB_code();
        }

        // 비밀댓글 체크박스 기본값 처리
        if (dto.getRe_secret() == null) {
            dto.setRe_secret("N");
        }

        // 작성자 본인 또는 관리자만 수정 가능
        if (loginUser != null && (loginUser.equals(origin.getM_code()) || "ADMIN".equals(role))) {
            replyDAO.updateReply(dto);
        }

        return "redirect:/user/board/detail/" + dto.getB_code() + "?t=" + System.currentTimeMillis();
    }

              

    // 📍 댓글 삭제
    @GetMapping("/reply/delete/{re_code}/{b_code}")
    public String deleteReply(@PathVariable("re_code") String re_code,
                              @PathVariable("b_code") String b_code,
                              @RequestParam("m_id") String m_id) {
        MemberDTO member = memberDAO.selectDAOById(m_id);
        if (member == null) {
            return "redirect:/guest/loginForm";
        }

        String loginUser = member.getM_code();
        String role = member.getM_auth();

        // 원본 댓글 조회
        ReplyDTO origin = replyDAO.getReplyByCode(re_code);

        // 작성자 본인 또는 관리자만 삭제 가능
        if (origin != null && loginUser != null &&
            (loginUser.equals(origin.getM_code()) || "ADMIN".equals(role))) {
            replyDAO.deleteReply(re_code);
        }

        return "redirect:/user/board/detail/" + b_code + "?t=" + System.currentTimeMillis();

    }
}


