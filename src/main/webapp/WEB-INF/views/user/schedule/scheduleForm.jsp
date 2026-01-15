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
        height: 100vh;
        position: relative; /* 자식 요소의 absolute 기준점 */
    }
    
    .container {
    	position: absolute; /* 위치를 자유롭게 배치 */
    	top: 50%;  /* 위에서 50% 지점 */
    	left: 50%; /* 왼쪽에서 50% 지점 */
    	transform: translate(-50%, -50%); /* 요소 크기의 절반만큼 다시 돌아가면 정중앙 */
    	
    	width: 50vw; 
    	max-width: 90%; 
    	padding: 50px 30px; 
    	
    	background-color: white;
    	border-radius: 30px;
    	box-shadow: 0 10px 40px rgba(162, 155, 254, 0.15);
    	box-sizing: border-box; /* 패딩 포함 크기 계산 */
    }
    
    .schedule-title {
    	text-align: center;
    	width: 100%;
    	font-size: 2.0rem;
    	font-weight: bold;
    	margin-bottom: 40px;
    	color: var(--primary-color);
    }
    
    .schedule-form {
    	text-align: center;
    	display: flex;       /* 내부 요소 정렬 */
    	flex-direction: column;
    	gap: 15px;           /* 입력창 사이 간격 */
    	align-items: center; /* 가로 중앙 정렬 */
    }
    
    #schedule-line {
    	margin-bottom: 10px;
    }
    
    input[type="text"] {
    	font-size: 1rem;
    	width: 100%; /* 컨테이너 대비 너비 */
    	padding: 15px;
    	border: 1px solid var(--border-color); /* 테두리 얇게 */
    	border-radius: 12px;
    	outline: none;
    	background-color: #fff;
    	transition: 0.2s;
    	box-sizing: border-box;
    }
    
    .schedule-btn {
    	margin-top: 20px;
    	width: 100%;
    	display: flex;
    	justify-content: center;
    	gap: 5px;
    }
    
    input[type="submit"] {
    	border: none; 
        background: #a29bfe; 
        color: white;
        padding: 12px 40px;
        font-size: 1.2rem;
        cursor: pointer; 
        border-radius: 15px;
        transition: all 0.2s;
        font-weight: bold;
	    font-family: 'Pretendard', sans-serif;
	    box-shadow: 0 5px 15px rgba(162, 155, 254, 0.3);
    }
    
    input[type="submit"]:hover {
    	background: var(--primary-hover);
    }
    
    button { 
    	border: #a29bfe; 
        background-color: white; 
        border-radius: 15px;
        padding: 6px 20px;
    }
    
    a { text-decoration: none; }
    
</style>
</head>
<body>
	<%@ include file="../../guest/header.jsp" %>
	<div class="container">
		<div class="schedule-title">
			<h3>여행 계획하기</h3>
		</div>
		<div class="schedule-form">
			<form name="scheduleForm" id="scheduleForm" method="post" action="/user/schedule/schedule">
				<div class="schedule-text" id="schedule-line">
					<input type="text" name="p_name" id="p_name" placeholder="여행지를 적어주세요. 예)서울 부산"><br>
				</div>
				<div class="schedule-cal" id="schedule-line">
					<input type="text" id="dateSchedule" placeholder="여행 기간을 선택하세요">
					<input type="hidden" name="s_start" id="s_start">
					<input type="hidden" name="s_end" id="s_end">
				</div>
				<div class="schedule-btn">
					<input type="submit" value="계획 시작">
				</div>
			</form>
			<a href="/user/mypage/main"><span style="color: #a29bfe;">메인으로 돌아가기</span></a>
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