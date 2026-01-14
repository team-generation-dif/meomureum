<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ taglib prefix="c" uri="jakarta.tags.core" %>
<!DOCTYPE html>
<html>
<head>
    <meta charset="UTF-8">
    <title>머무름 - 소개</title>
    <style>
        /* 폰트 및 배경 설정 */
        body {
            background-color: #fcfaff; /* 아주 연한 보라/핑크빛 미색 */
            margin: 0;
            padding: 0;
            font-family: 'Pretendard', 'NanumSquareRound', 'Malgun Gothic', sans-serif;
        }

        .intro-container { 
            max-width: 900px; 
            margin: 100px auto; 
            padding: 0 20px;
            text-align: center; 
        }

        /* 몽글몽글한 히어로 섹션 */
        .hero { 
            background: #ffffff; 
            padding: 80px 40px; 
            /* 1. 아주 둥근 모서리 */
            border-radius: 50px; 
            /* 2. 부드럽고 넓게 퍼지는 그림자 */
            box-shadow: 0 20px 40px rgba(180, 190, 220, 0.2); 
            border: 1px solid rgba(255, 255, 255, 0.8);
            position: relative;
            overflow: hidden;
        }

        /* 배경에 몽글몽글한 장식 요소 추가 (선택사항) */
        .hero::before {
            content: '';
            position: absolute;
            top: -50px;
            left: -50px;
            width: 150px;
            height: 150px;
            background: rgba(178, 226, 242, 0.3); /* 파스텔 블루 */
            border-radius: 50%;
            z-index: 0;
        }

        .hero h1 { 
            color: #74b9ff; /* 부드러운 하늘색 */
            font-size: 2.8rem; 
            margin-bottom: 10px;
            position: relative;
            z-index: 1;
        }

        .hero p { 
            color: #777; 
            font-size: 1.25rem; 
            line-height: 1.8; 
            position: relative;
            z-index: 1;
            word-break: keep-all; /* 한글 줄바꿈을 자연스럽게 */
        }

        .hero strong {
            color: #a29bfe; /* 파스텔 퍼플 */
            font-weight: 700;
        }

        /* 구분선 스타일 */
        .line {
            width: 60px;
            height: 6px;
            background: #ffdae0; /* 파스텔 핑크 */
            border-radius: 10px;
            margin: 30px auto;
            border: none;
        }

        .sub-text {
            font-size: 1rem !important; 
            color: #b2bec3 !important;
            margin-top: 20px;
        }

        /* 마우스 호버 시 살짝 떠오르는 효과 */
        .hero:hover {
            transform: translateY(-8px);
            transition: all 0.4s cubic-bezier(0.175, 0.885, 0.32, 1.275);
            box-shadow: 0 30px 60px rgba(180, 190, 220, 0.3);
        }
    </style>
</head>
<body>
    <jsp:include page="../guest/header.jsp" />

    <div class="intro-container">
        <div class="hero">
            <h1>🏠 기록이 머무는 공간, 머무름</h1>
            <div class="line"></div>
            <p>
                안녕하세요! <strong>머무름</strong>은 당신의 소중한 여정을 기록하고<br>
                효율적인 스케줄 관리를 도와주는 맞춤형 여행 대시보드 서비스입니다.
            </p>
            <p class="sub-text">
                여행을 좋아하는 다른 사람들과 일정을 공유하며,<br>
                보람있는 여행이 되길 기원합니다. 
            </p>
        </div>
    </div>
</body>
</html>