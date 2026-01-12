<%@ page language="java" contentType="text/html; charset=UTF-8"
    pageEncoding="UTF-8"%>
<%@ taglib prefix="c" uri="jakarta.tags.core"%>
<!DOCTYPE html>
<html>
<head>
<meta charset="UTF-8">
<title>Insert title here</title>
</head>
<body>
	<div>
		<c:forEach var="list" items="${lists}">
		<div>
			<p>${list.s_code}
			<p>${list.p_name}
			<p>${list.created_at}
			<p>${list.s_name}
			<a href="/user/schedule/updateSchedule?s_code=${list.s_code}">이 여행 계획 보기</a>
			<hr>
		</div>
		</c:forEach>
	</div>
</body>
</html>