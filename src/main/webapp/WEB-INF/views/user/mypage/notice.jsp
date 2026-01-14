<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ taglib prefix="c" uri="jakarta.tags.core" %>
<!DOCTYPE html>
<html>
<head>
<meta charset="UTF-8">
<title>머무름 - 공지사항</title>
<style>
    /* [1] 기본 레이아웃 */
    body { background-color: #ffffff; margin: 0; font-family: 'Malgun Gothic', sans-serif; color: #333; }
    .notice-container { width: 900px; margin: 60px auto; padding: 0 20px; }

    /* [2] 상단 헤더: 서비스 감성 */
    .notice-header { text-align: center; margin-bottom: 50px; }
    .notice-header h2 { font-size: 32px; color: #2d3436; font-weight: bold; margin-bottom: 10px; }
    .notice-header p { color: #a2a2a2; font-size: 15px; }
    .header-line { width: 40px; height: 3px; background: #a29bfe; margin: 20px auto; border-radius: 2px; }
    
    /* [3] 공지사항 리스트 디자인 */
    .notice-list { border-top: 2px solid #2d3436; }
    .notice-item { border-bottom: 1px solid #f1f3ff; }
    
    /* 질문(제목) 영역 */
    .notice-q { 
        padding: 25px 20px; cursor: pointer; display: flex; align-items: center; 
        font-size: 17px; font-weight: 500; transition: 0.3s;
        background: #fff;
    }
    .notice-q:hover { background: #fafaff; }
    
    /* 포인트 컬러 및 뱃지 */
    .q-sign { color: #a29bfe; font-weight: bold; font-size: 18px; margin-right: 20px; font-family: 'Arial'; }
    
    .cate { 
        font-size: 11px; font-weight: bold; color: #a29bfe; 
        background: #f1f3ff; padding: 4px 10px; border-radius: 20px; 
        margin-right: 15px; text-transform: uppercase;
    }
    
    /* 답변(내용) 영역 */
    .notice-a { 
        display: none; padding: 35px 40px 35px 75px; 
        background-color: #fcfcfd; color: #555; line-height: 1.9; 
        border-top: 1px solid #f8f9ff;
        white-space: pre-wrap; font-size: 15px;
    }
    
    /* 화살표 아이콘 */
    .arrow { 
        margin-left: auto; width: 24px; height: 24px; 
        display: flex; align-items: center; justify-content: center;
        color: #ddd; transition: 0.3s; font-size: 12px;
    }
    .notice-q.active { color: #a29bfe; background: #fafaff; }
    .notice-q.active .arrow { transform: rotate(180deg); color: #a29bfe; }

    /* [4] 하단 버튼 */
    .footer-area { text-align: center; margin-top: 60px; }
    .btn-home { 
        display: inline-block; text-decoration: none; padding: 15px 40px; 
        background: #2d3436; color: white; border-radius: 30px; 
        font-weight: bold; font-size: 14px; transition: 0.3s;
        box-shadow: 0 10px 20px rgba(0,0,0,0.1);
    }
    .btn-home:hover { background: #a29bfe; transform: translateY(-3px); box-shadow: 0 10px 20px rgba(162,155,254,0.3); }

    /* 텅 빈 상태 */
    .empty-msg { text-align: center; padding: 100px 0; color: #ccc; font-size: 16px; }
</style>
</head>
<body>

<div class="notice-container">
    <div class="notice-header">
        <p>STAY MEOMUREUM</p>
        <h2>공지사항</h2>
        <div class="header-line"></div>
    </div>

    <div class="notice-list">
        <c:forEach var="notice" items="${noticeList}">
            <div class="notice-item">
                <div class="notice-q" onclick="toggleNotice(this, '${notice.notice_code}')">
                    <span class="q-sign">NOTICE</span>
                    <span class="cate">${notice.notice_category}</span>
                    <span class="title-text">${notice.notice_title}</span>
                    <span class="arrow">▼</span>
                </div>
                <div id="ans-${notice.notice_code}" class="notice-a">
                    ${notice.notice_content}
                </div>
            </div>
        </c:forEach>
        
        <c:if test="${empty noticeList}">
            <div class="empty-msg">
                <img src="https://cdn-icons-png.flaticon.com/512/7486/7486744.png" width="50" style="opacity: 0.2; margin-bottom: 20px;"><br>
                등록된 새 소식이 없습니다.
            </div>
        </c:if>
    </div>

    <div class="footer-area">
        <a href="/user/mypage/main" class="btn-home">
            🏠 마이페이지로 돌아가기
        </a>
    </div>
</div>

<script>
function toggleNotice(btn, code) {
    var targetAns = document.getElementById('ans-' + code);
    if (!targetAns) return;

    var isOpen = (targetAns.style.display === 'block');

    // 모든 공지 닫기
    document.querySelectorAll('.notice-a').forEach(function(el) {
        el.style.display = 'none';
    });
    document.querySelectorAll('.notice-q').forEach(function(el) {
        el.classList.remove('active');
    });

    // 클릭한 공지만 열기
    if (!isOpen) {
        targetAns.style.display = 'block';
        btn.classList.add('active');
    }
}
</script>

</body>
</html>