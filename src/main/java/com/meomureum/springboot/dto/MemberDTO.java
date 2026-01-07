package com.meomureum.springboot.dto;

import lombok.Data;

@Data
public class MemberDTO {
	private String m_code;
	private String m_id;
	private String m_passwd;
	private String m_name;
	private String m_nick;
	private String m_email;
	private String created_at;
	private String m_tel;
	private String m_gender;
	private String m_grade;
	private String m_auth;
}
