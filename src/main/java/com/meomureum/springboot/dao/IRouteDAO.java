package com.meomureum.springboot.dao;

import java.util.List;

import org.apache.ibatis.annotations.Mapper;

import com.meomureum.springboot.dto.RouteDTO;

@Mapper
public interface IRouteDAO {
	public int deleteDAO(String s_code);
	public int insertDAO(RouteDTO dto);
	public List<RouteDTO> listDAOBySCode(String s_code);
}
