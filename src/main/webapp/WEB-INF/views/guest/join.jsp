<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<!DOCTYPE html>
<html>
<head>
<meta charset="UTF-8">
<title>머무름 - 함께하기</title>
<style>
    /* [1] 기본 레이아웃 및 배경 */
    body { 
        background-color: #f8f9ff; margin: 0; 
        font-family: 'Pretendard', 'Malgun Gothic', sans-serif; 
        display: flex; justify-content: center; align-items: center; 
        min-height: 100vh; padding: 60px 0;
    }
    
    /* [2] 회원가입 카드 컨테이너 */
    .join-container { 
        background: #fff; padding: 60px 50px; 
        border-radius: 40px; box-shadow: 0 20px 50px rgba(162,155,254,0.1); 
        width: 100%; max-width: 480px; border: 1px solid #f1f3ff;
    }

    .join-header { text-align: center; margin-bottom: 40px; }
    .join-header h2 { font-size: 28px; color: #2d3436; margin: 0; letter-spacing: -1px; }
    .join-header p { color: #a2a2a2; font-size: 14px; margin-top: 10px; }
    .header-dot { width: 6px; height: 6px; background: #a29bfe; border-radius: 50%; margin: 15px auto 0; }

    /* [3] 폼 요소 스타일 */
    .form-group { margin-bottom: 25px; }
    .form-group label { display: block; margin-bottom: 10px; font-weight: bold; color: #2d3436; font-size: 14px; margin-left: 5px; }
    
    .input-row { display: flex; gap: 10px; }
    
    input[type="text"], input[type="password"], input[type="email"], input[type="tel"] {
        width: 100%; padding: 15px 20px; border: 1px solid #f1f3ff; border-radius: 18px; 
        background-color: #fafaff; font-size: 15px; color: #2d3436; box-sizing: border-box; 
        transition: 0.3s; outline: none;
    }
    
    /* 포커스 시 부드러운 강조 */
    input:focus { 
        border-color: #a29bfe; background-color: #fff; 
        box-shadow: 0 0 0 4px rgba(162,155,254,0.1); 
    }
    
    input[readonly] { background-color: #f1f3ff; color: #b2bec3; cursor: default; border: none; }

    /* 중복확인 버튼 */
    .btn-check { 
        min-width: 100px; background: #2d3436; color: white; border: none; 
        border-radius: 15px; cursor: pointer; font-weight: bold; font-size: 13px; transition: 0.3s;
    }
    .btn-check:hover { background: #a29bfe; transform: translateY(-2px); }

    #id_msg { font-size: 12px; margin-top: 8px; color: #a2a2a2; margin-left: 5px; }

    /* 성별 라디오 버튼 커스텀 */
    .gender-group { display: flex; gap: 15px; padding: 5px 0; }
    .gender-group label { 
        flex: 1; padding: 12px; text-align: center; border: 1px solid #f1f3ff; 
        border-radius: 15px; cursor: pointer; transition: 0.3s; background: #fafaff;
        font-weight: normal; color: #888; margin: 0;
    }
    .gender-group input[type="radio"] { display: none; }
    .gender-group input[type="radio"]:checked + span { color: #a29bfe; font-weight: bold; }
    .gender-group label:has(input:checked) { 
        border-color: #a29bfe; background: #fff; color: #a29bfe; 
        box-shadow: 0 5px 15px rgba(162,155,254,0.1); 
    }

    /* 가입하기 버튼 */
    .btn-submit { 
        width: 100%; padding: 18px; background: #a29bfe; color: white; border: none; 
        border-radius: 20px; font-size: 17px; font-weight: bold; cursor: pointer; 
        margin-top: 30px; transition: 0.3s; box-shadow: 0 10px 20px rgba(162,155,254,0.2);
    }
    .btn-submit:hover { background: #6c5ce7; transform: translateY(-3px); }
    .btn-submit:disabled { background: #eee; color: #ccc; box-shadow: none; cursor: not-allowed; }

</style>
</head>
<body>
<div class="join-container">
    <div class="join-header">
        <h2>반가워요!</h2>
        <p>머무름과 함께 소중한 기록을 시작해 보세요</p>
        <div class="header-dot"></div>
    </div>

    <form action="/guest/join" method="post" id="joinForm">
        <div class="form-group">
            <label>아이디</label>
            <div class="input-row">
                <input type="text" name="m_id" id="m_id" placeholder="중복확인이 필요해요" readonly required>
                <button type="button" class="btn-check" onclick="fn_openIdCheck()">중복확인</button>
            </div>
            <div id="id_msg">중복 확인을 완료해 주세요.</div>
        </div>

        <div class="form-group">
            <label>비밀번호</label>
            <input type="password" name="m_passwd" placeholder="8자 이상, 숫자와 문자를 포함해 주세요" required>
        </div>

        <div class="form-group">
            <label>이름</label>
            <input type="text" name="m_name" placeholder="실명을 입력해 주세요" required>
        </div>

        <div class="form-group">
            <label>닉네임</label>
            <input type="text" name="m_nick" placeholder="커뮤니티에서 사용할 이름" required>
        </div>

        <div class="form-group">
            <label>이메일</label>
            <input type="email" name="m_email" placeholder="example@meomureum.com">
        </div>

        <div class="form-group">
            <label>전화번호</label>
            <input type="tel" name="m_tel" placeholder="010-0000-0000" required>
        </div>

        <div class="form-group">
            <label>성별</label>
            <div class="gender-group">
                <label>
                    <input type="radio" name="m_gender" value="M" checked>
                    <span>남성</span>
                </label>
                <label>
                    <input type="radio" name="m_gender" value="F">
                    <span>여성</span>
                </label>
            </div>
        </div>

        <button type="submit" class="btn-submit" id="submitBtn" disabled>기록 시작하기</button>
    </form>
</div>

<script>
document.getElementById("joinForm").addEventListener("submit", function(event) {
    const id = document.getElementById("m_id").value.trim();
    if (id.length < 4) {
        alert("아이디는 최소 4글자 이상이어야 합니다.");
        event.preventDefault();
        return;
    }

    const passwd = document.querySelector("input[name='m_passwd']").value;
    const pwPattern = /^(?=.*[A-Za-z])(?=.*\d)[A-Za-z\d]{8,}$/;
    if (!pwPattern.test(passwd)) {
        alert("비밀번호는 8자 이상, 숫자와 문자를 포함해야 합니다.");
        event.preventDefault();
        return;
    }

    const name = document.querySelector("input[name='m_name']").value;
    const namePattern = /^[가-힣]+$/;
    if (!namePattern.test(name)) {
        alert("이름은 한글만 입력 가능합니다.");
        event.preventDefault();
        return;
    }

    const emailInput = document.querySelector("input[name='m_email']");
    const emailValue = emailInput.value.trim();
    const emailPattern = /^[0-9a-zA-Z]([-_.]?[0-9a-zA-Z])*@[0-9a-zA-Z]([-_.]?[0-9a-zA-Z])*.[a-zA-Z]{2,3}$/i;
    
    if (emailValue !== "" && !emailPattern.test(emailValue)) {
        alert("올바른 이메일 형식이 아닙니다.");
        emailInput.focus();
        event.preventDefault();
        return false;
    }

    const telInput = document.querySelector("input[name='m_tel']");
    if (!/^010-\d{4}-\d{4}$/.test(telInput.value)) {
        alert("전화번호 형식을 확인해 주세요. (010-0000-0000)");
        telInput.focus();
        event.preventDefault();
        return false;
    }
});

function fn_openIdCheck() {
    var url = "/guest/idCheck";
    var name = "idCheckPopup";
    var option = "width=420, height=450, top=200, left=500, location=no, resizable=no";
    window.open(url, name, option);
}
</script>
</body>
</html>