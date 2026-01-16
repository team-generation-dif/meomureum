<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ taglib prefix="c" uri="jakarta.tags.core" %>
<!DOCTYPE html>
<html>
<head>
<meta charset="UTF-8">
<title>머무름 - FAQ</title>
<style>
    /* [1] 기본 레이아웃 및 폰트 */
    body { background-color: #ffffff; margin: 0; font-family: 'Malgun Gothic', sans-serif; color: #333; }
    .faq-container { width: 900px; margin: 60px auto; padding: 0 20px; }

    /* [2] 상단 헤더: 서비스 감성 */
    .faq-header { text-align: center; margin-bottom: 50px; }
    .faq-header h2 { font-size: 32px; color: #2d3436; font-weight: bold; margin-bottom: 10px; }
    .faq-header p { color: #a2a2a2; font-size: 15px; }
    .header-line { width: 40px; height: 3px; background: #a29bfe; margin: 20px auto; border-radius: 2px; }
    
    /* [3] FAQ 리스트 디자인 */
    .faq-list { border-top: 2px solid #2d3436; }
    .faq-item { border-bottom: 1px solid #f1f3ff; }
    
    /* 질문 영역 (Accordion Header) */
    .faq-q { 
        padding: 25px 20px; cursor: pointer; display: flex; align-items: center; 
        font-size: 17px; font-weight: 500; transition: 0.3s;
        background: #fff;
    }
    .faq-q:hover { background: #fafaff; }
    
    /* Q 아이콘 및 뱃지 */
    .q-sign { 
        color: #a29bfe; font-weight: bold; font-size: 22px; 
        margin-right: 20px; font-family: 'Arial'; opacity: 0.6;
    }
    .cate { 
        font-size: 11px; font-weight: bold; color: #a29bfe; 
        background: #f1f3ff; padding: 4px 12px; border-radius: 20px; 
        margin-right: 15px; text-transform: uppercase;
        white-space: nowrap;
    }
    
    /* 답변 영역 (Accordion Body) */
    .faq-a { 
        display: none; padding: 35px 40px 35px 85px; 
        background-color: #fcfcfd; color: #666; line-height: 1.9; 
        border-top: 1px solid #f8f9ff;
        white-space: pre-wrap; font-size: 15px;
        position: relative;
    }
    /* 답변 영역에 A 표시 (가상 요소) */
    .faq-a::before {
        content: 'A'; position: absolute; left: 40px; top: 35px;
        color: #a29bfe; font-weight: bold; font-size: 22px; opacity: 0.3;
    }
    
    /* 화살표 애니메이션 */
    .arrow { 
        margin-left: auto; width: 24px; height: 24px; 
        display: flex; align-items: center; justify-content: center;
        color: #ddd; transition: 0.3s; font-size: 12px;
    }
    .faq-q.active { color: #a29bfe; background: #fafaff; }
    .faq-q.active .arrow { transform: rotate(180deg); color: #a29bfe; }

    /* [4] 하단 홈 버튼 */
    .footer-area { text-align: center; margin-top: 60px; }
    .btn-home { 
        display: inline-block; text-decoration: none; padding: 15px 45px; 
        background: #2d3436; color: white; border-radius: 35px; 
        font-weight: bold; font-size: 14px; transition: 0.3s;
        box-shadow: 0 10px 20px rgba(0,0,0,0.1);
    }
    .btn-home:hover { background: #a29bfe; transform: translateY(-3px); box-shadow: 0 10px 20px rgba(162,155,254,0.3); }

    /* 검색 결과 없음 */
    .empty-msg { text-align: center; padding: 100px 0; color: #ccc; }
</style>
</head>
<body>

<div class="faq-container">
    <div class="faq-header">
        <p>STAY MEOMUREUM SUPPORT</p>
        <h2>자주 묻는 질문</h2>
        <div class="header-line"></div>
    </div>

    <div class="faq-list">
        <c:forEach var="faq" items="${faqList}">
            <div class="faq-item">
                <div class="faq-q" onclick="toggleFaq(this, '${faq.faq_code}')">
                    <span class="q-sign">Q</span>
                    <span class="cate">${faq.faq_category}</span>
                    <span class="title-text">${faq.faq_title}</span>
                    <span class="arrow">▼</span>
                </div>
                <div id="ans-${faq.faq_code}" class="faq-a">
                    ${faq.faq_content}
                </div>
            </div>
        </c:forEach>
        
        <c:if test="${empty faqList}">
            <div class="empty-msg">
                <img src="https://cdn-icons-png.flaticon.com/512/7486/7486744.png" width="50" style="opacity: 0.2; margin-bottom: 20px;"><br>
                궁금해하실 정보들을 준비 중입니다.
            </div>
        </c:if>
    </div>

    <div class="footer-area">
        <a href="/user/mypage/main" class="btn-home">
            🏠 메인으로 이동
        </a>
    </div>
</div>

<script>
function toggleFaq(btn, code) {
    var targetAns = document.getElementById('ans-' + code);
    if (!targetAns) return;

    var isOpen = (targetAns.style.display === 'block');

    // 하나만 열리도록 모든 답변창 닫기
    document.querySelectorAll('.faq-a').forEach(function(el) {
        el.style.display = 'none';
    });
    document.querySelectorAll('.faq-q').forEach(function(el) {
        el.classList.remove('active');
    });

    // 클릭한 질문만 열기
    if (!isOpen) {
        targetAns.style.display = 'block';
        btn.classList.add('active');
    }
}
</script>

</body>
</html>