// 일차 별 노드 생성
function newRoute(){
// 1. newNote()랑 비슷하게 노드로 작성하므로 필드를 설정
	const container = document.getElementById('r_container'); // 스케쥴러 영역
	const sidebarRoutes = document.getElementById('sidebar-routes'); // 사이드바 영역
	// 초기화
	container.innerHTML = "";
	sidebarRoutes.innerHTML = "";
	
	const start = new Date(document.getElementById('s_start').value);
	const end = new Date(document.getElementById('s_end').value);
// 2. 날짜 차이 + 1 을 일 단위로 계산
	const day = 1 + Math.round(Math.abs(end - start)/(1000*60*60*24));

// 3. 날짜 차이 + 1 만큼 반복문으로 노드를 작성
	for (let i = 1; i <= day; i++){
		// 스케쥴러 영역 생성
		const newRoute = document.createElement("div");
		newRoute.className = "r_day";
		newRoute.id = `day_section_${i}`; // 스크롤 목적지를 위한 id 설정
		newRoute.innerHTML = `
			<div>
				<h4>Day ${i}</h4>
				<ul id="day_${i}_list" class="route_list"></ul>
			</div>
		`;
		
		container.appendChild(newRoute);
		
		// 사이드바 영역 생성
		const navBtn = document.createElement("button");
        navBtn.type = "button";
        navBtn.className = "nav-item";
        navBtn.innerText = `Day ${i}`;
        navBtn.onclick = () => scrollToDay(i); // 클릭 이벤트 연결
		
        sidebarRoutes.appendChild(navBtn);
		
		makeSortable(`day_${i}_list`);
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
        <input type="text" name="r_memo" placeholder="메모 입력">
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

/* Sortable JS 라이브러리 */
function makeSortable(elementId) {
    const el = document.getElementById(elementId);
    if (el && typeof Sortable !== 'undefined') {
        new Sortable(el, {
            group: 'shared',
			handle: '.nav-item', // 드래그 핸들 지정
            animation: 150,
            onEnd: function(evt) {
                const newDay = evt.to.id.split('_')[1];
                const rDayInput = evt.item.querySelector('input[name="r_day"]');
                if(rDayInput) rDayInput.value = newDay;
                setOrder();
            }
        });
    }
}