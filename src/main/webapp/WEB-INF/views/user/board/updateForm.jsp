<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ taglib uri="http://java.sun.com/jsp/jstl/core" prefix="c" %>
<!DOCTYPE html>
<html>
<head>
<meta charset="UTF-8">
<title>게시글 수정 | 머무름</title>

<link href="https://stackpath.bootstrapcdn.com/bootstrap/3.4.1/css/bootstrap.min.css" rel="stylesheet">
<script src="https://code.jquery.com/jquery-3.5.1.min.js"></script>
<script src="https://stackpath.bootstrapcdn.com/bootstrap/3.4.1/js/bootstrap.min.js"></script>
<link href="https://cdn.jsdelivr.net/npm/summernote@0.8.18/dist/summernote.min.css" rel="stylesheet">
<script src="https://cdn.jsdelivr.net/npm/summernote@0.8.18/dist/summernote.min.js"></script>

<style>
    /* 폰트 및 배경 */
    @import url('https://cdn.jsdelivr.net/gh/orioncactus/pretendard/dist/web/static/pretendard.css');
    body { background-color: #f4f7fa; font-family: 'Pretendard', sans-serif; color: #444; }
    
    .update-wrapper { max-width: 950px; margin: 60px auto; padding: 0 20px; }
    
    /* 몽글몽글 카드 스타일 */
    .update-card { 
        background: #fff; 
        padding: 50px; 
        border-radius: 30px; /* 더 둥글게 */
        box-shadow: 0 15px 35px rgba(0,0,0,0.03); 
    }

    /* 제목 부분 */
    .header-area { display: flex; justify-content: space-between; align-items: center; margin-bottom: 40px; }
    .page-title { font-size: 26px; font-weight: 800; color: #333; letter-spacing: -1px; }
    .btn-back { 
        background: #fff; border: 1px solid #eee; padding: 8px 18px; 
        border-radius: 12px; font-size: 13px; color: #888; transition: 0.3s;
    }
    .btn-back:hover { background: #f9f9f9; color: #333; text-decoration: none; }

    /* 테이블 스타일 (보내주신 스크린샷 참고) */
    .info-section-title { font-size: 17px; font-weight: 700; color: #8e94f2; margin-bottom: 20px; display: flex; align-items: center; gap: 8px; }
    
    .form-grid { background: #fcfcfc; border-radius: 20px; padding: 10px; border: 1px solid #f0f2f5; margin-bottom: 30px; }
    .form-row { display: flex; border-bottom: 1px solid #f1f3f5; }
    .form-row:last-child { border-bottom: none; }
    
    .form-label { 
        width: 150px; background: #f9faff; padding: 20px; 
        font-weight: 600; color: #666; font-size: 14px;
        border-radius: 15px; margin: 5px; display: flex; align-items: center;
    }
    .form-content { flex: 1; padding: 15px 20px; display: flex; align-items: center; }

    /* 입력 요소 */
    .input-soft {
        width: 100%; border: 1px solid #e8e8e8; padding: 12px 18px; 
        border-radius: 15px; background: #fff; transition: 0.3s; outline: none;
    }
    .input-soft:focus { border-color: #a2a8f2; box-shadow: 0 0 0 4px rgba(162, 168, 242, 0.1); }

    /* 라디오 버튼 (몽글몽글 스타일) */
    .category-group { display: flex; gap: 25px; }
    .category-group label { font-weight: 500; cursor: pointer; display: flex; align-items: center; gap: 8px; margin: 0; color: #555; }
    .category-group input[type="radio"] { accent-color: #8e94f2; width: 18px; height: 18px; }

    /* 썸머노트 커스텀 */
    .note-editor.note-frame { border: 1px solid #e8e8e8 !important; border-radius: 20px !important; overflow: hidden; }
    .note-toolbar { background: #f9faff !important; border-bottom: 1px solid #f1f3f5 !important; padding: 10px !important; }

    /* 하단 버튼 영역 */
    .action-area { margin-top: 40px; display: flex; justify-content: center; }
    .btn-submit-dreamy {
        background: #a2a8f2; color: #fff; border: none; padding: 15px 60px; 
        border-radius: 20px; font-size: 16px; font-weight: 700;
        box-shadow: 0 8px 20px rgba(162, 168, 242, 0.3); transition: 0.3s;
    }
    .btn-submit-dreamy:hover { background: #8e94f2; transform: translateY(-3px); box-shadow: 0 10px 25px rgba(162, 168, 242, 0.4); }
</style>
</head>

<body>
<div class="update-wrapper">
    <div class="header-area">
        <div class="page-title">게시글 수정</div>
        <a href="/user/board/list" class="btn-back">← 목록으로</a>
    </div>

    <div class="update-card">
        <form method="post" action="/user/board/update">
            <input type="hidden" name="b_code" value="${board.b_code}">

            <div class="info-section-title">✨ 기본 정보 설정</div>
            <div class="form-grid">
                <div class="form-row">
                    <div class="form-label">카테고리</div>
                    <div class="form-content">
                        <div class="category-group">
                            <label><input type="radio" name="b_category" value="정보" <c:if test="${board.b_category eq '정보'}">checked</c:if>> 정보공유</label>
                            <label><input type="radio" name="input" name="b_category" value="동행" <c:if test="${board.b_category eq '동행'}">checked</c:if>> 동행</label>
                            <label><input type="radio" name="b_category" value="후기" <c:if test="${board.b_category eq '후기'}">checked</c:if>> 후기</label>
                        </div>
                    </div>
                </div>
                <div class="form-row">
                    <div class="form-label">제목</div>
                    <div class="form-content">
                        <input type="text" name="b_title" value="${board.b_title}" class="input-soft" placeholder="마음을 담은 제목을 적어주세요">
                    </div>
                </div>
            </div>

            <div class="info-section-title">📝 상세 내용</div>
            <div style="margin-top: 15px;">
                <textarea id="summernote" name="b_content" required>${board.b_content}</textarea>
            </div>

            <div class="action-area">
                <button type="submit" class="btn-submit-dreamy">수정 완료하기</button>
            </div>
        </form>
    </div>
</div>

<script>
$(document).ready(function() {
    $('#summernote').summernote({
        height: 400,
        lang: 'ko-KR',
        toolbar: [
            ['style', ['style']],
            ['font', ['bold', 'italic', 'underline', 'clear']],
            ['color', ['color']],
            ['para', ['ul', 'ol', 'paragraph']],
            ['insert', ['link', 'picture']],
            ['view', ['codeview']]
        ],
        callbacks: {
            onImageUpload: function(files) { uploadImage(files[0], this); }
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
        success: function(url) { $(editor).summernote('insertImage', url); }
    });
}
</script>
</body>
</html>