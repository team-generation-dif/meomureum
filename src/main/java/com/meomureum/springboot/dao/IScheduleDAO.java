package com.meomureum.springboot.dao;

import java.util.List;

import org.apache.ibatis.annotations.Mapper;

import com.meomureum.springboot.dto.ScheduleDTO;

@Mapper
public interface IScheduleDAO {
	public List<ScheduleDTO> listDAOById(String m_id);
	public ScheduleDTO selectDAO(String s_code);
	public int insertDAO(ScheduleDTO dto);
	public int deleteDAO(String s_code);
	public int updateDAO(ScheduleDTO dto);
}
