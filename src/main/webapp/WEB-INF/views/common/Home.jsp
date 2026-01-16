<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ taglib prefix="c" uri="jakarta.tags.core" %>
<%@ taglib prefix="fn" uri="jakarta.tags.functions" %>
<!DOCTYPE html>
<html>
<head>
    <meta charset="UTF-8">
    <title>머무름 - 소개</title>
    <style>
        /* ... 기존 CSS 스타일과 동일 (생략하지 않고 그대로 유지하세요) ... */
        body { background-color: #f8f9ff; margin: 0; padding: 0; font-family: 'Pretendard', sans-serif; color: #333; }
        .intro-container { max-width: 1100px; margin: 60px auto; padding: 0 20px; }
        .hero { background: white; padding: 80px 40px; border-radius: 40px; box-shadow: 0 20px 40px rgba(162,155,254,0.05); text-align: center; margin-bottom: 50px; border: 1px solid #f1f3ff; }
        .hero h1 { color: #a29bfe; font-size: 2.8rem; margin-bottom: 15px; }
        .hero p { color: #777; font-size: 1.2rem; line-height: 1.8; word-break: keep-all; }
        .line { width: 60px; height: 5px; background: #ffdae0; border-radius: 10px; margin: 25px auto; }
        .main-action-area { margin-top: 40px; }
        .btn-main { display: inline-block; padding: 18px 50px; background: linear-gradient(135deg, #a29bfe, #6c5ce7); color: white; text-decoration: none; border-radius: 35px; font-weight: bold; font-size: 1.2rem; box-shadow: 0 10px 20px rgba(108, 92, 231, 0.2); transition: 0.3s; }
        .btn-main:hover { transform: translateY(-5px); box-shadow: 0 15px 30px rgba(108, 92, 231, 0.3); filter: brightness(1.1); }
        .section-title { display: flex; justify-content: space-between; align-items: flex-end; margin-bottom: 25px; padding: 0 10px; }
        .section-title h2 { font-size: 24px; margin: 0; color: #2d3436; }
        .section-title h2 span { color: #a29bfe; margin-right: 8px; }
        .btn-more { font-size: 14px; color: #b2bec3; text-decoration: none; transition: 0.3s; }
        .btn-more:hover { color: #a29bfe; }
        .spot-grid { display: grid; grid-template-columns: repeat(3, 1fr); gap: 25px; margin-bottom: 60px; }
        .spot-card { background: white; border-radius: 25px; overflow: hidden; box-shadow: 0 10px 20px rgba(0,0,0,0.02); border: 1px solid #f1f3ff; transition: 0.3s; cursor: pointer; }
        .spot-card:hover { transform: translateY(-10px); box-shadow: 0 15px 30px rgba(162,155,254,0.1); }
        .spot-img { width: 100%; height: 200px; background: #f1f3ff; background-size: cover; background-position: center; }
        .spot-info { padding: 25px; }
        .spot-tag { font-size: 12px; color: #a29bfe; font-weight: bold; background: #f8f9ff; padding: 5px 12px; border-radius: 12px; }
        .spot-info h3 { margin: 12px 0 8px; font-size: 20px; color: #2d3436; }
        .spot-info p { margin: 0; font-size: 14px; color: #999; line-height: 1.5; }
        .best-list { background: white; border-radius: 30px; padding: 15px; border: 1px solid #f1f3ff; box-shadow: 0 10px 20px rgba(0,0,0,0.02); }
        .best-item { display: flex; align-items: center; padding: 20px; border-bottom: 1px solid #f8f9ff; transition: 0.2s; text-decoration: none; }
        .best-item:last-child { border-bottom: none; }
        .best-item:hover { background: #fafaff; border-radius: 20px; }
        .rank { width: 40px; font-weight: bold; color: #a29bfe; font-size: 20px; }
        .post-title { flex-grow: 1; color: #444; font-weight: 500; font-size: 16px; }
        .post-meta { font-size: 13px; color: #ccc; }
        .badge-hot { background: #ff7675; color: white; font-size: 11px; padding: 3px 8px; border-radius: 6px; margin-left: 10px; }
    </style>
</head>
<body>
    <jsp:include page="../guest/header.jsp" />

    <div class="intro-container">
        <div class="hero">
            <h1>🏠 머무름, 당신의 여정을 담다</h1>
            <div class="line"></div>
            <p>
                소중한 사람들과의 추억, 나만의 비밀스러운 여행지.<br>
                <strong>머무름</strong>에서 당신의 모든 순간을 기록하고 공유해 보세요.
            </p>

            <div class="main-action-area">
                <c:choose>
                    <c:when test="${empty pageContext.request.userPrincipal}">
                        <a href="/login" class="btn-main">지금 시작하기</a>
                    </c:when>
                    <c:when test="${pageContext.request.userPrincipal.name == 'admin'}">
                        <a href="/admin/member/main" class="btn-main">관리자 페이지 이동</a>
                    </c:when>
                    <c:otherwise>
                        <a href="/user/mypage/main" class="btn-main">나의 대시보드 이동</a>
                    </c:otherwise>
                </c:choose>
            </div>
        </div>

        <div class="section-title">
            <h2><span>📍</span>지금 떠나기 좋은 추천 장소</h2>
            <a href="/user/spot/list" class="btn-more">전체보기 ></a>
        </div>
        <div class="spot-grid">
            <%-- 추천 장소 (현재 고정값, 나중에 DB 연동 시 동일하게 c:forEach 사용 가능) --%>
            <c:choose>
			    <c:when test="${not empty recommends}">
			        <c:forEach var="place" items="${recommends}">
			            <div class="spot-card" onclick="location.href='/user/schedule/scheduleForm?p_place=${fn:split(place.p_addr, ' ')[0]} ${place.p_place}'" style="cursor: pointer;">
			                
			                <div class="spot-img-wrap">
	                            <img src="${place.file_path}" class="spot-img" alt="${place.p_place}">
			                </div>
			                
			                <div class="spot-info">
			                    <h4>${place.p_place}</h4>
			                    <p>📍 ${place.p_addr}</p>
			                    <div class="spot-tag">#사람들이_많이_찾는 #추천코스</div>
			                </div>
			            </div>
			        </c:forEach>
			    </c:when>
			    <c:otherwise>
			        <div class="spot-card">
			             <div class="spot-info"><h4>데이터 준비중</h4></div>
			        </div>
			    </c:otherwise>
			</c:choose>
        </div>

        <div class="section-title">
            <h2><span>🔥</span>이번 주 인기 게시글</h2>
            <a href="/user/board/list" class="btn-more">커뮤니티 이동 ></a>
        </div>

        <%-- [실시간 게시글 데이터 연동 영역] --%>
        <div class="best-list">
            <c:choose>
                <c:when test="${not empty bestPosts}">
                    <c:forEach var="post" items="${bestPosts}" varStatus="status">
                        <a href="/user/board/view?b_code=${post.b_code}" class="best-item">
                            <span class="rank">${status.count}</span>
                            <span class="post-title">
                                ${post.b_title} 
                                <c:if test="${post.b_view >= 50}"> <%-- 조회수가 50 이상이면 HOT 배지 --%>
                                    <span class="badge-hot">HOT</span>
                                </c:if>
                            </span>
                            <span class="post-meta">
                                조회수 ${post.b_view} · ${fn:substring(post.created_at, 0, 10)}
                            </span>
                        </a>
                    </c:forEach>
                </c:when>
                <c:otherwise>
                    <div style="text-align:center; padding: 40px; color:#ccc;">
                        등록된 인기 게시글이 없습니다.
                    </div>
                </c:otherwise>
            </c:choose>
        </div>
    </div>
</body>
</html>