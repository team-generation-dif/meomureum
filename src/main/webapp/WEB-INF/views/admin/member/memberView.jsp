<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<%@ taglib prefix="fmt" uri="http://java.sun.com/jsp/jstl/fmt" %>
<!DOCTYPE html>
<html>
<head>
<meta charset="UTF-8">
<title>머무름 - 회원 상세 관리</title>
<style>
    /* [1] 기본 레이아웃 */
    body { background-color: #f8f9ff; margin: 0; font-family: 'Malgun Gothic', sans-serif; color: #333; }
    .admin-main { padding: 40px; max-width: 900px; margin: 0 auto; }

    /* [2] 상단 헤더 영역 */
    .page-header { display: flex; justify-content: space-between; align-items: center; margin-bottom: 30px; }
    .table-title { font-size: 26px; font-weight: bold; color: #2d3436; }
    .btn-list {
        padding: 10px 20px; background: white; border: 1px solid #e1e5ff;
        border-radius: 12px; text-decoration: none; color: #666; font-weight: bold;
        transition: 0.3s; box-shadow: 0 4px 10px rgba(0,0,0,0.03);
    }
    .btn-list:hover { background: #f1f3ff; color: #a29bfe; }

    /* [3] 상세 정보 카드 */
    .detail-card { 
        background: white; border-radius: 30px; padding: 40px; 
        box-shadow: 0 15px 35px rgba(0,0,0,0.03); border: 1px solid #f1f3ff;
    }
    .card-section { margin-bottom: 30px; }
    .section-title { font-size: 18px; font-weight: bold; color: #a29bfe; margin-bottom: 20px; display: flex; align-items: center; gap: 8px; }

    /* [4] 상세 테이블 디자인 */
    .detail-table { width: 100%; border-collapse: collapse; }
    .detail-table th { 
        width: 150px; padding: 15px; background: #fafaff; 
        text-align: left; color: #888; font-size: 14px;
        border-bottom: 1px solid #f1f3ff;
    }
    .detail-table td { 
        padding: 15px; border-bottom: 1px solid #f1f3ff; 
        font-size: 15px; color: #2d3436; font-weight: 500;
    }

    /* [5] 입력 및 버튼 스타일 */
    .select-grade {
        padding: 8px 15px; border-radius: 10px; border: 1px solid #ddd;
        outline: none; font-family: inherit; font-size: 14px;
    }
    .btn-save {
        background: #a29bfe; color: white; border: none; padding: 9px 20px;
        border-radius: 10px; font-weight: bold; cursor: pointer; transition: 0.3s;
    }
    .btn-save:hover { background: #6c5ce7; }

    .btn-delete {
        background: #ff7675; color: white; border: none; padding: 12px 25px;
        border-radius: 12px; font-weight: bold; cursor: pointer; transition: 0.3s;
        box-shadow: 0 5px 15px rgba(255, 118, 117, 0.2);
    }
    .btn-delete:hover { background: #d63031; transform: translateY(-2px); }

    /* 권한 뱃지 */
    .badge-auth { 
        padding: 4px 10px; background: #ffeaa7; color: #fdcb6e; 
        border-radius: 8px; font-size: 12px; font-weight: bold;
    }
</style>
</head>
<body>

    <div class="admin-main">
        <div class="page-header">
            <h1 class="table-title">회원 상세 정보</h1>
            <a href="/admin/member/memberList" class="btn-list">← 목록으로</a>
        </div>

        <div class="detail-card">
            
            <div class="card-section">
                <div class="section-title">👤 기본 정보</div>
                <table class="detail-table">
                    <tr>
                        <th>회원번호</th>
                        <td>${member.m_code}</td>
                        <th>아이디</th>
                        <td><strong>${member.m_id}</strong></td>
                    </tr>
                    <tr>
                        <th>이름(실명)</th>
                        <td>${member.m_name}</td>
                        <th>닉네임</th>
                        <td>${member.m_nick}</td>
                    </tr>
                    <tr>
                        <th>이메일</th>
                        <td>${member.m_email}</td>
                        <th>전화번호</th>
                        <td>${member.m_tel}</td>
                    </tr>
                    <tr>
                        <th>가입일시</th>
                        <td>${member.created_at}</td>
                        <th>현재권한</th>
                        <td><span class="badge-auth">${member.m_auth}</span></td>
                    </tr>
                </table>
            </div>

            <div class="card-section">
                <div class="section-title">✨ 서비스 이용 등급</div>
                <form action="/admin/updateGrade" method="post">
                    <input type="hidden" name="m_code" value="${member.m_code}">
                    <div style="background: #f8f9ff; padding: 20px; border-radius: 20px; display: flex; align-items: center; gap: 15px;">
                        <span style="font-size: 14px; color: #666;">회원 등급 조정:</span>
                        <select name="m_grade" class="select-grade">
                            <option value="BASIC" ${member.m_grade == 'BASIC' ? 'selected' : ''}>일반회원 (BASIC)</option>
                            <option value="LIMIT" ${member.m_grade == 'LIMIT' ? 'selected' : ''}>이용제한 (LIMIT)</option>
                            <option value="BLACKLIST" ${member.m_grade == 'BLACKLIST' ? 'selected' : ''}>블랙리스트 (BLACKLIST)</option>
                        </select>
                        <button type="submit" class="btn-save">설정 저장</button>
                    </div>
                </form>
            </div>

            <div style="margin-top: 50px; padding-top: 30px; border-top: 1px dashed #eee; display: flex; justify-content: space-between; align-items: center;">
                <div>
                    <div style="font-weight: bold; color: #2d3436;">계정 삭제</div>
                    <div style="font-size: 13px; color: #999; margin-top: 5px;">회원 데이터를 영구적으로 삭제하며 되돌릴 수 없습니다.</div>
                </div>
                <form action="/admin/delete" method="post" onsubmit="return confirm('정말 이 회원을 강제 탈퇴시키겠습니까?\n이 작업은 되돌릴 수 없습니다.');">
                    <input type="hidden" name="m_code" value="${member.m_code}">
                    <button type="submit" class="btn-delete">회원 강제 탈퇴</button>
                </form>
            </div>

        </div>
    </div>

</body>
</html>