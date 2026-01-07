<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<!DOCTYPE html>
<html>
<head>
<meta charset="UTF-8">
<title>로그인 - 머무름</title>
<style>
    body { font-family: 'Malgun Gothic', sans-serif; background-color: #f4f7f6; display: flex; justify-content: center; align-items: center; height: 100vh; margin: 0; }
    .login-box { background: #fff; padding: 40px; border-radius: 12px; box-shadow: 0 4px 20px rgba(0,0,0,0.1); width: 360px; }
    h2 { text-align: center; color: #2c3e50; margin-bottom: 30px; }
    .input-group { margin-bottom: 20px; }
    input[type="text"], input[type="password"] { 
        width: 100%; padding: 12px; border: 1px solid #ddd; border-radius: 6px; box-sizing: border-box; font-size: 15px;
    }
    input:focus { border-color: #3498db; outline: none; }
    .btn-login { 
        width: 100%; padding: 13px; background: #3498db; color: white; border: none; border-radius: 6px; font-size: 16px; font-weight: bold; cursor: pointer; transition: 0.3s;
    }
    .btn-login:hover { background: #2980b9; }
    .bottom-links { margin-top: 20px; text-align: center; font-size: 14px; color: #7f8c8d; }
    .bottom-links a { color: #3498db; text-decoration: none; }
</style>
</head>
<body>

<div class="login-box">
    <h2>MEMBER LOGIN</h2>
    
    <form action="/guest/login" method="post">
        <div class="input-group">
            <input type="text" name="m_id" placeholder="아이디" required>
        </div>
        <div class="input-group">
            <input type="password" name="m_passwd" placeholder="비밀번호" required>
        </div>
        <button type="submit" class="btn-login">로그인</button>
    </form>
    
    <div class="bottom-links">
        계정이 없으신가요? <a href="/guest/join">회원가입</a>
    </div>
</div>

<script>
    // 로그인 실패 시 컨트롤러에서 보낸 에러 메시지 처리
    window.onload = function() {
        var error = "${error}";
        if (error) {
            alert(error);
        }
    };
</script>

</body>
</html>