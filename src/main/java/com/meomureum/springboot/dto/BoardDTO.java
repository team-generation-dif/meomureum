package com.meomureum.springboot.dto;

import java.util.Date;

import lombok.Data;

@Data
public class BoardDTO {
	private String b_code;
	private String b_title;
	private String b_content;
	private int b_view;
	private String b_category;
	private Date created_at;
	private String m_code;	
}
