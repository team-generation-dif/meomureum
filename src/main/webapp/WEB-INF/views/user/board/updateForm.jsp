<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ taglib uri="http://java.sun.com/jsp/jstl/core" prefix="c" %>
<!DOCTYPE html>
<html>
<head>
<meta charset="UTF-8">
<title>게시글 수정</title>

<link href="https://stackpath.bootstrapcdn.com/bootstrap/3.4.1/css/bootstrap.min.css" rel="stylesheet">
<script src="https://code.jquery.com/jquery-3.5.1.min.js"></script>
<script src="https://stackpath.bootstrapcdn.com/bootstrap/3.4.1/js/bootstrap.min.js"></script>
<link href="https://cdn.jsdelivr.net/npm/summernote@0.8.18/dist/summernote.min.css" rel="stylesheet">
<script src="https://cdn.jsdelivr.net/npm/summernote@0.8.18/dist/summernote.min.js"></script>
</head>

<body>
    <div class="container" style="margin-top: 20px;">
        <h3>게시글 수정</h3>
        
        <form method="post" action="/user/board/update">
            <input type="hidden" name="b_code" value="${board.b_code}">

            <table border="1" width="800">
                <tr>
                    <td style="padding: 10px; background: #f8f9fa;">분류</td>
                    <td style="padding: 10px;">
                        <input type="radio" name="b_category" value="정보"
                            <c:if test="${board.b_category eq '정보'}">checked</c:if>> 정보공유
                        <input type="radio" name="b_category" value="동행"
                            <c:if test="${board.b_category eq '동행'}">checked</c:if>> 동행
                        <input type="radio" name="b_category" value="후기"
                            <c:if test="${board.b_category eq '후기'}">checked</c:if>> 후기
                    </td>
                </tr>
                <tr>
                    <td style="padding: 10px; background: #f8f9fa;">제목</td>
                    <td style="padding: 10px;">
                        <input type="text" name="b_title" value="${board.b_title}" style="width: 100%;" required>
                    </td>
                </tr>
                <tr>
                    <td style="padding: 10px; background: #f8f9fa;">내용</td>
                    <td style="padding: 10px;">
                        <textarea id="summernote" name="b_content" required>${board.b_content}</textarea>
                    </td>
                </tr>
            </table>
            
            <div style="margin-top: 20px;">
                <input type="submit" value="수정 완료" class="btn btn-primary">
                <input type="reset" value="초기화" class="btn btn-warning">
                <a href="/user/board/list" class="btn btn-default">목록으로</a>
            </div>
        </form>
    </div>

<script>
$(document).ready(function() {
    $('#summernote').summernote({
        height: 400,
        lang: 'ko-KR',
        callbacks: {
            // 수정 시에도 새로운 이미지를 추가할 수 있도록 설정
            onImageUpload: function(files) {
                uploadImage(files[0], this);
            }
        }
    });
});

function uploadImage(file, editor) {
    let data = new FormData();
    data.append("file", file);
    $.ajax({
        url: '/user/board/uploadImage',
        method: 'POST',
        data: data,
        contentType: false,
        processData: false,
        success: function(url) {
            // 새로 올린 사진도 본문에 삽입
            $(editor).summernote('insertImage', url);
        },
        error: function() {
            alert("이미지 업로드에 실패했습니다.");
        }
    });
}
</script>
</body>
</html>
