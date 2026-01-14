<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ taglib prefix="c" uri="jakarta.tags.core" %>
<!DOCTYPE html>
<html>
<head>
<meta charset="UTF-8">
<title>머무름 - 게시글 작성</title>

<script src="https://code.jquery.com/jquery-3.5.1.min.js"></script>
<link href="https://stackpath.bootstrapcdn.com/bootstrap/3.4.1/css/bootstrap.min.css" rel="stylesheet">
<script src="https://stackpath.bootstrapcdn.com/bootstrap/3.4.1/js/bootstrap.min.js"></script>
<link href="https://cdn.jsdelivr.net/npm/summernote@0.8.18/dist/summernote.min.css" rel="stylesheet">
<script src="https://cdn.jsdelivr.net/npm/summernote@0.8.18/dist/summernote.min.js"></script>

<style>
    /* [1] 기본 레이아웃 */
    body { background-color: #f8f9ff; margin: 0; font-family: 'Malgun Gothic', sans-serif; color: #333; }
    .main-wrapper { padding: 40px; max-width: 1000px; margin: 0 auto; }

    /* [2] 헤더 스타일 */
    /* [2] 상단 헤더 및 메인으로 버튼 (네모 형태로 수정) */
    .page-header { display: flex; justify-content: space-between; align-items: center; margin-bottom: 30px; }
    
    .btn-home-back {
        display: flex; 
        align-items: center; 
        gap: 8px; 
        padding: 10px 20px; 
        background: white;
        border: 1px solid #e1e5ff; 
        
        /* 둥근 타원에서 깔끔한 네모로 변경 */
        border-radius: 6px !important; 
        
        text-decoration: none !important; 
        font-weight: bold; 
        color: #666;
        box-shadow: 0 4px 10px rgba(162,155,254,0.05);
        transition: 0.3s;
    }
    
    .btn-home-back:hover { 
        background: #f1f3ff; 
        color: #a29bfe; 
        border-color: #a29bfe; 
        transform: translateY(-2px); 
    }

    /* [6] 게시글 등록 버튼 (네모 형태 유지) */
    .btn-write { 
        background: #a29bfe !important; 
        color: white !important; 
        padding: 12px 28px; 
        
        /* 메인 버튼과 통일된 네모 형태 */
        border-radius: 6px !important; 
        
        font-weight: bold; 
        font-size: 15px;
        text-decoration: none !important; 
        display: inline-block;
        float: right;
        border: none !important;
        cursor: pointer;
        transition: all 0.3s ease;
        box-shadow: 0 4px 12px rgba(162, 155, 254, 0.2);
    }
    .table-title { font-size: 28px; font-weight: bold; color: #2d3436; margin: 0; }
    
    /* [3] 콘텐츠 카드 디자인 */
    .content-card { 
        background: white; border-radius: 30px; padding: 40px; 
        box-shadow: 0 15px 35px rgba(0,0,0,0.03); border: 1px solid #f1f3ff;
    }

    /* [4] 입력 폼 스타일 */
    .form-group-custom { margin-bottom: 25px; }
    .form-label { font-weight: bold; color: #666; margin-bottom: 10px; display: block; font-size: 15px; }
    
    .input-text { 
        width: 100%; padding: 12px 15px; border-radius: 10px; 
        border: 1px solid #e1e5ff; outline: none; transition: 0.3s;
    }
    .input-text:focus { border-color: #a29bfe; box-shadow: 0 0 8px rgba(162,155,254,0.2); }

    /* 라디오 버튼 스타일링 */
    .radio-group { display: flex; gap: 20px; align-items: center; padding: 5px 0; }
    .radio-group input[type="radio"] { margin-right: 5px; accent-color: #a29bfe; }

    /* [5] 하단 버튼 (요청하신 네모 형태) */
    .btn-submit { 
        background: #a29bfe !important; color: white !important; 
        padding: 12px 35px; border-radius: 6px !important; /* 모서리 살짝 둥근 네모 */
        font-weight: bold; font-size: 16px; border: none !important;
        transition: 0.3s; cursor: pointer; box-shadow: 0 4px 12px rgba(162,155,254,0.2);
    }
    .btn-submit:hover { background: #6c5ce7 !important; transform: translateY(-2px); }

    .btn-cancel { 
        background: white; color: #999; padding: 12px 25px; 
        border-radius: 6px; border: 1px solid #e1e5ff; 
        text-decoration: none !important; font-weight: bold; transition: 0.3s;
    }
    .btn-cancel:hover { background: #f8f9ff; color: #666; }

    .footer-btns { display: flex; justify-content: space-between; align-items: center; margin-top: 30px; }

    /* Summernote 테두리 교정 */
    .note-editor.note-frame { border: 1px solid #e1e5ff !important; border-radius: 10px !important; overflow: hidden; }
</style>
</head>
<body>
<div class="main-wrapper">
    <div class="page-header">
        <h1 class="table-title">새 글 작성</h1>
    </div>

    <div class="content-card">
        <form name="boardForm" method="post" action="/user/board/write">
            
            <input type="hidden" name="${_csrf.parameterName}" value="${_csrf.token}"/>
            
            <div class="form-group-custom">
                <label class="form-label">카테고리</label>
                ...
                <div class="radio-group">
                    <label><input type="radio" name="b_category" value="정보" checked> 정보공유</label>
                    <label><input type="radio" name="b_category" value="동행"> 동행게시판</label>
                    <label><input type="radio" name="b_category" value="후기"> 후기게시판</label>
                </div>
            </div>

            <div class="form-group-custom">
                <label class="form-label">제목</label>
                <input type="text" name="b_title" class="input-text" placeholder="제목을 입력해 주세요" required>
            </div>

            <div class="form-group-custom">
                <label class="form-label">내용</label>
                <textarea id="summernote" name="b_content" required></textarea>
            </div>

            <div class="footer-btns">
                <a href="/user/board/list" class="btn-cancel">취소</a>
                <input type="submit" value="게시글 등록" class="btn-submit">
            </div>
        </form>
    </div>
</div>

<script>
$(document).ready(function() {
    $('#summernote').summernote({
        placeholder: '내용을 입력하고 사진을 드래그하거나 아이콘을 클릭해서 넣어보세요.',
        height: 450,
        lang: 'ko-KR',
        toolbar: [
          ['style', ['style']],
          ['font', ['bold', 'underline', 'clear']],
          ['color', ['color']],
          ['para', ['ul', 'ol', 'paragraph']],
          ['table', ['table']],
          ['insert', ['link', 'picture', 'video']],
          ['view', ['fullscreen', 'codeview', 'help']]
        ],
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