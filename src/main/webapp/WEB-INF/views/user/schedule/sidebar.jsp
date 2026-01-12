<%@ page language="java" contentType="text/html; charset=UTF-8"
    pageEncoding="UTF-8"%>
<%@ taglib prefix="c" uri="jakarta.tags.core" %>
<!DOCTYPE html>
<html>
<head>
<style>
    .nav-group { padding: 15px; border-bottom: 1px solid #eee; }
    .nav-btn {
        display: block; width: 100%; padding: 10px; margin-bottom: 5px;
        text-align: left; background: none; border: 1px solid #ddd;
        border-radius: 4px; cursor: pointer; transition: 0.2s;
    }
    .nav-btn:hover { background: #f0f7ff; border-color: #007bff; }
</style>
<meta charset="UTF-8">
<title>Insert title here</title>
</head>
<body>
	<div class="sidebar-nav">
	    <div class="nav-group">
	        <h4>노트</h4>
	        <div id="sidebar-notes">
	        	<c:if test="${mode == 'update'}">
	        		<%-- 순서대로 번호를 부여 --%>
                    <c:forEach var="note" items="${noteDTO}" varStatus="status"> 
                        <button type="button" class="nav-item" id="nav_note_${status.index}" onclick="scrollToNote(${status.index})">
                            ${note.n_title != '' ? note.n_title : '새 노트'}
                        </button>
                    </c:forEach>
                </c:if>
            </div>
	    </div>
	
	    <div class="nav-group">
	        <h4>여행 일정</h4>
	        <div id="sidebar-routes">
	            <c:if test="${mode == 'update'}">
	                <c:forEach var="dayNum" begin="1" end="${dayDiff}">
	                    <button type="button" class="nav-item" onclick="scrollToDay(${dayNum})">
	                        Day ${dayNum}
	                    </button>
	                </c:forEach>
	            </c:if>
	        </div>
	    </div>
	</div>
</body>
</html>