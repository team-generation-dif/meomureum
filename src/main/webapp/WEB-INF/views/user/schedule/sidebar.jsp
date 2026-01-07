<%@ page language="java" contentType="text/html; charset=UTF-8"
    pageEncoding="UTF-8"%>
<%@ taglib prefix="c" uri="jakarta.tags.core" %>
<!DOCTYPE html>
<html>
<head>
<meta charset="UTF-8">
<title>Insert title here</title>
</head>
<body>
	<div>
		<form>
			<div id="note">
				<input type="button" value="계획 노트" onclick="">
				<c:forEach>
					<div id="">
						<input type="button" value="" onclick="">
					</div>
				</c:forEach>
			</div>
			<div id="route">
				<input type="button" value="여행 일정" onclick="">
				<c:forEach>
					<div id="">
						<input type="button" value="" onclick="">
					</div>
				</c:forEach>
			</div>
		</form>
	</div>
</body>
</html>