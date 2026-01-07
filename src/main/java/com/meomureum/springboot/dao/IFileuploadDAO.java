package com.meomureum.springboot.dao;

import java.util.List;

import org.apache.ibatis.annotations.Mapper;

import com.meomureum.springboot.dto.FileuploadDTO;

@Mapper
public interface IFileuploadDAO {
    int insertFile(FileuploadDTO dto);
    List<FileuploadDTO> selectFilesByTarget(String target_code);
    int deleteFilesByTarget(String target_code);
}
