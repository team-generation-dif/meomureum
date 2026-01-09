package com.meomureum.springboot.dto;

import lombok.Data;
import java.util.Date;

@Data
public class ReplyDTO {
    private String re_code;       // 댓글 PK (화면에는 안 씀)
    private String re_content;    // 댓글 내용
    private Date created_at;      // 작성일
    private String re_secret;     // 비밀댓글 여부
    private int re_depth;         // 댓글 깊이
    private String b_code;        // 게시글 코드
    private String m_code;        // 댓글 작성자
}

