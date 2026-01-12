function newNote(){
	const container = document.getElementById('n_container');
    const template = document.getElementById('n_template').innerHTML;
	const newNote = document.createElement("div"); // 스케쥴러 영역
	
	const sidebarNotes = document.getElementById('sidebar-notes'); // 사이드바 영역
	const noteIdx = document.querySelectorAll('.n_item').length; // 클래스 선택자 n_item인 태그 갯수
	
	newNote.className = "n_item";
	newNote.innerHTML = template;
	newNote.id = `note_section_${noteIdx}`; // 스크롤 위치 확인용 ID 설정
	
	// 제목 입력 시 사이드바 버튼 텍스트와 동기화
    const titleInput = newNote.querySelector('input[name="n_title"]'); // name 값이 n_title인 모든 노트 선택
	// 노트의 명칭이 입력될 때마다 실행하는 함수. 
    titleInput.addEventListener('input', function() {
        document.getElementById(`nav_note_${noteIdx}`).innerText = this.value || '새 노트';
    }); 
	
	container.appendChild(newNote);
	
	// 사이드바에 버튼 추가
    const navBtn = document.createElement("button");
    navBtn.type = "button";
    navBtn.className = "nav-item";
    navBtn.id = `nav_note_${noteIdx}`;
    navBtn.innerText = "새 노트";
    navBtn.onclick = () => scrollToNote(noteIdx);
    sidebarNotes.appendChild(navBtn);
}

function deleteNote(item){
    const n_item = item.closest('.n_item');
    n_item.remove();
	setOrder();
}

/* Sortable JS 라이브러리 */
document.addEventListener("DOMContentLoaded", function() {
    const nContainer = document.getElementById('n_container');
    if (nContainer && typeof Sortable !== 'undefined') {
        new Sortable(nContainer, {
            animation: 150,
            handle: '.nav-item', // 드래그 핸들 지정
            ghostClass: 'sortable-ghost',
            onEnd: function() {
                setOrder(); // 드래그가 끝나면 즉시 hidden 필드 순서(n_order) 갱신
            }
        });
    }
});