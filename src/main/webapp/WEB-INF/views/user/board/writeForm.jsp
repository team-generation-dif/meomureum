<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<!DOCTYPE html>
<html>
<head>
<meta charset="UTF-8">
<title>게시글 작성</title>

<link href="https://stackpath.bootstrapcdn.com/bootstrap/3.4.1/css/bootstrap.min.css" rel="stylesheet">
<script src="https://code.jquery.com/jquery-3.5.1.min.js"></script>
<script src="https://stackpath.bootstrapcdn.com/bootstrap/3.4.1/js/bootstrap.min.js"></script>
<link href="https://cdn.jsdelivr.net/npm/summernote@0.8.18/dist/summernote.min.css" rel="stylesheet">
<script src="https://cdn.jsdelivr.net/npm/summernote@0.8.18/dist/summernote.min.js"></script>
</head>

<body>
    <div class="container" style="margin-top: 20px; max-width: 900px;">
        <h3>게시글 작성</h3>
        
        <form name="boardForm" method="post" action="/user/board/write">
            <table border="1" width="100%" style="border-collapse: collapse; border-color: #ddd;">
                <tr>
                    <td style="padding: 10px; background: #f8f9fa; width: 150px; font-weight: bold;">분류</td>
                    <td style="padding: 10px;">
                        <input type="radio" name="b_category" value="정보" checked> 정보공유
                        <input type="radio" name="b_category" value="동행"> 동행
                        <input type="radio" name="b_category" value="후기"> 후기
                    </td>
                </tr>
                <tr>
                    <td style="padding: 10px; background: #f8f9fa; font-weight: bold;">제목</td>
                    <td style="padding: 10px;">
                        <input type="text" name="b_title" style="width: 100%; height: 30px;" placeholder="제목을 입력하세요" required>
                    </td>
                </tr>
                <tr>
                    <td style="padding: 10px; background: #f8f9fa; font-weight: bold;">내용</td>
                    <td style="padding: 10px;">
                        <textarea id="summernote" name="b_content" required></textarea>
                    </td>           
                </tr>
            </table>           
            	<div style="margin-top: 20px; display: flex; justify-content: space-between; align-items: center;">
    				<!-- 왼쪽: 작성 버튼 -->
    			<input type="submit" value="작성" class="btn btn-primary">

    				<!-- 오른쪽: 목록으로 버튼 -->
    			<a href="/user/board/list" class="btn btn-default">목록으로</a>
				</div>
        </form>
    </div>
<script>
$(document).ready(function() {
    $('#summernote').summernote({
        placeholder: '내용을 입력하고 사진을 드래그하거나 아이콘을 클릭해서 넣어보세요.',
        height: 400,
        lang: 'ko-KR',
        callbacks: {
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
            $(editor).summernote('insertImage', url);
        },
        error: function() {
            alert("이미지 업로드 실패");
        }
    });
}
</script>
</body>
</html>
