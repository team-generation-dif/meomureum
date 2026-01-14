<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ taglib prefix="c" uri="jakarta.tags.core" %>
<%@ taglib prefix="fmt" uri="jakarta.tags.fmt" %>
<!DOCTYPE html>
<html>
<head>
<meta charset="UTF-8">
<title>머무름 - 신고관리</title>
<style>
    body { background-color: #f8f9ff; margin: 0; font-family: 'Malgun Gothic', sans-serif; color: #333; }
    .admin-main { padding: 40px; max-width: 1300px; margin: 0 auto; }
    .page-header { display: flex; justify-content: space-between; align-items: flex-start; margin-bottom: 20px; }
    .table-title { font-size: 28px; font-weight: bold; color: #2d3436; margin: 0; }
    .btn-home-back {
        display: flex; align-items: center; gap: 8px; padding: 10px 18px; background: white;
        border: 1px solid #e1e5ff; border-radius: 12px; text-decoration: none; font-weight: bold; color: #666;
        box-shadow: 0 4px 10px rgba(162,155,254,0.1); transition: 0.3s;
    }
    .content-card { background: white; border-radius: 30px; padding: 35px; box-shadow: 0 15px 35px rgba(0,0,0,0.03); border: 1px solid #f1f3ff; }
    table { width: 100%; border-collapse: separate; border-spacing: 0; }
    th { padding: 15px; color: #a2a2a2; font-size: 13px; text-transform: uppercase; border-bottom: 2px solid #f8f9ff; text-align: center; }
    td { padding: 18px 10px; border-bottom: 1px solid #f8f9ff; text-align: center; font-size: 14px; color: #444; }
    .badge-cat { padding: 5px 10px; border-radius: 8px; font-size: 11px; font-weight: bold; background: #f1f3ff; color: #a29bfe; }
    .btn-action { border: none; padding: 6px 12px; border-radius: 8px; font-size: 12px; font-weight: bold; cursor: pointer; transition: 0.2s; }
    .btn-delete { background: #ff7675; color: white; }
    .btn-ignore { background: #dfe6e9; color: #636e72; }
    .target-link { color: #a29bfe; text-decoration: underline; font-weight: bold; }
</style>
</head>
<body>
    <div class="admin-main">
        <div class="page-header">
            <h1 class="table-title">신고내역 관리</h1>
            <a href="/admin/member/main" class="btn-home-back">🏠 관리자 메인</a>
        </div>
        <div class="content-card">
            <table>
                <thead>
                    <tr>
                        <th>신고코드</th><th>구분</th><th>대상번호</th><th>신고제목</th><th>신고내용</th><th>신고자</th><th>신고일</th><th>처리</th>
                    </tr>
                </thead>
                <tbody>
                    <c:forEach var="rep" items="${reports}">
                        <tr>
                            <td>${rep.rep_code}</td>
                            <td><span class="badge-cat">${rep.rep_category}</span></td>
                            <td>
                                <a href="/user/board/detail/${rep.target_code}" class="target-link" target="_blank">
                                    ${rep.target_code}
                                </a>
                            </td>
                            <td style="text-align: left;"><b>${rep.rep_title}</b></td>
                            <td style="text-align: left;">${rep.rep_content}</td>
                            <td>${rep.m_code}</td>
                            <td><fmt:formatDate value="${rep.created_at}" pattern="yyyy-MM-dd HH:mm"/></td>
                            <td>
                                <form action="/admin/report/process" method="post" style="display:flex; gap:5px;">
                                    <input type="hidden" name="rep_code" value="${rep.rep_code}">
                                    <input type="hidden" name="target_code" value="${rep.target_code}">
                                    <input type="hidden" name="rep_category" value="${rep.rep_category}">
                                    <button type="submit" name="action" value="DELETE" class="btn-action btn-delete" onclick="return confirm('정말 삭제하시겠습니까?')">삭제</button>
                                    <button type="submit" name="action" value="IGNORE" class="btn-action btn-ignore">무시</button>
                                </form>
                            </td>
                        </tr>
                    </c:forEach>
                </tbody>
            </table>
        </div>
    </div>
</body>
</html>