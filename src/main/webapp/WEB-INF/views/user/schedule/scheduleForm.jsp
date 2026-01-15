<%@ page language="java" contentType="text/html; charset=UTF-8"
    pageEncoding="UTF-8"%>
<!DOCTYPE html>
<html>
<head>
<!-- 달력 flatpickr 라이브러리 사용 -->
<link rel="stylesheet" href="https://cdn.jsdelivr.net/npm/flatpickr/dist/flatpickr.min.min.css">
<script src="https://cdn.jsdelivr.net/npm/flatpickr"></script>
<script src="https://cdn.jsdelivr.net/npm/flatpickr/dist/l10n/ko.js"></script>
<meta charset="UTF-8">
<title>머무름 - 여정 시작</title>
<style>
	/* 대시보드(user/mypage/main.jsp)의 컬러 정보 참조 */
	:root {
        --primary-color: #a29bfe;
        --primary-hover: #6c5ce7;
        --bg-color: #f8f9ff;
        --text-color: #2d3436;
        --border-color: #f1f3ff;
        --shadow-soft: 0 10px 30px rgba(162, 155, 254, 0.05);
    }

	body {
        font-family: 'Pretendard', sans-serif;
        margin: 0;
        padding: 0;
        color: var(--text-color);
        background-color: var(--bg-color);
        overflow: hidden; /* 전체 스크롤 방지 */
    }
</style>
</head>
<body>
	<div>
		<div>
			<h3>여행 계획하기</h3>
		</div>
		<div>
			<form name="scheduleForm" id="scheduleForm" method="post" action="/user/schedule/schedule">
				<div>
					<input type="text" name="p_name" id="p_name" placeholder="여행지를 적어주세요. 예)서울 부산"><br>
				</div>
				<div>
					<input type="text" id="dateSchedule" placeholder="여행 기간을 선택하세요">
					<input type="hidden" name="s_start" id="s_start">
					<input type="hidden" name="s_end" id="s_end">
				</div>
				<div>
					<input type="submit" value="계획 시작">
				</div>
			</form>
		</div>
	</div>
	<!-- 달력 출력 -->
	<script>
	    flatpickr("#dateSchedule", {
	        local: "ko",        // 한국어 설정
	        mode: "range",      // 범위 선택 모드(시작과 끝을 선택하는 범위)
	        showMonths: 2,      // 2개월씩 보기
	        dateFormat: "Y-m-d", // 데이터 형식
	        minDate: "today",    // 오늘 이전 날짜 선택 불가
	        onClose: function(selectedDates, dateStr, instance) {
	            // 날짜가 두 개 모두 선택되었을 때 실행
	            if (selectedDates.length === 2) {
	                // s_start와 s_end 히든 필드에 각각 날짜 할당
	                document.getElementById("s_start").value = instance.formatDate(selectedDates[0], "Y-m-d");
	                document.getElementById("s_end").value = instance.formatDate(selectedDates[1], "Y-m-d");
	            }
	        }
	    });
	</script>
</body>
</html>