<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ taglib prefix="c" uri="jakarta.tags.core" %>
<!DOCTYPE html>
<html>
<head>
    <meta charset="UTF-8">
    <title>본인 확인</title>
    <style>
        body { font-family: 'Malgun Gothic', sans-serif; background-color: #f4f7f6; display: flex; justify-content: center; align-items: center; height: 100vh; margin: 0; }
        .confirm-box { background: white; padding: 40px; border-radius: 15px; box-shadow: 0 5px 20px rgba(0,0,0,0.1); width: 350px; text-align: center; }
        h2 { color: #333; margin-bottom: 20px; }
        input[type="password"] { width: 100%; padding: 12px; margin: 10px 0; border: 1px solid #ddd; border-radius: 5px; box-sizing: border-box; }
        .btn-submit { width: 100%; padding: 12px; border: none; border-radius: 5px; color: white; cursor: pointer; font-size: 16px; font-weight: bold; }
        .btn-update { background: #4CAF50; }
        .btn-delete { background: #f44336; }
        .error-msg { color: #ff4d4d; font-size: 13px; margin-bottom: 10px; }
    </style>
</head>
<body>
    <div class="confirm-box">
        <h2>🔒 본인 확인</h2>
        <p>
            <c:choose>
                <c:when test="${mode == 'delete'}"><b style="color:#f44336;">회원 탈퇴</b>를 위해</c:when>
                <c:otherwise>안전한 <b>정보 수정</b>을 위해</c:otherwise>
            </c:choose>
            <br>비밀번호를 입력해주세요.
        </p>
        
        <c:if test="${not empty error}">
            <div class="error-msg">${error}</div>
        </c:if>
			<form action="/user/mypage/checkPw" method="post">
			    <input type="hidden" name="${_csrf.parameterName}" value="${_csrf.token}" />
			    
			    <input type="hidden" name="mode" value="${mode}">
			    <input type="password" name="m_passwd" placeholder="현재 비밀번호 입력" required autofocus>
			    
			    <button type="submit" class="btn-submit ${mode == 'delete' ? 'btn-delete' : 'btn-update'}">
			        ${mode == 'delete' ? '탈퇴하기' : '확인'}
			    </button>
			</form>
    </div>
</body>
</html>