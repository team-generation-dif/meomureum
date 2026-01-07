package com.meomureum.springboot.dao;

import java.util.List;

import org.apache.ibatis.annotations.Mapper;

import com.meomureum.springboot.dto.NoteDTO;

@Mapper
public interface INoteDAO {
	// 쪽지 보내기 (저장)
    int insertNote(NoteDTO noteDto);

    // 내가 받은 쪽지 목록 조회
    List<NoteDTO> getReceivedNotes(String p_code);

    // 내가 보낸 쪽지 목록 조회
    List<NoteDTO> getSentNotes(String s_code);

    // 쪽지 상세 보기
    NoteDTO getNoteDetail(String n_code);

    // 쪽지 삭제
    int deleteNote(String n_code);
}
