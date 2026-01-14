<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ taglib prefix="c" uri="jakarta.tags.core" %>
<!DOCTYPE html>
<html>
<head>
<meta charset="UTF-8">
<style>
    /* 헤더 전체 컨테이너 */
    .header { 
        display: flex; 
        /* 모든 요소를 오른쪽 끝으로 정렬 */
        justify-content: flex-end; 
        align-items: center; 
        padding: 15px 30px; 
        background: #ffffff; 
        box-shadow: 0 2px 10px rgba(0,0,0,0.05);
        font-family: 'Pretendard', sans-serif;
        /* 요소들 사이의 일정한 간격 */
        gap: 15px; 
    }

    .welcome-msg { font-weight: 600; color: #2d3436; margin-right: 5px; }
    
    .btn { 
        text-decoration: none; 
        color: #636e72; 
        font-size: 14px; 
        padding: 8px 12px;
        border-radius: 8px;
        transition: 0.2s;
    }
    .btn:hover { background: #f1f3ff; color: #a29bfe; }

    /* 드롭다운 스타일 */
    .dropdown { position: relative; display: inline-block; }
    .dropbtn { 
        background: #a29bfe; 
        color: white;
        border: none; 
        padding: 8px 16px; 
        border-radius: 20px; 
        cursor: pointer; 
        font-size: 14px; 
        font-weight: bold;
    }

    .dropdown-content { 
        display: none; 
        position: absolute; 
        right: 0; 
        top: 40px; 
        background-color: white; 
        min-width: 180px; 
        box-shadow: 0px 10px 25px rgba(0,0,0,0.1); 
        z-index: 1000; 
        border-radius: 12px;
        overflow: hidden;
        border: 1px solid #f1f3ff;
    }	
    
    .dropdown-content a { 
        color: #2d3436; 
        padding: 12px 20px; 
        text-decoration: none; 
        display: block; 
        font-size: 14px; 
    }
    .dropdown-content a:hover { background-color: #f8f9ff; color: #a29bfe; }
    .dropdown:hover .dropdown-content { display: block; }
</style>
</head>
<body>
    <header class="header">
        <%-- [2] 로그인 정보 및 드롭다운 메뉴 영역 --%>
        <c:if test="${not empty pageContext.request.userPrincipal}">
            <c:choose>
                <c:when test="${pageContext.request.userPrincipal.name == 'admin'}">
                    <span class="welcome-msg">🛡️ 관리자 모드</span>
                </c:when>
                <c:otherwise>
                    <span class="welcome-msg">✨ ${pageContext.request.userPrincipal.name}님</span>
                </c:otherwise>
            </c:choose>
            
            <a href="/logout" class="btn" style="color:#ff7675;">로그아웃</a>

            <%-- 드롭다운 메뉴 --%>
            <div class="dropdown">
                <button class="dropbtn">전체메뉴 ▼</button>
                <div class="dropdown-content">
                    <c:choose>
                        <%-- 관리자용 메뉴 --%>
                        <c:when test="${pageContext.request.userPrincipal.name == 'admin'}">
                            <a href="/admin/member/memberList">👤 회원 관리</a>
                            <a href="/user/board/list">📝 커뮤니티 관리</a>
                            <a href="/admin/notice/noticeManage">📢 공지사항 관리</a>
                            <a href="/admin/faq/faqManage">❓ FAQ 관리</a>
                            <a href="/admin/board/listReports">🚨 신고 접수 관리</a>
                            <a href="#" style="color:red;">⚠️ 관리자 탈퇴</a>
                        </c:when>
                        <%-- 일반 유저용 메뉴 --%>
                        <c:otherwise>
                            <a href="/user/mypage/myView">👤 내 정보 보기</a>
                            <a href="/user/board/list">📝 커뮤니티 보기</a>
                            <a href="/user/mypage/main">🗓️ 내 여정 보기</a>
                            <a href="/user/mypage/notice">❗ 공지사항 보기</a>
                            <a href="/user/mypage/faq">❓ 고객센터 FAQ</a>
                        </c:otherwise>
                    </c:choose>
                </div>
            </div>
        </c:if>
    </header>
</body>
</html>