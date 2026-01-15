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
	/* 대시보드 및 지도의 컬러 정보 유지 */
:root {
    --primary-color: #a29bfe;
    --primary-hover: #6c5ce7;
    --bg-color: #f8f9ff;
    --text-color: #2d3436;
    --white: #ffffff;
    --shadow: 0 15px 35px rgba(162, 155, 254, 0.15);
}

body {
    font-family: 'Pretendard', sans-serif;
    margin: 0;
    padding: 0;
    color: var(--text-color);
    background-color: var(--bg-color);
    display: flex;
    justify-content: center;
    align-items: center;
    height: 100vh; /* 화면 중앙 정렬 */
    overflow: hidden;
}

/* 중앙 카드 컨테이너 */
.plan-container {
    background: var(--white);
    padding: 40px;
    border-radius: 20px;
    box-shadow: var(--shadow);
    width: 100%;
    max-width: 400px;
    text-align: center;
}

.plan-container h3 {
    font-size: 24px;
    margin-bottom: 30px;
    color: var(--primary-hover);
    font-weight: 700;
}

/* 입력 필드 스타일 */
.input-group {
    margin-bottom: 20px;
    text-align: left;
}

.input-group label {
    display: block;
    font-size: 14px;
    margin-bottom: 8px;
    font-weight: 600;
    color: #636e72;
}

.input-group input {
    width: 100%;
    padding: 12px 15px;
    border: 2px solid #f1f3ff;
    border-radius: 12px;
    font-size: 15px;
    box-sizing: border-box;
    transition: all 0.3s ease;
    outline: none;
}

.input-group input:focus {
    border-color: var(--primary-color);
    background-color: #fff;
    box-shadow: 0 0 8px rgba(162, 155, 254, 0.2);
}

/* 제출 버튼 스타일 */
.btn-submit {
    width: 100%;
    padding: 15px;
    background-color: var(--primary-color);
    color: white;
    border: none;
    border-radius: 12px;
    font-size: 16px;
    font-weight: 700;
    cursor: pointer;
</style>
</head>
<body>
    <div class="plan-container">
        <h3>✨ 여정 시작하기</h3>
        
        <form name="scheduleForm" id="scheduleForm" method="post" action="/user/schedule/schedule">
            <div class="input-group">
                <label for="p_name">어디로 떠나시나요?</label>
                <input type="text" name="p_name" id="p_name" placeholder="예) 서울, 부산, 제주도" required>
            </div>

            <div class="input-group">
                <label for="dateSchedule">언제 떠나시나요?</label>
                <input type="text" id="dateSchedule" placeholder="여행 기간을 선택하세요" readonly>
                <input type="hidden" name="s_start" id="s_start">
                <input type="hidden" name="s_end" id="s_end">
            </div>

            <button type="submit" class="btn-submit">계획 시작하기</button>
        </form>
    </div>

    <script>
        flatpickr("#dateSchedule", {
            locale: "ko",
            mode: "range",
            showMonths: 2,
            dateFormat: "Y-m-d",
            minDate: "today",
            onClose: function(selectedDates, dateStr, instance) {
                if (selectedDates.length === 2) {
                    document.getElementById("s_start").value = instance.formatDate(selectedDates[0], "Y-m-d");
                    document.getElementById("s_end").value = instance.formatDate(selectedDates[1], "Y-m-d");
                }
            }
        });
    </script>
</body>
</html>