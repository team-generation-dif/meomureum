package com.meomureum.springboot.dao;
import java.util.List;

import org.apache.ibatis.annotations.Mapper;

import com.meomureum.springboot.dto.FileuploadDTO;

@Mapper
public interface IFileuploadDAO {
    // 파일 정보 저장
    int insertFile(FileuploadDTO fileDto);

    // 특정 게시글에 속한 파일 목록 가져오기
    List<FileuploadDTO> getFilesByTarget(String target_type, String target_code);

    // 파일 삭제
    int deleteFile(String file_code);
}	