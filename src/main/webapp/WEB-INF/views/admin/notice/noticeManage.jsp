<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ taglib prefix="c" uri="jakarta.tags.core" %>
<!DOCTYPE html>
<html>
<head>
<meta charset="UTF-8">
<title>공지사항 관리자 - 머무름</title>
<style>
    /* [1] 기본 레이아웃 및 폰트 */
    body { background-color: #f8f9ff; margin: 0; font-family: 'Malgun Gothic', sans-serif; color: #333; }
    .admin-main { padding: 40px; max-width: 1100px; margin: 0 auto; }

    /* [2] 상단 헤더 정렬 */
    .page-header { display: flex; justify-content: space-between; align-items: center; margin-bottom: 30px; }
    .table-title { font-size: 26px; font-weight: bold; color: #2d3436; }
    .btn-home-back {
        display: flex; align-items: center; gap: 8px;
        padding: 10px 18px; background: white;
        border: 1px solid #f1f3ff; border-radius: 15px;
        text-decoration: none; font-weight: bold; color: #666;
        box-shadow: 0 5px 15px rgba(162,155,254,0.1);
        transition: 0.3s;
    }
    .btn-home-back:hover { background: #f1f3ff; color: #a29bfe; border-color: #a29bfe; }

    /* [3] 등록 카드 (신규 공지) */
    .reg-card { 
        background: white; border-radius: 25px; padding: 30px; 
        box-shadow: 0 10px 20px rgba(162,155,254,0.05); border: 1px solid #f1f3ff;
        margin-bottom: 40px;
    }
    .reg-card h4 { margin: 0 0 20px 0; color: #a29bfe; font-size: 18px; display: flex; align-items: center; gap: 8px; }

    /* [4] 검색 영역 */
    .search-row { display: flex; justify-content: space-between; align-items: center; margin-bottom: 20px; }
    .search-box { display: flex; gap: 10px; background: white; padding: 8px 15px; border-radius: 20px; border: 1px solid #f1f3ff; box-shadow: 0 5px 10px rgba(0,0,0,0.02); }
    .search-input { border: none; background: transparent; padding: 5px; width: 220px; outline: none; }
    .btn-search { background: #34495e; color: white; border: none; padding: 8px 18px; border-radius: 15px; font-weight: bold; cursor: pointer; transition: 0.3s; }

    /* [5] 리스트 카드 및 테이블 */
    .content-card { background: white; border-radius: 30px; padding: 35px; box-shadow: 0 15px 35px rgba(0,0,0,0.03); border: 1px solid #f1f3ff; }
    table { width: 100%; border-collapse: separate; border-spacing: 0; }
    th { padding: 15px; color: #a2a2a2; font-size: 13px; text-transform: uppercase; border-bottom: 2px solid #f8f9ff; text-align: center; }
    td { padding: 18px 10px; border-bottom: 1px solid #f8f9ff; text-align: center; font-size: 14px; color: #444; }
    
    /* 공지 내용 열 스타일 */
    .content-row { display: none; background: #fafaff; }
    .content-box { padding: 25px; line-height: 1.8; white-space: pre-wrap; color: #555; font-size: 14px; text-align: left; background: #ffffff; margin: 10px; border-radius: 15px; border: 1px solid #f1f3ff; }
    
    /* 뱃지 및 버튼 스타일 */
    .form-control { width: 100%; padding: 12px; margin-bottom: 12px; border: 1px solid #eee; border-radius: 12px; outline: none; font-family: inherit; transition: 0.3s; }
    .btn-submit { width: 100%; padding: 14px; background: #a29bfe; color: white; border: none; border-radius: 12px; cursor: pointer; font-size: 16px; font-weight: bold; transition: 0.3s; }
    .btn-submit:hover { background: #6c5ce7; transform: translateY(-2px); }
    
    .title-link { color: #333; text-decoration: none; cursor: pointer; font-weight: bold; transition: 0.2s; }
    .title-link:hover { color: #a29bfe; }
    
    /* 카테고리별 뱃지 색상 분기 */
    .badge { padding: 5px 12px; border-radius: 10px; font-size: 12px; font-weight: bold; }
    .badge-normal { background: #e1e5ff; color: #a29bfe; }
    .badge-urgent { background: #ffeaa7; color: #d6a01e; }
    .badge-essential { background: #ff7675; color: white; }

    .btn-del { background: #ff7675; color: white; border: none; padding: 7px 15px; border-radius: 10px; cursor: pointer; font-weight: bold; transition: 0.3s; }
    .btn-del:hover { background: #d63031; }
</style>
<script>
    function toggleContent(code) {
        const contentRow = document.getElementById('content-' + code);
        if (contentRow.style.display === 'table-row') {
            contentRow.style.display = 'none';
        } else {
            document.querySelectorAll('.content-row').forEach(row => row.style.display = 'none');
            contentRow.style.display = 'table-row';
        }
    }
</script>
</head>
<body>

<div class="admin-main">
    <div class="page-header">
        <h1 class="table-title">⚙️ 공지사항 관리</h1>
        <a href="/admin/member/main" class="btn-home-back">🏠 관리자 메인</a>
    </div>

    <div class="reg-card">
        <h4><span style="font-size: 20px;">📢</span> 신규 공지사항 등록</h4>
        <form action="/admin/notice/insert" method="post">
            <input type="hidden" name="${_csrf.parameterName}" value="${_csrf.token}" />
            <div style="display: flex; gap: 15px; align-items: flex-start;">
                <select name="notice_category" class="form-control" style="width: 180px; flex-shrink: 0;">
                    <option value="일반공지">일반공지</option>
                    <option value="긴급공지">긴급공지</option>
                    <option value="필독">필독</option>
                </select>
                <div style="flex-grow: 1;">
                    <input type="text" name="notice_title" class="form-control" placeholder="공지 제목을 입력하세요" required>
                    <textarea name="notice_content" class="form-control" style="height: 100px; resize: none;" placeholder="상세 내용을 입력하세요" required></textarea>
                </div>
            </div>
            <button type="submit" class="btn-submit">공지사항 등록하기</button>
        </form>
    </div>

    <div class="search-row">
        <h4 style="margin:0; color: #2d3436;">📋 공지사항 리스트</h4>
        <form action="/admin/notice/noticeManage" method="get" class="search-box">
            <input type="text" name="keyword" class="search-input" placeholder="제목 또는 내용 검색" value="${param.keyword}">
            <button type="submit" class="btn-search">검색</button>
        </form>
    </div>

    <div class="content-card">
        <table>
            <thead>
                <tr>
                    <th width="15%">카테고리</th>
                    <th width="50%">제목 (클릭 시 내용 보기)</th>
                    <th width="20%">등록일</th>
                    <th width="15%">관리</th>
                </tr>
            </thead>
            <tbody>
                <c:if test="${empty noticeList}">
                    <tr><td colspan="4" style="padding: 80px; color: #ccc;">등록된 공지사항이 없습니다.</td></tr>
                </c:if>
                <c:forEach var="notice" items="${noticeList}">
                    <tr>
                        <td>
                            <c:choose>
                                <c:when test="${notice.notice_category == '필독'}"><span class="badge badge-essential">필독</span></c:when>
                                <c:when test="${notice.notice_category == '긴급공지'}"><span class="badge badge-urgent">긴급</span></c:when>
                                <c:otherwise><span class="badge badge-normal">일반</span></c:otherwise>
                            </c:choose>
                        </td>
                        <td style="text-align: left; padding-left: 20px;">
                            <span class="title-link" onclick="toggleContent('${notice.notice_code}')">
                                ${notice.notice_title}
                            </span>
                        </td>
                        <td style="color: #999; font-size: 13px;">${notice.created_at}</td>
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
                                <div style="color: #a29bfe; font-weight: bold; margin-bottom: 10px; border-bottom: 1px solid #f1f3ff; padding-bottom: 10px;">[상세 내용]</div>
                                ${notice.notice_content}
                            </div>
                        </td>
                    </tr>
                </c:forEach>
            </tbody>
        </table>
    </div>
</div>
</body>
</html>