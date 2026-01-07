<%@ page language="java" contentType="text/html; charset=UTF-8"
    pageEncoding="UTF-8"%>
<%@ taglib uri="http://java.sun.com/jsp/jstl/fmt" prefix="fmt" %>
<!DOCTYPE html>
<html>
<head>
<meta charset="UTF-8">
<title>게시글 상세</title>
</head>
<body>
<h3>게시글 상세</h3>
<table border="1" width="700">
    <tr>
        <th>게시판 코드</th>
        <td>${board.b_code}</td>
    </tr>
    <tr>
        <th>분류</th>
        <td>${board.b_category}</td>
    </tr>
    <tr>
        <th>제목</th>
        <td>${board.b_title}</td>
    </tr>
    <tr>
        <th>작성일</th>
        <td><fmt:formatDate value="${board.created_at}" pattern="yyyy-MM-dd HH:mm"/></td>
    </tr>
    <tr>
        <th>조회수</th>
        <td>${board.b_view}</td>
    </tr>
    <tr>
        <th>내용</th>
        <td>${board.b_content}</td>
    </tr>
</table>
<br>
<a href="/user/board/list">목록으로</a>
<a href="/user/board/writeForm">글 작성</a>
<a href="/user/board/updateForm/${board.b_code}">수정</a>
<a href="/user/board/delete/${board.b_code}">삭제</a>
</body>
</html>
