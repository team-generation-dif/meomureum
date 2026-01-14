<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ taglib uri="http://java.sun.com/jsp/jstl/core" prefix="c" %>
<%@ taglib uri="http://java.sun.com/jsp/jstl/fmt" prefix="fmt" %>
<!DOCTYPE html>
<html>
<head>
<meta charset="UTF-8">
<title>머무름 - 게시글 상세보기</title>

<link href="https://stackpath.bootstrapcdn.com/bootstrap/3.4.1/css/bootstrap.min.css" rel="stylesheet">
<script src="https://code.jquery.com/jquery-3.5.1.min.js"></script>
<script src="https://stackpath.bootstrapcdn.com/bootstrap/3.4.1/js/bootstrap.min.js"></script>

<style>
    body { background-color: #f8f9ff; font-family: 'Malgun Gothic', sans-serif; }
    .container { max-width: 900px; margin-top: 30px; margin-bottom: 50px; }
    .board-box { padding: 30px; background: white; border-radius: 15px; box-shadow: 0 5px 15px rgba(0,0,0,0.05); }
    .reply-box { margin-top: 30px; background: white; padding: 25px; border-radius: 15px; }
    .reply-item { border-bottom: 1px solid #eee; padding: 15px 0; }
    .reply-meta { font-size: 13px; color: #888; margin-bottom: 5px; }
    .reply-content { font-size: 15px; flex-grow: 1; }
    .reply-actions { display: flex; gap: 5px; margin-left: 10px; }
    
    /* 신고 모달 커스텀 스타일 */
    #reportModal { 
        display: none; position: fixed; z-index: 1050; left: 0; top: 0; 
        width: 100%; height: 100%; background-color: rgba(0,0,0,0.5); 
    }
    .modal-content-custom { 
        background-color: white; margin: 10% auto; padding: 30px; 
        border-radius: 15px; width: 400px; box-shadow: 0 5px 25px rgba(0,0,0,0.2);
    }
</style>
</head>
<body>

<div class="container">
    <div class="page-header" style="border:none;">
        <h3><span class="glyphicon glyphicon-list-alt" style="color:#a29bfe;"></span> 게시글 상세보기</h3>
    </div>

    <div class="board-box">
        <div style="display:flex; justify-content:space-between; align-items:flex-end; margin-bottom:15px;">
            <div>
                <span class="label label-primary">${board.b_category}</span>
                <h2 style="margin-top:10px; font-weight:bold;">${board.b_title}</h2>
            </div>
            <div style="text-align:right; color:#999; font-size:13px;">
                작성일: <fmt:formatDate value="${board.created_at}" pattern="yyyy-MM-dd"/> | 
                조회수: ${board.b_view}
            </div>
        </div>
        <hr>
        <div style="min-height: 200px; line-height:1.8; font-size:16px;">
            ${board.b_content}
        </div>
        
        <div style="margin-top:30px; display:flex; justify-content:space-between;">
            <button type="button" class="btn btn-link" style="color:#ff7675; text-decoration:none;"
                    onclick="openReportForm('BOARD', '${board.b_code}')">
                <span class="glyphicon glyphicon-alert"></span> 게시글 신고하기
            </button>

            <div>
                <c:if test="${board.m_code eq sessionScope.m_code or sessionScope.loginRole eq 'ADMIN'}">
                    <a href="/user/board/updateForm/${board.b_code}" class="btn btn-warning btn-sm">수정</a>
                    <a href="javascript:void(0);" onclick="deleteBoard('${board.b_code}')" class="btn btn-danger btn-sm">삭제</a>
                </c:if>
                <a href="/user/board/list" class="btn btn-default btn-sm">목록으로</a>
            </div>
        </div>
    </div>

    <div class="reply-box">
        <h4><span class="glyphicon glyphicon-comment"></span> 댓글</h4>
        <c:choose>
            <c:when test="${not empty pageContext.request.userPrincipal}">
                <form method="post" action="/user/board/reply/write">
                    <input type="hidden" name="b_code" value="${board.b_code}">
                    <div class="input-group">
                        <textarea name="re_content" class="form-control" rows="3" style="resize:none;" placeholder="따뜻한 댓글을 남겨주세요." required></textarea>
                        <span class="input-group-addon" style="padding:0;">
                            <input type="submit" value="등록" style="height:74px; width:70px; border:none; background:#a29bfe; color:white;">
                        </span>
                    </div>
                    <div style="margin-top:10px;">
                        <label style="font-weight:normal; cursor:pointer;"><input type="checkbox" name="re_secret" value="Y"> 비밀댓글</label>
                    </div>
                </form>
            </c:when>
            <c:otherwise>
                <div class="well text-center">
                    댓글을 작성하려면 <a href="/guest/loginForm" class="btn btn-primary btn-xs">로그인</a> 이 필요합니다.
                </div>
            </c:otherwise>
        </c:choose>

        <div style="margin-top:20px;">
            <c:forEach var="reply" items="${replyList}">
                <div class="reply-item">
                    <div class="reply-meta">
                        <strong style="color:#333;">${reply.m_nick}</strong> | <fmt:formatDate value="${reply.created_at}" pattern="yyyy-MM-dd HH:mm"/>
                    </div>
                    <div style="display:flex; justify-content:space-between; align-items:center;">
                        <div class="reply-content">
                            <c:choose>
                                <c:when test="${reply.re_secret eq 'Y'}">
                                    <c:if test="${reply.m_code eq sessionScope.m_code or sessionScope.loginRole eq 'ADMIN' or board.m_code eq sessionScope.m_code}">
                                        <span class="glyphicon glyphicon-lock"></span> ${reply.re_content}
                                    </c:if>
                                    <c:if test="${reply.m_code ne sessionScope.m_code and sessionScope.loginRole ne 'ADMIN' and board.m_code ne sessionScope.m_code}">
                                        <span class="glyphicon glyphicon-lock"></span> <em style="color:#ccc;">비밀댓글입니다.</em>
                                    </c:if>
                                </c:when>
                                <c:otherwise>${reply.re_content}</c:otherwise>
                            </c:choose>
                        </div>
                        <div class="reply-actions">
                            <c:if test="${reply.m_code eq sessionScope.m_code or sessionScope.loginRole eq 'ADMIN'}">
                                <button type="button" class="btn btn-default btn-xs" onclick="toggleEdit('${reply.re_code}')">수정</button>
                                <button type="button" class="btn btn-default btn-xs" onclick="deleteReply('${reply.re_code}', '${board.b_code}')">삭제</button>
                            </c:if>
                            <button type="button" class="btn btn-link btn-xs" style="color:#ff7675;" onclick="openReportForm('REPLY', '${reply.re_code}')">신고</button>
                        </div>
                    </div>
                    
                    <div id="editForm-${reply.re_code}" style="display:none; margin-top:10px; background:#fcfcfc; padding:10px; border-radius:10px;">
                        <form method="post" action="/user/board/reply/update">
                            <input type="hidden" name="re_code" value="${reply.re_code}">
                            <input type="hidden" name="b_code" value="${board.b_code}">
                            <textarea name="re_content" class="form-control" rows="2">${reply.re_content}</textarea>
                            <div style="margin-top:5px; text-align:right;">
                                <label style="font-weight:normal; margin-right:10px;"><input type="checkbox" name="re_secret" value="Y" <c:if test="${reply.re_secret eq 'Y'}">checked</c:if>> 비밀글</label>
                                <input type="submit" value="수정완료" class="btn btn-primary btn-xs">
                                <button type="button" class="btn btn-default btn-xs" onclick="toggleEdit('${reply.re_code}')">취소</button>
                            </div>
                        </form>
                    </div>
                </div>
            </c:forEach>
        </div>
    </div>
</div>

<div id="reportModal">
    <div class="modal-content-custom">
        <h4 style="font-weight:bold; margin-bottom:20px; color:#ff7675;">신고하기</h4>
        <form id="reportForm" method="post" action="/report/submit">
            <input type="hidden" name="rep_category" id="rep_category">
            <input type="hidden" name="target_code" id="target_code">

            <div class="form-group">
                <label>신고 제목</label>
                <input type="text" name="rep_title" class="form-control" placeholder="신고 사유 요약" required>
            </div>

            <div class="form-group">
                <label>상세 내용</label>
                <textarea name="rep_content" class="form-control" rows="4" placeholder="자세한 신고 사유를 적어주세요." required></textarea>
            </div>

            <div style="margin-top:20px; text-align:right;">
                <button type="button" class="btn btn-default" onclick="closeReportForm()">취소</button>
                <button type="submit" class="btn btn-danger">신고 제출</button>
            </div>
        </form>
    </div>
</div>

<script>
function deleteBoard(bCode) {
    if(confirm("정말 이 게시글을 삭제하시겠습니까?")) {
        location.href = "/user/board/delete/" + bCode;
    }
}

function deleteReply(reCode, bCode) {
    if(confirm("댓글을 삭제하시겠습니까?")) {
        location.href = "/user/board/reply/delete/" + reCode + "/" + bCode;
    }
}

function toggleEdit(reCode) {
    const form = document.getElementById("editForm-" + reCode);
    form.style.display = (form.style.display === "none") ? "block" : "none";
}

// 신고 모달 제어
function openReportForm(category, code) {
    document.getElementById("rep_category").value = category;
    document.getElementById("target_code").value = code;
    document.getElementById("reportModal").style.display = "block";
}

function closeReportForm() {
    document.getElementById("reportModal").style.display = "none";
}

// 모달 바깥쪽 클릭 시 닫기
window.onclick = function(event) {
    const modal = document.getElementById("reportModal");
    if (event.target == modal) {
        modal.style.display = "none";
    }
}
</script>

</body>
</html>