<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ taglib prefix="c" uri="jakarta.tags.core" %>
<%@ taglib prefix="fmt" uri="jakarta.tags.fmt" %>
<!DOCTYPE html>
<html>
<head>
<meta charset="UTF-8">
<title>머무름 - 신고 관리</title>
<style>
    body { background-color: #f8f9ff; margin: 0; font-family: 'Malgun Gothic', sans-serif; color: #333; }
    .admin-wrapper { padding: 40px; max-width: 1200px; margin: 0 auto; }
	
	/* 상단 헤더 */	
    .admin-header { display: flex; justify-content: space-between; align-items: flex-end; margin-bottom: 40px; }
    .welcome-text h1 { margin: 0; font-size: 26px; color: #2d3436; }
    .welcome-text p { margin: 5px 0 0; color: #a29bfe; font-weight: bold; }
	
	/* 홈 버튼 스타일 */
    .btn-home-back {
        display: inline-flex;
        align-items: center;
        gap: 8px;
        padding: 10px 18px;
        background: white;
        border: 1px solid #f1f3ff;
        border-radius: 15px;
        text-decoration: none;
        font-weight: bold;
        color: #666;
        font-size: 15px;
        box-shadow: 0 5px 15px rgba(162,155,254,0.1);
        transition: 0.3s;
    }
    .btn-home-back:hover {
        background: #a29bfe;
        color: white;
        box-shadow: 0 5px 15px rgba(162,155,254,0.3);
    }	
			
    /* 탭 스타일 */
    .nav-tabs { border-bottom: 2px solid #e1e5ff; margin-bottom: 20px; }
    .nav-tabs li { display: inline-block; margin-right: 10px; }
    .nav-tabs a {
        display: inline-block; padding: 10px 20px; border-radius: 20px 20px 0 0;
        background: #f1f3ff; color: #555; text-decoration: none; font-weight: bold;
        transition: 0.3s;
    }
    .nav-tabs .active a { background: #a29bfe; color: #fff; }

    /* 검색창 */
    .search-box { text-align: right; margin: 20px 0; }
    .search-box input[type="text"] {
        border: 1px solid #ddd; border-radius: 20px; padding: 6px 15px;
    }
    .search-box button {
        background: #a29bfe; color: #fff; border: none; border-radius: 20px;
        padding: 6px 15px; margin-left: 5px; cursor: pointer;
    }

    /* 테이블 */
    table { width: 100%; border-collapse: collapse; background: #fff; border-radius: 15px; overflow: hidden; }
    th, td { padding: 12px; text-align: center; border-bottom: 1px solid #eee; }
    th { background: #f1f3ff; color: #555; }
    tr:hover { background: #fafafa; }

    /* 버튼 */
    .btn { padding: 6px 12px; border-radius: 20px; font-size: 13px; text-decoration: none; }
    .btn-success { background-color: #81ecec; color: #333; border: none;} /* 파스텔 민트 */
    .btn-warning { background-color: #ffeaa7; color: #333; border: none;} /* 파스텔 옐로우 */   

    /* 페이징 */
    .pagination { margin-top: 20px; text-align: center; }
    .pagination a {
        display: inline-block; margin: 0 5px; padding: 6px 12px;
        border: 1px solid #ddd; border-radius: 20px; color: #007bff; text-decoration: none;
    }
    .pagination a.active { background: #a29bfe; color: #fff; border-color: #a29bfe; }
    .pagination a:hover { background: #e1e5ff; }
</style>
</head>
<body>
<div class="admin-wrapper">
    <header class="admin-header">
        <div class="welcome-text">
            <h1>🚨 신고 관리</h1>
            <p>회원들이 접수한 신고를 확인하고 처리합니다.</p>
        </div>
         <!-- ✅ 통일된 홈 버튼 -->
        <a href="/admin/member/main" class="btn-home-back">
            <span style="font-size: 18px;">🏠</span> 관리자 메인
        </a>
    </header>

<!-- 상태별 탭 -->
<ul class="nav-tabs">
  <li class="${status == 'PENDING' ? 'active' : ''}">
    <a href="/admin/board/listreports?status=PENDING">대기중 신고</a>
  </li>
  <li class="${status == 'DONE' ? 'active' : ''}">
    <a href="/admin/board/listreports?status=DONE">완료된 신고</a>
  </li>
  <li class="${status == 'IGNORE' ? 'active' : ''}">
    <a href="/admin/board/listreports?status=IGNORE">보류된 신고</a>
  </li>
</ul>

<!-- 검색창 -->
<div class="search-box">
    <form method="get" action="/admin/board/listreports">
        <input type="hidden" name="status" value="${status}">
        <input type="text" name="keyword" value="${keyword}" placeholder="검색어 입력">
        <button type="submit">검색</button>
    </form>
</div>

<!-- 디바운스 방식 자동 검색 -->
<script>
document.addEventListener("DOMContentLoaded", function() {
    const searchInput = document.getElementById("keywordInput");
    let timer;

    searchInput.addEventListener("input", function() {
        clearTimeout(timer);
        timer = setTimeout(() => {
            const keyword = this.value;
            const status = document.querySelector("input[name='status']").value;
            const url = "/admin/board/listreports?status=" + encodeURIComponent(status)
                        + "&page=1&size=${pageSize}&keyword=" + encodeURIComponent(keyword);
            window.location.href = url;
        }, 500); // 0.5초 지연 후 실행
    });
});
</script>

 <!-- 신고 리스트 -->
    <table>
        <thead>
            <tr>
                <th>신고코드</th><th>카테고리</th><th>제목</th><th>내용</th>
                <th>신고자</th><th>대상코드</th><th>신고일</th><th>상태</th><th>처리</th>                
            </tr>
        </thead>
        <tbody>
            <c:forEach var="rep" items="${reports}">
                <tr>
                    <td>${rep.rep_code}</td>
                    <td>${rep.rep_category}</td>
                    <td>${rep.rep_title}</td>
                    <td>${rep.rep_content}</td>
                    <td>${rep.m_code}</td>
                    <td>${rep.target_code}</td>
                    <td><fmt:formatDate value="${rep.created_at}" pattern="yyyy-MM-dd HH:mm"/></td>
                    <td>${rep.rep_status}</td>                   
                    <td>
                    	<form method="post" action="/admin/board/listreports/process">
                        	<input type="hidden" name="rep_code" value="${rep.rep_code}">
                        	<button type="submit" name="action" value="DELETE" class="btn btn-success btn-sm">삭제</button>
                        	<button type="submit" name="action" value="IGNORE" class="btn btn-warning btn-sm">보류</button>
                    	</form>
					</td>
                </tr>
            </c:forEach>
        </tbody>
    </table>

	<!-- 아래에 페이지네이션 추가 -->
	<div class="pagination">
    	<c:forEach begin="1" end="${totalPages}" var="i">
        	<a href="/admin/board/listreports?page=${i}&size=${pageSize}&keyword=${keyword}" 
   				class="${i == currentPage ? 'active' : ''}">${i}</a>
    	</c:forEach>
	</div>
</body>
</html>