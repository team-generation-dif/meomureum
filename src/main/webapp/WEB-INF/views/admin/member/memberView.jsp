<%@ page language="java" contentType="text/html; charset=UTF-8"
    pageEncoding="UTF-8"%>
<!DOCTYPE html>
<html>
<head>
<meta charset="UTF-8">
<title>회원정보 상세보기</title>
</head>
<body>
	<fieldset>
	<legend>회원정보 상세보기</legend>
	<table border="1" width="1000">
		<tr>
			<td>번호</td>
			<td>${detail.m_code}</td>
			<td>아이디</td>
			<td>${detail.m_id}</td>
		</tr>
		<tr>
			<td>이름</td>
			<td>${detail.m_name}</td>
			<tb>닉네임</tb>
			<td>${detail.m_nick}</td>
		</tr>
		<tr>
			<td>이메일</td>
			<td>${detail.m_email}</td>
			<td>연락처</td>
			<td>${detail.m_tel}</td>
		</tr>
		<tr>
			<td>성별</td>
			<td>${detail.m_gender}</td>
			<td>등급</td>
			<td>${detail.grade}</td>
		</tr>
		<tr>
			<td>권한</td>
			<td>${detail.m_auth}</td>
			<td>가입일</td>
			<td>${detail.created_at}</td>
		</tr>
			<td colspan="4">
			<a href= "/user/memberDelete?cno=${detail.cno}">회원탈퇴</a></td>
		</tr>
	</table>
	</fieldset>
</body>
</html>