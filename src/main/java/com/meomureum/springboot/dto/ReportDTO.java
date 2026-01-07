package com.meomureum.springboot.dto;

import lombok.Data;

@Data
public class ReportDTO {
	private String rep_code;
	private String target_type;
	private String m_code;
	private String rep_title;
	private String rep_content;
	private String created_at;
}
