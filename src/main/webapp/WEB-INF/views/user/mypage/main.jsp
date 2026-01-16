<%@ page language="java" contentType="text/html; charset=UTF-8"
	pageEncoding="UTF-8"%>
<%@ taglib prefix="c" uri="jakarta.tags.core"%>
<!DOCTYPE html>
<html>
<head>
<meta charset="UTF-8">
<title>머무름 - 대시보드</title>
<style>
/* [기본 레이아웃] */
body {
	background-color: #f8f9ff;
	margin: 0;
	display: flex;
	font-family: 'Pretendard', sans-serif;
	min-height: 100vh;
	color: #2d3436;
}

/* [사이드바] - 기존 스타일 유지 */
.sidebar {
	width: 260px;
	background: white;
	margin: 20px;
	border-radius: 40px;
	padding: 30px 15px;
	box-shadow: 10px 0 30px rgba(162, 155, 254, 0.03);
	flex-shrink: 0;
	display: flex;
	flex-direction: column;
}

.logo {
	font-size: 1.6rem;
	font-weight: bold;
	color: #a29bfe;
	text-align: center;
	margin-bottom: 40px;
}

.menu-link {
	display: block;
	padding: 15px 20px;
	margin-bottom: 10px;
	border-radius: 20px;
	text-decoration: none;
	font-weight: 600;
	color: #888;
	transition: 0.3s;
}

.menu-link.active {
	background-color: #a29bfe;
	color: white;
	box-shadow: 0 10px 20px rgba(162, 155, 254, 0.2);
}

.menu-link:hover {
	background-color: #f1f3ff;
	color: #a29bfe;
}

/* [메인 영역] */
.main-container {
	flex-grow: 1;
	padding: 30px 40px;
}

