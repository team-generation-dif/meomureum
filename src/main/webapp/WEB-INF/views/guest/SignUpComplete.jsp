<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<!DOCTYPE html>
<html>
<head>
<meta charset="UTF-8">
<title>머무름 - 가입을 환영합니다!</title>
<style>
    /* [1] 배경 및 레이아웃 */
    body { 
        background-color: #f8f9ff; margin: 0; 
        font-family: 'Pretendard', 'Malgun Gothic', sans-serif; 
        display: flex; justify-content: center; align-items: center; 
        height: 100vh; 
    }

    /* [2] 축하 카드 컨테이너 */
    .success-card { 
        background: #fff; padding: 60px 40px; 
        border-radius: 40px; box-shadow: 0 20px 50px rgba(162,155,254,0.1); 
        width: 100%; max-width: 450px; border: 1px solid #f1f3ff;
        text-align: center;
        animation: fadeInUp 0.8s ease-out; /* 등장 애니메이션 */
    }

    /* 축하 아이콘 애니메이션 */
    .welcome-icon {
        font-size: 60px; margin-bottom: 20px; display: inline-block;
        animation: toss 2s infinite alternate ease-in-out;
    }

    h2 { font-size: 28px; color: #2d3436; margin: 10px 0; letter-spacing: -1px; }
    .welcome-msg { color: #a2a2a2; font-size: 16px; line-height: 1.6; margin-bottom: 40px; }
    .welcome-msg strong { color: #a29bfe; }

    /* [3] 버튼 스타일 */
    .btn-group { display: flex; flex-direction: column; gap: 12px; }
    
    .btn-login { 
        padding: 18px; background: #a29bfe; color: white; border: none; 
        border-radius: 20px; font-size: 16px; font-weight: bold; text-decoration: none;
        transition: 0.3s; box-shadow: 0 10px 20px rgba(162,155,254,0.2);
    }
    .btn-login:hover { background: #6c5ce7; transform: translateY(-3px); }

    .btn-home { 
        padding: 15px; color: #b2bec3; text-decoration: none; 
        font-size: 14px; font-weight: 500; transition: 0.2s;
    }
    .btn-home:hover { color: #a29bfe; }

    /* 애니메이션 정의 */
    @keyframes fadeInUp {
        from { opacity: 0; transform: translateY(30px); }
        to { opacity: 1; transform: translateY(0); }
    }
    @keyframes toss {
        0% { transform: rotate(-10deg) scale(1); }
        100% { transform: rotate(10deg) scale(1.1); }
    }
</style>
</head>
<body>

<div class="success-card">
    <div class="welcome-icon">🎁</div>
    <h2>축하합니다!</h2>
    <p class="welcome-msg">
        이제 <strong>머무름</strong>의 소중한 가족이 되었습니다.<br>
        당신의 모든 여행과 기록이 이곳에서<br>
        더욱 빛나기를 응원할게요.
    </p>

    <div class="btn-group">
        <a href="/guest/loginForm" class="btn-login">기억을 담으러 가기 (로그인)</a>
        <a href="/" class="btn-home">홈으로 돌아가기</a>
    </div>
</div>

</body>
</html>