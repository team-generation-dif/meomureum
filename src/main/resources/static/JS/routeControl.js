// 일차 별 노드 생성
function newRoute(){
// 1. newNote()랑 비슷하게 노드로 작성하므로 필드를 설정
	const container = document.getElementById('r_container'); // 스케쥴러 영역
	
	const startVal = document.getElementById('s_start').value;
    const endVal = document.getElementById('s_end').value;
    
    // 날짜가 모두 선택되지 않았으면 중단
    if(!startVal || !endVal) return;

    const start = new Date(startVal);
    const end = new Date(endVal);
	
// 2. 날짜 차이 + 1 을 일 단위로 계산
	const day = 1 + Math.round(Math.abs(end - start)/(1000*60*60*24));
	// 변경 시 기존과 차이를 알 수 있게 count 저장
	const currentDays = container.querySelectorAll('.r_day');
    const dayCount = currentDays.length;
	
// 3. 날짜 차이 + 1 만큼 반복문으로 노드를 작성
	// 날짜가 늘어남 ->  늘어난 만큼 생성 (계획 생성 시점엔 dayCount = 0)
	if (dayCount < day) {
		for (let i = dayCount + 1; i <= day; i++){
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
			
			makeSortable(`day_${i}_list`);
		}
	// 날짜가 줄어듬 -> 줄어들면 뒤부터 삭제
	} else if (dayCount > day) {
		// 역순으로 일차 반복
		for (let i = dayCount; i > day; i--){
			const lastDay = document.getElementById(`day_section_${i}`);
            if (lastDay) {
                lastDay.remove();
            }
		}
	}
	
	setOrder();

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
		<div class="r_item_header">
	    	<strong>${place.place_name}</strong>
			<div>
				<input type="button" value="▲" onclick="moveUpNote(this); setOrder();">
				<input type="button" value="▼" onclick="moveDownNote(this); setOrder();">
			</div>
		</div>
		<br>
        <input type="text" name="r_memo" placeholder="메모 입력">
		<div class="item_x">
        	<input type="button" value="X" onclick="this.closest('.r_item').remove(); setOrder();">
		</div>
        <input type="hidden" name="r_day" value="${day}">
        <input type="hidden" name="r_order">
        
		<input type="hidden" name="p_image_url" value="${place.image_url}">
        <input type="hidden" name="api_code" value="${place.id}">
        <input type="hidden" name="p_place" value="${place.place_name}">
        <input type="hidden" name="p_category" value="${place.category_group_name}">
        <input type="hidden" name="p_lat" value="${place.y}">
        <input type="hidden" name="p_lon" value="${place.x}">
        <input type="hidden" name="p_addr" value="${place.road_address_name || place.address_name}">
    `;
    
    targetList.appendChild(li);
	setOrder();
}

/* Sortable JS 라이브러리 */
function makeSortable(elementId) {
    const el = document.getElementById(elementId);
    if (!el) return;

    new Sortable(el, {
        group: 'shared', // 다른 일차(Day) 간 이동 가능하게 설정
        animation: 150,
        filter: "input, textarea, button", // 입력창 간섭 방지
        preventOnFilter: false,
        onEnd: function(evt) {
            // evt.to : 아이템이 떨어진(도착한) 대상 리스트(ul)
            // 도착지 리스트의 id에서 숫자를 추출 (예: day_2_list -> 2)
            const targetUlId = evt.to.id; 
            const newDayNum = targetUlId.split('_')[1]; 

            // 이동한 아이템(evt.item) 내의 r_day hidden input 값을 변경
            const rDayInput = evt.item.querySelector('input[name="r_day"]');
            if (rDayInput) {
                rDayInput.value = newDayNum;
                console.log(`장소가 ${newDayNum}일차로 변경되었습니다.`);
            }
            
            // 전체 순서 및 사이드바 갱신
            setOrder();
        }
    });
}