.home-card-btn {
	display: block;
	width: 100%;
	background: linear-gradient(135deg, #a29bfe, #74b9ff);
	color: white;
	text-align: center;
	padding: 35px;
	border-radius: 35px;
	text-decoration: none;
	font-size: 1.4rem;
	font-weight: bold;
	margin-bottom: 30px;
	box-shadow: 0 15px 30px rgba(162, 155, 254, 0.2);
	transition: 0.3s;
	box-sizing: border-box;
}

.home-card-btn:hover {
	transform: translateY(-5px);
	box-shadow: 0 20px 40px rgba(162, 155, 254, 0.3);
}

/* [그리드 레이아웃] */
/* [그리드 레이아웃 수정] */
.dashboard-grid {
	display: grid;
	grid-template-columns: 1.2fr 0.8fr;
	gap: 25px;
	/* 아래 코드를 추가하여 높이 동기화를 해제합니다 */
	align-items: start;
}

.section-card {
	background: white;
	border-radius: 35px;
	padding: 35px;
	border: 1px solid #f1f3ff;
	box-shadow: 0 10px 30px rgba(0, 0, 0, 0.02);
}

.section-title {
	font-size: 1.3rem;
	font-weight: bold;
	margin-bottom: 25px;
	display: flex;
	align-items: center;
	gap: 10px;
}

.section-title span {
	color: #a29bfe;
}

/* [여정 카드 리스트 - 핵심 수정 부분] */
.item-list {
	display: flex;
	flex-direction: column;
	gap: 15px;
}

.journey-item {
	display: flex;
	align-items: center;
	padding: 20px;
	background: #fafaff;
	border-radius: 25px;
	border: 1px solid #f1f3ff;
	transition: 0.3s;
	text-decoration: none;
	color: inherit;
}

.journey-item:hover {
	background: #fff;
	border-color: #a29bfe;
	transform: scale(1.02);
	box-shadow: 0 10px 20px rgba(162, 155, 254, 0.05);
}

.date-info {
	min-width: 90px;
	border-right: 2px dashed #e1e5ff;
	margin-right: 20px;
	padding-right: 10px;
}

.date-info .day {
	display: block;
	font-size: 1.1rem;
	font-weight: bold;
	color: #a29bfe;
}

.date-info .code {
	font-size: 0.75rem;
	color: #ccc;
}

.journey-content {
	flex-grow: 1;
}

.journey-content .s-name {
	display: block;
	font-size: 1.1rem;
	font-weight: bold;
	margin-bottom: 5px;
	color: #2d3436;
}

.journey-content .p-name {
	font-size: 0.9rem;
	color: #a2a2a2;
}

.arrow-icon {
	color: #e1e5ff;
	font-size: 1.2rem;
}

/* [기타 섹션] */
.empty-msg {
	text-align: center;
	color: #ccc;
	padding: 50px 0;
	font-size: 0.95rem;
	line-height: 1.6;
}

.btn-add {
	display: inline-block;
	margin-top: 15px;
	padding: 12px 25px;
	background: #a29bfe;
	color: white;
	text-decoration: none;
	border-radius: 15px;
	font-weight: bold;
	font-size: 0.9rem;
	transition: 0.2s;
}

.btn-add:hover {
	background: #6c5ce7;
}
</style>
</head>
<body>

	<nav class="sidebar">
		<div class="logo">🏠 머무름</div>
		<a href="/user/mypage/main" class="menu-link active">내 대시보드</a> 
		<a href="/user/mypage/myView" class="menu-link">내 정보 상세</a>
		<a href="/user/schedule/schedule" class="menu-link">여정 관리</a>
		<a href="/user/board/list" class="menu-link">커뮤니티</a>
		<a href="/user/mypage/notice" class="menu-link">공지사항</a>
		<a href="/user/mypage/faq" class="menu-link">FAQ</a>	
		
		<div style="margin-top: auto;">
			<a href="/logout" class="menu-link" style="color: #ff7675;">로그아웃</a>
		</div>
	</nav>

	<main class="main-container">
		<a href="/Home" class="home-card-btn"> 🏠 기록이 머무는 공간, 머무름
			<div
				style="font-size: 0.9rem; font-weight: normal; margin-top: 8px; opacity: 0.9;">오늘
				당신의 여정은 어떤가요? 홈으로 이동하기</div>
		</a>

		<div class="dashboard-grid">
			<div class="section-card">
				<div class="section-title">
					<span>🗓️</span> 다가올 나의 여정
				</div>

				<div class="item-list">
					<jsp:include page="/user/mypage/mySchedule" />
				</div>

				<div style="text-align: center; margin-top: 15px;">
					<a href="/user/schedule/scheduleForm" class="btn-add">새 여정 추가하기
						+</a>
				</div>
			</div>
<div class="section-card">
    <div class="section-title">
        <span>📸</span> 최근 나의 기록
    </div>
    
    <div class="item-list">
        <c:choose>
            <c:when test="${not empty myRecentPosts}">
                <c:forEach var="post" items="${myRecentPosts}">
                    <a href="/user/board/detail/${post.b_code}" class="journey-item">
                        <div class="journey-content">
                            <span class="s-name">${post.b_title}</span>
                            <span class="p-name">
                                <c:choose>
                                    <c:when test="${post.b_category == 'free'}">자유게시판</c:when>
                                    <c:otherwise>기록게시판</c:otherwise>
                                </c:choose>
                                | 조회 ${post.b_view}
                            </span>
                        </div>
                        <div class="arrow-icon">〉</div>
                    </a>
                </c:forEach>
            </c:when>
            <c:otherwise>
                <div class="empty-msg" style="padding: 20px 0;">
                    다녀온 여행의 기록을<br>커뮤니티에 공유해보세요! <br> 
                    <a href="/user/board/list" class="btn-add" style="background: #f1f3ff; color: #a29bfe;">글쓰기</a>
                </div>
            </c:otherwise>
        </c:choose>
    </div>
</div>
		</div>
	</main>
</body>
</html>