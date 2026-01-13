package com.meomureum.springboot.dao;

import java.util.List;

import org.apache.ibatis.annotations.Mapper;

import com.meomureum.springboot.dto.PlaceDTO;

@Mapper
public interface IPlaceDAO {
	// 장소 정보 저장
    int insertDAO(PlaceDTO placeDto);
    
    // API 코드로 장소 조회 (중복 방지를 위함)
    PlaceDTO selectDAOByApiCode(String api_code);
    
    // 전체 장소 목록 조회
    //List<PlaceDTO> getAllPlaces();

    // 특정 카테고리별 장소 조회 (예: 맛집, 카페 등)
    //List<PlaceDTO> getPlacesByCategory(String p_category);

    // 특정 장소 상세 정보 조회
    //PlaceDTO getPlaceByCode(String p_code);

    // 특정 위치(위도/경도) 근처의 장소 검색 시 활용
    //List<PlaceDTO> getNearbyPlaces(double lat, double lon);
}
