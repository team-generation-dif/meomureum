<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<script>
    alert("${msg}"); // 컨트롤러에서 보낸 메시지 출력
    location.href = "${url}"; // 지정된 페이지로 이동
</script>