package com.meomureum.springboot.dao;

import java.util.List;

import org.apache.ibatis.annotations.Param;

import com.meomureum.springboot.dto.ReportDTO;

public interface IReportDAO {
	void insertReport(ReportDTO dto);
	List<ReportDTO> listPendingReports(@Param("startRow") int startRow, @Param("endRow") int endRow);
    List<ReportDTO> listDoneReports(@Param("startRow") int startRow, @Param("endRow") int endRow);
    List<ReportDTO> listIgnoredReports(@Param("startRow") int startRow, @Param("endRow") int endRow);
    void updateReportStatus(ReportDTO dto); //처리 상태 업데이트 메서드 추가
    ReportDTO findReportByCode(String rep_code);
    List<ReportDTO> listReports();
}
