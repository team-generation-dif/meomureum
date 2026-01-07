package com.meomureum.springboot.dto;

import lombok.Data;

@Data
public class ReplyDTO {
	private String re_code;
	private String re_content;
	private String created_at;
	private String re_secret;
	private int re_depth;
	private String b_code;
}
