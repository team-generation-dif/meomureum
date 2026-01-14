package com.meomureum.springboot.dao;

import java.util.List;

import org.apache.ibatis.annotations.Mapper;

import com.meomureum.springboot.dto.NoticeDTO;

@Mapper
public interface INoticeDAO {
	// 공지사항 전체 목록 조회
    List<NoticeDTO> getAllNotices();

    // 특정 카테고리별 공지사항 조회
    List<NoticeDTO> getNoticesByCategory(String notice_category);

    // 공지사항 상세 내용 보기
    NoticeDTO getNoticeDetail(String notice_code);
    
    public List<NoticeDTO> searchNotices(String keyword);

    // 공지사항 작성
    int insertNotice(NoticeDTO noticeDto);

    // 공지사항 삭제
    int deleteNotice(String notice_code);
}
