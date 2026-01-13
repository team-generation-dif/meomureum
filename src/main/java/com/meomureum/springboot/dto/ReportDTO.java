package com.meomureum.springboot.dto;

import java.util.Date;

import lombok.Data;

@Data
public class ReportDTO {
	    private String rep_code;
	    private String rep_category;   // BOARD / REPLY
	    private String m_code;		   // 신고자
	    private String rep_title;
	    private String rep_content;
	    private Date created_at;
	    private String target_code;    // 게시글/댓글 코드 (추가)
}
