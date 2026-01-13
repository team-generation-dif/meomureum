
// 1. 전체 순서 및 사이드바 동기화 통합 함수
// 제출 전이나 조작 후 순서(n_order, r_order)를 1, 2, 3...으로 채워주는 함수
function setOrder() {
    // A. 노트 순서 세팅 및 사이드바 갱신
    const notes = document.querySelectorAll('.n_item');
    const sidebarNotes = document.getElementById('sidebar-notes');
	// 노트가 존재할 경우만 작동
    if (sidebarNotes) {
        sidebarNotes.innerHTML = ''; // 사이드바 초기화
		// 노트 순서에 따라 번호 지정
        notes.forEach((note, index) => {
            // hidden 필드 값 세팅
            const orderInput = note.querySelector('input[name="n_order"]');
            if (orderInput) {
				orderInput.value = index + 1;
            }
            // 본문 ID 재설정 (스크롤 목적지 고정)
            note.id = `note_section_${index}`;
            
            // 사이드바 버튼 생성 및 추가
            const titleVal = note.querySelector('input[name="n_title"]').value;
            const navBtn = createNavButton(titleVal, () => scrollToNote(index));
            sidebarNotes.appendChild(navBtn);
        });
    }

    // B. 루트(일차) 순서 세팅 및 사이드바 갱신
    const days = document.querySelectorAll('.r_day');
    const sidebarRoutes = document.getElementById('sidebar-routes');
	// 이것 역시 루트가 있을 경우 작동
    if (sidebarRoutes) {
        sidebarRoutes.innerHTML = ''; // 사이드바 초기화
		// 일차 별로 나누기 
        days.forEach((day, index) => {
            const dayNum = index + 1;
            // 본문 ID 재설정
            day.id = `day_section_${dayNum}`;
            
            // 일차 별로 아이템들 순서 세팅
            const r_orders = day.querySelectorAll('input[name="r_order"]');
            r_orders.forEach((order, rIdx) => {
                order.value = rIdx + 1;
            });

            // 사이드바 버튼 생성 및 추가
            const navBtn = createNavButton(`Day ${dayNum}`, () => scrollToDay(dayNum));
            sidebarRoutes.appendChild(navBtn);
        });
    }
	
	// 지도의 목록을 갱신하기 위해 지도 쪽에 알림
	if(typeof updateMapButtons === 'function') {
	    updateMapButtons(day);
	}
}

// 공통 버튼 생성 함수
function createNavButton(text, onClick) {
    const btn = document.createElement("button");
    btn.type = "button";
    btn.className = "nav-item";
    btn.innerText = text;
    btn.onclick = onClick;
    return btn;
}

function moveUpNote(items){
	const item = items.closest('.n_item, .r_item');
	const prev = item.previousElementSibling;
    
    if (prev) {
        // 현재 노트를 이전 노트 앞으로 이동
        item.parentNode.insertBefore(item, prev);
		setOrder();
    }
}

function moveDownNote(items){
	const item = items.closest('.n_item, .r_item');
	const next = item.nextElementSibling;
    
    if (next) {
        // 현재 노트를 다음다음 노트 앞으로 이동
        item.parentNode.insertBefore(item, next.nextElementSibling);
		setOrder();
    }
}

// (노트)지정 위치로 스크롤
function scrollToNote(idx) {
    const target = document.getElementById(`note_section_${idx}`);
    if (target) {
        target.scrollIntoView({ behavior: 'smooth', block: 'start' });
    }
}

// (루트)지정 위치로 스크롤
function scrollToDay(dayNum) {
    const target = document.getElementById(`day_section_${dayNum}`);
    const scrollContainer = document.getElementById('left-content'); // 스케줄러 pane

    if (target) {
        // 특정 요소로 스크롤 이동
        target.scrollIntoView({
            behavior: 'smooth', // 부드럽게 이동
            block: 'start'      // 섹션의 시작 부분에 맞춤
        });
        
        // 약간의 강조 효과 (선택 사항)
        target.style.backgroundColor = "#fff9c4";
        setTimeout(() => target.style.backgroundColor = "transparent", 1000);
    }
}