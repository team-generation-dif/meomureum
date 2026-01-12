<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<%@ taglib prefix="sec" uri="http://www.springframework.org/security/tags" %>
<!DOCTYPE html>
<html>
<head>
    <meta charset="UTF-8">
    <title>머무름 - 환영합니다</title>
    <style>
        body { font-family: 'Malgun Gothic', sans-serif; margin: 0; padding: 0; }
        .navbar { background: #2c3e50; color: white; padding: 15px 50px; display: flex; justify-content: space-between; align-items: center; }
        .navbar a { color: white; text-decoration: none; margin-left: 20px; font-weight: bold; }
        .hero { background: #f8f9fa; height: 400px; display: flex; flex-direction: column; justify-content: center; align-items: center; text-align: center; }
        .hero h1 { font-size: 3rem; color: #34495e; }
        .btn-join { background: #3498db; color: white; padding: 12px 25px; border-radius: 5px; text-decoration: none; margin-top: 20px; }
        .footer { background: #eee; padding: 20px; text-align: center; font-size: 14px; color: #666; }
    </style>
</head>
<body>
    <nav class="navbar">
        <div class="logo"><h2>머무름</h2></div>
        <div class="menu">
            <sec:authorize access="isAnonymous()">
                <a href="/guest/loginForm">로그인</a>
                <a href="/guest/join">회원가입</a>
            </sec:authorize>

            <sec:authorize access="isAuthenticated()">
                <span><b><sec:authentication property="principal.username"/></b>님 반갑습니다.</span>
                
                <sec:authorize access="hasAuthority('ADMIN')">
                    <a href="/admin/list" style="color:#f1c40f;">[관리자 페이지]</a>
                </sec:authorize>
                
                <sec:authorize access="hasAuthority('USER')">
                    <a href="/user/mypage/main">마이페이지</a>
                </sec:authorize>
                
                <a href="/logout">로그아웃</a>
            </sec:authorize>
        </div>
    </nav>

    <div class="hero">
        <h1>편안한 공간, 머무름에 오신 것을 환영합니다.</h1>
        <p>지금 가입하고 다양한 서비스를 이용해 보세요.</p>
        
        <sec:authorize access="isAnonymous()">
            <a href="/guest/join" class="btn-join">30초만에 회원가입하기</a>
        </sec:authorize>
    </div>

    <div style="padding: 50px; text-align: center;">
        <h3>오늘의 추천 스테이</h3>
        <p>로그인하시면 더 많은 정보를 보실 수 있습니다.</p>
    </div>

    <footer class="footer">
        &copy; 2026 Meomureum. All rights reserved.
    </footer>

</body>
</html>