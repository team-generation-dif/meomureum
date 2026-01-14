<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ taglib prefix="c" uri="jakarta.tags.core" %>
<!DOCTYPE html>
<html>
<head>
    <meta charset="UTF-8">
    <title>머무름 - 정보 수정</title>
    <style>
        /* [1] 배경 및 레이아웃 */
        body { background-color: #f8f9ff; margin: 0; font-family: 'Malgun Gothic', sans-serif; color: #333; }
        .wrapper { display: flex; justify-content: center; align-items: center; min-height: 100vh; padding: 40px 20px; }

        /* [2] 수정 박스 디자인 */
        .update-card { 
            background: white; width: 480px; padding: 50px; 
            border-radius: 35px; box-shadow: 0 20px 40px rgba(162,155,254,0.1); 
            border: 1px solid #f1f3ff;
        }
        
        .update-header { text-align: center; margin-bottom: 35px; }
        .update-header h2 { margin: 0; font-size: 26px; color: #2d3436; letter-spacing: -1px; }
        .update-header p { color: #a2a2a2; font-size: 14px; margin-top: 8px; }

        /* [3] 폼 스타일링 */
        .form-group { margin-bottom: 20px; }
        .label-text { display: block; font-size: 13px; font-weight: bold; color: #a2a2a2; margin-bottom: 8px; margin-left: 5px; }
        
        input[type="text"], input[type="password"], input[type="email"], input[type="tel"] {
            width: 100%; padding: 14px 20px; border: 1px solid #f1f3ff; border-radius: 18px;
            background-color: #fafaff; font-size: 15px; color: #2d3436; font-family: inherit;
            box-sizing: border-box; transition: 0.3s; outline: none;
        }

        /* 포커스 효과 */
        input:focus { border-color: #a29bfe; background-color: #fff; box-shadow: 0 0 0 4px rgba(162,155,254,0.1); }
        
        /* 읽기 전용(ID) */
        input[readonly] { background-color: #f1f3ff; color: #b2bec3; cursor: not-allowed; border: none; }

        .hint-box { 
            background: #fff5f5; color: #ff7675; padding: 10px 15px; 
            border-radius: 12px; font-size: 12px; margin-top: 8px; display: flex; align-items: center; gap: 5px;
        }

        /* [4] 버튼 그룹 */
        .btn-group { margin-top: 40px; display: flex; gap: 12px; }
        .btn { 
            flex: 1; padding: 16px; border-radius: 20px; text-decoration: none; 
            font-size: 16px; font-weight: bold; cursor: pointer; border: none; transition: 0.3s;
        }
        .btn-submit { background-color: #a29bfe; color: white; box-shadow: 0 8px 15px rgba(162,155,254,0.2); }
        .btn-submit:hover { background-color: #6c5ce7; transform: translateY(-2px); }
        
        .btn-back { background-color: #f1f3ff; color: #b2bec3; }
        .btn-back:hover { background-color: #e1e5ff; color: #a29bfe; }
    </style>
</head>
<body>

    <div class="wrapper">
        <div class="update-card">
            <div class="update-header">
                <h2>✏️ 정보 수정</h2>
                <p>회원님의 소중한 정보를 안전하게 관리하세요</p>
            </div>
            
            <form name="member" method="post" action="/user/update">
                <input type="hidden" name="m_code" value="${edit.m_code}">
                
                <div class="form-group">
                    <span class="label-text">아이디</span>
                    <input type="text" value="${edit.m_id}" readonly>
                </div>

                <div class="form-group">
                    <span class="label-text">새 비밀번호</span>
                    <input type="password" name="m_passwd" placeholder="변경 시에만 입력해 주세요">
                    <div class="hint-box">
                        <span>💡</span> 비밀번호를 바꾸고 싶을 때만 입력하세요.
                    </div>
                </div>

                <div class="form-group">
                    <span class="label-text">이름</span>
                    <input type="text" name="m_name" value="${edit.m_name}" required>
                </div>

                <div class="form-group">
                    <span class="label-text">닉네임</span>
                    <input type="text" name="m_nick" value="${edit.m_nick}" required>
                </div>

                <div class="form-group">
                    <span class="label-text">이메일</span>
                    <input type="email" name="m_email" value="${edit.m_email}" required>
                </div>

                <div class="form-group" style="margin-bottom: 0;">
                    <span class="label-text">연락처</span>
                    <input type="tel" name="m_tel" value="${edit.m_tel}" required>
                </div>
                
                <div class="btn-group">
                    <button type="submit" class="btn btn-submit">수정 완료</button>
                    <button type="button" class="btn btn-back" onclick="location.href='/user/mypage/myView'">취소</button>
                </div>
            </form>
        </div>
    </div>

</body>
</html>