<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ taglib prefix="c" uri="jakarta.tags.core" %>
<%@ taglib prefix="fmt" uri="jakarta.tags.fmt" %>
<!DOCTYPE html>
<html>
<head>
<meta charset="UTF-8">
<title>신고 관리 목록</title>
<link href="https://stackpath.bootstrapcdn.com/bootstrap/3.4.1/css/bootstrap.min.css" rel="stylesheet">
</head>
<body>
<div class="container">
<!-- 검색창 -->
<form method="get" action="/admin/board/listreports" class="form-inline" style="margin-bottom:15px;">
    <input type="text" name="keyword" value="${keyword}" class="form-control" placeholder="검색어 입력">
    <button type="submit" class="btn btn-primary">검색</button>
</form>

<h3>대기중 신고</h3>
<table class="table table-bordered table-hover">
    <thead>
        <tr>
            <th>신고코드</th><th>카테고리</th><th>제목</th><th>내용</th>
            <th>신고자</th><th>대상코드</th><th>신고일</th><th>처리</th>
        </tr>
    </thead>
    <tbody>
        <c:forEach var="rep" items="${pendingReports}">
            <tr>
                <td>${rep.rep_code}</td>
                <td>${rep.rep_category}</td>
                <td>${rep.rep_title}</td>
                <td>${rep.rep_content}</td>
                <td>${rep.m_code}</td>
                <td>${rep.target_code}</td>
                <td><fmt:formatDate value="${rep.created_at}" pattern="yyyy-MM-dd HH:mm"/></td>
                <td>
                    <form method="post" action="/admin/board/listreports/process" style="display:inline;">
                        <input type="hidden" name="rep_code" value="${rep.rep_code}">
                        <input type="hidden" name="action" value="DELETE">
                        <button type="submit" class="btn btn-danger btn-sm">삭제(수용)</button>
                    </form>
                    <form method="post" action="/admin/board/listreports/process" style="display:inline;">
                        <input type="hidden" name="rep_code" value="${rep.rep_code}">
                        <input type="hidden" name="action" value="IGNORE">
                        <button type="submit" class="btn btn-secondary btn-sm">보류(기각)</button>
                    </form>
                </td>
            </tr>
        </c:forEach>
    </tbody>
</table>

<h3>완료된 신고</h3>
<table class="table table-bordered table-hover">
    <thead>
        <tr>
            <th>신고코드</th><th>카테고리</th><th>제목</th><th>내용</th>
            <th>신고자</th><th>대상코드</th><th>신고일</th><th>처리 상태</th>
        </tr>
    </thead>
    <tbody>
        <c:forEach var="rep" items="${doneReports}">
            <tr>
                <td>${rep.rep_code}</td>
                <td>${rep.rep_category}</td>
                <td>${rep.rep_title}</td>
                <td>${rep.rep_content}</td>
                <td>${rep.m_code}</td>
                <td>${rep.target_code}</td>
                <td><fmt:formatDate value="${rep.created_at}" pattern="yyyy-MM-dd HH:mm"/></td>
                <td><span class="label label-success">완료</span></td>
            </tr>
        </c:forEach>
    </tbody>
</table>

<h3>보류된 신고</h3>
<table class="table table-bordered table-hover">
    <thead>
        <tr>
            <th>신고코드</th><th>카테고리</th><th>제목</th><th>내용</th>
            <th>신고자</th><th>대상코드</th><th>신고일</th><th>처리 상태</th>
        </tr>
    </thead>
    <tbody>
        <c:forEach var="rep" items="${ignoredReports}">
            <tr>
                <td>${rep.rep_code}</td>
                <td>${rep.rep_category}</td>
                <td>${rep.rep_title}</td>
                <td>${rep.rep_content}</td>
                <td>${rep.m_code}</td>
                <td>${rep.target_code}</td>
                <td><fmt:formatDate value="${rep.created_at}" pattern="yyyy-MM-dd HH:mm"/></td>
                <td><span class="label label-default">보류</span></td>
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
</div>
</body>
</html>