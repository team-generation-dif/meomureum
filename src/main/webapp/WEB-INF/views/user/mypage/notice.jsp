<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ taglib prefix="c" uri="jakarta.tags.core" %>
<!DOCTYPE html>
<html>
<head>
<meta charset="UTF-8">
<title>마이페이지 - 공지사항</title>
<style>
    .notice-container { width: 800px; margin: 40px auto; font-family: 'Malgun Gothic', sans-serif; }
    .notice-header { border-bottom: 2px solid #333; padding-bottom: 15px; margin-bottom: 30px; }
    .notice-header h2 { margin: 0; color: #2c3e50; }
    
    .notice-item { border-bottom: 1px solid #eee; }
    
    /* 질문(제목) 영역 */
    .notice-q { 
        padding: 20px; cursor: pointer; display: flex; align-items: center; 
        font-size: 16px; font-weight: 500; transition: background 0.2s;
    }
    .notice-q:hover { background: #fcfcfc; }
    
    /* 공지사항 포인트 컬러: 파란색(#3498db) */
    .q-sign { color: #3498db; font-weight: bold; font-size: 20px; margin-right: 15px; }
    .cate { color: #999; font-size: 12px; margin-right: 10px; border: 1px solid #eee; padding: 2px 5px; border-radius: 3px; }
    
    /* 답변(내용) 영역: 기본 숨김 */
    .notice-a { 
        display: none; padding: 25px 25px 25px 55px; 
        background-color: #f9f9f9; color: #666; line-height: 1.8; border-top: 1px solid #f1f1f1;
        white-space: pre-wrap; /* 줄바꿈 유지 */
    }
    
    /* 화살표 애니메이션 */
    .arrow { margin-left: auto; color: #ccc; transition: transform 0.3s; }
    .notice-q.active .arrow { transform: rotate(180deg); color: #3498db; }
</style>
</head>
<body>

<div class="notice-container">
    <div class="notice-header">
        <h2>공지사항</h2>
    </div>

    <div class="notice-list">
        <c:forEach var="notice" items="${noticeList}">
            <div class="notice-item">
                <div class="notice-q" onclick="toggleNotice(this, '${notice.notice_code}')">
                    <span class="q-sign">Q</span>
                    <span class="cate">${notice.notice_category}</span>
                    <span>${notice.notice_title}</span>
                    <span class="arrow">▼</span>
                </div>
                <div id="ans-${notice.notice_code}" class="notice-a">
                    ${notice.notice_content}
                </div>
            </div>
        </c:forEach>
        
        <c:if test="${empty noticeList}">
            <div style="text-align:center; padding:80px 0; color:#bbb;">등록된 공지사항이 없습니다.</div>
        </c:if>
    </div>

    <div style="text-align: center; margin-top: 50px;">
        <a href="/user/mypage/main" style="text-decoration: none; padding: 12px 25px; background: #34495e; color: white; border-radius: 4px; font-weight: bold; font-size: 14px;">
            🏠 메인으로
        </a>
    </div>
</div>

<script>
function toggleNotice(btn, code) {
    // 1. 해당 ID를 가진 답변창 찾기
    var targetAns = document.getElementById('ans-' + code);
    if (!targetAns) return;

    // 2. 현재 열림 상태 확인
    var isOpen = (targetAns.style.display === 'block');

    // 3. 모든 답변창 닫기 및 활성화 클래스 제거
    document.querySelectorAll('.notice-a').forEach(function(el) {
        el.style.display = 'none';
    });
    document.querySelectorAll('.notice-q').forEach(function(el) {
        el.classList.remove('active');
    });

    // 4. 원래 닫혀있었다면 해당 창 열기
    if (!isOpen) {
        targetAns.style.display = 'block';
        btn.classList.add('active');
    }
}
</script>

</body>
</html>