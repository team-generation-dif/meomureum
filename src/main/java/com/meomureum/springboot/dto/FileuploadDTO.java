package com.meomureum.springboot.dto;

import lombok.Data;

@Data
public class FileuploadDTO {
	private String file_code;
	private String target_type;
	private String target_code;
	private String file_path;
	private String file_name;
	private int file_size;
	private int file_order;
}	
