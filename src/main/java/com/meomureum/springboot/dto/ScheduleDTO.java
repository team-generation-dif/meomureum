package com.meomureum.springboot.dto;

import java.util.Date;

import lombok.Data;

@Data
public class ScheduleDTO {
	private String s_code;
	private String m_code;
	private String created_at;
	private String s_start;
	private String s_end;
	private String s_name;
}
