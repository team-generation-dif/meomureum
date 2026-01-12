<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ taglib prefix="c" uri="jakarta.tags.core" %>
<!DOCTYPE html>
<html>
<head>
    <meta charset="UTF-8">
    <title>머무름 - 소개</title>
    <style>
        .intro-container { max-width: 900px; margin: 80px auto; text-align: center; font-family: 'Malgun Gothic', sans-serif; }
        .hero { background: #f8f9fa; padding: 60px 20px; border-radius: 20px; border: 1px solid #eee; }
        .hero h1 { color: #3498db; font-size: 2.5rem; }
        .hero p { color: #666; font-size: 1.2rem; line-height: 1.8; }
    </style>
</head>
<body>
    <jsp:include page="../guest/header.jsp" />

    <div class="intro-container">
        <div class="hero">
            <h1>🏠 기록이 머무는 공간, 머무름</h1>
            <hr width="50" style="border: 2px solid #3498db; margin: 30px auto;">
            <p>
                안녕하세요! <strong>머무름</strong>은 당신의 소중한 여정을 기록하고<br>
                효율적인 스케줄 관리를 도와주는 맞춤형 여행 대시보드 서비스입니다.
            </p>
            <p style="font-size: 1rem; color: #999;">
                여행을 좋아하는 다른 사람들과 일정을 공유하며, 보람있는 여행이 되길 기원합니다. 
            </p>
        </div>
    </div>
</body>
</html>