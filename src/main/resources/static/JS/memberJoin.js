
document.getElementById("joinForm").addEventListener("submit", function(event) {

	// 아이디 검사
    const id = document.getElementById("m_id").value.trim();
    if (id.length < 4) {
        alert("아이디는 최소 4글자 이상이어야 합니다.");
        event.preventDefault();
        return;
    }

    // 비밀번호 검사 (8자 이상, 숫자+문자 포함)
    const passwd = document.querySelector("input[name='m_passwd']").value;
    const pwPattern = /^(?=.*[A-Za-z])(?=.*\d)[A-Za-z\d]{8,}$/;
    if (!pwPattern.test(passwd)) {
        alert("비밀번호는 8자 이상, 숫자와 문자를 포함해야 합니다.");
        event.preventDefault();
        return;
    }

    // 이름 검사 (한글만 허용)
    const name = document.querySelector("input[name='m_name']").value;
    const namePattern = /^[가-힣]+$/;
    if (!namePattern.test(name)) {
        alert("이름은 한글만 입력 가능합니다.");
        event.preventDefault();
        return;
    }

    // 이메일 검사
    const email = document.querySelector("input[name='m_email']").value;
    if (email && !/^[^\s@]+@[^\s@]+\.[^\s@]+$/.test(email)) {
        alert("올바른 이메일 형식이 아닙니다.");
        event.preventDefault();
        return;
    }

    // 전화번호 검사 (010-0000-0000 형식)
    const tel = document.querySelector("input[name='m_tel']").value;
    if (tel && !/^010-\d{4}-\d{4}$/.test(tel)) {
        alert("전화번호는 010-0000-0000 형식으로 입력해주세요.");
        event.preventDefault();
        return;
    }
	
	
});

// 팝업창을 띄우는 함수
function fn_openIdCheck() {
    var url = "/guest/idCheck";
    var name = "idCheckPopup";
    var option = "width=450, height=350, top=200, left=500, location=no";
    window.open(url, name, option);
}

