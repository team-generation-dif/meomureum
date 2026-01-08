package com.meomureum.springboot.dto;

import lombok.Data;

@Data
public class NoteDTO {
	private String n_code;
	private String s_code;
	private String p_code;
	private String n_title;
	private String n_content;
	private String created_at;
	private int n_order;
}
