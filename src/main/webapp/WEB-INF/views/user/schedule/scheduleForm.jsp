<%@ page language="java" contentType="text/html; charset=UTF-8"
    pageEncoding="UTF-8"%>
<!DOCTYPE html>
<html>
<head>
<meta charset="UTF-8">
<title>Insert title here</title>
</head>
<body>
	<div>
		<h3>여행 계획하기</h3>
	</div>
	<div>
		<form name="scheduleForm" id="scheduleForm" method="post" action="/user/schedule/schedule">
			<div>
				<input type="text" name="p_name" id="p_name" placeholder="여행지를 적어주세요. 예)서울 부산"><br>
			</div>
			<div>
				<input type="date" name="s_start" id="s_start" placeholder="여행 시작일">
				<input type="date" name="s_end" id="s_end" placeholder="여행 종료일">
			</div>
			<div>
				<input type="submit" value="계획 시작">
			</div>
		</form>
	</div>
</body>
</html>