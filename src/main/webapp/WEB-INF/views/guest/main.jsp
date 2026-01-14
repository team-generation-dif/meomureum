<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<%@ taglib prefix="sec" uri="http://www.springframework.org/security/tags" %>
<!DOCTYPE html>
<html>
<head>
    <meta charset="UTF-8">
    <title>머무름 - 당신의 발길이 머무는 곳</title>
    <style>
        /* [1] 기본 셋팅 및 감성 폰트 */
        @import url('https://cdn.jsdelivr.net/gh/orioncactus/pretendard/dist/web/static/pretendard.css');
        
        body { 
            font-family: 'Pretendard', sans-serif; 
            margin: 0; padding: 0; 
            background-color: #fff; 
            color: #333; 
            line-height: 1.6;
        }

        /* [2] 네비게이션 바 (Glassmorphism) */
        .navbar { 
            background: rgba(255, 255, 255, 0.9); 
            backdrop-filter: blur(10px);
            padding: 15px 10%; 
            display: flex; justify-content: space-between; align-items: center; 
            position: sticky; top: 0; z-index: 1000;
            border-bottom: 1px solid #f1f3ff;
        }
        .navbar .logo h2 { margin: 0; color: #a29bfe; font-weight: 900; letter-spacing: -1px; cursor: pointer; }
        .navbar .menu { display: flex; align-items: center; gap: 25px; }
        .navbar a { color: #555; text-decoration: none; font-weight: 600; font-size: 14px; transition: 0.3s; }
        .navbar a:hover { color: #a29bfe; }
        
        .admin-link { color: #6c5ce7 !important; background: #f1f3ff; padding: 8px 15px; border-radius: 12px; }
        .logout-link { color: #ff7675 !important; }

        /* [3] 히어로 섹션 (관광지 컨셉) */
        .hero { 
            background: linear-gradient(135deg, #f8f9ff 0%, #e1e5ff 100%); 
            height: 550px; display: flex; flex-direction: column; justify-content: center; 
            align-items: center; text-align: center; 
            border-bottom-left-radius: 100px; border-bottom-right-radius: 100px;
            box-shadow: inset 0 -30px 50px rgba(162,155,254,0.05);
        }
        .hero h1 { 
            font-size: 3.5rem; color: #2d3436; margin: 0; font-weight: 800;
            animation: fadeInUp 1s ease-out;
        }
        .hero p { 
            font-size: 1.3rem; color: #636e72; margin-top: 25px; 
            animation: fadeInUp 1.2s ease-out;
        }
        .btn-join { 
            background: #a29bfe; color: white; padding: 18px 45px; border-radius: 50px; 
            text-decoration: none; margin-top: 40px; font-weight: 700; font-size: 16px;
            box-shadow: 0 10px 25px rgba(162,155,254,0.4); transition: 0.4s;
            animation: fadeInUp 1.4s ease-out;
        }
        .btn-join:hover { background: #6c5ce7; transform: translateY(-5px); box-shadow: 0 15px 30px rgba(162,155,254,0.5); }

        /* [4] 관광지 카드 섹션 */
        .recommend-section { padding: 100px 10%; text-align: center; }
        .recommend-title { font-size: 32px; font-weight: 800; margin-bottom: 60px; color: #2d3436; }
        .recommend-title span { color: #a29bfe; }

        .card-container { display: grid; grid-template-columns: repeat(3, 1fr); gap: 40px; }
        
        .spot-card {
            background: white; border-radius: 35px; overflow: hidden;
            box-shadow: 0 15px 40px rgba(0,0,0,0.06); border: 1px solid #f1f3ff;
            transition: 0.4s; position: relative;
        }
        .spot-card:hover { transform: translateY(-20px); }
        
        .spot-tag {
            position: absolute; top: 20px; left: 20px;
            background: rgba(162, 155, 254, 0.95); color: white;
            padding: 6px 15px; border-radius: 15px; font-size: 12px; font-weight: bold;
            z-index: 2;
        }
        .spot-img-wrap { width: 100%; height: 300px; overflow: hidden; }
        .spot-img { width: 100%; height: 100%; object-fit: cover; transition: 0.5s; }
        .spot-card:hover .spot-img { scale: 1.1; }

        .spot-info { padding: 30px; text-align: left; }
        .spot-info h4 { margin: 0 0 12px; font-size: 22px; color: #2d3436; font-weight: 700; }
        .spot-info p { color: #7f8c8d; font-size: 15px; margin: 0; display: flex; align-items: center; gap: 6px; }
        .spot-hashtags { margin-top: 15px; font-size: 13px; color: #a29bfe; font-weight: 600; }

        /* [5] 푸터 */
        .footer { background: #fbfbff; padding: 60px 0; text-align: center; color: #b2bec3; font-size: 14px; border-top: 1px solid #f1f3ff; }

        @keyframes fadeInUp {
            from { opacity: 0; transform: translateY(30px); }
            to { opacity: 1; transform: translateY(0); }
        }
    </style>
</head>
<body>

    <nav class="navbar">
        <div class="logo" onclick="location.href='/'"><h2>머무름</h2></div>
        <div class="menu">
            
            <sec:authorize access="isAnonymous()">
                <a href="/guest/loginForm">로그인</a>
                <a href="/guest/join" style="color: #a29bfe;">회원가입</a>
            </sec:authorize>

            <sec:authorize access="isAuthenticated()">
                <span style="font-size: 14px; margin-right: 10px; color: #636e72;">
                    ✨ <b><sec:authentication property="principal.username"/></b>님 환영해요
                </span>
                
                <sec:authorize access="hasAuthority('ADMIN')">
                    <a href="/admin/member/main" class="admin-link">관리자 센터</a>
                </sec:authorize>
                
                <sec:authorize access="hasAuthority('USER')">
                    <a href="/user/mypage/main">마이페이지</a>
                </sec:authorize>
                
                <a href="/logout" class="logout-link">로그아웃</a>
            </sec:authorize>
        </div>
    </nav>

    <div class="hero">
        <h1>어디로 떠나볼까요?<br>발길이 <span>머무는</span> 모든 순간</h1>
        <p>대한민국 구석구석, 당신만을 위한 숨은 관광지를 추천해 드립니다.</p>
        
        <sec:authorize access="isAnonymous()">
            <a href="/guest/join" class="btn-join">바로 회원가입하러가기</a>
        </sec:authorize>
    </div>

    <div class="recommend-section">
        <div class="recommend-title">📍 지금 떠나기 좋은 <span>추천 관광지</span></div>
        <div class="card-container">
            
           <div class="spot-card">
    <span class="spot-tag">#풍경명소</span>
    <div class="spot-img-wrap">
        <img src="https://images.unsplash.com/photo-1541014163200-349092658826?auto=format&fit=crop&w=800&q=80" 
             class="spot-img" 
             alt="제주 종달리 수국길"
             onerror="this.src='https://images.unsplash.com/photo-1506744038136-46273834b3fb?auto=format&fit=crop&w=800&q=80';">
    </div>
    <div class="spot-info">
        <h4>제주 종달리 수국길</h4>
        <p>📍 제주특별자치도 제주시 구좌읍</p>
        <div class="spot-hashtags">#여름여행 #꽃구경 #인생샷</div>
    </div>
</div>

            <div class="spot-card">
                <span class="spot-tag">#역사탐방</span>
                <div class="spot-img-wrap">
                    <img src="https://images.unsplash.com/photo-1548115184-bc6544d06a58?w=600&q=80" class="spot-img" alt="경주 첨성대">
                </div>
                <div class="spot-info">
                    <h4>경주 대릉원 & 첨성대</h4>
                    <p>📍 경상북도 경주시 황남동</p>
                    <div class="spot-hashtags">#야경명소 #가족여행 #전통문화</div>
                </div>
            </div>

            <div class="spot-card">
                <span class="spot-tag">#야경맛집</span>
                <div class="spot-img-wrap">
                    <img src="https://images.unsplash.com/photo-1540959733332-eab4deabeeaf?w=600&q=80" class="spot-img" alt="해운대">
                </div>
                <div class="spot-info">
                    <h4>부산 해운대 더베이 101</h4>
                    <p>📍 부산광역시 해운대구</p>
                    <div class="spot-hashtags">#도심야경 #데이트코스 #바다산책</div>
                </div>
            </div>

        </div>
    </div>

    <footer class="footer">
        <div style="font-weight: 800; color: #a29bfe; font-size: 18px; margin-bottom: 20px;">머무름</div>
        <div>(주)머무름  |  사업자등록번호: 123-45-67890  |  서울시 강남구 테헤란로</div>
        <p style="margin-top: 15px;">&copy; 2026 Meomureum. All rights reserved.</p>
    </footer>

</body>
</html>