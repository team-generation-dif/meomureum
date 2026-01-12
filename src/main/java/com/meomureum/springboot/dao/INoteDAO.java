package com.meomureum.springboot.dao;

import java.util.List;

import org.apache.ibatis.annotations.Mapper;

import com.meomureum.springboot.dto.NoteDTO;

@Mapper
public interface INoteDAO {
	public int deleteDAO(String s_code);
	public int insertDAO(NoteDTO dto);
	public List<NoteDTO> listDAOBySCode(String s_code);
}
