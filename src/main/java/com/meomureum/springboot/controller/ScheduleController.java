package com.meomureum.springboot.controller;

import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Controller;
import org.springframework.ui.Model;
import org.springframework.web.bind.annotation.RequestMapping;

import com.meomureum.springboot.dao.IScheduleDAO;

import jakarta.servlet.http.HttpServletRequest;

@Controller
public class ScheduleController {
	
	@Autowired
	IScheduleDAO dao;
	
	@RequestMapping("/user/schedule/scheduleForm")
	public String scheduleForm() {
		
		return "user/schedule/scheduleForm";
	}
	
	@RequestMapping("/user/schedule/schedule")
	public String schedule(Model model, HttpServletRequest request) {
		
		String p_name = request.getParameter("p_name");
		
		model.addAttribute("p_name", p_name);
		
		return "user/schedule/mapArea"; // 지도 표시 테스트 하는중 
	}
}
