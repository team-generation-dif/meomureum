<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ taglib prefix="c" uri="jakarta.tags.core" %>
<!DOCTYPE html>
<html>
<head>
<meta charset="UTF-8">
<title>FAQ 관리자 - 머무름</title>
<style>
    .container { width: 1000px; margin: 40px auto; font-family: 'Malgun Gothic', sans-serif; }
    .title-area { border-bottom: 2px solid #333; padding-bottom: 10px; margin-bottom: 30px; }
    .reg-box { background: #f9f9f9; padding: 25px; border-radius: 8px; border: 1px solid #ddd; margin-bottom: 40px; }
    .reg-box h4 { margin-top: 0; color: #4CAF50; }
    
    table { width: 100%; border-collapse: collapse; }
    th { background: #f4f4f4; padding: 12px; border: 1px solid #ddd; }
    td { padding: 12px; border: 1px solid #ddd; text-align: center; }
    
    .form-control { width: 100%; padding: 10px; margin-bottom: 10px; border: 1px solid #ccc; border-radius: 4px; box-sizing: border-box; }
    .btn-submit { width: 100%; padding: 12px; background: #4CAF50; color: white; border: none; border-radius: 4px; cursor: pointer; font-size: 16px; }
    .btn-del { background: #e74c3c; color: white; border: none; padding: 6px 12px; border-radius: 4px; cursor: pointer; }
	/* 관리자 메인 이동 버튼 스타일 */
	.btn-home {
	    text-decoration: none;
	    padding: 10px 20px;
	    background: #34495e;
	    color: white;
	    border-radius: 4px;
	    font-weight: bold;
	    transition: background 0.3s;
	}
	.btn-home:hover {
	    background: #2c3e50;
	    color: #ecf0f1;
	}
</style>
</head>
<body>
<div class="container">
    <div class="title-area" style="display: flex; justify-content: space-between; align-items: center;">
        <h2>⚙️ 자주 묻는 질문(FAQ) 관리</h2>
        <a href="/admin/member/memberList" style="text-decoration: none; padding: 10px 20px; background: #34495e; color: white; border-radius: 4px; font-weight: bold; font-size: 14px;">
            🏠 메인으로
        </a>
    </div>
    <div class="reg-box">        <h4>[신규 FAQ 등록]</h4>
        <form action="/admin/faq/insert" method="post">
            <input type="hidden" name="${_csrf.parameterName}" value="${_csrf.token}" />
            
            <select name="faq_category" class="form-control" style="width: 150px;">
                <option value="회원가입">회원가입</option>
                <option value="등급">등급</option>
                <option value="커뮤니티">커뮤니티</option>
                <option value="신고">신고</option>
            </select>
            
            <input type="text" name="faq_title" class="form-control" placeholder="질문 내용을 입력하세요" required>
            <textarea name="faq_content" class="form-control" style="height: 120px;" placeholder="답변 내용을 입력하세요" required></textarea>
            
            <button type="submit" class="btn-submit">FAQ 등록하기</button>
        </form>
    </div>

    <h4>[등록된 FAQ 리스트]</h4>
    <table>
        <thead>
            <tr>
                <th width="10%">카테고리</th>
                <th width="50%">질문(Title)</th>
                <th width="15%">등록일</th>
                <th width="10%">관리</th>
            </tr>
        </thead>
        <tbody>
            <c:if test="${empty faqList}">
                <tr><td colspan="4">등록된 FAQ가 없습니다.</td></tr>
            </c:if>
            <c:forEach var="faq" items="${faqList}">
                <tr>
                    <td><b>${faq.faq_category}</b></td>
                    <td style="text-align: left;">${faq.faq_title}</td>
                    <td>${faq.created_at}</td>
                    <td>
                        <form action="/admin/faq/delete" method="post" onsubmit="return confirm('정말 삭제하시겠습니까?');">
                            <input type="hidden" name="${_csrf.parameterName}" value="${_csrf.token}" />
                            <input type="hidden" name="faq_code" value="${faq.faq_code}">
                            <button type="submit" class="btn-del">삭제</button>
                        </form>
                    </td>
                </tr>
            </c:forEach>
        </tbody>
    </table>
</div>

</body>
</html>