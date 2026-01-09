// 일차 별 노드 생성
function newRoute(){
// 1. newNote()랑 비슷하게 노드로 작성하므로 필드를 설정
	const container = document.getElementById('r_container');
	container.innerHTML = "";
	
	const start = new Date(document.getElementById('s_start').value);
	const end = new Date(document.getElementById('s_end').value);
// 2. 날짜 차이 + 1 을 일 단위로 계산
	const day = 1 + Math.round(Math.abs(end - start)/(1000*60*60*24));

// 3. 날짜 차이 + 1 만큼 반복문으로 노드를 작성
	for (let i = 1; i <= day; i++){
		const newRoute = document.createElement("div");
		newRoute.className = "r_day";
		newRoute.innerHTML = `
			<div>
				<h4>Day ${i}</h4>
				<ul id="day_${i}_list" class="route_list"></ul>
			</div>
		`;
		
		container.appendChild(newRoute);
	}

	// 지도의 목록을 갱신하기 위해 지도 쪽에 알림 
    if(typeof updateMapButtons === 'function') {
        updateMapButtons(day);
    }
}
// 일차 내에 세부 계획 노드 생성
function addRoute(day, place) {
    
    let targetList = document.getElementById(`day_${day}_list`);
    
    if (!targetList) {
        alert("해당 날짜가 존재하지 않습니다.");
        return;
    }

    const li = document.createElement("li");
    li.className = "r_item";
    
    li.innerHTML = `
    	<strong>${place.place_name}</strong>
		<input type="button" value="▲" onclick="moveUpNote(this); setOrder();">
		<input type="button" value="▼" onclick="moveDownNote(this); setOrder();">
		<br>
        <input type="text" name="r_memo" placeholder="메모 입력"">
        <input type="button" value="X" onclick="this.closest('.r_item').remove(); setOrder();">
        <input type="hidden" name="r_day" value="${day}">
        <input type="hidden" name="r_order">
        
        <input type="hidden" name="api_code" value="${place.id}">
        <input type="hidden" name="p_place" value="${place.place_name}">
        <input type="hidden" name="p_category" value="${place.category_group_name}">
        <input type="hidden" name="p_lat" value="${place.y}">
        <input type="hidden" name="p_lon" value="${place.x}">
        <input type="hidden" name="p_addr" value="${place.road_address_name || place.address_name}">
    `;
    
    targetList.appendChild(li);
}
function moveUpNote(item){
	const r_item = item.closest('.r_item');
	const prev = r_item.previousElementSibling;
    
    if (prev) {
        // 현재 노트를 이전 노트 앞으로 이동
        r_item.parentNode.insertBefore(r_item, prev);
    }
}

function moveDownNote(item){
	const r_item = item.closest('.r_item');
	const next = r_item.nextElementSibling;
    
    if (next) {
        // 현재 노트를 다음다음 노트 앞으로 이동
        r_item.parentNode.insertBefore(r_item, next.nextElementSibling);
    }
}