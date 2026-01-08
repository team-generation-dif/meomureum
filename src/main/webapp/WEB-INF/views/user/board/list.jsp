<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ taglib uri="http://java.sun.com/jsp/jstl/core" prefix="c" %>
<%@ taglib uri="http://java.sun.com/jsp/jstl/fmt" prefix="fmt" %>
<!DOCTYPE html>
<html>
<head>
<meta charset="UTF-8">
<title>게시판 목록</title>

<link href="https://stackpath.bootstrapcdn.com/bootstrap/3.4.1/css/bootstrap.min.css" rel="stylesheet">
<script src="https://code.jquery.com/jquery-3.5.1.min.js"></script>
<script src="https://stackpath.bootstrapcdn.com/bootstrap/3.4.1/js/bootstrap.min.js"></script>

<link rel="stylesheet" type="text/css" href="https://cdn.datatables.net/1.10.25/css/dataTables.bootstrap.min.css">
<script type="text/javascript" src="https://cdn.datatables.net/1.10.25/js/jquery.dataTables.min.js"></script>
<script type="text/javascript" src="https://cdn.datatables.net/1.10.25/js/dataTables.bootstrap.min.js"></script>

<style>
    body { font-family: 'Malgun Gothic', sans-serif; background-color: #f9f9f9; }
    .container { 
        background-color: white; padding: 30px; border-radius: 10px; 
        box-shadow: 0 0 10px rgba(0,0,0,0.1); margin-top: 30px;
        max-width: 1000px;
    }
    .table { width: 100% !important; }
    .table th { background-color: #f8f9fa; text-align: center; }
    .table td { text-align: center; vertical-align: middle !important; }
    .text-left { text-align: left !important; }
    
    .nav-tabs { margin-bottom: 20px; border-bottom: 2px solid #ddd; }
    .nav-tabs > li { cursor: pointer; } /* 마우스 커서 손모양 */
    .nav-tabs > li > a { font-weight: bold; color: #666; }

    /* 페이징 번호 완벽 중앙 정렬 */
    .dataTables_wrapper .dataTables_paginate {
        width: 100%;
        text-align: center !important;
        float: none !important;
        margin-top: 20px;
    }
    .dataTables_wrapper .dataTables_paginate .pagination {
        display: inline-flex;
    }
    
    /* 10개씩 보기 하단 배치 */
    .dataTables_length { float: left !important; margin-top: 20px; }
    
    /* 하단 게시글 등록 버튼 */
    .btn-write-wrapper { text-align: right; margin-top: 20px; }
</style>
</head>
<body>

<div class="container">
    <h3><span class="glyphicon glyphicon-list-alt"></span> 게시판 목록</h3>
    
    <ul class="nav nav-tabs" id="categoryTab">
        <li class="active"><a data-category="">전체보기</a></li>
        <li><a data-category="정보">정보공유</a></li>
        <li><a data-category="동행">동행게시판</a></li>
        <li><a data-category="후기">후기게시판</a></li>
    </ul>

    <table id="mainTable" class="table table-bordered table-hover">
        <thead>
            <tr>
                <th width="80">번호</th>
                <th width="100">분류</th>
                <th>제목</th>
                <th width="150">작성일</th>
                <th width="80">조회수</th>
                <th style="display:none;">내용</th> </tr>
        </thead>
        <tbody>
            <c:forEach var="dto" items="${boardlist}">
                <tr>
                    <td>${dto.b_code}</td>
                    <td>
                        <span class="label ${dto.b_category == '정보' ? 'label-info' : (dto.b_category == '동행' ? 'label-success' : 'label-warning')}">
                            ${dto.b_category}
                        </span>
                    </td>
                    <td class="text-left">
                        <a href="/user/board/detail/${dto.b_code}"><strong>${dto.b_title}</strong></a>
                    </td>
                    <td><fmt:formatDate value="${dto.created_at}" pattern="yyyy-MM-dd"/></td>
                    <td>${dto.b_view}</td>
                    <td style="display:none;">${dto.b_content}</td> 
                </tr>
            </c:forEach>
        </tbody>
    </table>

    <div class="btn-write-wrapper">
        <a href="/user/board/writeForm" class="btn btn-primary">
            <span class="glyphicon glyphicon-pencil"></span> 게시글 등록
        </a>
    </div>
</div>

<script>
$(document).ready(function() {
    var table = $('#mainTable').DataTable({
        "dom": '<"top"f>rt<"bottom"lp><"clear">',
        "language": {
            "lengthMenu": "_MENU_ 개씩 보기",
            "search": "제목+내용 검색: ",
            "zeroRecords": "해당하는 게시글이 없습니다.",
            "paginate": { "next": "다음", "previous": "이전" }
        },
        "columnDefs": [
            { "targets": [0, 1, 3, 4], "searchable": false }, // 분류(1)를 '통합 검색창'에서 제외
            { "targets": [2, 5], "searchable": true }         // 제목(2)과 내용(5)만 '통합 검색창'에서 검색
        ],
        "order": [[ 0, "desc" ]],
        "pageLength": 10
    });

    // [수정된 탭 필터링 로직]
    $('#categoryTab a').on('click', function(e) {
        e.preventDefault();
        
        // 1. 탭 활성화 클래스 처리
        $('#categoryTab li').removeClass('active');
        $(this).parent().addClass('active');

        // 2. 카테고리 값 가져오기 (정보, 동행, 후기 중 하나)
        var category = $(this).attr('data-category');

        // 3. 필터링 실행
        // 컬럼 1(분류)에서 해당 텍스트를 찾아 화면을 다시 그립니다.
        // category가 빈 문자열("")이면 모든 데이터가 다시 보입니다.
        table.column(1).search(category).draw();
    });
});
</script>
</body>
</html>