<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ taglib uri="http://java.sun.com/jsp/jstl/core" prefix="c" %>
<%@ taglib uri="http://java.sun.com/jsp/jstl/fmt" prefix="fmt" %>
<!DOCTYPE html>
<html>
<head>
<meta charset="UTF-8">
<title>게시글 상세 보기</title>
<style>
    body { font-family: 'Malgun Gothic', sans-serif; line-height: 1.6; color: #333; margin: 20px; }
    .container { width: 800px; margin: 0 auto; border: 1px solid #ddd; padding: 30px; border-radius: 8px; }
    
    .info-table { width: 100%; border-collapse: collapse; margin-bottom: 20px; }
    .info-table th { background-color: #f8f9fa; border: 1px solid #dee2e6; padding: 12px; text-align: left; width: 150px; }
    .info-table td { border: 1px solid #dee2e6; padding: 12px; }
    
    /* [수정] 본문 영역 스타일 */
    .post-content-area { margin-top: 30px; border-top: 2px solid #333; padding-top: 30px; }
    
    /* [중요] 에디터에서 작성한 HTML이 들어가는 곳 */
    .post-text { 
        font-size: 16px; 
        margin-bottom: 40px; 
        word-break: break-all; /* 긴 영어 단어 줄바꿈 */
    }
    
    /* [추가] 본문 내 포함된 이미지가 컨테이너를 벗어나지 않게 설정 */
    .post-text img {
        max-width: 100%;
        height: auto;
        display: block; /* 이미지 아래 미세한 공백 제거 */
        margin: 10px 0; /* 이미지 위아래 간격 */
    }
    
    .btn-group { margin-top: 30px; text-align: center; border-top: 1px solid #eee; padding-top: 20px; }
    .btn { display: inline-block; padding: 8px 16px; margin: 0 5px; text-decoration: none; color: #fff; background-color: #007bff; border-radius: 4px; font-size: 14px; }
    .btn-list { background-color: #6c757d; }
    .btn-delete { background-color: #dc3545; }
</style>
</head>
<body>

<div class="container">
    <h3>게시글 상세</h3>

    <table class="info-table">
        <tr>
            <th>번호/분류</th>
            <td>[${board.b_code}] / <strong>${board.b_category}</strong></td>
        </tr>
        <tr>
            <th>제목</th>
            <td style="font-weight: bold; font-size: 1.1em;">${board.b_title}</td>
        </tr>
        <tr>
            <th>작성일/조회수</th>
            <td>
                <fmt:formatDate value="${board.created_at}" pattern="yyyy-MM-dd HH:mm"/> 
                <span style="margin-left: 20px; color: #888;">조회수: ${board.b_view}</span>
            </td>
        </tr>
    </table>

    <div class="post-content-area">
        <div class="post-text">${board.b_content}</div>
        
        </div>

    <div class="btn-group">
        <a href="/user/board/list" class="btn btn-list">목록보기</a>
        <a href="/user/board/updateForm/${board.b_code}" class="btn">수정하기</a>
        <a href="javascript:void(0);" onclick="confirmDelete('${board.b_code}')" class="btn btn-delete">삭제하기</a>
    </div>
</div>

<script>
    function confirmDelete(code) {
        if(confirm("정말로 이 게시글을 삭제하시겠습니까?")) {
            location.href = "/user/board/delete/" + code;
        }
    }
</script>

</body>
</html>
