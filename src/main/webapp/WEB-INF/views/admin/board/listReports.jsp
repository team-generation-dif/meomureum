<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ taglib prefix="c" uri="jakarta.tags.core" %>
<%@ taglib prefix="fmt" uri="jakarta.tags.fmt" %>
<!DOCTYPE html>
<html>
<head>
<meta charset="UTF-8">
<title>신고 관리</title>
<link href="https://stackpath.bootstrapcdn.com/bootstrap/3.4.1/css/bootstrap.min.css" rel="stylesheet">
</head>
<body>
<div class="container">
    <h3>🚨 신고된 게시글/댓글 목록</h3>
    <table class="table table-bordered table-hover">
        <thead>
            <tr>
                <th>신고코드</th>
                <th>카테고리</th>
                <th>제목</th>
                <th>내용</th>
                <th>신고자</th>
                <th>대상코드</th>
                <th>신고일</th>
                <th>처리</th>
            </tr>
        </thead>
        <tbody>
            <c:forEach var="rep" items="${reports}">
                <tr>
                    <td>${rep.rep_code}</td>
                    <td>${rep.rep_category}</td>
                    <td>${rep.rep_title}</td>
                    <td>${rep.rep_content}</td>
                    <td>${rep.m_code}</td>
                    <td>${rep.target_code}</td>
                    <td><fmt:formatDate value="${rep.created_at}" pattern="yyyy-MM-dd HH:mm"/></td>
                    <td>
                        <!-- 삭제 버튼 -->
                        <form method="post" action="/admin/report/process" style="display:inline;">
                            <input type="hidden" name="rep_code" value="${rep.rep_code}">
                            <input type="hidden" name="target_code" value="${rep.target_code}">
                            <input type="hidden" name="rep_category" value="${rep.rep_category}">
                            <input type="hidden" name="action" value="DELETE">
                            <button type="submit" class="btn btn-danger btn-sm"
                                    onclick="return confirm('정말 삭제하시겠습니까?')">삭제</button>
                        </form>
                        <!-- 무시 버튼 -->
                        <form method="post" action="/admin/report/process" style="display:inline;">
                            <input type="hidden" name="rep_code" value="${rep.rep_code}">
                            <input type="hidden" name="target_code" value="${rep.target_code}">
                            <input type="hidden" name="rep_category" value="${rep.rep_category}">
                            <input type="hidden" name="action" value="IGNORE">
                            <button type="submit" class="btn btn-secondary btn-sm">무시</button>
                        </form>
                    </td>
                </tr>
            </c:forEach>
        </tbody>
    </table>
</div>
</body>
</html>
