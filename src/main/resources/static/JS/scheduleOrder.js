// 제출 전 순서(n_order, r_order)를 1, 2, 3...으로 채워주는 함수
function setOrder() {
    const n_orders = document.querySelectorAll('input[name="n_order"]');
    n_orders.forEach((order, index) => {
        order.value = index + 1;
    });
    
    const dayLists = document.querySelectorAll('ul[id$="_list"]');
    dayLists.forEach((list) => {
	    const r_orders = list.querySelectorAll('input[name="r_order"]');
	    r_orders.forEach((order, index) => {
	        order.value = index + 1;
	    });
    });
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