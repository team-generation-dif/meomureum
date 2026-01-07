<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<!DOCTYPE html>
<html>
<head>
<meta charset="UTF-8">
<title>회원가입 - 머무름</title>
<style>
    body { font-family: 'Malgun Gothic', sans-serif; background-color: #f8f9fa; display: flex; justify-content: center; padding: 50px 0; }
    .join-container { background: #fff; padding: 40px; border-radius: 12px; box-shadow: 0 8px 20px rgba(0,0,0,0.08); width: 450px; }
    h2 { text-align: center; color: #2c3e50; margin-bottom: 30px; }
    .form-group { margin-bottom: 18px; }
    .form-group label { display: block; margin-bottom: 8px; font-weight: 600; color: #444; }
    .input-row { display: flex; gap: 8px; }
    input[type="text"], input[type="password"], input[type="email"], input[type="tel"] {
        width: 100%; padding: 12px; border: 1px solid #ddd; border-radius: 6px; box-sizing: border-box; transition: 0.3s;
    }
    input:focus { border-color: #3498db; outline: none; box-shadow: 0 0 5px rgba(52,152,219,0.3); }
    .btn-check { width: 120px; background: #34495e; color: white; border: none; border-radius: 6px; cursor: pointer; font-weight: bold; }
    #id_msg { font-size: 13px; margin-top: 6px; color: #7f8c8d; }
    .gender-group { display: flex; gap: 20px; padding: 10px 0; }
    .btn-submit { width: 100%; padding: 15px; background: #3498db; color: white; border: none; border-radius: 6px; font-size: 17px; font-weight: bold; cursor: pointer; margin-top: 20px; }
    .btn-submit:disabled { background: #bdc3c7; cursor: not-allowed; }
</style>
</head>
<body>

<div class="join-container">
    <h2>회원가입</h2>
    <form action="/guest/join" method="post" id="joinForm">
        
        <div class="form-group">
            <label>아이디</label>
            <div class="input-row">
                <input type="text" name="m_id" id="m_id" placeholder="중복확인을 해주세요" readonly required>
                <button type="button" class="btn-check" onclick="fn_openIdCheck()">중복확인</button>
            </div>
            <div id="id_msg">중복 확인을 해야 가입이 가능합니다.</div>
        </div>

        <div class="form-group">
            <label>비밀번호</label>
            <input type="password" name="m_passwd" placeholder="비밀번호 입력" required>
        </div>

        <div class="form-group">
            <label>이름</label>
            <input type="text" name="m_name" placeholder="실명 입력" required>
        </div>

        <div class="form-group">
            <label>닉네임</label>
            <input type="text" name="m_nick" placeholder="사용할 닉네임">
        </div>

        <div class="form-group">
            <label>이메일</label>
            <input type="email" name="m_email" placeholder="example@mail.com">
        </div>

        <div class="form-group">
            <label>전화번호</label>
            <input type="tel" name="m_tel" placeholder="010-0000-0000">
        </div>

        <div class="form-group">
            <label>성별</label>
            <div class="gender-group">
                <label style="font-weight:normal;"><input type="radio" name="m_gender" value="M" checked> 남성</label>
                <label style="font-weight:normal;"><input type="radio" name="m_gender" value="F"> 여성</label>
            </div>
        </div>

        <button type="submit" class="btn-submit" id="submitBtn" disabled>가입하기</button>
    </form>
</div>

<script>
    // 팝업창을 띄우는 함수
    function fn_openIdCheck() {
        var url = "/guest/idCheck";
        var name = "idCheckPopup";
        var option = "width=450, height=350, top=200, left=500, location=no";
        window.open(url, name, option);
    }
</script>

</body>
</html>