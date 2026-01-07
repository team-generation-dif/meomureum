<%@ page language="java" contentType="text/html; charset=UTF-8"
    pageEncoding="UTF-8"%>
<!DOCTYPE html>
<html>
<head>
<script src="/JS/noteControl.js"></script>

<meta charset="UTF-8">
<title>Insert title here</title>
</head>
<body>
	<div><%@ include file="mapArea.jsp" %></div>
<%-- 	<div><%@ include file="sidebar.jsp" %></div> --%>
	<!-- 여행 계획 정보 -->
	<div id="">
		<div><input type="text" name="s_name" id="s_name" value="To ${p_name}"></div>
		<div></div>
	</div>
	<!-- 노트 영역 -->
	<div>
		<div id="n_container"></div>
		<input type="button" value="새 노트 작성" onclick="newNote()">
		<script type="text/template" id="n_template">
			<div>
				<div>
					<input type="text" name="n_title" placeholder="새로운 경험을 작성하세요">
					<input type="button" value="▲" onclick="moveUpNote(this)">
					<input type="button" value="▼" onclick="moveDownNote(this)">
				</div>
				<textarea type="text" name="n_content"></textarea>
				<input type="button" value="노트 삭제" onclick="deleteNote(this)">
			</div>
		</script>
	</div>
	<!-- 루트 영역 -->
</body>
</html>