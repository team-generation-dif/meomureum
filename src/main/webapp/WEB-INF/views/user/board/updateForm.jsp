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

<style>
  /* 폰트 설정 */
@import url('https://cdn.jsdelivr.net/gh/orioncactus/pretendard/dist/web/static/pretendard.css');

/* 배경 및 기본 폰트 */
body { 
    background-color: #f4f7fa; 
    font-family: 'Pretendard', sans-serif; 
    color: #444; 
}

/* 기존 .container를 몽글몽글한 카드로 변신 */
.container { 
    max-width: 850px !important; 
    margin: 60px auto !important; 
    background: #fff; 
    padding: 50px !important; 
    border-radius: 30px; 
    box-shadow: 0 15px 35px rgba(0,0,0,0.03); 
}

/* 제목 스타일 */
h3 { 
    font-size: 26px; 
    font-weight: 800; 
    color: #333; 
    margin-bottom: 40px; 
    letter-spacing: -1px;
}

/* 테이블 디자인 (회원정보 상세 페이지 스타일) */
.table-bordered { 
    border: none !important; 
    background: #fcfcfc; 
    border-radius: 20px; 
    overflow: hidden;
    display: block; /* 몽글몽글한 그리드 느낌을 위해 */
}

.table-bordered tr { 
    display: flex; 
    border-bottom: 1px solid #f1f3f5 !important;
}

.table-bordered tr td { 
    border: none !important; 
    padding: 20px !important;
}

/* 왼쪽 라벨(분류, 제목 등) */
.table-bordered tr td:first-child { 
    width: 150px; 
    background: #f9faff !important; 
    font-weight: 700 !important; 
    color: #8e94f2 !important; /* 보라색 포인트 */
    display: flex;
    align-items: center;
}

/* 오른쪽 입력 칸 */
.table-bordered tr td:last-child { 
    flex: 1; 
    background: #fff !important;
}

/* 입력창(제목) 스타일 */
input[type="text"] {
    width: 100%; 
    border: 1px solid #e8e8e8 !important; 
    padding: 12px 18px !important; 
    border-radius: 15px !important; 
    transition: 0.3s;
    outline: none;
}

input[type="text"]:focus { 
    border-color: #a2a8f2 !important; 
    box-shadow: 0 0 0 4px rgba(162, 168, 242, 0.1) !important; 
}

/* 라디오 버튼 간격 */
input[type="radio"] { 
    accent-color: #8e94f2; 
    margin-right: 5px !important;
    vertical-align: middle;
}

/* 에디터 둥글게 */
.note-editor.note-frame { 
    border: 1px solid #e8e8e8 !important; 
    border-radius: 20px !important; 
    overflow: hidden; 
}

/* 하단 버튼 영역 */
.btn-area { 
    margin-top: 40px; 
    display: flex; 
    justify-content: center; 
    gap: 15px;
}

/* 목록으로 버튼 */
.btn-default { 
    background: #fff !important; 
    border: 1px solid #eee !important; 
    padding: 12px 30px !important; 
    border-radius: 15px !important; 
    color: #888 !important;
    transition: 0.3s;
}

/* 수정 완료 버튼 */
.btn-primary { 
    background: #a2a8f2 !important; 
    border: none !important; 
    padding: 12px 50px !important; 
    border-radius: 15px !important; 
    font-weight: 700 !important;
    box-shadow: 0 8px 20px rgba(162, 168, 242, 0.3) !important;
    transition: 0.3s;
}

.btn-primary:hover { 
    background: #8e94f2 !important; 
    transform: translateY(-3px); 
}
</style>
</head>

<body>
<div class="container" style="margin-top: 20px;">
    <h3>게시글 수정</h3>
    
    <form method="post" action="/user/board/update">
    <!-- PK만 전달 -->
    <input type="hidden" name="b_code" value="${board.b_code}">

    <table class="table table-bordered" style="width:800px;">
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

    <!-- 버튼 영역 -->
    <div class="btn-area">
        <a href="/user/board/list" class="btn btn-default">목록으로</a>
        <input type="submit" value="수정 완료" class="btn btn-primary">
    </div>
</form>
</div>

<script>
$(document).ready(function() {
    $('#summernote').summernote({
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
            alert("이미지 업로드에 실패했습니다.");
        }
    });
}
</script>
</body>
</html>

