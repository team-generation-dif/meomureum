<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ taglib prefix="c" uri="jakarta.tags.core" %>
<!DOCTYPE html>
<html>
<head>
<meta charset="UTF-8">
<title>공지사항 관리자 - 머무름</title>
<style>
    .container { width: 1000px; margin: 40px auto; font-family: 'Malgun Gothic', sans-serif; }
    .title-area { border-bottom: 2px solid #333; padding-bottom: 10px; margin-bottom: 30px; }
    .reg-box { background: #f9f9f9; padding: 25px; border-radius: 8px; border: 1px solid #ddd; margin-bottom: 40px; }
    
    /* 검색 영역 스타일 */
    .search-area { margin-bottom: 20px; text-align: right; display: flex; justify-content: flex-end; gap: 5px; }
    .search-input { padding: 8px; border: 1px solid #ddd; border-radius: 4px; width: 250px; }
    .btn-search { padding: 8px 15px; background: #34495e; color: white; border: none; border-radius: 4px; cursor: pointer; }

    table { width: 100%; border-collapse: collapse; }
    th { background: #f4f4f4; padding: 12px; border: 1px solid #ddd; }
    td { padding: 12px; border: 1px solid #ddd; text-align: center; }
    
    /* 내용 보기 스타일 */
    .content-row { display: none; background: #fffdf0; text-align: left; }
    .content-box { padding: 20px; line-height: 1.6; white-space: pre-wrap; border: 1px solid #ddd; }
    .title-link { color: #333; text-decoration: none; cursor: pointer; font-weight: 500; }
    .title-link:hover { text-decoration: underline; color: #4CAF50; }

    .form-control { width: 100%; padding: 10px; margin-bottom: 10px; border: 1px solid #ccc; border-radius: 4px; box-sizing: border-box; }
    .btn-submit { width: 100%; padding: 12px; background: #4CAF50; color: white; border: none; border-radius: 4px; cursor: pointer; font-size: 16px; }
    .btn-del { background: #e74c3c; color: white; border: none; padding: 6px 12px; border-radius: 4px; cursor: pointer; }
    .btn-home { text-decoration: none; padding: 10px 20px; background: #34495e; color: white; border-radius: 4px; font-weight: bold; font-size: 14px; }
</style>
<script>
    // 제목 클릭 시 내용을 펼치고 닫는 함수
    function toggleContent(code) {
        const contentRow = document.getElementById('content-' + code);
        if (contentRow.style.display === 'table-row') {
            contentRow.style.display = 'none';
        } else {
            contentRow.style.display = 'table-row';
        }
    }
</script>
</head>
<body>
<div class="container">
    <div class="title-area" style="display: flex; justify-content: space-between; align-items: center;">
        <h2>⚙️ 공지사항 관리 (커뮤니티)</h2>
        <a href="/admin/member/memberList" class="btn-home">🏠 메인으로</a>
    </div>

    <div class="reg-box">
        <h4>[신규 공지사항 등록]</h4>
        <form action="/admin/notice/insert" method="post">
            <input type="hidden" name="${_csrf.parameterName}" value="${_csrf.token}" />
            <select name="notice_category" class="form-control" style="width: 150px;">
                <option value="일반공지">일반공지</option>
                <option value="긴급공지">긴급공지</option>
                <option value="필독">필독</option>
            </select>
            <input type="text" name="notice_title" class="form-control" placeholder="공지 제목을 입력하세요" required>
            <textarea name="notice_content" class="form-control" style="height: 120px;" placeholder="공지 내용을 입력하세요" required></textarea>
            <button type="submit" class="btn-submit">공지사항 등록하기</button>
        </form>
    </div>

    <div class="search-area">
        <form action="/admin/notice/noticeManage" method="get" style="display: flex; gap: 5px;">
            <input type="text" name="keyword" class="search-input" placeholder="제목 또는 내용 검색" value="${param.keyword}">
            <button type="submit" class="btn-search">검색</button>
        </form>
    </div>

    <h4>[등록된 공지사항 리스트]</h4>
    <table>
        <thead>
            <tr>
                <th width="12%">카테고리</th>
                <th width="53%">제목 (클릭 시 내용 보기)</th>
                <th width="20%">등록일</th>
                <th width="15%">관리</th>
            </tr>
        </thead>
        <tbody>
            <c:if test="${empty noticeList}">
                <tr><td colspan="4">등록된 공지사항이 없습니다.</td></tr>
            </c:if>
            <c:forEach var="notice" items="${noticeList}">
                <tr>
                    <td><b>${notice.notice_category}</b></td>
                    <td style="text-align: left;">
                        <span class="title-link" onclick="toggleContent('${notice.notice_code}')">
                            ${notice.notice_title}
                        </span>
                    </td>
                    <td>${notice.created_at}</td>
                    <td>
                        <form action="/admin/notice/delete" method="post" onsubmit="return confirm('정말 삭제하시겠습니까?');">
                            <input type="hidden" name="${_csrf.parameterName}" value="${_csrf.token}" />
                            <input type="hidden" name="notice_code" value="${notice.notice_code}">
                            <button type="submit" class="btn-del">삭제</button>
                        </form>
                    </td>
                </tr>
                <tr id="content-${notice.notice_code}" class="content-row">
                    <td colspan="4">
                        <div class="content-box">
                            <strong>[상세 내용]</strong><br><br>
                            ${notice.notice_content}
                        </div>
                    </td>
                </tr>
            </c:forEach>
        </tbody>
    </table>
</div>
</body>
</html>