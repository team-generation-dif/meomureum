package com.meomureum.springboot.dto;

import lombok.Data;

@Data
public class QualifyDTO {
	private String qual_code;
	private String qual_reason;
	private String created_at;
	private String expire_at;
	private String black_email;
	private String black_tel;
	private String m_code;
	
}
