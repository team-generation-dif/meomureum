let n_count = 0;
function newNote(){
	const container = document.getElementById('n_container');
    const template = document.getElementById('n_template').innerHTML;
	const newNote = document.createElement("div")
	
	newNote.className = "n_item"
	newNote.innerHTML = template;
	
	container.appendChild(newNote);
	n_count++;
}

function deleteNote(btn){
    const n_item = btn.closest('.n_item');
    n_item.remove();
    n_count--;
}

function moveUpNote(btn){
	const n_item = btn.closest('.n_item');
	const prev = n_item.previousElementSibling;
    
    if (prev) {
        // 현재 노트를 이전 노트 앞으로 이동
        n_item.parentNode.insertBefore(n_item, prev);
    }
}

function moveDownNote(btn){
	const n_item = btn.closest('.n_item');
	const next = n_item.nextElementSibling;
    
    if (next) {
        // 현재 노트를 다음다음 노트 앞으로 이동
        n_item.parentNode.insertBefore(n_item, next.nextElementSibling);
    }
}