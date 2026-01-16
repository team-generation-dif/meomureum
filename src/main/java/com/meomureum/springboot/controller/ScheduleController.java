package com.meomureum.springboot.controller;

import java.io.InputStream;
import java.net.URL;
import java.nio.file.Files;
import java.nio.file.Path;
import java.nio.file.Paths;
import java.nio.file.StandardCopyOption;
import java.time.LocalDate;
import java.time.temporal.ChronoUnit;
import java.util.UUID;

import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.security.core.Authentication;
import org.springframework.stereotype.Controller;
import org.springframework.ui.Model;
import org.springframework.web.bind.annotation.RequestMapping;
import org.springframework.web.bind.annotation.RequestParam;

import com.meomureum.springboot.dao.IFileuploadDAO;
import com.meomureum.springboot.dao.IMemberDAO;
import com.meomureum.springboot.dao.INoteDAO;
import com.meomureum.springboot.dao.IPlaceDAO;
import com.meomureum.springboot.dao.IRouteDAO;
import com.meomureum.springboot.dao.IScheduleDAO;
import com.meomureum.springboot.dto.FileuploadDTO;
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
	@Autowired
	IFileuploadDAO fileuploadDAO;
	
	// 이미지파일(여행지) 저장 경로 고정
	private final String uploadDir = "C:/upload/place/";
	
	@RequestMapping("/user/schedule/scheduleForm")
	public String scheduleForm() {
		return "user/schedule/scheduleForm";
	}
	
	// 여행 계획 시작 폼
	@RequestMapping("/user/schedule/schedule")
	public String schedule(Model model, HttpServletRequest request, Authentication Authentication) {
		
		// 로그인 명 가지고 오기
		String m_id = Authentication.getName();
		String p_name = request.getParameter("p_name");
		String s_start = request.getParameter("s_start");
		String s_end = request.getParameter("s_end");
		String mode = "new";
		
		// m_id로 m_code 가져오기
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
	public String mySchedule(Model model, Authentication Authentication) {
		
		String m_id = Authentication.getName();
		MemberDTO memberDTO = memberDAO.selectDAOById(m_id);
		String m_code = memberDTO.getM_code();
		
		model.addAttribute("lists", scheduleDAO.listDAOByMCode(m_code));
		
		return "user/mypage/mySchedule";
	}
	
	// 여행 계획 수정으로 연결
	@RequestMapping("/user/schedule/updateSchedule")
	public String updateSchedule(Model model, @RequestParam("s_code") String s_code) {
		
		ScheduleDTO scheduleDTO = scheduleDAO.selectDAO(s_code);
		
		long diff = ChronoUnit.DAYS.between(
				LocalDate.parse(scheduleDTO.getS_start().substring(0, 10)), 
			    LocalDate.parse(scheduleDTO.getS_end().substring(0, 10))
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
			
			String[] n_api_code = request.getParameterValues("n_api_code"); 
		    String[] n_p_name = request.getParameterValues("n_p_name");
		    String[] n_p_addr = request.getParameterValues("n_p_addr");
		    String[] n_p_tel = request.getParameterValues("n_p_tel");
		    String[] n_p_img = request.getParameterValues("n_p_img");
		    String[] n_p_cat = request.getParameterValues("n_p_cat");
		    String[] n_p_x = request.getParameterValues("n_p_x");
		    String[] n_p_y = request.getParameterValues("n_p_y");
			
		    // 파일 저장 경로 (클래스 멤버변수 사용)
		    java.io.File dir = new java.io.File(uploadDir);
		    if (!dir.exists()) dir.mkdirs();
		    
			for (int i=0; i<n_title.length;i++) {
				noteDTO.setS_code(s_code);
				noteDTO.setN_title(n_title[i]);
				noteDTO.setN_content(n_content[i]);
				noteDTO.setN_order(Integer.parseInt(n_order[i]));
				
				// n_api_code 배열이 존재하고, 현재 인덱스에 값이 있다면 (빈 문자열이 아니면)
		        if (n_api_code != null && n_api_code.length > i && n_api_code[i] != null && !n_api_code[i].isEmpty()) {
		            
		            // 1) PlaceDB 확인
		            PlaceDTO existingPlace = placeDAO.selectDAOByApiCode(n_api_code[i]);
		            String pCode;
		            
		            if (existingPlace != null) {
		                pCode = existingPlace.getP_code();
		            } else {
		                // 2) 신규 장소 저장
		                PlaceDTO placeDTO = new PlaceDTO();
		                placeDTO.setApi_code(n_api_code[i]);
		                placeDTO.setP_place(n_p_name[i]);
		                placeDTO.setP_addr(n_p_addr[i]);
		                placeDTO.setP_tel(n_p_tel[i]); // 전화번호 저장
		                placeDTO.setP_category(n_p_cat[i]);
		                placeDTO.setP_lon(Double.parseDouble(n_p_x[i]));
		                placeDTO.setP_lat(Double.parseDouble(n_p_y[i]));
		                
		                placeDAO.insertDAO(placeDTO);
		                pCode = placeDTO.getP_code();
		                
		                // 3) 이미지 다운로드 & 저장 (신규 장소일 때만)
		                if (n_p_img[i] != null && !n_p_img[i].isEmpty()) {
		                    String savedFileName = saveImageFromUrl(n_p_img[i], uploadDir);
		                    if (savedFileName != null) {
		                        FileuploadDTO fileDTO = new FileuploadDTO();
		                        fileDTO.setTarget_type("PLACE");
		                        fileDTO.setTarget_code(pCode);
		                        fileDTO.setFile_name(savedFileName);
		                        fileDTO.setFile_path("/upload/place/" + savedFileName);
		                        fileDTO.setFile_order(1);
		                        fileuploadDAO.insertFile(fileDTO);
		                    }
		                }
		            }
		            // 4) 노트 DTO에 p_code 세팅 (테이블에 컬럼이 있어야 함)
		            noteDTO.setP_code(pCode);
		        } else {
		            noteDTO.setP_code(null); // 장소 없는 노트
		        }
				
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
	        String[] p_image_url = request.getParameterValues("p_image_url");
	        String[] p_place = request.getParameterValues("p_place");
	        String[] p_addr = request.getParameterValues("p_addr");
	        String[] p_lat = request.getParameterValues("p_lat");
	        String[] p_lon = request.getParameterValues("p_lon");
	        String[] p_category = request.getParameterValues("p_category");
	        
	        // 이미지 저장할 폴더가 없으면 생성
	        java.io.File dir = new java.io.File(uploadDir);
	        if (!dir.exists()) {
	            dir.mkdirs(); 
	        }
	        
	        for (int i=0; i<api_code.length; i++) {
	            // 1. 여행지 정보(Place) 저장 시도
	        	// 이미 DB에 기록된 곳인지 확인
	        	PlaceDTO existingPlace = placeDAO.selectDAOByApiCode(api_code[i]);
	            String existingPCode;
	            
	            // 이미 기록된 곳이라면 pcode만 변수에 가져옴
	            if (existingPlace != null) {
	            	existingPCode = existingPlace.getP_code();
            	// 새로운 곳이라면 여행지 정보 저장 + 마이바티스 selectKey기능으로 넘김
	            } else {
	            	PlaceDTO placeDTO = new PlaceDTO();
		            placeDTO.setApi_code(api_code[i]); // TourAPI contentid
		            placeDTO.setP_place(p_place[i]);
		            placeDTO.setP_category(p_category[i]);
		            placeDTO.setP_lat(Double.parseDouble(p_lat[i]));
		            placeDTO.setP_lon(Double.parseDouble(p_lon[i]));
		            placeDTO.setP_addr(p_addr[i]);
		            
		            placeDAO.insertDAO(placeDTO);
		            existingPCode = placeDTO.getP_code();
		            
		            // 이미지 다운로드 및 fileupload 테이블 저장 (신규 장소일 경우에만 수행)
	                if (p_image_url != null && p_image_url.length > i && 
	                    p_image_url[i] != null && !p_image_url[i].isEmpty()) {
	                    
	                    String savedFileName = saveImageFromUrl(p_image_url[i], uploadDir);
	                    
	                    if (savedFileName != null) {
	                        //FileuploadDTO 생성 및 저장 (DTO 구조에 맞게 수정 필요)
	                        FileuploadDTO fileDTO = new FileuploadDTO();
	                        fileDTO.setTarget_type("PLACE");
	                        fileDTO.setTarget_code(existingPCode);
	                        fileDTO.setFile_name(savedFileName);
	                        fileDTO.setFile_path("/upload/place/" + savedFileName);
	                        fileDTO.setFile_order(1);
	                        fileuploadDAO.insertFile(fileDTO);
	                    }
	                }
	            }
	            
	            // 2. 루트 정보 생성 및 저장
	            RouteDTO routeDTO = new RouteDTO();
	            routeDTO.setS_code(s_code);
	            routeDTO.setP_code(existingPCode);
	            routeDTO.setR_day(Integer.parseInt(r_day[i]));
	            routeDTO.setR_order(Integer.parseInt(r_order[i]));
	            routeDTO.setR_memo(r_memo[i]);
	            
	            routeDAO.insertDAO(routeDTO);
	        }	
	    }
		
		return "redirect:/user/mypage/main";
	}
	
	// 이미지를 URL에서 다운로드하여 저장하는 메소드
	private String saveImageFromUrl(String imageUrl, String saveDir) {
	    try {
	        URL url = new URL(imageUrl);
	        // 확장자 추출 (URL에 파라미터가 있거나 점이 없는 경우 대비)
     			String extension = ".jpg"; // 기본값
                int lastDotIndex = imageUrl.lastIndexOf(".");
                 
                // 점(.)이 있고, 뒤에 글자가 3~5자 이내일 때만 확장자로 인정 (예: .jpg, .jpeg, .png)
                if (lastDotIndex != -1 && (imageUrl.length() - lastDotIndex) <= 6) {
                     String extTemp = imageUrl.substring(lastDotIndex);
                     // 쿼리스트링(?ver=1) 등이 붙어있을 수 있으므로 제거
                     if(extTemp.contains("?")) {
                         extTemp = extTemp.split("\\?")[0];
                     }
                      
                     // 이미지 확장자가 맞는지 간단 체크
                     if (extTemp.toLowerCase().matches(".*(jpg|jpeg|png|gif|bmp).*")) {
                         extension = extTemp;
                     }
                }
	        // 파일명 중복 방지하는 randomUUID() -> 필요할까..?
	        String savedFileName = UUID.randomUUID().toString() + extension;
	        Path targetPath = Paths.get(saveDir, savedFileName);
	        
	        try (InputStream in = url.openStream()) {
	            Files.copy(in, targetPath, StandardCopyOption.REPLACE_EXISTING);
	        }
	        return savedFileName; // 저장된 파일명 반환
	    } catch (Exception e) {
	        e.printStackTrace();
	        return null;
	    }
	}
	// 여행 계획 삭제 메서드
		@RequestMapping("/user/schedule/deleteSchedule")
		public String deleteSchedule(@RequestParam("s_code") String s_code) {
			try {
				// 1. 하위 데이터(노트, 루트)부터 삭제
				noteDAO.deleteDAO(s_code);
				routeDAO.deleteDAO(s_code);
				
				// 2. 메인 스케줄 삭제
				scheduleDAO.deleteDAO(s_code);
				
				System.out.println("삭제 성공: " + s_code);
			} catch (Exception e) {
				System.out.println("삭제 중 오류 발생");
				e.printStackTrace();
			}
			// 3. 다시 대시보드로 이동
			return "redirect:/user/mypage/main";
		}
	
}
