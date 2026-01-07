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
		<th><a href="/user/board/detail/${dto.b_code}">${dto.b_title}</a></th>  
		<th>${dto.created_at}</th> 
		<th>${dto.b_view}</th> 
		<th>
			<th><a href="/user/board/detail/${dto.b_code}">상세보기</a></th>			
		</th> 
	</tr>
	</c:forEach>
	</table>
	<div style="text-align:right">
                <a href="/user/board/writeForm">게시글 등록</a>
            </div>
</body>
</html>