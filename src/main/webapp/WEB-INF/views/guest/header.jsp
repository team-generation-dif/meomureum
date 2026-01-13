<%@ page language="java" contentType="text/html; charset=UTF-8"
    pageEncoding="UTF-8"%>
    <%@ taglib prefix="c" uri="jakarta.tags.core" %>
<!DOCTYPE html>
<html>
<head>
<meta charset="UTF-8">
<title>Insert title here</title>
<style>
    .header { display: flex; justify-content: flex-end; align-items: center; padding: 20px; background: #f8f9fa; gap: 15px; }
    .welcome-msg { font-weight: bold; color: #2c3e50; margin-right: 10px; }
    .btn { text-decoration: none; color: #555; font-size: 14px; }
    .btn:hover { color: #3498db; }

    /* 드롭다운 전체 컨테이너 */
    .dropdown { 
        position: relative; 
        display: inline-block;
        padding-bottom: 5px; /* 버튼과 목록 사이의 보이지 않는 다리 역할 */
    }
    
    .dropbtn { background: #e9ecef; border: 1px solid #ddd; padding: 5px 10px; border-radius: 4px; cursor: pointer; font-size: 12px; }

    /* 메뉴 목록 */
    .dropdown-content { 
        display: none; 
        position: absolute; 
        right: 0; 
        top: 100%; /* 버튼 바로 아래 위치 */
        background-color: white; 
        min-width: 160px; 
        box-shadow: 0px 8px 16px rgba(0,0,0,0.1); 
        z-index: 100; 
        border: 1px solid #eee;
        border-radius: 4px;
    }	

    .dropdown-content a { 
        color: #333; 
        padding: 12px 16px; 
        text-decoration: none; 
        display: block; 
        font-size: 14px;
        border-bottom: 1px solid #f1f1f1;
    }

    .dropdown-content a:last-child { border-bottom: none; }
    .dropdown-content a:hover { background-color: #f1f1f1; color: #3498db; }
    
    /* hover 상태 유지 */
    .dropdown:hover .dropdown-content { display: block; }
</style>
</head>
<body>
    <header class="header">
		<div>
			<a href="/Home" type="button" class="btn">Home</a>
		</div>
		<!-- 로그인 된 상태 -->
		<c:choose>
		    <c:when test="${not empty pageContext.request.userPrincipal}">
		        <c:choose>
		        	<%-- 관리자 아이디 로그인 --%>
		            <c:when test="${pageContext.request.userPrincipal.name == 'admin'}"> 
						<a href="/logout" type="button" class="btn">로그아웃</a>
		            </c:when>
		            <%-- 일반 아이디 로그인 --%>
		            <c:otherwise>
		                <span class="welcome-msg">
		                    ✨ ${pageContext.request.userPrincipal.name}님 환영합니다!
		                </span>
		                <a href="/logout" class="btn">로그아웃</a>
		            </c:otherwise>
       			</c:choose>
       			<%-- 드롭다운 메뉴 생성 --%>
					<div class="dropdown">
                    <button class="dropbtn">메뉴 ▼</button>
                    <div class="dropdown-content">
                        <%-- 관리자 전용 목록 --%>
                        <c:if test="${pageContext.request.userPrincipal.name == 'admin'}">
                            <a href="/admin/member/memberList" style="background:#fff9db;">📂 회원 관리</a>
                            <a href="">📂 게시판 관리</a>
                            <hr style="margin:0; border:0; border-top:1px solid #eee;">
                            <a href="/admin/faq/faqManage">📂 FAQ관리</a>
                            <hr style="margin:0; border:0; border-top:1px solid #eee;">
                            <a href="/user/mypage/confirmPwForm?mode=delete" style="color:red; font-weight:bold;">⚠️ 관리자 탈퇴</a>
                        </c:if>
                        
                        <%-- 유저 공통 목록 --%>
                        <c:if test="${pageContext.request.userPrincipal.name != 'admin'}">
	                        <a href="/user/mypage/myView">내 정보 보기</a>
	                        <a href="/user/board/list">회원게시판</a>
	                        <a href="/user/mypage/mySchedule">내 여정</a>
	                        <a href="/user/mypage/faq">고객센터FAQ</a>
                        </c:if>
                        <%-- 1. 보이지 않는 탈퇴용 폼을 하나 만듭니다 --%>
						<form id="deleteForm" action="/user/delete" method="post" style="display:none;">
						    <%-- 현재 로그인한 유저의 코드를 넘겨줘야 한다면 추가 (생략 가능 시 삭제) --%>
						    <input type="hidden" name="m_code" value="${pageContext.request.userPrincipal.name}">
						</form>
                    </div>
       			</div>
			</c:when>
		</c:choose>
	</header>
</body>
</html>