package com.meomureum.springboot.dao;

import java.util.List;
import com.meomureum.springboot.dto.ReportDTO;

public interface IReportDAO {
	void insertReport(ReportDTO dto);
    List<ReportDTO> listReports(); // 전체 신고 목록
    void deleteReport(String rep_code); // 신고 처리 후 삭제
}
