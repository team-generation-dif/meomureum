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
    .reply-content { font-size: 15px; flex-grow: 1; }
    .reply-actions { margin-left: 10px; }
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
    
    <!-- 게시글 수정/삭제 버튼 -->
    <c:if test="${board.m_code eq sessionScope.m_code or sessionScope.loginRole eq 'ADMIN'}">
        <div style="margin-top:20px; text-align:right;">
            <a href="/user/board/updateForm/${board.b_code}" class="btn btn-warning">게시글 수정</a>
            <a href="/user/board/delete/${board.b_code}" class="btn btn-danger">게시글 삭제</a>
        </div>
    </c:if>
    
    <!-- 게시글 신고 버튼 -->
    <button type="button" class="btn btn-danger btn-sm"
            onclick="openReportForm('BOARD', '${board.b_code}')">
        게시글 신고
    </button>

    <!-- 댓글 작성 -->
    <div class="reply-box">
        <h4>댓글 작성</h4>
        <c:choose>
            <c:when test="${not empty pageContext.request.userPrincipal}">
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
            </c:when>
            <c:otherwise>
                <div class="alert alert-info" style="margin-top:10px;">
                    댓글을 작성하려면 로그인하세요.
                    <a href="/guest/loginForm" class="btn btn-xs btn-primary" style="margin-left:10px;">로그인</a>
                </div>
            </c:otherwise>
        </c:choose>
    </div>

    <!-- 댓글 목록 -->
    <div class="reply-box">
        <h4>댓글 목록</h4>
        <c:forEach var="reply" items="${replyList}">
            <div class="reply-item">
                <div class="reply-meta">
                    <strong>${reply.m_nick}</strong> |  
                    <fmt:formatDate value="${reply.created_at}" pattern="yyyy-MM-dd HH:mm"/>
                </div>

                <!-- 댓글 내용 + 버튼 나란히 -->
                <div style="display:flex; justify-content:space-between; align-items:center;">
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

                    <!-- 버튼 영역 -->
                    <div class="reply-actions">
                        <button type="button" class="btn btn-primary btn-xs"
                                onclick="toggleEdit('${reply.re_code}')">수정</button>

                        <button type="button" class="btn btn-danger btn-xs"
        						onclick="deleteReply('${reply.re_code}', '${board.b_code}')">삭제</button>

						<script>
						function deleteReply(reCode, bCode) {
    						if(confirm("정말 이 댓글을 삭제하시겠습니까?")) {
        						location.href = "/user/board/reply/delete/" + reCode + "/" + bCode;
   							 }
						}
						</script>
						                                
                        <button type="button" class="btn btn-warning btn-xs"
                                onclick="openReportForm('REPLY', '${reply.re_code}')">댓글 신고</button>
                    </div>
                </div>

                <!-- 숨겨진 수정 폼 -->
                <div id="editForm-${reply.re_code}" style="display:none; margin-top:10px;">
                    <form method="post" action="/user/board/reply/update">
                        <input type="hidden" name="re_code" value="${reply.re_code}">
                        <input type="hidden" name="b_code" value="${board.b_code}">
                        <textarea name="re_content" rows="2" style="width:100%">${reply.re_content}</textarea>
                        <div style="margin-top:5px;">
                            <label><input type="checkbox" name="re_secret" value="Y"
                                <c:if test="${reply.re_secret eq 'Y'}">checked</c:if>> 비밀댓글</label>
                        </div>
                        <div style="margin-top:5px; text-align:right;">
                            <input type="submit" value="댓글 수정" class="btn btn-sm btn-primary">
                        </div>
                    </form>
                </div>
            </div>
        </c:forEach>
    </div>

    <!-- 신고 모달 -->
    <div id="reportModal" class="modal" style="display:none;">
        <div class="modal-content">
            <h4>신고하기</h4>
            <form id="reportForm" method="post" action="/report/submit">
                <input type="hidden" name="rep_category" id="rep_category">
                <input type="hidden" name="target_code" id="target_code">

                <div class="form-group">
                    <label for="rep_title">제목</label>
                    <input type="text" name="rep_title" id="rep_title" class="form-control" required>
                </div>

                <div class="form-group">
                    <label for="rep_content">내용</label>
                    <textarea name="rep_content" id="rep_content" class="form-control" required></textarea>
                </div>

                <button type="submit" class="btn btn-danger">신고 제출</button>
                <button type="button" class="btn btn-secondary" onclick="closeReportForm()">취소</button>
            </form>
        </div>
    </div>

    <!-- 목록으로 버튼 -->
    <div style="margin-top: 30px; text-align: right;">
        <a href="/user/board/list" class="btn btn-default">목록으로</a>
    </div>
</div>

<script>
function toggleEdit(reCode) {
    const form = document.getElementById("editForm-" + reCode);
    form.style.display = (form.style.display === "none") ? "block" : "none";
}

function openReportForm(category, code) {
    document.getElementById("rep_category").value = category;
    document.getElementById("target_code").value = code;
    document.getElementById("reportModal").style.display = "block";
}

function closeReportForm() {
    document.getElementById("reportModal").style.display = "none";
}
</script>

</body>
</html>
