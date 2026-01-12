<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ taglib prefix="c" uri="jakarta.tags.core" %>
<!DOCTYPE html>
<html>
<head>
    <meta charset="UTF-8">
    <title>머무름 - 정보 수정</title>
    <style>
        body { font-family: 'Malgun Gothic', sans-serif; background-color: #f4f7f6; margin: 0; padding: 50px; }
        .update-box { background: white; width: 450px; margin: 0 auto; padding: 40px; border-radius: 15px; box-shadow: 0 5px 20px rgba(0,0,0,0.05); }
        h2 { text-align: center; color: #333; border-bottom: 2px solid #2196F3; padding-bottom: 10px; margin-bottom: 30px; }
        
        table { width: 100%; border-collapse: collapse; }
        th { text-align: left; padding: 12px; color: #777; width: 120px; font-size: 14px; }
        td { padding: 8px 0; }
        
        /* 입력창 스타일 */
        input[type="text"], input[type="password"], input[type="email"], input[type="tel"] {
            width: 100%;
            padding: 10px;
            border: 1px solid #ddd;
            border-radius: 5px;
            box-sizing: border-box;
            font-size: 14px;
        }
        
        /* 아이디(읽기전용) 스타일 */
        input[readonly] { background-color: #f8f9fa; color: #999; cursor: not-allowed; border: 1px solid #eee; }
        
        .hint { font-size: 11px; color: #ff6b6b; margin-top: 4px; }
        
        /* 버튼 스타일 */
        .btn-group { margin-top: 30px; display: flex; gap: 10px; }
        .btn { flex: 1; padding: 12px; border-radius: 5px; text-decoration: none; font-size: 15px; font-weight: bold; cursor: pointer; border: none; text-align: center; }
        .btn-submit { background-color: #2196F3; color: white; }
        .btn-submit:hover { background-color: #1976D2; }
        .btn-back { background-color: #adb5bd; color: white; }
        .btn-back:hover { background-color: #868e96; }
    </style>
</head>
<body>

    <div class="update-box">
        <h2>✏️ 정보 수정</h2>
        
        <form name="member" method="post" action="/user/update">
            <input type="hidden" name="m_code" value="${edit.m_code}">
            
            <table>
                <tr>
                    <th>아이디</th>
                    <td><input type="text" value="${edit.m_id}" readonly></td>
                </tr>
                <tr>
                    <th>새 비밀번호</th>
                    <td>
                        <input type="password" name="m_passwd" placeholder="변경 시에만 입력">
                        <div class="hint">* 비밀번호를 변경할 때만 입력하세요.</div>
                    </td>
                </tr>
                <tr>
                    <th>이름</th>
                    <td><input type="text" name="m_name" value="${edit.m_name}"></td>
                </tr>
                <tr>
                    <th>닉네임</th>
                    <td><input type="text" name="m_nick" value="${edit.m_nick}"></td>
                </tr>
                <tr>
                    <th>이메일</th>
                    <td><input type="email" name="m_email" value="${edit.m_email}"></td>
                </tr>
                <tr>
                    <th>연락처</th>
                    <td><input type="tel" name="m_tel" value="${edit.m_tel}"></td>
                </tr>
            </table>
            
            <div class="btn-group">
                <button type="submit" class="btn btn-submit">수정 완료</button>
                <button type="button" class="btn btn-back" onclick="location.href='/user/mypage/main'">취소</button>
            </div>
        </form>
    </div>

</body>
</html>