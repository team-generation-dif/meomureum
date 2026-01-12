<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ taglib prefix="c" uri="jakarta.tags.core" %>
<%@ taglib prefix="fmt" uri="jakarta.tags.fmt" %>
<!DOCTYPE html>
<html>
<head>
<meta charset="UTF-8">
<title>머무름 - 관리자 모드</title>
<style>
    .admin-container { max-width: 1200px; margin: 50px auto; padding: 20px; font-family: 'Malgun Gothic', sans-serif; }
    .table-title { font-size: 24px; font-weight: bold; margin-bottom: 20px; color: #2c3e50; border-left: 5px solid #3498db; padding-left: 15px; }
    
    table { width: 100%; border-collapse: collapse; background: white; box-shadow: 0 2px 10px rgba(0,0,0,0.1); }
    th { background-color: #f8f9fa; color: #333; padding: 15px; border-bottom: 2px solid #dee2e6; text-align: center; font-size: 14px; }
    td { padding: 12px; border-bottom: 1px solid #eee; text-align: center; font-size: 14px; color: #555; }
    tr:hover { background-color: #f1f7ff; }

    /* 등급별 배지 스타일 */
    .badge { padding: 4px 8px; border-radius: 4px; font-size: 11px; font-weight: bold; }
    .badge-admin { background: #e74c3c; color: white; }
    .badge-user { background: #3498db; color: white; }
    
    .link-name { text-decoration: none; color: #2980b9; font-weight: bold; }
    .link-name:hover { text-decoration: underline; }
</style>
</head>
<body>
    <%@ include file="../../guest/header.jsp" %>

    <div class="admin-container">
        <div class="table-title">👥 전체 회원 관리</div>
        
        <table>
            <thead>
                <tr>
                    <th>번호</th>
                    <th>아이디</th>
                    <th>이름</th>
                    <th>닉네임</th>
                    <th>이메일</th>
                    <th>연락처</th>
                    <th>성별</th>
                    <th>등급</th>
                    <th>권한</th>
                    <th>가입일</th>
                </tr>
            </thead>
            <tbody>
                <c:forEach var="dto" items="${members}">
                    <tr>
                        <td>${dto.m_code}</td>
                        <td>${dto.m_id}</td>
                        <td>
                            <a href="/admin/view/${dto.m_code}" class="link-name">${dto.m_name}</a>
                        </td>
                        <td>${dto.m_nick}</td>
                        <td>${dto.m_email}</td>
                        <td>${dto.m_tel}</td>
                        <td>${dto.m_gender}</td>
                        <td><span class="badge" style="border: 1px solid #ddd;">${dto.m_grade}</span></td>
                        <td>
                            <c:choose>
                                <c:when test="${dto.m_auth == 'ADMIN'}">
                                    <span class="badge badge-admin">관리자</span>
                                </c:when>
                                <c:otherwise>
                                    <span class="badge badge-user">일반유저</span>
                                </c:otherwise>
                            </c:choose>
                        </td>
                        <td>
                            <c:choose>
                                <c:when test="${not empty dto.created_at}">
                                    ${dto.created_at}
                                </c:when>
                                <c:otherwise>-</c:otherwise>
                            </c:choose>
                        </td>
                    </tr>
                </c:forEach>
            </tbody>
        </table>
    </div>
</body>
</html>