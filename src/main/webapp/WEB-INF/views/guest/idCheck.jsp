<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<!DOCTYPE html>
<html>
<head>
<meta charset="UTF-8">
<title>아이디 중복 확인 - 머무름</title>
<style>
    /* [1] 기본 레이아웃 및 폰트 */
    body { 
        background-color: #f8f9ff; margin: 0; padding: 0;
        font-family: 'Malgun Gothic', sans-serif; 
        display: flex; flex-direction: column; align-items: center; justify-content: center;
        height: 100vh;
    }
    .check-container {
        background: white; width: 85%; max-width: 320px; padding: 30px;
        border-radius: 30px; box-shadow: 0 10px 30px rgba(162,155,254,0.1);
        border: 1px solid #f1f3ff;
    }

    h3 { color: #2d3436; font-size: 20px; margin-top: 0; margin-bottom: 20px; letter-spacing: -1px; }

    /* [2] 검색 영역 */
    .search-box { margin-bottom: 25px; display: flex; gap: 8px; }
    input[type="text"] {
        flex: 1; padding: 12px 15px; border: 1px solid #f1f3ff; border-radius: 15px;
        background: #fafaff; font-size: 14px; outline: none; transition: 0.3s;
    }
    input[type="text"]:focus { border-color: #a29bfe; background: white; }
    
    .btn-search {
        background: #a29bfe; color: white; border: none; padding: 0 15px;
        border-radius: 12px; font-weight: bold; cursor: pointer; transition: 0.3s;
    }
    .btn-search:hover { background: #6c5ce7; }

    /* [3] 결과 메시지 및 버튼 */
    .res-msg { margin-bottom: 25px; min-height: 50px; font-size: 14px; line-height: 1.6; }
    .status-icon { font-size: 24px; display: block; margin-bottom: 10px; }
    
    .btn-use {
        width: 100%; padding: 14px; background: #2d3436; color: white;
        border: none; border-radius: 15px; font-weight: bold; cursor: pointer;
        font-size: 14px; transition: 0.3s;
    }
    .btn-use:hover { background: #a29bfe; transform: translateY(-2px); box-shadow: 0 5px 15px rgba(162,155,254,0.3); }

    .msg-blue { color: #6c5ce7; font-weight: bold; }
    .msg-red { color: #ff7675; font-weight: bold; }
</style>
</head>
<body>

<div class="check-container">
    <h3>🔍 아이디 중복 확인</h3>
    
    <div class="search-box">
        <form action="/guest/idCheck" method="get" style="display: flex; width: 100%; gap: 5px;">
            <input type="text" name="m_id" value="${m_id}" placeholder="아이디를 입력하세요" required autofocus>
            <button type="submit" class="btn-search">검색</button>
        </form>
    </div>

    <div class="res-msg">
        <c:if test="${not empty m_id}">
            <c:choose>
                <c:when test="${result == 0}">
                    <span class="status-icon">✅</span>
                    <span class="msg-blue">[${m_id}]</span>은(는)<br>사용 가능한 멋진 아이디예요!
                </c:when>
                <c:otherwise>
                    <span class="status-icon">❌</span>
                    <span class="msg-red">이미 사용 중인 아이디입니다.</span><br>다른 아이디를 입력해볼까요?
                </c:otherwise>
            </c:choose>
        </c:if>
        <c:if test="${empty m_id}">
            <p style="color: #ccc;">아이디를 입력하고<br>중복 여부를 확인해 보세요.</p>
        </c:if>
    </div>

    <c:if test="${result == 0 and not empty m_id}">
        <button type="button" class="btn-use" onclick="fn_sendId('${m_id}')">이 아이디 사용하기</button>
    </c:if>
</div>

<script>
    function fn_sendId(id) {
        // 부모창(join.jsp)에 아이디 전달 및 상태 변경
        if (window.opener && !window.opener.closed) {
            window.opener.document.getElementById("m_id").value = id;
            
            // 회원가입 폼의 제출 버튼 활성화 및 메시지 업데이트
            const submitBtn = window.opener.document.getElementById("submitBtn");
            const idMsg = window.opener.document.getElementById("id_msg");
            
            if (submitBtn) submitBtn.disabled = false;
            if (idMsg) {
                idMsg.innerText = "사용 가능한 아이디입니다.";
                idMsg.style.color = "#6c5ce7";
                idMsg.style.fontWeight = "bold";
            }
        }
        window.close(); // 팝업 닫기
    }
</script>

</body>
</html>