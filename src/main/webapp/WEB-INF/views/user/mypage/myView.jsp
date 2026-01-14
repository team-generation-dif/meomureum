<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ taglib prefix="c" uri="jakarta.tags.core" %>
<!DOCTYPE html>
<html>
<head>
    <meta charset="UTF-8">
    <title>머무름 - 마이페이지</title>
    <style>
        /* [1] 배경 및 레이아웃 */
        body { background-color: #f8f9ff; margin: 0; font-family: 'Malgun Gothic', sans-serif; color: #333; }
        .wrapper { display: flex; justify-content: center; align-items: center; min-height: 100vh; padding: 20px; }

        /* [2] 프로필 카드 디자인 */
        .profile-card { 
            background: white; width: 500px; padding: 50px; 
            border-radius: 35px; box-shadow: 0 20px 40px rgba(162,155,254,0.1); 
            border: 1px solid #f1f3ff; position: relative;
        }
        
        /* 상단 아이콘/타이틀 */
        .profile-header { text-align: center; margin-bottom: 40px; }
        .avatar-circle {
            width: 80px; height: 80px; background: #f1f3ff; color: #a29bfe;
            border-radius: 30px; display: flex; align-items: center; justify-content: center;
            font-size: 35px; margin: 0 auto 15px;
        }
        .profile-header h2 { margin: 0; font-size: 24px; color: #2d3436; }
        .profile-header p { color: #a2a2a2; font-size: 14px; margin-top: 5px; }

        /* [3] 정보 리스트 스타일 */
        .info-list { margin-bottom: 40px; }
        .info-item { 
            display: flex; justify-content: space-between; align-items: center;
            padding: 15px 5px; border-bottom: 1px solid #f8f9ff;
        }
        .info-label { color: #a2a2a2; font-size: 14px; font-weight: 500; }
        .info-value { color: #2d3436; font-size: 16px; font-weight: bold; }
        
        /* 등급 뱃지 */
        .grade-badge {
            background: #e1e5ff; color: #a29bfe; padding: 4px 12px;
            border-radius: 10px; font-size: 12px;
        }

        /* [4] 버튼 그룹 */
        .btn-group { display: flex; flex-direction: column; gap: 12px; }
        .btn { 
            padding: 15px; border-radius: 18px; text-decoration: none; 
            font-size: 15px; font-weight: bold; text-align: center; transition: 0.3s; 
            border: none; cursor: pointer;
        }
        .btn-edit { background-color: #a29bfe; color: white; box-shadow: 0 8px 15px rgba(162,155,254,0.2); }
        .btn-edit:hover { background-color: #6c5ce7; transform: translateY(-2px); }
        
        .btn-main { background-color: #f8f9ff; color: #a29bfe; border: 1px solid #e1e5ff; }
        .btn-main:hover { background-color: #f1f3ff; }

        /* 탈퇴 링크 */
        .btn-delete { 
            margin-top: 25px; font-size: 13px; color: #ccc; 
            text-decoration: underline; background: none; border: none; cursor: pointer;
        }
        .btn-delete:hover { color: #ff7675; }
    </style>
</head>
<body>
    <div class="wrapper">
        <div class="profile-card">
            <div class="profile-header">
                <div class="avatar-circle">👤</div>
                <h2>내 정보 상세</h2>
                <p>STAY MEOMUREUM Account</p>
            </div>

            <div class="info-list">
                <div class="info-item">
                    <span class="info-label">아이디</span>
                    <span class="info-value">${view.m_id}</span>
                </div>
                <div class="info-item">
                    <span class="info-label">이름</span>
                    <span class="info-value">${view.m_name}</span>
                </div>
                <div class="info-item">
                    <span class="info-label">닉네임</span>
                    <span class="info-value">${view.m_nick}</span>
                </div>
                <div class="info-item">
                    <span class="info-label">이메일</span>
                    <span class="info-value">${view.m_email}</span>
                </div>
                <div class="info-item">
                    <span class="info-label">연락처</span>
                    <span class="info-value">${view.m_tel}</span>
                </div>
                <div class="info-item" style="border-bottom: none;">
                    <span class="info-label">가입 등급</span>
                    <span class="grade-badge">${view.m_grade}</span>
                </div>
            </div>
            
            <div class="btn-group">
                <a href="/user/mypage/confirmPwForm?mode=update" class="btn btn-edit">회원 정보 수정</a>
                <a href="/user/mypage/main" class="btn btn-main">마이페이지 메인</a>
            </div>

            <div style="text-align: center;">
                <a href="/user/mypage/confirmPwForm?mode=delete" class="btn-delete">회원 탈퇴를 원하시나요?</a>
            </div>
        </div>
    </div>
</body>
</html>