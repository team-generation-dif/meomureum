<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ taglib prefix="c" uri="jakarta.tags.core" %>
<!DOCTYPE html>
<html>
<head>
    <meta charset="UTF-8">
    <title>머무름 - 본인 확인</title>
    <style>
        /* [1] 배경 및 중앙 정렬 */
        body { 
            background-color: #f8f9ff; margin: 0; 
            font-family: 'Malgun Gothic', sans-serif; 
            display: flex; justify-content: center; align-items: center; 
            height: 100vh; 
        }

        /* [2] 컨테이너 카드 디자인 */
        .confirm-card { 
            background: white; padding: 50px 40px; 
            border-radius: 35px; box-shadow: 0 20px 50px rgba(162,155,254,0.1); 
            width: 400px; text-align: center; border: 1px solid #f1f3ff;
        }

        /* 아이콘 섹션 */
        .lock-icon {
            width: 70px; height: 70px; background: #f1f3ff; color: #a29bfe;
            border-radius: 25px; display: flex; align-items: center; justify-content: center;
            font-size: 30px; margin: 0 auto 25px;
        }

        h2 { color: #2d3436; font-size: 24px; margin-bottom: 10px; letter-spacing: -1px; }
        
        .desc-text { color: #888; font-size: 15px; line-height: 1.6; margin-bottom: 30px; }
        .mode-highlight { font-weight: bold; border-bottom: 2px solid #a29bfe; padding-bottom: 2px; color: #2d3436; }
        .mode-delete { color: #ff7675; border-bottom-color: #ff7675; }

        /* [3] 입력창 스타일 */
        input[type="password"] { 
            width: 100%; padding: 15px 20px; margin-bottom: 15px; 
            border: 1px solid #f1f3ff; border-radius: 18px; 
            background-color: #fafaff; font-size: 16px; 
            box-sizing: border-box; outline: none; transition: 0.3s;
            text-align: center; /* 보안상 중앙 정렬이 깔끔함 */
        }
        input[type="password"]:focus { 
            border-color: #a29bfe; background-color: #fff; 
            box-shadow: 0 0 0 4px rgba(162,155,254,0.1); 
        }

        /* [4] 버튼 스타일 */
        .btn-submit { 
            width: 100%; padding: 16px; border: none; border-radius: 18px; 
            color: white; cursor: pointer; font-size: 16px; font-weight: bold; 
            transition: 0.3s; margin-top: 10px;
        }
        
        /* 모드별 버튼 색상 */
        .btn-update { 
            background: #a29bfe; 
            box-shadow: 0 8px 15px rgba(162,155,254,0.3); 
        }
        .btn-update:hover { background: #6c5ce7; transform: translateY(-2px); }

        .btn-delete { 
            background: #ff7675; 
            box-shadow: 0 8px 15px rgba(255, 118, 117, 0.3); 
        }
        .btn-delete:hover { background: #ee5253; transform: translateY(-2px); }

        /* 에러 메시지 */
        .error-msg { 
            background: #fff5f5; color: #ff7675; padding: 10px; 
            border-radius: 12px; font-size: 13px; margin-bottom: 20px;
            border: 1px solid #ffe3e3;
        }

        .back-link {
            display: inline-block; margin-top: 25px; color: #ccc; 
            text-decoration: none; font-size: 13px; transition: 0.2s;
        }
        .back-link:hover { color: #a29bfe; }
    </style>
</head>
<body>
    <div class="confirm-card">
        <div class="lock-icon">🔒</div>
        <h2>본인 확인</h2>
        
        <p class="desc-text">
            <c:choose>
                <c:when test="${mode == 'delete'}">
                    소중한 정보를 지키기 위해<br>
                    <span class="mode-highlight mode-delete">회원 탈퇴</span> 전 비밀번호를 입력해주세요.
                </c:when>
                <c:otherwise>
                    안전한 <span class="mode-highlight">정보 수정</span>을 위해<br>
                    현재 사용 중인 비밀번호를 입력해주세요.
                </c:otherwise>
            </c:choose>
        </p>
        
        <c:if test="${not empty error}">
            <div class="error-msg">⚠️ ${error}</div>
        </c:if>

        <form action="/user/mypage/checkPw" method="post">
            <input type="hidden" name="${_csrf.parameterName}" value="${_csrf.token}" />
            <input type="hidden" name="mode" value="${mode}">
            
            <input type="password" name="m_passwd" placeholder="현재 비밀번호를 입력하세요" required autofocus>
            
            <button type="submit" class="btn-submit ${mode == 'delete' ? 'btn-delete' : 'btn-update'}">
                ${mode == 'delete' ? '탈퇴하기' : '인증 및 확인'}
            </button>
        </form>

        <a href="/user/mypage/myView" class="back-link">이전으로 돌아가기</a>
    </div>
</body>
</html>