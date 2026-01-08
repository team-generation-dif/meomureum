package com.meomureum.springboot.controller;

import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Controller;
import org.springframework.ui.Model;
import org.springframework.web.bind.annotation.RequestMapping;

import com.meomureum.springboot.dao.INoteDAO;
import com.meomureum.springboot.dao.IScheduleDAO;
import com.meomureum.springboot.dto.NoteDTO;
import com.meomureum.springboot.dto.ScheduleDTO;

import jakarta.servlet.http.HttpServletRequest;

@Controller
public class ScheduleController {
	
	@Autowired
	IScheduleDAO scheduleDAO;
	@Autowired
	INoteDAO noteDAO;
	
	@RequestMapping("/user/schedule/scheduleForm")
	public String scheduleForm() {
		
		return "user/schedule/scheduleForm";
	}
	
	// 여행 계획 시작 폼
	@RequestMapping("/user/schedule/schedule")
	public String schedule(Model model, HttpServletRequest request) {
		
		String p_name = request.getParameter("p_name");
		String s_start = request.getParameter("s_start");
		String s_end = request.getParameter("s_end");
		String mode = "new";
		
		model.addAttribute("p_name", p_name);
		model.addAttribute("s_start", s_start);
		model.addAttribute("s_end", s_end);
		model.addAttribute("mode", mode);
		
		return "user/schedule/schedule";
	}
	
	// 여행 계획 커밋하기
	@RequestMapping("/user/schedule/insertSchedule")
	public String insertSchedule(ScheduleDTO dto, HttpServletRequest request) {
		// 파라미터 받아오기
		String mode = request.getParameter("mode");
		String[] n_title = request.getParameterValues("n_title");
		String[] n_content = request.getParameterValues("n_content");
		String[] n_order = request.getParameterValues("n_order");
		String s_code = "";
		
		// mode=="update"라면 1부터 진행, mode=="new"라면 3부터 진행
		// 1. mode=="update"일 때 노트가 있다면 먼저 노트를 지움
		if ("update".equals(mode)) {
			s_code = request.getParameter("s_code");
			noteDAO.deleteDAO(s_code); 
			
		// 2. 계획 업데이트
			scheduleDAO.updateDAO(dto);
		} else {
		// 3. mode=="new"라면 계획 생성
			scheduleDAO.insertDAO(dto);
			// insertDAO에 selectKey를 설정해서 계획 DB 로우를 생성하기 전에 s_code를 생성해서 저장
			s_code = dto.getS_code();
		}
		// 4. 노트가 있다면 노트 데이터 입력
		if (n_title != null) {
			NoteDTO noteDTO = new NoteDTO();
			for (int i=0; i<n_title.length;i++) {
				noteDTO.setS_code(s_code);
				noteDTO.setN_title(n_title[i]);
				noteDTO.setN_content(n_content[i]);
				noteDTO.setN_order(Integer.parseInt(n_order[i]));
				
				noteDAO.insertDAO(noteDTO);
			}
		}
		return "user/schedule/scheduleConfirm";
	}
}
