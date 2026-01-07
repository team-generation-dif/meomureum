<%@ page language="java" contentType="text/html; charset=UTF-8"
    pageEncoding="UTF-8"%>
<!DOCTYPE html>
<html>
<head>
<meta charset="UTF-8">
<title>게시판 작성</title>
</head>
<body>
	<form name="boardForm" method="post" action="/user/board/write" enctype="multipart/form-data">
		<table border="1" width="800">
			<tr>
				<td>분류</td>
				<td>
					정보공유게시판 <input type="radio" name="b_category" value="정보">
					동행게시판 <input type="radio" name="b_category" value="동행">
					후기게시판 <input type="radio" name="b_category" value="후기">
				</td>
			</tr>
			<tr>
				<td>제목</td>
				<td><input type="text" name="b_title" required></td>
			</tr>
			<tr>
				<td>내용</td>
				<td><textarea name="b_content" rows="10" cols="70" required></textarea></td>			
			</tr>
			<tr>
				<td>이미지</td>
				<input type="file" name="uploadFiles" multiple>	
			</tr>				
		</table>
		<br>
		<input type="submit" value="작성"> 
		<input type="reset" value="초기화">	
	</form> 
</body>
</html>