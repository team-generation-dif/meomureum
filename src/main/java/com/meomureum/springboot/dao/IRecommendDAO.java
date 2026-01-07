package com.meomureum.springboot.dao;

import java.util.List;

import org.apache.ibatis.annotations.Mapper;

import com.meomureum.springboot.dto.RecommendDTO;


@Mapper
public interface IRecommendDAO {
	public List<RecommendDTO> listDao(); // 추천목록
	public RecommendDTO boardCode(String b_code); // 게시(코드) 조회
}
