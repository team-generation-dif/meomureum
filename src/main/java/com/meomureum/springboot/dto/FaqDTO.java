package com.meomureum.springboot.dto;

import lombok.Data;

@Data
public class FaqDTO {
	private String faq_code;
	private String faq_category;
	private String faq_title;
	private String faq_content;
	private String created_at;
}
