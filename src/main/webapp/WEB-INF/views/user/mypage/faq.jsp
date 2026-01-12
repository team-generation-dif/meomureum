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
    .faq-q { 
        padding: 20px; cursor: pointer; display: flex; align-items: center; 
        font-size: 16px; font-weight: 500;
    }
    .faq-q:hover { background: #fcfcfc; }
    .q-sign { color: #4CAF50; font-weight: bold; font-size: 20px; margin-right: 15px; }
    .cate { color: #999; font-size: 12px; margin-right: 10px; border: 1px solid #eee; padding: 2px 5px; }
    
    .faq-a { 
        display: none; padding: 20px 20px 20px 55px; 
        background-color: #f9f9f9; color: #666; line-height: 1.6; border-top: 1px solid #f1f1f1;
    }
    .arrow { margin-left: auto; color: #ccc; }
    .active .arrow { transform: rotate(180deg); color: #4CAF50; }
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
</div>

<script>
function toggleFaq(btn, code) {
    const ans = document.getElementById('ans-' + code);
    const isOpen = ans.style.display === 'block';

    // 다른 답변들 닫기
    document.querySelectorAll('.faq-a').forEach(el => el.style.display = 'none');
    document.querySelectorAll('.faq-q').forEach(el => el.classList.remove('active'));

    if (!isOpen) {
        ans.style.display = 'block';
        btn.classList.add('active');
    }
}
</script>

</body>
</html>