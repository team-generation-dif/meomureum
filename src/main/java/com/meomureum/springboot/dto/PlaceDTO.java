package com.meomureum.springboot.dto;

import lombok.Data;

@Data

public class PlaceDTO {
	private String p_code;
	private String api_code;
	private String p_place;
	private String p_category;
	private int p_lat;
	private int p_lon;
	private String p_addr;
}
