<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<!DOCTYPE html>
<html>
<head>
<meta charset="UTF-8">
<title>머무름 - 로그인</title>
<style>
    /* [1] 배경 및 레이아웃 */
    body { 
        background-color: #f8f9ff; margin: 0; 
        font-family: 'Pretendard', 'Malgun Gothic', sans-serif; 
        display: flex; justify-content: center; align-items: center; 
        height: 100vh; 
    }

    /* [2] 로그인 카드 컨테이너 */
    .login-container { 
        background: #fff; padding: 60px 50px; 
        border-radius: 40px; box-shadow: 0 20px 50px rgba(162,155,254,0.1); 
        width: 100%; max-width: 400px; border: 1px solid #f1f3ff;
        text-align: center;
    }

    .login-header { margin-bottom: 40px; }
    .login-header h2 { font-size: 26px; color: #2d3436; margin: 0; letter-spacing: -1px; }
    .login-header p { color: #a2a2a2; font-size: 14px; margin-top: 10px; }
    .header-dot { width: 6px; height: 6px; background: #a29bfe; border-radius: 50%; margin: 15px auto 0; }

    /* [3] 입력창 스타일 */
    .input-group { margin-bottom: 15px; }
    input[type="text"], input[type="password"] { 
        width: 100%; padding: 16px 20px; border: 1px solid #f1f3ff; border-radius: 20px; 
        background-color: #fafaff; font-size: 15px; color: #2d3436; box-sizing: border-box; 
        transition: 0.3s; outline: none;
    }
    input:focus { 
        border-color: #a29bfe; background-color: #fff; 
        box-shadow: 0 0 0 4px rgba(162,155,254,0.1); 
    }

    /* [4] 버튼 스타일 */
    .btn-login { 
        width: 100%; padding: 18px; background: #a29bfe; color: white; border: none; 
        border-radius: 20px; font-size: 16px; font-weight: bold; cursor: pointer; 
        margin-top: 15px; transition: 0.3s; box-shadow: 0 10px 20px rgba(162,155,254,0.2);
    }
    .btn-login:hover { background: #6c5ce7; transform: translateY(-3px); }

    /* [5] 하단 링크 */
    .bottom-links { margin-top: 30px; font-size: 14px; color: #b2bec3; }
    .bottom-links a { color: #a29bfe; text-decoration: none; font-weight: bold; margin-left: 5px; }
    .bottom-links a:hover { text-decoration: underline; }

    /* 에러 메시지 스타일 */
    .error-area {
        background: #fff5f5; color: #ff7675; padding: 12px; border-radius: 15px;
        font-size: 13px; margin-bottom: 20px; display: none; /* 기본 숨김 */
    }
</style>
</head>
<body>

<div class="login-container">
    <div class="login-header">
        <h2>반가운 발걸음 🏠</h2>
        <p>당신의 기록이 머무는 공간, 머무름입니다</p>
        <div class="header-dot"></div>
    </div>

    <div id="errorBox" class="error-area"></div>
    
    <form action="/j_spring_security_check" method="post">
        <div class="input-group">
            <input type="text" name="j_username" placeholder="아이디를 입력해 주세요" required autofocus>
        </div>
        <div class="input-group">
            <input type="password" name="j_password" placeholder="비밀번호를 입력해 주세요" required>
        </div>
        <button type="submit" class="btn-login">머무름(로그인)</button>
    </form>
    
   <div class="bottom-links">
    아직 회원이 아니신가요? <a href="/guest/join">회원가입</a><br><br>
    <a href="/" style="color: #b2bec3; font-weight: normal; font-size: 13px;">이전 페이지로 돌아가기</a>
</div>
</div>

<script>
    window.onload = function() {
        // 1. 로그인 실패 에러 메시지 처리
        var error = "${error}";
        var errorBox = document.getElementById("errorBox");
        if (error && error.trim() !== "") {
            errorBox.innerText = "⚠️ " + error;
            errorBox.style.display = "block";
        }

        // 2. 탈퇴 완료 메시지 처리
        const urlParams = new URLSearchParams(window.location.search);
        if (urlParams.get('message') === 'deleted') {
            alert("회원 탈퇴가 정상적으로 처리되었습니다. 그동안 머무름과 함께해 주셔서 감사합니다.");
        }
    };
</script>

</body>
</html>