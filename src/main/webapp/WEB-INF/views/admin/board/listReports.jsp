<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ taglib prefix="c" uri="jakarta.tags.core" %>
<%@ taglib prefix="fmt" uri="jakarta.tags.fmt" %>
<!DOCTYPE html>
<html>
<head>
<meta charset="UTF-8">
<title>머무름 - 신고 관리 대시보드</title>
<link href="https://stackpath.bootstrapcdn.com/bootstrap/3.4.1/css/bootstrap.min.css" rel="stylesheet">
<link href="https://fonts.googleapis.com/css2?family=Noto+Sans+KR:wght@300;400;500;700&display=swap" rel="stylesheet">

<style>
    /* 여행 계획 페이지와 통일된 컬러 테마 */
    :root {
        --primary-color: #a29bfe;
        --primary-hover: #6c5ce7;
        --bg-color: #f8f9ff;
        --text-color: #2d3436;
        --border-color: #f1f3ff;
        --shadow-soft: 0 10px 30px rgba(162, 155, 254, 0.05);
    }

    body {
        font-family: 'Noto Sans KR', sans-serif;
        background-color: var(--bg-color);
        color: var(--text-color);
        padding-top: 30px;
        padding-bottom: 60px; /* 버튼 아래 여유 공간 */
    }

    .container {
        background: #fff;
        padding: 40px;
        border-radius: 20px;
        box-shadow: var(--shadow-soft);
        border: 1px solid var(--border-color);
        margin-bottom: 25px; /* 컨테이너와 하단 버튼 사이 간격 */
    }

    /* 상단 헤더 */
    .admin-header {
        display: flex;
        justify-content: space-between;
        align-items: center;
        border-bottom: 2px solid var(--border-color);
        padding-bottom: 20px;
        margin-bottom: 30px;
    }

    h3 {
        font-weight: 700;
        color: var(--text-color);
        margin-top: 40px;
        margin-bottom: 20px;
        padding-left: 12px;
        border-left: 5px solid var(--primary-color);
    }

    /* 검색창 스타일링 */
    .form-control {
        border-radius: 10px;
        border: 1px solid #dfe6e9;
    }

    .btn-search {
        background: var(--primary-color);
        color: white;
        border: none;
        border-radius: 10px;
        padding: 7px 20px;
        font-weight: 600;
    }

    /* 테이블 스타일링 */
    .table {
        border-radius: 15px;
        overflow: hidden;
        border: 1px solid var(--border-color);
    }

    .table thead th {
        background-color: #fcfcff;
        color: var(--text-color);
        text-align: center;
        border-bottom: 2px solid var(--border-color) !important;
        padding: 15px !important;
    }

    .table tbody td {
        text-align: center;
        vertical-align: middle;
        font-size: 13px;
        padding: 12px 8px;
        border-top: 1px solid var(--border-color);
    }

    .content-cell {
        max-width: 200px;
        white-space: nowrap;
        overflow: hidden;
        text-overflow: ellipsis;
    }

    /* 하단 버튼 영역 - 컨테이너 바로 밑 중앙 */
    .bottom-btn-container {
        display: flex;
        justify-content: center;
        width: 100%;
    }

    .btn-home-normal {
        background-color: var(--primary-color);
        color: white;
        padding: 15px 40px;
        border-radius: 30px;
        font-weight: bold;
        text-decoration: none;
        box-shadow: 0 10px 20px rgba(162, 155, 254, 0.15);
        transition: background-color 0.2s; /* 과한 애니메이션 제거 */
        display: inline-flex;
        align-items: center;
        gap: 8px;
        border: none;
        font-size: 14px;
    }

    .btn-home-normal:hover {
        background-color: var(--primary-hover);
        color: white;
        text-decoration: none;
    }

    /* 라벨 색상 */
    .label-warning { background-color: #ffeaa7; color: #d63031; }
    .label-info { background-color: #dff9fb; color: #0984e3; }
    .label-success { background-color: #55efc4; color: #00b894; }
    .label-default { background-color: #f1f2f6; color: #747d8c; }
</style>
</head>
<body>

<div class="container">
    <div class="admin-header">
        <h2 style="margin:0; font-weight:700; color:var(--text-color);">REPORT MANAGEMENT</h2>
        <form method="get" action="/admin/board/listreports" class="form-inline">
            <div class="form-group">
                <input type="text" name="keyword" value="${keyword}" class="form-control" placeholder="검색어 입력">
            </div>
            <button type="submit" class="btn btn-search">조회</button>
        </form>
    </div>

    <h3 style="border-left-color: #ff7675;">대기중 신고</h3>
    <table class="table table-hover">
        <thead>
            <tr>
                <th>코드</th><th>카테고리</th><th>제목</th><th>내용</th>
                <th>신고자</th><th>대상</th><th>신고일</th><th>처리</th>
            </tr>
        </thead>
        <tbody>
            <c:forEach var="rep" items="${pendingReports}">
                <tr>
                    <td><strong>${rep.rep_code}</strong></td>
                    <td><span class="label label-warning">${rep.rep_category}</span></td>
                    <td>${rep.rep_title}</td>
                    <td class="content-cell" title="${rep.rep_content}">${rep.rep_content}</td>
                    <td>${rep.m_code}</td>
                    <td><code style="color:var(--primary-hover)">${rep.target_code}</code></td>
                    <td><fmt:formatDate value="${rep.created_at}" pattern="yyyy-MM-dd"/></td>
                    <td>
                        <form method="post" action="/admin/board/listreports/process" style="display:inline;">
                            <input type="hidden" name="rep_code" value="${rep.rep_code}">
                            <input type="hidden" name="action" value="DELETE">
                            <button type="submit" class="btn btn-danger btn-sm" onclick="return confirm('신고를 수용하시겠습니까?')">수용</button>
                        </form>
                        <form method="post" action="/admin/board/listreports/process" style="display:inline;">
                            <input type="hidden" name="rep_code" value="${rep.rep_code}">
                            <input type="hidden" name="action" value="IGNORE">
                            <button type="submit" class="btn btn-secondary btn-sm">기각</button>
                        </form>
                    </td>
                </tr>
            </c:forEach>
        </tbody>
    </table>

    <h3 style="border-left-color: var(--primary-color);">완료된 신고</h3>
    <table class="table table-hover">
        <thead>
            <tr><th>코드</th><th>카테고리</th><th>제목</th><th>신고자</th><th>상태</th></tr>
        </thead>
        <tbody>
            <c:forEach var="rep" items="${doneReports}">
                <tr>
                    <td>${rep.rep_code}</td>
                    <td><span class="label label-info">${rep.rep_category}</span></td>
                    <td>${rep.rep_title}</td>
                    <td>${rep.m_code}</td>
                    <td><span class="label label-success">수용완료</span></td>
                </tr>
            </c:forEach>
        </tbody>
    </table>

    <h3 style="border-left-color: #b2bec3;">기각된 신고</h3>
    <table class="table table-hover">
        <thead>
            <tr><th>코드</th><th>카테고리</th><th>제목</th><th>신고자</th><th>상태</th></tr>
        </thead>
        <tbody>
            <c:forEach var="rep" items="${ignoredReports}">
                <tr>
                    <td>${rep.rep_code}</td>
                    <td><span class="label label-default">${rep.rep_category}</span></td>
                    <td>${rep.rep_title}</td>
                    <td>${rep.m_code}</td>
                    <td><span class="label label-default">기각됨</span></td>
                </tr>
            </c:forEach>
        </tbody>
    </table>

    <div class="pagination-wrapper" style="text-align: center; margin-top: 30px;">
        <c:forEach begin="1" end="${totalPages}" var="i">
            <a href="/admin/board/listreports?page=${i}&size=${pageSize}&keyword=${keyword}" 
               style="display: inline-block; padding: 8px 16px; border: 1px solid var(--border-color); border-radius: 8px; text-decoration: none; color: var(--primary-color); margin: 0 3px; background: white; ${i == currentPage ? 'background-color: var(--primary-color); color: white; border-color: var(--primary-color);' : ''}">${i}</a>
        </c:forEach>
    </div>
</div>

<div class="bottom-btn-container">
    <a href="/admin/member/main" class="btn-home-normal">
        <span class="glyphicon glyphicon-home"></span> 메인으로 돌아가기
    </a>
</div>

</body>
</html>