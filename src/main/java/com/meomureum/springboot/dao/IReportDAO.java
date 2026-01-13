package com.meomureum.springboot.dao;

import java.util.List;
import com.meomureum.springboot.dto.ReportDTO;

public interface IReportDAO {
	void insertReport(ReportDTO dto);
    List<ReportDTO> listReports();
}
