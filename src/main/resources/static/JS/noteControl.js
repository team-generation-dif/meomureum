function newNote(){
	const container = document.getElementById('n_container');
    const template = document.getElementById('n_template').innerHTML;
	const newNote = document.createElement("div"); // 스케쥴러 영역
	
	newNote.className = "n_item";
	
	// ★ 빈 hidden input들을 추가하여 배열 인덱스를 맞춤
    const emptyHiddenInputs = `
        <input type="hidden" name="n_api_code" value="">
        <input type="hidden" name="n_p_name" value="">
        <input type="hidden" name="n_p_addr" value="">
        <input type="hidden" name="n_p_tel" value="">
        <input type="hidden" name="n_p_img" value="">
        <input type="hidden" name="n_p_cat" value="">
        <input type="hidden" name="n_p_x" value="">
        <input type="hidden" name="n_p_y" value="">
    `;
	
	newNote.innerHTML = template + emptyHiddenInputs;
	
	container.appendChild(newNote);
	
	// 제목 입력 시 사이드바에 즉시 반영
    const titleInput = newNote.querySelector('input[name="n_title"]');
    titleInput.addEventListener('input', setOrder); 
    
    setOrder();
}

function addNoteWithPlace(place) {
	const container = document.getElementById('n_container');
    const template = document.getElementById('n_template').innerHTML;
    const newNote = document.createElement("div"); 
    
    newNote.className = "n_item";
    newNote.innerHTML = template;
    
    // 1. 제목 설정
    const titleInput = newNote.querySelector('input[name="n_title"]');
    titleInput.value = place.place_name;
    
    // 2. 정보 표시용 UI 생성 (화면용)
    const infoDiv = document.createElement('div');
    infoDiv.className = 'note-place-info';
    
    let imgHtml = '';
    // 이미지 경로 처리 (이미지가 없으면 빈 값)
    const imageUrl = place.image_url || '';
    
    if (imageUrl) {
        imgHtml = `<img src="${imageUrl}" alt="${place.place_name}">`;
    } else {
        imgHtml = `<div style="width:80px; height:80px; background:#eee; display:flex; align-items:center; justify-content:center; border-radius:4px; font-size:11px; color:#aaa;">No Image</div>`;
    }
    
    const addr = place.road_address_name || place.address_name || '';
    const tel = place.phone || '';
    const apiCode = place.id;
    const category = place.category_name || '';
    const x = place.x;
    const y = place.y;

    infoDiv.innerHTML = `
        ${imgHtml}
        <div class="info-text">
            <div class="info-addr">${addr}</div>
            <div class="info-tel" style="color:#007bff;">${tel}</div>
        </div>
    `;
    
    // 3. 데이터 전송용 Hidden Input 생성
    // Controller에서 이 값들을 받아 Place 정보를 저장하고 Note와 연결
    const hiddenInputs = `
        <input type="hidden" name="n_api_code" value="${apiCode}">
        <input type="hidden" name="n_p_name" value="${place.place_name}">
        <input type="hidden" name="n_p_addr" value="${addr}">
        <input type="hidden" name="n_p_tel" value="${tel}">
        <input type="hidden" name="n_p_img" value="${imageUrl}">
        <input type="hidden" name="n_p_cat" value="${category}">
        <input type="hidden" name="n_p_x" value="${x}">
        <input type="hidden" name="n_p_y" value="${y}">
    `;
    
    // 4. DOM 조립
    const textarea = newNote.querySelector('textarea[name="n_content"]');
    if (textarea) {
        textarea.value = ''; 
        textarea.placeholder = "이 장소에 대한 메모를 남겨보세요.";
        // UI 삽입
        textarea.parentNode.insertBefore(infoDiv, textarea);
        // Hidden Input 삽입
        newNote.insertAdjacentHTML('beforeend', hiddenInputs);
    }
    
    container.appendChild(newNote);
    
    // 이벤트 바인딩 및 정렬
	if (titleInput) {
        titleInput.addEventListener('input', setOrder);
    }
    setOrder();
    newNote.scrollIntoView({ behavior: 'smooth', block: 'center' });
}

function deleteNote(item){
    const n_item = item.closest('.n_item');
    n_item.remove();
	setOrder();
}

/* Sortable JS 라이브러리 */
document.addEventListener("DOMContentLoaded", function() {
    const nContainer = document.getElementById('n_container');
    if (nContainer) {
        new Sortable(nContainer, {
            animation: 150,
            ghostClass: 'sortable-ghost',
            filter: "input, textarea, button", // 입력창 간섭 방지
            preventOnFilter: false, 
            onEnd: function() {
                setOrder(); 
            }
        });
    }
});