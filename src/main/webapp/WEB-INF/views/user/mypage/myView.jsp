<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ taglib prefix="c" uri="jakarta.tags.core" %>
<!DOCTYPE html>
<html>
<head>
    <meta charset="UTF-8">
    <title>머무름 - 내 정보 보기</title>
    <style>
        body { font-family: 'Malgun Gothic', sans-serif; background-color: #f4f7f6; margin: 0; padding: 50px; }
        .view-box { background: white; width: 450px; margin: 0 auto; padding: 40px; border-radius: 15px; box-shadow: 0 5px 20px rgba(0,0,0,0.05); }
        h2 { text-align: center; color: #333; border-bottom: 2px solid #4CAF50; padding-bottom: 10px; }
        table { width: 100%; margin-top: 20px; border-collapse: collapse; }
        th { text-align: left; padding: 12px; color: #777; border-bottom: 1px solid #eee; width: 120px; }
        td { padding: 12px; color: #333; border-bottom: 1px solid #eee; font-weight: bold; }
        .btn-group { margin-top: 30px; text-align: center; }
        .btn { padding: 10px 25px; border-radius: 5px; text-decoration: none; font-size: 14px; margin: 0 5px; cursor: pointer; border: none; }
        .btn-main { background-color: #4CAF50; color: white; }
        .btn-edit { background-color: #2196F3; color: white; }
    </style>
</head>
<body>
    <div class="view-box">
        <h2>📋 내 정보 상세</h2>
        <table>
            <tr><th>아이디</th><td>${view.m_id}</td></tr>
            <tr><th>이름</th><td>${view.m_name}</td></tr>
            <tr><th>닉네임</th><td>${view.m_nick}</td></tr>
            <tr><th>이메일</th><td>${view.m_email}</td></tr>
            <tr><th>연락처</th><td>${view.m_tel}</td></tr>
            <tr><th>가입등급</th><td>${view.m_grade}</td></tr>
        </table>
        
 <div class="btn-group">
    <a href="/user/mypage/main" class="btn btn-main">메인으로</a>
    
    <a href="/user/mypage/confirmPwForm?mode=update" class="btn btn-edit">정보 수정하기</a>
    
    <a href="/user/mypage/confirmPwForm?mode=delete" class="btn" 
       style="background-color: #ff4d4d; color: white; padding: 10px 25px; border-radius: 5px; text-decoration: none;">회원 탈퇴</a>
</div>
    </div>
</body>
</html>