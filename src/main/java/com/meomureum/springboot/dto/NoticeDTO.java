package com.meomureum.springboot.dto;

import lombok.Data;

@Data
public class NoticeDTO {
	private String notice_code;
	private String notice_title;
	private String notice_content;
	private String notice_category;
	private String created_at;
}
