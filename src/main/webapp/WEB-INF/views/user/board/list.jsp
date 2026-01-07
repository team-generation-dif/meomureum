<%@ page language="java" contentType="text/html; charset=UTF-8"
    pageEncoding="UTF-8"%>
<!DOCTYPE html>
<html>
<head>
<meta charset="UTF-8">
<title>게시판 목록</title>
</head>
<body>
<h3>게시판 목록</h3>
	<table border="1" width="700">
	<tr>
		<th>게시판 코드</th> 
		<th>분류</th> 
		<th>제목</th> 
		<th>작성일</th> 
		<th>조회수</th> 
	</tr>
	<c:forEach var="dto" items="${boardlist}"> 
	<tr>
		<th>${dto.b_code}</th> 
		<th>${dto.b_category}</th> 
		<th><a href="detail?b_code=${dto.b_code}">${dto.b_title}</a></th>  
		<th>${dto.created_at}</th> 
		<th>${dto.b_view}</th> 
	</tr>
	</c:forEach>
	</table>
	<div class="text-end">
                <a href="/board/insertForm">게시글 등록</a>
            </div>
</body>
</html>