package com.meomureum.springboot.dao;

import java.util.List;

import org.apache.ibatis.annotations.Param;

import com.meomureum.springboot.dto.ReportDTO;

public interface IReportDAO {
	void insertReport(ReportDTO dto);
	List<ReportDTO> listPendingReports(@Param("startRow") int startRow,
            						   @Param("endRow") int endRow,
            						   @Param("keyword") String keyword);
	
	int countPendingReports(@Param("keyword") String keyword);
    void updateReportStatus(ReportDTO dto); //처리 상태 업데이트 메서드 추가
    ReportDTO findReportByCode(String rep_code);
    List<ReportDTO> listReports();
    int countReportsByStatus(@Param("status") String status);
    int countAllReports();
}
