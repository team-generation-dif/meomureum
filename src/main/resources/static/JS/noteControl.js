function newNote(){
	const container = document.getElementById('n_container');
    const template = document.getElementById('n_template').innerHTML;
	const newNote = document.createElement("div"); // 스케쥴러 영역
	
	newNote.className = "n_item";
	newNote.innerHTML = template;
	
	container.appendChild(newNote);
	
	// 제목 입력 시 사이드바에 즉시 반영
    const titleInput = newNote.querySelector('input[name="n_title"]');
    titleInput.addEventListener('input', setOrder); 
    
    setOrder();
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