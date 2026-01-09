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
import com.meomureum.springboot.dao.IReplyDAO;
import com.meomureum.springboot.dto.BoardDTO;
import com.meomureum.springboot.dto.FileuploadDTO;
import com.meomureum.springboot.dto.ReplyDTO;

@Controller
@RequestMapping("/user/board")
public class BoardController {

    @Autowired
    private IBoardDAO boardDAO;
    
    @Autowired
    private IFileuploadDAO fileuploadDAO;
    
    @Autowired
    private IReplyDAO replyDAO;

    
    // 📍 게시판 목록
    @GetMapping("/list")
    public String list(Model model) {
        List<BoardDTO> boardList = boardDAO.listDao();
        model.addAttribute("boardlist", boardList);
        return "user/board/list"; // list.jsp
    }

    // 📍 게시글 상세 조회 (조회수 증가 포함)
    @GetMapping("/detail/{b_code}")
    public String detail(@PathVariable("b_code") String b_code, Model model) {
        // 조회수 증가
        boardDAO.increaseViewCount(b_code);
        // 이미지 조회
        List<FileuploadDTO> fileList = fileuploadDAO.selectFilesByTarget(b_code);
        model.addAttribute("fileList", fileList);
        // 글 조회
        BoardDTO board = boardDAO.selectDao(b_code);       
        model.addAttribute("board", board);
        // 댓글 목록 조회 추가
        List<ReplyDTO> replyList = replyDAO.getReplies(b_code);
        model.addAttribute("replyList", replyList);

        return "user/board/detail"; // detail.jsp               
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

    // 📍 글 수정 처리
    @PostMapping("/update")
    public String update(BoardDTO dto) {
        boardDAO.updateDao(dto); // DB 업데이트
        return "redirect:/user/board/detail/" + dto.getB_code(); // 수정 후 상세보기로 
    }

    // 📍 글 삭제
    @GetMapping("/delete/{b_code}")
    public String delete(@PathVariable("b_code") String b_code) {
        boardDAO.deleteDao(b_code);
        return "redirect:/user/board/list";
    }
    // 📍 댓글 등록
    @PostMapping("/reply/write")
    public String writeReply(ReplyDTO dto) {
        replyDAO.insertReply(dto); // 댓글 저장
        return "redirect:/user/board/detail/" + dto.getB_code(); // 저장 후 상세 페이지로 이동
    } 
}
