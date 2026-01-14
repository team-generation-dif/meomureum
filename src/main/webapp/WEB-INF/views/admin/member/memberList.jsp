<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<!DOCTYPE html>
<html>
<head>
<meta charset="UTF-8">
<title>머무름 - 회원관리</title>
<style>
    /* [1] 기본 레이아웃 */
    body { background-color: #f8f9ff; margin: 0; font-family: 'Malgun Gothic', sans-serif; color: #333; }
    .admin-main { padding: 40px; max-width: 1300px; margin: 0 auto; position: relative; }

    /* [2] 상단 제목과 우측 상단 메인 버튼 */
    .page-header { display: flex; justify-content: space-between; align-items: flex-start; margin-bottom: 20px; }
    .table-title { font-size: 28px; font-weight: bold; color: #2d3436; margin: 0; }
    
    .btn-home-back {
        display: flex; align-items: center; gap: 8px;
        padding: 10px 18px; background: white;
        border: 1px solid #e1e5ff; border-radius: 12px;
        text-decoration: none; font-weight: bold; color: #666;
        box-shadow: 0 4px 10px rgba(162,155,254,0.1);
        transition: 0.3s;
    }
    .btn-home-back:hover { background: #f1f3ff; color: #a29bfe; border-color: #a29bfe; transform: translateY(-2px); }

    /* [3] 요약 통계 카드 */
    .stats-container { display: grid; grid-template-columns: repeat(3, 1fr); gap: 20px; margin-bottom: 30px; }
    .stat-card { 
        background: white; padding: 25px; border-radius: 25px; 
        box-shadow: 0 10px 20px rgba(162,155,254,0.05);
        display: flex; align-items: center; gap: 20px; border: 1px solid #f1f3ff;
    }
    .stat-icon { font-size: 30px; background: #f1f3ff; width: 60px; height: 60px; display: flex; align-items: center; justify-content: center; border-radius: 20px; color: #a29bfe; }
    .stat-info b { font-size: 22px; color: #333; }
    .stat-info p { margin: 5px 0 0; color: #888; font-size: 14px; }

    /* [4] 중간 검색 영역 (통계와 리스트 사이) */
    .middle-search-bar { 
        display: flex; justify-content: flex-end; margin-bottom: 20px; padding: 0 10px;
    }
    .search-box { 
        display: flex; gap: 10px; background: white; padding: 10px 15px; 
        border-radius: 20px; border: 1px solid #e1e5ff; width: fit-content;
        box-shadow: 0 5px 15px rgba(0,0,0,0.02);
    }
    .search-input { border: none; background: transparent; padding: 5px; width: 250px; outline: none; font-size: 14px; }
    .btn-search { background: #a29bfe; color: white; border: none; padding: 8px 20px; border-radius: 15px; font-weight: bold; cursor: pointer; transition: 0.3s; }
    .btn-search:hover { background: #6c5ce7; }

    /* [5] 리스트 카드 및 테이블 */
    .content-card { 
        background: white; border-radius: 30px; padding: 35px; 
        box-shadow: 0 15px 35px rgba(0,0,0,0.03); border: 1px solid #f1f3ff;
    }
    table { width: 100%; border-collapse: separate; border-spacing: 0; }
    th { padding: 15px; color: #a2a2a2; font-size: 13px; text-transform: uppercase; letter-spacing: 1px; border-bottom: 2px solid #f8f9ff; text-align: center; }
    td { padding: 18px 10px; border-bottom: 1px solid #f8f9ff; text-align: center; font-size: 14px; color: #444; }
    tr:hover td { background-color: #fafaff; color: #a29bfe; }
    
    /* 뱃지 및 박스 */
    .badge { padding: 6px 12px; border-radius: 12px; font-size: 11px; font-weight: bold; }
    .badge-admin { background: #ffeaa7; color: #fdcb6e; }
    .badge-user { background: #e1e5ff; color: #a29bfe; }
    .grade-box { border: 1px solid #eee; padding: 4px 10px; border-radius: 8px; font-size: 12px; background: #fdfdfd; }
    .link-name { text-decoration: none; color: #333; font-weight: bold; transition: 0.2s; }
    .link-name:hover { color: #a29bfe; }
</style>
</head>
<body>

    <div class="admin-main">
        
        <div class="page-header">
            <h1 class="table-title">회원관리</h1>
            <a href="/admin/member/main" class="btn-home-back">🏠 관리자 메인</a>
        </div>

        <div class="stats-container">
            <div class="stat-card">
                <div class="stat-icon">👥</div>
                <div class="stat-info">
                    <b>${members.size()}명</b>
                    <p>전체 회원수</p>
                </div>
            </div>
            <div class="stat-card">
                <div class="stat-icon">✨</div>
                <div class="stat-info">
                    <b>신규</b>
                    <p>오늘 가입 회원</p>
                </div>
            </div>
            <div class="stat-card">
                <div class="stat-icon">🛠️</div>
                <div class="stat-info">
                    <b>관리 중</b>
                    <p>회원 게시판 연동</p>
                </div>
            </div>
        </div>

        <div class="middle-search-bar">
            <form action="/admin/member/memberList" method="get" class="search-box">
                <input type="text" name="keyword" class="search-input" value="${keyword}" placeholder="이름 또는 아이디를 입력하세요...">
                <button type="submit" class="btn-search">검색</button>
            </form>
        </div>

        <div class="content-card">
            <div style="margin-bottom: 20px; font-weight: bold; color: #2d3436; font-size: 18px;">전체 회원 목록</div>
            <table>
                <thead>
                    <tr>
                        <th>NO</th>
                        <th>ID</th>
                        <th>NAME</th>
                        <th>NICKNAME</th>
                        <th>EMAIL</th>
                        <th>GRADE</th>
                        <th>AUTH</th>
                        <th>JOIN DATE</th>
                    </tr>
                </thead>
                <tbody>
                    <c:if test="${empty members}">
                        <tr><td colspan="8" style="padding: 100px; color: #ccc;">회원 데이터가 존재하지 않습니다.</td></tr>
                    </c:if>
                    <c:forEach var="dto" items="${members}">
                        <tr>
                            <td style="color: #bbb; font-size: 12px;">${dto.m_code}</td>
                            <td><b>${dto.m_id}</b></td>
                            <td><a href="/admin/member/memberview/${dto.m_code}" class="link-name">${dto.m_name}</a></td>
                            <td>${dto.m_nick}</td>
                            <td>${dto.m_email}</td>
                            <td><span class="grade-box">${dto.m_grade}</span></td>
                            <td>
                                <c:choose>
                                    <c:when test="${dto.m_auth == 'ADMIN'}">
                                        <span class="badge badge-admin">관리자</span>
                                    </c:when>
                                    <c:otherwise>
                                        <span class="badge badge-user">일반유저</span>
                                    </c:otherwise>
                                </c:choose>
                            </td>
                            <td style="font-size: 12px; color: #999;">${dto.created_at}</td>
                        </tr>
                    </c:forEach>
                </tbody>
            </table>
        </div>
    </div>
</body>
</html>