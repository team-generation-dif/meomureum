<%@ page language="java" contentType="text/html; charset=UTF-8"
    pageEncoding="UTF-8"%>
<!DOCTYPE html>
<html>
<head>
<meta charset="UTF-8">
<title>신고 관리</title>
</head>
<body>
<h3>신고 관리</h3>
<table class="table table-bordered">
    <tr>
        <th>코드</th><th>분류</th><th>신고자</th><th>제목</th><th>내용</th><th>작성일</th>
    </tr>
    <c:forEach var="r" items="${reports}">
        <tr>
            <td>${r.rep_code}</td>
            <td>${r.rep_category}</td>
            <td>${r.m_code}</td>
            <td>${r.rep_title}</td>
            <td>${r.rep_content}</td>
            <td><fmt:formatDate value="${r.created_at}" pattern="yyyy-MM-dd HH:mm"/></td>
        </tr>
    </c:forEach>
</table>

</body>
</html>