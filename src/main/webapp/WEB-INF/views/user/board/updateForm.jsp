<%@ page language="java" contentType="text/html; charset=UTF-8"
    pageEncoding="UTF-8"%>
<%@ taglib uri="http://java.sun.com/jsp/jstl/core" prefix="c" %>
<!DOCTYPE html>
<html>
<head>
<meta charset="UTF-8">
<title>게시글 수정</title>
</head>
<body>
    <h3>게시글 수정</h3>
    <form method="post" action="/user/board/update">
        <!-- 수정 대상 글 코드 -->
        <input type="hidden" name="b_code" value="${board.b_code}">

        <table border="1" width="800">
            <tr>
                <td>분류</td>
                <td>
                    <input type="radio" name="b_category" value="정보"
                        <c:if test="${board.b_category eq '정보'}">checked</c:if>> 정보공유
                    <input type="radio" name="b_category" value="동행"
                        <c:if test="${board.b_category eq '동행'}">checked</c:if>> 동행
                    <input type="radio" name="b_category" value="후기"
                        <c:if test="${board.b_category eq '후기'}">checked</c:if>> 후기
                </td>
            </tr>
            <tr>
                <td>제목</td>
                <td><input type="text" name="b_title" value="${board.b_title}" required></td>
            </tr>
            <tr>
                <td>내용</td>
                <td><textarea name="b_content" rows="10" cols="70" required>${board.b_content}</textarea></td>
            </tr>
        </table>
        <br>
        <input type="submit" value="수정">
        <input type="reset" value="초기화">
        <a href="/user/board/list">목록으로</a>
    </form>
</body>
</html>
