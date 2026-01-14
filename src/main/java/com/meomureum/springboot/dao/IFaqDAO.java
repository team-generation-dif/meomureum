package com.meomureum.springboot.dao;

import java.util.List;

import org.apache.ibatis.annotations.Mapper;

import com.meomureum.springboot.dto.FaqDTO;

@Mapper
public interface IFaqDAO {
	// 1. 모든 FAQ 목록 가져오기
    List<FaqDTO> getAllFaqs();

    // 2. 새로운 FAQ 게시글 추가하기
    int insertFaq(FaqDTO faqDto);

    // 3. 특정 FAQ 상세 보기 (코드 기준)
    FaqDTO getFaqByCode(String faq_code);
    
    List<FaqDTO> searchFaqs(String keyword);
    
    // 4. FAQ 삭제하기
    int deleteFaq(String faq_code);
}
