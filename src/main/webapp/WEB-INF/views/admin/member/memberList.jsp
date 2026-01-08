<%@ page language="java" contentType="text/html; charset=UTF-8"
    pageEncoding="UTF-8"%>
<%@ taglib prefix="c" uri="jakarta.tags.core" %>
<%@ taglib prefix="fmt" uri="jakarta.tags.fmt" %>
<!DOCTYPE html>
<html>
<head>
<meta charset="UTF-8">
<title>회원목록</title>
</head>
<body>
	<fieldset>
	<legend>회원목록</legend>
	<table border="1" width="1000">
		<tr>
			<td>번호</td>
			<td>아이디</td>
			<td>이름</td>
			<tb>닉네임</tb>	
			<td>이메일</td>
			<td>연락처</td>
			<td>성별</td>
			<td>등급</td>
			<td>권한</td>
			<td>가입일</td>
		</tr>
	<c:forEach var="dto" items="${list}">
			<tr>
			<td>${dto.m_code}</td>
			<td>${dto.m_id}</td>
			<td><a href="/admin/memberView?m_code=${dto.m_code}">${dto.m_name}</a></td>
			<td>${dto.m_nick}</td>
			<td>${dto.m_email}</td>
			<td>${dto.m_tel}</td>
			<td>${dto.m_gender}</td>
			<td>${dto.m_grade}</td>
			<td>${dto.m_auth}</td>
			<td>${dto.created_at}</td>
			<td><fmt:formatDate value="${dto.m_auth}" pattern="yyyy-MM-dd"/></td>
		</tr>
	</c:forEach>
	</table>
	</fieldset>
</body>
</html>