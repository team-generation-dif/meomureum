package com.meomureum.springboot.dao;

import org.apache.ibatis.annotations.Mapper;

import com.meomureum.springboot.dto.RouteDTO;

@Mapper
public interface IRouteDAO {
	public int deleteDAO(String s_code);
	public int insertDAO(RouteDTO dto);
}
