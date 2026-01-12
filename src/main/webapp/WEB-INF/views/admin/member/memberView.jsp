<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ taglib prefix="c" uri="jakarta.tags.core" %>
<%@ taglib prefix="fmt" uri="jakarta.tags.fmt" %>
<!DOCTYPE html>
<html>
<head><title>관리자 - 회원 상세 관리</title></head>
<body>
    <%@ include file="../../guest/header.jsp" %> <h2>회원 상세 관리 (Admin Mode)</h2>
    <fieldset style="border: 2px solid #2c3e50; padding: 20px;">
        <legend><b>회원 기본 및 보안 정보</b></legend>
        
        <table border="1" style="width:100%; border-collapse: collapse; text-align: left;">
            <tr height="40">
                <th width="150" bgcolor="#f4f4f4"> 회원번호</th>
                <td width="350"> ${member.m_code}</td>
                <th width="150" bgcolor="#f4f4f4"> 아이디</th>
                <td width="350"> ${member.m_id}</td>
            </tr>
            <tr height="40">
                <th bgcolor="#f4f4f4"> 이름(실명)</th>
                <td> ${member.m_name}</td>
                <th bgcolor="#f4f4f4"> 닉네임</th>
                <td> ${member.m_nick}</td>
            </tr>
            <tr height="40">
                <th bgcolor="#f4f4f4"> 이메일</th>
                <td> ${member.m_email}</td>
                <th bgcolor="#f4f4f4"> 전화번호</th>
                <td> ${member.m_tel}</td>
            </tr>
            <tr height="40">
                <th bgcolor="#f4f4f4"> 가입일시</th>
                <td> ${member.created_at}</td> <th bgcolor="#f4f4f4"> 현재권한</th>
                <td> ${member.m_auth}</td>
            </tr>
            
            <form action="/admin/updateGrade" method="post">
                <input type="hidden" name="m_code" value="${member.m_code}">
                <tr height="50">
                    <th bgcolor="#ebf5fb"> 등급 수정</th>
                    <td colspan="3">
                        <select name="m_grade" style="padding:5px;">
                            <option value="BASIC" ${member.m_grade == 'BASIC' ? 'selected' : ''}>일반회원</option>
                            <option value="LIMIT" ${member.m_grade == 'LIMIT' ? 'selected' : ''}>제한</option>
                            <option value="BLACKLIST" ${member.m_grade == 'BLACKLIST' ? 'selected' : ''}>블랙리스트</option>
                        </select>
                        <button type="submit" style="cursor:pointer;">등급 변경 저장</button>
                    </td>
                </tr>
            </form>
        </table>

        <div style="margin-top: 20px; display: flex; justify-content: space-between;">
            <button onclick="location.href='/admin/member/list'">목록으로 돌아가기</button>
            
            <form action="/admin/delete" method="post" onsubmit="return confirm('정말 이 회원을 강제 탈퇴시키겠습니까?');">
                <input type="hidden" name="m_code" value="${member.m_code}">
                <button type="submit" style="background: #e74c3c; color: white; border: none; padding: 10px 20px; cursor: pointer;">
                    회원 강제 탈퇴(삭제)
                </button>
            </form>
        </div>
    </fieldset>
</body>
</html>