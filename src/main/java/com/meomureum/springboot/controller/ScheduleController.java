package com.meomureum.springboot.controller;

import java.time.LocalDate;
import java.time.temporal.ChronoUnit;

import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Controller;
import org.springframework.ui.Model;
import org.springframework.web.bind.annotation.RequestMapping;

import com.meomureum.springboot.dao.IMemberDAO;
import com.meomureum.springboot.dao.INoteDAO;
import com.meomureum.springboot.dao.IPlaceDAO;
import com.meomureum.springboot.dao.IRouteDAO;
import com.meomureum.springboot.dao.IScheduleDAO;
import com.meomureum.springboot.dto.MemberDTO;
import com.meomureum.springboot.dto.NoteDTO;
import com.meomureum.springboot.dto.PlaceDTO;
import com.meomureum.springboot.dto.RouteDTO;
import com.meomureum.springboot.dto.ScheduleDTO;

import jakarta.servlet.http.HttpServletRequest;

@Controller
public class ScheduleController {
	
	@Autowired
	IScheduleDAO scheduleDAO;
	@Autowired
	INoteDAO noteDAO;
	@Autowired
	IRouteDAO routeDAO;
	@Autowired
	IPlaceDAO placeDAO;
	@Autowired
	IMemberDAO memberDAO;
	
	
	@RequestMapping("/user/schedule/scheduleForm")
	public String scheduleForm() {
		
		return "user/schedule/scheduleForm";
	}
	
	// 여행 계획 시작 폼
	@RequestMapping("/user/schedule/schedule")
	public String schedule(Model model, HttpServletRequest request) {
		
		String m_id = request.getParameter("m_id");
		String p_name = request.getParameter("p_name");
		String s_start = request.getParameter("s_start");
		String s_end = request.getParameter("s_end");
		String mode = "new";
		
		// 세션 저장된 m_id로 m_code 가져오기
		MemberDTO memberDTO = memberDAO.selectDAOById(m_id);
		
		model.addAttribute("member", memberDTO); // ${member.m_code}로 m_code 전달
		model.addAttribute("p_name", p_name);
		model.addAttribute("s_start", s_start);
		model.addAttribute("s_end", s_end);
		model.addAttribute("mode", mode);
		
		return "user/schedule/schedule";
	}
	
	// 내 여행 계획 목록
	@RequestMapping("/user/mypage/mySchedule")
	public String mySchedule(Model model, HttpServletRequest request) {
		
		String m_id = request.getParameter("m_id");
		
		model.addAttribute("lists", scheduleDAO.listDAOById(m_id));
		
		return "user/mypage/mySchedule";
	}
	
	// 여행 계획 수정으로 연결
	@RequestMapping("/user/schedule/updateSchedule")
	public String updateSchedule(Model model, HttpServletRequest request) {
		
		String s_code = request.getParameter("s_code");
		ScheduleDTO scheduleDTO = scheduleDAO.selectDAO(s_code);
		
		long diff = ChronoUnit.DAYS.between(
		    LocalDate.parse(scheduleDTO.getS_start()), 
		    LocalDate.parse(scheduleDTO.getS_end())
		) + 1;
		model.addAttribute("dayDiff", diff);
		
		model.addAttribute("noteDTO",noteDAO.listDAOBySCode(s_code));
		model.addAttribute("routeDTO",routeDAO.listDAOBySCode(s_code));
		
		String mode = "update";
		
		model.addAttribute("scheduleDTO", scheduleDTO);
		model.addAttribute("mode", mode);
		
		return "user/schedule/schedule";
	}
	
	// 여행 계획 커밋하기
	@RequestMapping("/user/schedule/insertSchedule")
	public String insertSchedule(ScheduleDTO dto, HttpServletRequest request, Model model) {
		// 파라미터 받아오기
		String mode = request.getParameter("mode");
		String m_code = request.getParameter("m_code");
		String s_code = "";
		
		// mode=="update"라면 1부터 진행, mode=="new"라면 3부터 진행
		// 1. mode=="update"일 때 노트와 루트가 있다면 모두 지움
		if ("update".equals(mode)) {
			s_code = request.getParameter("s_code");
			noteDAO.deleteDAO(s_code); 
			routeDAO.deleteDAO(s_code);
			
		// 2. 계획 업데이트
			scheduleDAO.updateDAO(dto);
		} else {
		// 3. mode=="new"라면 계획 생성
			scheduleDAO.insertDAO(dto);
			// insertDAO에 selectKey를 설정해서 계획 DB 로우를 생성하기 전에 s_code를 생성해서 저장
			s_code = dto.getS_code();
		}
		
		// 4. 노트가 있다면 노트 데이터 입력
		String[] n_title = request.getParameterValues("n_title");
		if (n_title != null) {
			String[] n_content = request.getParameterValues("n_content");
			String[] n_order = request.getParameterValues("n_order");
			NoteDTO noteDTO = new NoteDTO();
			
			for (int i=0; i<n_title.length;i++) {
				noteDTO.setS_code(s_code);
				noteDTO.setN_title(n_title[i]);
				noteDTO.setN_content(n_content[i]);
				noteDTO.setN_order(Integer.parseInt(n_order[i]));
				
				noteDAO.insertDAO(noteDTO);
			}
		}
		// 5. 여행지 데이터를 가져오고, 루트 데이터 입력
		String[] api_code = request.getParameterValues("api_code"); // API의 장소 고유 ID
	    if (api_code != null) {
	        String[] r_day = request.getParameterValues("r_day");
	        String[] r_order = request.getParameterValues("r_order");
	        String[] r_memo = request.getParameterValues("r_memo");
	        
	        // 장소 상세 정보들
	        String[] p_place = request.getParameterValues("p_place");
	        String[] p_addr = request.getParameterValues("p_addr");
	        String[] p_lat = request.getParameterValues("p_lat");
	        String[] p_lon = request.getParameterValues("p_lon");
	        String[] p_category = request.getParameterValues("p_category");

	        for (int i=0; i<api_code.length; i++) {
	            // A. 여행지 정보(Place) 저장 시도 
	            PlaceDTO placeDTO = new PlaceDTO();
	            placeDTO.setApi_code(api_code[i]);
	            placeDTO.setP_place(p_place[i]);
	            placeDTO.setP_category(p_category[i]);
	            placeDTO.setP_lat(Double.parseDouble(p_lat[i]));
	            placeDTO.setP_lon(Double.parseDouble(p_lon[i]));
	            placeDTO.setP_addr(p_addr[i]);
	            
	            placeDAO.insertDAO(placeDTO);
	            
	            // B. 루트 정보 생성 및 저장
	            RouteDTO routeDTO = new RouteDTO();
	            routeDTO.setS_code(s_code);
	            routeDTO.setR_day(Integer.parseInt(r_day[i]));
	            routeDTO.setR_order(Integer.parseInt(r_order[i]));
	            routeDTO.setR_memo(r_memo[i]);
	            
	            routeDAO.insertDAO(routeDTO);
	        }	
	    }
		
		return "user/schedule/scheduleConfirm";
	}
}
