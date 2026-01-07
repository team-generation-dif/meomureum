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
import org.springframework.web.multipart.MultipartFile;

import com.meomureum.springboot.dao.IBoardDAO;
import com.meomureum.springboot.dao.IFileuploadDAO;
import com.meomureum.springboot.dto.BoardDTO;
import com.meomureum.springboot.dto.FileuploadDTO;

@Controller
@RequestMapping("/user/board")
public class BoardController {

    @Autowired
    private IBoardDAO boardDAO;

    // 📍 게시판 목록
    @GetMapping("/list")
    public String list(Model model) {
        List<BoardDTO> boardList = boardDAO.listDao();
        model.addAttribute("boardlist", boardList);
        return "user/board/list"; // list.jsp
    }

    // 📍 게시글 상세 조회 (조회수 증가 포함)
    @GetMapping("/detail/{b_code}")
    public String detail(@PathVariable String b_code, Model model) {
        // 조회수 증가
        boardDAO.increaseViewCount(b_code);
        // 글 조회
        BoardDTO board = boardDAO.selectDao(b_code);
        model.addAttribute("board", board);
        return "user/board/detail"; // detail.jsp
    }

    // 📍 글 작성 폼 이동
    @GetMapping("/writeForm")
    public String writeForm() {
        return "user/board/writeForm"; // writeForm.jsp
    }

    // 📍 글 작성 처리
    @PostMapping("/write")
    public String write(BoardDTO dto, @RequestParam("uploadFiles") List<MultipartFile> files) {
        boardDAO.insertDao(dto); // 게시글 저장
        String targetCode = dto.getB_code(); // 새 글 코드

        int order = 1;
        for (MultipartFile file : files) {
            if (!file.isEmpty()) {
                String fileName = file.getOriginalFilename();
                String uploadPath = "C:/upload/";
                File dest = new File(uploadPath + fileName);
				/* file.transferTo(dest); */

                FileuploadDTO fileDto = new FileuploadDTO();
                fileDto.setTarget_type("BOARD");
                fileDto.setTarget_code(targetCode);
                fileDto.setFile_path(uploadPath);
                fileDto.setFile_name(fileName);
                fileDto.setFile_size(file.getSize());
                fileDto.setFile_order(order++);

				/* IFileuploadDAO.insertFile(fileDto); */
            }
        }
        return "redirect:/user/board/list";
    }


    // 📍 글 수정 폼 이동
    @GetMapping("/updateForm/{b_code}")
    public String updateForm(@PathVariable String b_code, Model model) {
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
    public String delete(@PathVariable String b_code) {
        boardDAO.deleteDao(b_code);
        return "redirect:/user/board/list";
    }
}
