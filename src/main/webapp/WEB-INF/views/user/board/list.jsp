<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ taglib prefix="c" uri="jakarta.tags.core" %>
<%@ taglib prefix="fmt" uri="jakarta.tags.fmt" %>
<!DOCTYPE html>
<html>
<head>
<meta charset="UTF-8">
<title>머무름 - 커뮤니티</title>

<%-- 라이브러리 로드 --%>
<script src="https://code.jquery.com/jquery-3.5.1.min.js"></script>
<link rel="stylesheet" type="text/css" href="https://cdn.datatables.net/1.10.25/css/jquery.dataTables.css">
<script type="text/javascript" src="https://cdn.datatables.net/1.10.25/js/jquery.dataTables.min.js"></script>
<link rel="stylesheet" href="https://cdnjs.cloudflare.com/ajax/libs/font-awesome/5.15.4/css/all.min.css">

<style>
    /* [1] 기본 레이아웃 */
    body { background-color: #f8f9ff !important; margin: 0; font-family: 'Pretendard', 'Malgun Gothic', sans-serif; }
    .admin-main { padding: 40px 20px; max-width: 1200px; margin: 0 auto; }
    .page-header { display: flex; justify-content: space-between; align-items: center; margin-bottom: 25px; }
    .table-title { font-size: 28px; font-weight: bold; color: #2d3436; margin: 0; }
    
    .btn-home-back {
        display: flex; align-items: center; gap: 8px; padding: 10px 18px; background: white;
        border: 1px solid #e1e5ff; border-radius: 12px !important; text-decoration: none !important; 
        font-weight: bold; color: #666; font-size: 14px;
        box-shadow: 0 4px 10px rgba(162,155,254,0.1); transition: 0.3s;
    }

    /* [2] 검색 영역 */
    .dataTables_filter { float: right; margin-bottom: 20px; }
    .dataTables_filter label { display: flex; align-items: center; background: white; border: 1px solid #e1e5ff; border-radius: 12px; padding: 5px 5px 5px 15px; }
    .dataTables_filter input { border: none !important; outline: none !important; width: 220px !important; padding: 8px !important; margin: 0 !important; }
    .search-btn-custom { background: #a29bfe; color: white; border: none; border-radius: 8px; width: 38px; height: 38px; cursor: pointer; display: flex; align-items: center; justify-content: center; }

    /* [3] 콘텐츠 카드 및 테이블 */
    .content-card { background: white; border-radius: 30px; padding: 35px; box-shadow: 0 15px 35px rgba(0,0,0,0.03); border: 1px solid #f1f3ff; }
    #mainTable { width: 100% !important; border-collapse: separate !important; border-spacing: 0; margin-bottom: 20px !important; }
    #mainTable thead th { padding: 15px !important; color: #a2a2a2; font-size: 13px; border-bottom: 2px solid #f8f9ff !important; text-align: center; }
    #mainTable tbody td { padding: 18px 10px; border-bottom: 1px solid #f8f9ff; text-align: center; font-size: 14px; }

    /* [4] 페이지네이션 (이전/다음 버튼 작동 해결) */
    .dataTables_wrapper .dataTables_paginate { margin-top: 20px !important; text-align: center !important; float: none !important; display: flex; justify-content: center; gap: 5px; }
    .dataTables_wrapper .dataTables_paginate .paginate_button {
        padding: 8px 16px !important;
        margin: 0 2px !important;
        border-radius: 8px !important;
        border: 1px solid #e1e5ff !important;
        background: white !important;
        color: #666 !important;
        font-weight: bold !important;
        cursor: pointer !important;
    }
    .dataTables_wrapper .dataTables_paginate .paginate_button:hover {
        background: #f1f3ff !important;
        color: #a29bfe !important;
        border-color: #a29bfe !important;
    }
    .dataTables_wrapper .dataTables_paginate .paginate_button.current {
        background: #a29bfe !important;
        color: white !important;
        border-color: #a29bfe !important;
    }
    .dataTables_wrapper .dataTables_paginate .paginate_button.disabled {
        opacity: 0.5;
        cursor: default !important;
    }

    .nav-tabs-custom { display: flex; gap: 8px; margin-bottom: 20px; list-style: none; padding: 0; }
    .nav-tabs-custom li a { text-decoration: none; padding: 10px 20px; border-radius: 10px !important; background: white; color: #888; font-weight: 600; border: 1px solid #eee; display: block; cursor: pointer; }
    .nav-tabs-custom li.active a { background: #a29bfe; color: white !important; }
</style>
</head>
<body>
<div class="admin-main">
    <div class="page-header">
        <h1 class="table-title">커뮤니티 광장</h1>
        <c:choose>
            <c:when test="${pageContext.request.userPrincipal.name == 'admin'}">
                <a href="/admin/member/main" class="btn-home-back">🏠 관리자 메인</a>
            </c:when>
            <c:otherwise>
                <a href="/user/mypage/main" class="btn-home-back">🏠 메인으로 이동</a>
            </c:otherwise>
        </c:choose>
    </div>

    <ul class="nav-tabs-custom" id="categoryTab">
        <li class="active"><a data-category="">전체보기</a></li>
        <li><a data-category="정보">정보공유</a></li>
        <li><a data-category="동행">동행게시판</a></li>
        <li><a data-category="후기">후기게시판</a></li>
    </ul>

    <div class="content-card">
        <table id="mainTable">
            <thead>
                <tr>
                    <th width="80">No.</th>
                    <th width="120">분류</th>
                    <th>제목</th>
                    <th width="150">날짜</th>
                    <th width="80">조회</th>
                </tr>
            </thead>
            <tbody>
                <c:forEach var="dto" items="${boardlist}">
                    <tr>
                        <td style="color: #bbb;">${dto.b_code}</td>
                        <td><span style="padding: 5px 10px; background: #f1f3ff; color: #a29bfe; border-radius: 8px; font-size: 12px; font-weight: bold;">${dto.b_category}</span></td>
                        <td style="text-align: left;"><a href="/user/board/detail/${dto.b_code}" style="text-decoration:none; color:#444; font-weight:bold;">${dto.b_title}</a></td>
                        <td style="color: #999;"><fmt:formatDate value="${dto.created_at}" pattern="yyyy.MM.dd"/></td>
                        <td style="font-weight: bold; color: #a29bfe;">${dto.b_view}</td>
                    </tr>
                </c:forEach>
            </tbody>
        </table>
        
        <div style="display: flex; justify-content: flex-end; margin-top: 10px;">
            <a href="/user/board/writeForm" style="background: #a29bfe; color: white; padding: 12px 25px; border-radius: 12px; text-decoration: none; font-weight: bold;">새 글 작성하기</a>
        </div>
    </div>
</div>

<script>
    $(document).ready(function() {
        var table = $('#mainTable').DataTable({
            "dom": 'f<"clear">rt<"bottom"p>', // p(페이지네이션) 위치 명시
            "paging": true,
            "pagingType": "simple_numbers", // 이전, 다음, 숫자 모두 표시
            "language": {
                "search": "",
                "searchPlaceholder": "키워드를 입력하세요",
                "zeroRecords": "데이터가 없습니다.",
                "paginate": { 
                    "next": '<i class="fas fa-chevron-right"></i>', 
                    "previous": '<i class="fas fa-chevron-left"></i>' 
                }
            },
            "order": [[ 0, "desc" ]],
            "pageLength": 10
        });

        // 돋보기 버튼 추가
        $('.dataTables_filter label').append('<button type="button" class="search-btn-custom"><i class="fas fa-search"></i></button>');

        // 카테고리 탭 클릭
        $('#categoryTab a').on('click', function(e) {
            e.preventDefault();
            $('#categoryTab li').removeClass('active');
            $(this).parent().addClass('active');
            table.column(1).search($(this).attr('data-category')).draw();
        });
    });
</script>
</body>
</html>