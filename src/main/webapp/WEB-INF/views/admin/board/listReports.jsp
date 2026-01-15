<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ taglib prefix="c" uri="jakarta.tags.core" %>
<%@ taglib prefix="fmt" uri="jakarta.tags.fmt" %>
<!DOCTYPE html>
<html>
<head>
<meta charset="UTF-8">
<title>머무름 - 신고 관리 대시보드</title>
<link href="https://stackpath.bootstrapcdn.com/bootstrap/3.4.1/css/bootstrap.min.css" rel="stylesheet">

<style>
.pagination a { margin: 0 5px; text-decoration:none; }
.pagination a.active { font-weight:bold; color:red; }
</style>

</head>
<body>

<div class="container">

<h3>신고 관리 목록</h3>

<!-- 상태별 탭 -->
<ul class="nav nav-tabs">
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
<div style="text-align:right; margin:10px 0;">
    <form method="get" action="/admin/board/listreports" class="form-inline">
        <input type="hidden" name="status" value="${status}">
        <input type="text" name="keyword" value="${keyword}" class="form-control" placeholder="검색어 입력">
        <button type="submit" class="btn btn-primary">검색</button>
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
    <table class="table table-bordered table-hover">
        <thead>
            <tr>
                <th>신고코드</th><th>카테고리</th><th>제목</th><th>내용</th>
                <th>신고자</th><th>대상코드</th><th>신고일</th><th>상태</th>
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

<div class="bottom-btn-container">
    <a href="/admin/member/main" class="btn-home-normal">
        <span class="glyphicon glyphicon-home"></span> 메인으로 돌아가기
    </a>
</div>

</body>
</html>