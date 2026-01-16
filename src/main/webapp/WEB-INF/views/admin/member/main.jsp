<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ taglib prefix="c" uri="jakarta.tags.core" %>
<!DOCTYPE html>
<html>
<head>
<meta charset="UTF-8">
<title>머무름 - 관리자 센터</title>
<style>
    body { background-color: #f8f9ff; margin: 0; font-family: 'Malgun Gothic', sans-serif; color: #333; }
    .admin-wrapper { padding: 40px; max-width: 1200px; margin: 0 auto; }

    .admin-header { display: flex; justify-content: space-between; align-items: flex-end; margin-bottom: 40px; }
    .welcome-text h1 { margin: 0; font-size: 28px; color: #2d3436; }
    .welcome-text p { margin: 5px 0 0; color: #a29bfe; font-weight: bold; }

    .stat-grid { display: grid; grid-template-columns: repeat(4, 1fr); gap: 20px; margin-bottom: 40px; }
    .stat-item { 
        background: white; padding: 25px; border-radius: 30px; 
        box-shadow: 0 10px 20px rgba(162,155,254,0.05); border: 1px solid #f1f3ff;
        transition: 0.3s;
    }
    .stat-item:hover { transform: translateY(-5px); box-shadow: 0 15px 30px rgba(162,155,254,0.1); }
    .stat-label { font-size: 14px; color: #888; margin-bottom: 10px; display: block; }
    .stat-value { font-size: 24px; font-weight: bold; color: #333; }
    .stat-value span { font-size: 14px; color: #a29bfe; margin-left: 5px; }

    /* 메뉴 카드 그리드를 3열로 변경하여 가독성 높임 */
    .menu-grid { display: grid; grid-template-columns: repeat(3, 1fr); gap: 25px; }
    .menu-card { 
        background: white; border-radius: 35px; padding: 35px 30px; 
        text-decoration: none; border: 1px solid #f1f3ff;
        transition: 0.3s; position: relative; overflow: hidden;
        display: flex; flex-direction: column; justify-content: space-between;
    }
    .menu-card::after { 
        content: '→'; position: absolute; right: 25px; bottom: 25px; 
        font-size: 24px; color: #f1f3ff; transition: 0.3s; 
    }
    .menu-card:hover { border-color: #a29bfe; transform: translateY(-5px); }
    .menu-card:hover::after { color: #a29bfe; transform: translateX(5px); }
    
    .menu-icon { font-size: 36px; margin-bottom: 15px; display: block; }
    .menu-info h3 { margin: 0; font-size: 20px; color: #333; }
    .menu-info p { margin: 10px 0 0; color: #888; line-height: 1.5; font-size: 14px; }

    .home-btn {
        background: white; padding: 12px 25px; border-radius: 20px;
        color: #a29bfe; font-weight: bold; text-decoration: none;
        box-shadow: 0 5px 15px rgba(162,155,254,0.1); border: 1px solid #f1f3ff;
    }
</style>
</head>
<body>
   <div class="admin-wrapper">
    <header class="admin-header">
        <div class="welcome-text">
            <h1>관리자 센터 🛠️</h1>
            <p>기록이 머무는 공간, 서비스를 관리합니다.</p>
        </div>
        <a href="/user/mypage/main" class="home-btn">🏠 유저 모드로 돌아가기</a>
    </header>
<div class="stat-grid">
    <div class="stat-item">
        <span class="stat-label">전체 회원</span>
        <div class="stat-value">${memberCount}<span>명</span></div>
    </div>
    <div class="stat-item">
        <span class="stat-label">오늘 신규가입</span>
        <div class="stat-value" style="color: #a29bfe;">${newCount}<span>명</span></div>
    </div>
    <div class="stat-item">
        <span class="stat-label">새로운 게시물</span>
        <div class="stat-value">${newBoardCount}<span>건</span></div>
    </div>
    <div class="stat-item">
        <span class="stat-label">미처리 신고</span>
        <div class="stat-value" style="color: #ff7675;">${reportCount}<span>건</span></div>
    </div>
</div>

    <div class="menu-grid">
        <a href="/admin/member/memberList" class="menu-card">
            <div>
                <span class="menu-icon">👥</span>
                <div class="menu-info">
                    <h3>회원 관리</h3>
                    <p>전체 회원 목록 조회 및<br>정보 수정, 권한 설정</p>
                </div>
            </div>
        </a>

        <a href="/admin/faq/faqManage" class="menu-card">
            <div>
                <span class="menu-icon">❓</span>
                <div class="menu-info">
                    <h3>FAQ 관리</h3>
                    <p>자주 묻는 질문 등록 및<br>카테고리별 답변 관리</p>
                </div>
            </div>
        </a>

        <a href="/admin/notice/noticeManage" class="menu-card">
            <div>
                <span class="menu-icon">📢</span>
                <div class="menu-info">
                    <h3>공지사항 관리</h3>
                    <p>중요 안내 사항 작성 및<br>전체 공지 게시글 관리</p>
                </div>
            </div>
        </a>

        <a href="/user/board/list" class="menu-card">
            <div>
                <span class="menu-icon">📝</span>
                <div class="menu-info">
                    <h3>커뮤니티 관리</h3>
                    <p>여행기 및 커뮤니티 글 모니터링<br>부적절한 게시글 관리</p>
                </div>
            </div>
        </a>

        <a href="/admin/board/listReports" class="menu-card" style="background: #fffcfc;">
            <div>
                <span class="menu-icon">🚨</span>
                <div class="menu-info">
                    <h3>신고 접수</h3>
                    <p>회원들이 접수한 불편 사항 및<br>부적절 유저 신고 확인</p>
                </div>
            </div>
        </a>
    </div>

    <div style="margin-top: 60px; padding-top: 30px; border-top: 1px dashed #e1e5ff; display: flex; justify-content: flex-end;">
        <a href="/user/mypage/confirmPwForm?mode=delete" style="
            font-size: 13px; color: #bbb; text-decoration: none; 
            display: flex; align-items: center; gap: 5px; transition: 0.3s;
        " onmouseover="this.style.color='#ff7675';" onmouseout="this.style.color='#bbb';">
            <span>⚠️</span> 관리자 권한 반납 및 계정 탈퇴
        </a>
    </div>
</div>
</body>
</html>