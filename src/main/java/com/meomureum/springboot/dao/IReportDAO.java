package com.meomureum.springboot.dao;

import java.util.List;

import org.apache.ibatis.annotations.Param;

import com.meomureum.springboot.dto.ReportDTO;

public interface IReportDAO {
	// 신고 등록
	void insertReport(ReportDTO dto);
	
	// 대기중 신고
	List<ReportDTO> listPendingReports(@Param("startRow") int startRow,
            						   @Param("endRow") int endRow,
            						   @Param("keyword") String keyword);
	int countPendingReports(@Param("keyword") String keyword);

	// 완료된 신고
    List<ReportDTO> listDoneReports(@Param("startRow") int startRow,
                                    @Param("endRow") int endRow,
                                    @Param("keyword") String keyword);
    int countDoneReports(@Param("keyword") String keyword);

    // 보류된 신고
    List<ReportDTO> listIgnoredReports(@Param("startRow") int startRow,
                                       @Param("endRow") int endRow,
                                       @Param("keyword") String keyword);
    int countIgnoredReports(@Param("keyword") String keyword);
	
    void updateReportStatus(ReportDTO dto); //처리 상태 업데이트 메서드 추가
    // 단건 조회
    ReportDTO findReportByCode(String rep_code);
    // 전체 목록
    List<ReportDTO> listReports();
    // 상태별 건수
    int countReportsByStatus(@Param("status") String status);
    // 전체 건수
    int countAllReports();
}
