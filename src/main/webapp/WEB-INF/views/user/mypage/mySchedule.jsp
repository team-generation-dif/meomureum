<%@ page language="java" contentType="text/html; charset=UTF-8"
    pageEncoding="UTF-8"%>
<%@ taglib prefix="c" uri="jakarta.tags.core"%>
<!DOCTYPE html>
<html>
<head>
<meta charset="UTF-8">
<title>머무름 - 내 여정</title>
</head>
<body>
	<%@ include file="../../guest/header.jsp" %>
	<table border="1">
		<c:forEach var="list" items="${lists}">
			<tr>
				<td>${list.s_code}</td>
				<td>${list.p_name}</td>
				<td>${list.created_at}</td>
				<td>${list.s_name}</td>
				<td><a href="/user/schedule/updateSchedule?s_code=${list.s_code}">이 여행 계획 보기</a></td>
			</tr>
		</c:forEach>
	</table>
</body>
</html>