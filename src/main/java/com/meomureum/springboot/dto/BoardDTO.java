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
	public String getM_code() { return m_code; }
	public void setM_code(String m_code) { this.m_code = m_code; }
	private String m_nick;   // 작성자 닉네임 추가
}
