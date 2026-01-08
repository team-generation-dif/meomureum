<%@ page language="java" contentType="text/html; charset=UTF-8"
    pageEncoding="UTF-8"%>
<%@ taglib prefix="c" uri="jakarta.tags.core"%>
<!DOCTYPE html>
<html>
<head>
<!-- 달력 flatpickr 라이브러리 사용 -->
<link rel="stylesheet" href="https://cdn.jsdelivr.net/npm/flatpickr/dist/flatpickr.min.min.css">
<script src="https://cdn.jsdelivr.net/npm/flatpickr"></script>
<script src="https://cdn.jsdelivr.net/npm/flatpickr/dist/l10n/ko.js"></script>
<script src="/JS/noteControl.js"></script>
<script>
// 제출 전 순서(n_order)를 1, 2, 3...으로 채워주는 함수
function setOrder() {
    const orders = document.querySelectorAll('input[name="n_order"]');
    orders.forEach((order, index) => {
        order.value = index + 1;
    });
}
</script>
<style>
	.container {
	    display: flex; /* 가로 배열 */
	    width: 100%;
	    height: 100vh;
	    overflow: hidden;
	}
	
	#left-content {
	    flex: 1; /* 남은 공간 모두 차지 */
	    background: white;
	}
	
	#right-side {
	    width: 40%; /* 기본값 40% */
	    min-width: 100px;
	    background: #f9f9f9;
	}
	
	#resizer {
	    width: 5px;
	    cursor: col-resize; /* 마우스 커서 모양 변경 */
	    background: #ccc;
	    transition: background 0.2s;
	}
	
	#resizer:hover {
	    background: #666; /* 마우스 올리면 색상 변경 */
	}
</style>
<meta charset="UTF-8">
<title>Insert title here</title>
</head>
<body>
	<div class="container">
		<%-- 	<div><%@ include file="sidebar.jsp" %></div> --%>
	    <div id="left-content" class="content">
	       
			<form name="schedule" method="post" action="/user/schedule/insertSchedule" onsubmit="setOrder()">
				<!-- 여행 계획을 새로 작성할 때 -->
				<c:if test="${mode == 'new'}">
					<input type="hidden" value="${mode}">
					<!-- 여행 계획 정보 -->
					<div id="">
						<div><input type="text" name="s_name" id="s_name" value="To ${p_name}"></div>
						<div>
							<input type="text" id="dateSchedule" placeholder="여행 기간을 선택하세요">
							<input type="hidden" name="s_start" id="s_start" value="${s_start}">
							<input type="hidden" name="s_end" id="s_end" value="${s_end}">
						</div>
					</div>
					<!-- 노트 영역 -->
					<div>
						<div id="n_container"></div>
						<input type="button" value="새 노트 작성" onclick="newNote()">
						<script type="text/template" id="n_template">
					<div>
						<div>
							<input type="text" name="n_title" placeholder="새로운 경험을 작성하세요">
							<input type="button" value="▲" onclick="moveUpNote(this)">
							<input type="button" value="▼" onclick="moveDownNote(this)">
						</div>
						<textarea type="text" name="n_content"></textarea>
						<input type="hidden" name="n_order">
						<input type="button" value="노트 삭제" onclick="deleteNote(this)">
					</div>
				</script>
					</div>
					<!-- 루트 영역 -->
				
				
					
				</c:if>
				<!-- 2. 수정으로 들어왔을 때 (마이페이지 등) -->
				<c:if test="${mode == 'update'}">
					<input type="hidden" name="s_code" value="${dto.s_code}">
					<input type="hidden" value="${mode}">
					<!-- 여행 계획 정보 -->
					<div id="">
						<div><input type="text" name="s_name" id="s_name" value="To ${p_name}"></div>
						<div>
							<input type="text" id="dateSchedule" placeholder="여행 기간을 선택하세요">
							<input type="hidden" name="s_start" id="s_start" value="${s_start}">
							<input type="hidden" name="s_end" id="s_end" value="${s_end}">
						</div>
					</div>
					<!-- 노트 영역 -->
					<div>
						<div id="n_container"></div>
						<input type="button" value="새 노트 작성" onclick="newNote()">
						<script type="text/template" id="n_template">
					<div>
						<div>
							<input type="text" name="n_title" placeholder="새로운 경험을 작성하세요">
							<input type="button" value="▲" onclick="moveUpNote(this)">
							<input type="button" value="▼" onclick="moveDownNote(this)">
						</div>
						<textarea type="text" name="n_content"></textarea>
						<input type="hidden" name="n_order">
						<input type="button" value="노트 삭제" onclick="deleteNote(this)">
					</div>
				</script>
					</div>
					<!-- 루트 영역 -->
				
				
					
				</c:if>
				<input type="submit" value="계획 저장">
			</form>
			
			<script>
				const start = "${s_start}";
			    const end = "${s_end}";
				
			    flatpickr("#dateSchedule", {
			        local: "ko",        // 한국어 설정
			        mode: "range",      // 범위 선택 모드(시작과 끝을 선택하는 범위)
			        showMonths: 2,      // 2개월씩 보기
			        dateFormat: "Y-m-d", // 데이터 형식
			        minDate: "today",    // 오늘 이전 날짜 선택 불가
			     	//  초기값 설정: 시작일과 종료일이 모두 있을 경우 달력에 표시
			        defaultDate: (start && end) ? [start, end] : [],
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
		</div>
		<div id="resizer"></div>
	
	    <div id="right-side" class="content">
	        <%@ include file="mapAreaTest.jsp" %>
	    </div>
	</div>
</body>
</html>