<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<!DOCTYPE html>
<html>
<head>
<meta charset="UTF-8">
<title>아이디 중복 확인</title>
<style>
    body { font-family: sans-serif; text-align: center; padding-top: 50px; }
    .search-box { margin-bottom: 20px; }
    .res-msg { margin-bottom: 20px; font-weight: bold; }
    button { cursor: pointer; padding: 5px 10px; }
</style>
</head>
<body>
    <h3>아이디 중복 확인</h3>
    <div class="search-box">
        <form action="/guest/idCheck" method="get">
            <input type="text" name="m_id" value="${m_id}" placeholder="아이디 입력" required>
            <button type="submit">검색</button>
        </form>
    </div>

    <div class="res-msg">
        <c:if test="${not empty m_id}">
            <c:choose>
                <c:when test="${result == 0}">
                    <span style="color:blue;">[${m_id}]는 사용 가능합니다.</span><br><br>
                    <button type="button" onclick="fn_sendId('${m_id}')">이 아이디 사용</button>
                </c:when>
                <c:otherwise>
                    <span style="color:red;">이미 사용 중인 아이디입니다.</span>
                </c:otherwise>
            </c:choose>
        </c:if>
    </div>

    <script>
        function fn_sendId(id) {
            // 부모창(join.jsp)에 아이디 전달 및 버튼 활성화
            opener.document.getElementById("m_id").value = id;
            opener.document.getElementById("submitBtn").disabled = false;
            opener.document.getElementById("id_msg").innerText = "아이디 확인 완료";
            opener.document.getElementById("id_msg").style.color = "blue";
            window.close(); // 팝업 닫기
        }
    </script>
</body>
</html>