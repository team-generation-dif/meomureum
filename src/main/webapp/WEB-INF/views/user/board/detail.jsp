<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ taglib uri="http://java.sun.com/jsp/jstl/core" prefix="c" %>
<%@ taglib uri="http://java.sun.com/jsp/jstl/fmt" prefix="fmt" %>
<!DOCTYPE html>
<html>
<head>
<meta charset="UTF-8">
<title>게시글 상세보기</title>

<link href="https://stackpath.bootstrapcdn.com/bootstrap/3.4.1/css/bootstrap.min.css" rel="stylesheet">
<script src="https://code.jquery.com/jquery-3.5.1.min.js"></script>
<script src="https://stackpath.bootstrapcdn.com/bootstrap/3.4.1/js/bootstrap.min.js"></script>

<style>
    .container { max-width: 900px; margin-top: 30px; }
    .board-box { padding: 20px; background: #f9f9f9; border: 1px solid #ddd; border-radius: 5px; }
    .reply-box { margin-top: 40px; }
    .reply-item { border-bottom: 1px solid #eee; padding: 10px 0; }
    .reply-meta { font-size: 13px; color: #888; margin-bottom: 5px; }
    .reply-content { font-size: 15px; }
</style>
</head>
<body>

<div class="container">
    <h3><span class="glyphicon glyphicon-file"></span> 게시글 상세보기</h3>

    <!-- 게시글 내용 -->
    <div class="board-box">
        <p><strong>분류:</strong> ${board.b_category}</p>
        <p><strong>제목:</strong> ${board.b_title}</p>
        <p><strong>작성일:</strong> <fmt:formatDate value="${board.created_at}" pattern="yyyy-MM-dd"/></p>
        <p><strong>조회수:</strong> ${board.b_view}</p>
        <hr>
        <p>${board.b_content}</p>
    </div>

    <!-- 댓글 작성 -->
    <div class="reply-box">
        <h4>댓글 작성</h4>
        <form method="post" action="/user/board/reply/write">
            <input type="hidden" name="b_code" value="${board.b_code}">
            <textarea name="re_content" rows="3" style="width:100%;" placeholder="댓글을 입력하세요" required></textarea>
            <div style="margin-top:10px;">
                <label><input type="checkbox" name="re_secret" value="Y"> 비밀댓글</label>
            </div>
            <div style="margin-top:10px; text-align:right;">
                <input type="submit" value="댓글 등록" class="btn btn-sm btn-primary">
            </div>
        </form>
    </div>

    <!-- 댓글 목록 -->
    <div class="reply-box">
        <h4>댓글 목록</h4>
        <c:forEach var="reply" items="${replyList}">
            <div class="reply-item">
                <div class="reply-meta">
                    <strong>${reply.re_code}</strong> | 
                    <fmt:formatDate value="${reply.created_at}" pattern="yyyy-MM-dd HH:mm"/>
                </div>
                <div class="reply-content">
                    <c:choose>
                        <c:when test="${reply.re_secret eq 'Y'}">
                            <em>비밀댓글입니다.</em>
                        </c:when>
                        <c:otherwise>
                            ${reply.re_content}
                        </c:otherwise>
                    </c:choose>
                </div>
            </div>
        </c:forEach>
    </div>

    <!-- 목록으로 버튼 -->
    <div style="margin-top: 30px; text-align: right;">
        <a href="/user/board/list" class="btn btn-default">목록으로</a>
    </div>
</div>

</body>
</html>