<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<!DOCTYPE html>
<html>
<head>
<meta charset="UTF-8">
<title>머무름 - 메인</title>
<style>
    .header { display: flex; justify-content: flex-end; padding: 20px; background: #f8f9fa; gap: 15px; }
    .welcome-msg { font-weight: bold; color: #2c3e50; margin-right: 10px; }
    .btn { text-decoration: none; color: #555; font-size: 14px; }
    .btn:hover { color: #3498db; }
</style>
</head>
<body>

    <div class="header">
        <c:choose>
            <%-- 1. 로그인 전: 로그인/회원가입 링크 노출 --%>
            <c:when test="${empty sessionScope.loginMember}">
                <a href="/guest/login" class="btn">로그인</a>
                <a href="/guest/join" class="btn">회원가입</a>
            </c:when>

            <%-- 2. 로그인 후: 환영 메시지/로그아웃 링크 노출 --%>
            <c:otherwise>
                <span class="welcome-msg">
                    ✨ ${sessionScope.loginMember.m_nick}님 환영합니다!
                </span>
                <a href="/guest/logout" class="btn">로그아웃</a>
            </c:otherwise>
        </c:choose>
    </div>

    <div style="text-align:center; margin-top:100px;">
        <h1>🏠 머무름에 오신 것을 환영합니다</h1>
        <p>로그인 상태에 따라 상단 메뉴가 변경됩니다.</p>
    </div>

</body>
</html>