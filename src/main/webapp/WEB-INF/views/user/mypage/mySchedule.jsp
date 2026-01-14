<%@ page language="java" contentType="text/html; charset=UTF-8"
	pageEncoding="UTF-8"%>
<%@ taglib prefix="c" uri="jakarta.tags.core"%>
<%@ taglib prefix="fn" uri="http://java.sun.com/jsp/jstl/functions"%>
<style>
.delete-btn {
	background: none;
	border: none;
	color: #ff7675;
	cursor: pointer;
	padding: 10px;
	border-radius: 12px;
	transition: 0.2s;
	margin-left: 10px;
	display: flex;
	align-items: center;
	justify-content: center;
	flex-shrink: 0;
}

.delete-btn:hover {
	background-color: #fff5f5;
	color: #d63031;
	transform: scale(1.1);
}

.journey-card-wrapper {
	display: flex;
	align-items: center;
	width: 100%;
	margin-bottom: 15px;
}
</style>

<c:choose>
	<c:when test="${empty lists}">
		<div class="empty-msg">
			아직 등록된 여행 계획이 없어요.<br> 새로운 추억을 계획해볼까요?
		</div>
	</c:when>
	<c:otherwise>
		<c:forEach var="list" items="${lists}">
			<div class="journey-card-wrapper">
				<a href="/user/schedule/updateSchedule?s_code=${list.s_code}"
					class="journey-item" style="flex-grow: 1; margin-bottom: 0;"> <%-- 2. 날짜 출력 부분 수정 --%>
					<div class="date-info">
						<%-- s_start와 s_end의 0번째부터 10번째 직전까지 자름 --%>
						<span class="day">${fn:substring(list.s_start, 0, 10)}</span> <span
							class="end"> ~ ${fn:substring(list.s_end, 0, 10)}</span>
					</div>

					<div class="journey-content">
						<span class="s-name">${list.s_name}</span> <span class="p-name">📍
							${list.p_name}</span>
					</div>
					<div class="arrow-icon">❯</div>
				</a>

				<button type="button" class="delete-btn" title="일정 삭제"
					onclick="fn_deleteSchedule('${list.s_code}', '${list.s_name}')">
					<svg xmlns="http://www.w3.org/2000/svg" width="20" height="20"
						fill="none" viewBox="0 0 24 24" stroke="currentColor"
						stroke-width="2">
                      <path stroke-linecap="round"
							stroke-linejoin="round"
							d="M19 7l-.867 12.142A2 2 0 0116.138 21H7.862a2 2 0 01-1.995-1.858L5 7m5 4v6m4-6v6m1-10V4a1 1 0 00-1-1h-4a1 1 0 00-1 1v3M4 7h16" />
                    </svg>
				</button>
			</div>
		</c:forEach>
	</c:otherwise>
</c:choose>

<script>
    function fn_deleteSchedule(sCode, sName) {
        if (confirm("[" + sName + "] 일정을 삭제하시겠습니까?")) {
            // 주소 앞에 반드시 / 를 붙이고, 
            // 혹시 프로젝트에 context path가 있다면 아래와 같이 쓰는 것이 가장 안전합니다.
            location.href = "/user/schedule/deleteSchedule?s_code=" + sCode;
        }
    }
</script>