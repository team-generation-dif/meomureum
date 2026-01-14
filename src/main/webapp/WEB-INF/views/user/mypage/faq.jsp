<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ taglib prefix="c" uri="jakarta.tags.core" %>
<!DOCTYPE html>
<html>
<head>
<meta charset="UTF-8">
<title>마이페이지 - FAQ</title>
<style>
    .faq-container { width: 800px; margin: 40px auto; font-family: 'Malgun Gothic', sans-serif; }
    .faq-header { border-bottom: 2px solid #333; padding-bottom: 15px; margin-bottom: 30px; }
    .faq-item { border-bottom: 1px solid #eee; }
    
    /* 질문 영역 */
    .faq-q { padding: 20px; cursor: pointer; display: flex; align-items: center; font-size: 16px; font-weight: 500; transition: background 0.2s; }
    .faq-q:hover { background: #fcfcfc; }
    .q-sign { color: #4CAF50; font-weight: bold; font-size: 20px; margin-right: 15px; }
    .cate { color: #999; font-size: 12px; margin-right: 10px; border: 1px solid #eee; padding: 2px 5px; border-radius: 3px; }
    
    /* 답변 영역 (기본 숨김) */
    .faq-a { 
        display: none; padding: 20px 20px 20px 55px; 
        background-color: #f9f9f9; color: #666; line-height: 1.6; border-top: 1px solid #f1f1f1;
        white-space: pre-wrap; /* 줄바꿈 허용 */
    }
    
    .arrow { margin-left: auto; color: #ccc; transition: 0.3s; }
    .faq-q.active .arrow { transform: rotate(180deg); color: #4CAF50; }
</style>
</head>
<body>

<div class="faq-container">
    <div class="faq-header">
        <h2>자주 묻는 질문 (FAQ)</h2>
    </div>

    <div class="faq-list">
        <c:forEach var="faq" items="${faqList}">
            <div class="faq-item">
                <div class="faq-q" onclick="toggleFaq(this, '${faq.faq_code}')">
                    <span class="q-sign">Q</span>
                    <span class="cate">${faq.faq_category}</span>
                    <span>${faq.faq_title}</span>
                    <span class="arrow">▼</span>
                </div>
                <div id="ans-${faq.faq_code}" class="faq-a">
                    ${faq.faq_content}
                </div>
            </div>
        </c:forEach>
        
        <c:if test="${empty faqList}">
            <div style="text-align:center; padding:80px 0; color:#bbb;">등록된 질문이 없습니다.</div>
        </c:if>
    </div>

    <div style="text-align: center; margin-top: 50px;">
        <a href="/user/mypage/main" style="text-decoration: none; padding: 10px 20px; background: #34495e; color: white; border-radius: 4px; font-weight: bold; font-size: 14px;">
            🏠 메인으로
        </a>
    </div>
</div>

<script>
function toggleFaq(btn, code) {
    // 1. 클릭한 질문에 해당하는 답변창 찾기
    var targetAns = document.getElementById('ans-' + code);
    if (!targetAns) return; // 요소를 찾지 못하면 함수 종료

    // 2. 현재 열려있는지 확인
    var isOpen = (targetAns.style.display === 'block');

    // 3. 모든 답변창을 닫고, 모든 질문의 active 클래스 제거 (하나만 열리게 함)
    document.querySelectorAll('.faq-a').forEach(function(el) {
        el.style.display = 'none';
    });
    document.querySelectorAll('.faq-q').forEach(function(el) {
        el.classList.remove('active');
    });

    // 4. 원래 닫혀있었다면 해당 답변창만 열기
    if (!isOpen) {
        targetAns.style.display = 'block';
        btn.classList.add('active');
    }
}
</script>

</body>
</html>