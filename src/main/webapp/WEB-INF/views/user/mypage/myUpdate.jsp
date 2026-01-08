<%@ page language="java" contentType="text/html; charset=UTF-8"
    pageEncoding="UTF-8"%>
    <%@ taglib prefix="c" uri="jakarta.tags.core" %>
    <%@ taglib prefix="fn" uri="jakarta.tags.functions" %>
    <%@ taglib prefix="fmt" uri="jakarta.tags.fmt" %>
<!DOCTYPE html>
<html>
<head>
<meta charset="UTF-8">
<title>회원정보 수정</title>
</head>
<body>
<fieldset>
	<legend>회원정보 수정</legend>
	<table>
	<form name="member" method="post" action="/user/memberUpdateProc">
	<input type="hidden" name="cno" value="${edit.m_code}">
		<tr>
		<td>비밀번호:</td>
		<td><input type="password" name="m_passwd" value="${edit.m_passwd}"></td>
		</tr>
		<tr>
		<td>이름:</td>
		<td><input type="text" name="m_name" value="${edit.m_name}"></td>
		</tr>
		<tr>
		<td>닉네임:</td>
		<td><input type="text" name="m_nick" value="${edit.m_nick}"></td>
		</tr>
		<tr>
        <td>이메일:</td>
        <td><input type="email" name="m_email" value="${edit.m_email}"></td>
        </tr>
        <tr>
		<td>연락처:</td>
		<td>
			<input type="tel" name="m_tel" value="${edit.m_tel}">
		</td>
		</tr>
		<tr>
		 <td colspan="1">
		 	<input type="submit" value="회원정보수정">
		 	<input type="button" value="수정취소" onclick="history.back();">
		 </td>
		 </tr>
		</form>
		</table>
		</fieldset>
</body>
</html>