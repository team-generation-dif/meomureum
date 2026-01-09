package com.meomureum.springboot.dto;

import lombok.Data;

@Data

public class RouteDTO {
	private String r_code;
	private String p_code;
	private String s_code;
	private int r_order;
	private String r_memo;
	private int r_day;
}
