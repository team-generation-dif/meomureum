<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<!DOCTYPE html>
<html>
<head>
<meta charset="UTF-8">
<style>
    /* 0. 전체 레이아웃: include될 것을 고려하여 여백 제거 */
    body, html {margin:0; padding:0; width:100%; height:100%; overflow:hidden;}
    
    .map_wrap {position:relative; width:100%; height:100%;}
    #map {width:100%; height:100%; position:relative; overflow:hidden;}
    
	/* 1. 목록 스타일 (토글 기능 포함) */
    #menu_wrap {
        position: absolute;
        top: 10px; left: 10px; bottom: 30px;
        width: 250px;
        padding: 5px;
        overflow-y: auto;
        background: rgba(255, 255, 255, 0.95);
        z-index: 2;
        font-size: 12px;
        border-radius: 5px;
        box-shadow: 0 2px 5px rgba(0,0,0,0.2);
        transition: transform 0.3s ease-in-out; /* 부드러운 전환 */
    }
    
    /* 목록 숨김 클래스 */
    #menu_wrap.hidden { transform: translateX(-270px); }
    
    /* 목록 토글 버튼 */
    #toggle_btn {
        position: absolute;
        top: 10px; left: 270px; /* 메뉴 너비 + 여백 */
        width: 25px; height: 50px;
        background: white;
        z-index: 2;
        border: 1px solid #ccc;
        border-radius: 0 5px 5px 0;
        cursor: pointer;
        display: flex; align-items: center; justify-content: center;
        transition: left 0.3s ease-in-out;
        box-shadow: 2px 0 5px rgba(0,0,0,0.1);
    }
    /* 메뉴가 숨겨지면 버튼도 이동 */
    #toggle_btn.hidden { left: 0; } 

    /* 2. 카테고리 버튼 스타일 (지도 상단 중앙) */
    .category_bar {
        position: absolute; top: 10px; left: 50%;
        transform: translateX(-50%);
        z-index: 2;
        background: white;
        padding: 5px 10px;
        border-radius: 20px;
        box-shadow: 0 2px 5px rgba(0,0,0,0.2);
        display: flex; gap: 5px;
    }
    .cat_btn {
        border: 1px solid #ddd; background: #fff;
        padding: 5px 12px; border-radius: 15px;
        font-size: 12px; cursor: pointer;
    }
    .cat_btn:hover, .cat_btn.active { background: #007bff; color: white; border-color: #007bff; }

    /* 목록 아이템 스타일 */
    #placesList { padding: 0; margin: 0; }
    #placesList li {list-style: none;}
    #placesList .item {position:relative; border-bottom:1px solid #888; overflow: hidden; cursor: pointer; padding: 10px 5px;}
    #placesList .item:hover {background-color: #f1f1f1;}
    #placesList .item .title {font-weight: bold; font-size: 14px; color: #333;}
    
    /* 인포윈도우 스타일 */
    .iw_inner { padding: 5px; width: 200px; }
    .iw_title { font-weight: bold; margin-bottom: 5px; display: block;}
    .iw_btn_group { margin-top: 8px; display: flex; flex-wrap: wrap; gap: 3px; }
    .iw_btn_group button {
        border: 1px solid #007bff; background: white; color: #007bff;
        padding: 2px 6px; font-size: 11px; cursor: pointer; border-radius: 3px;
    }
    .iw_btn_group button:hover { background: #007bff; color: white; }
</style>
</head>
<body>

<div class="map_wrap">
    <div id="map"></div>

	<div class="category_bar">
        <button class="cat_btn active" onclick="searchCategory('AT4', this)">관광명소</button>
        <button class="cat_btn" onclick="searchCategory('FD6', this)">음식점</button>
        <button class="cat_btn" onclick="searchCategory('CE7', this)">카페</button>
        <button class="cat_btn" onclick="searchCategory('AD5', this)">숙박</button>
    </div>

    <div id="toggle_btn" onclick="toggleMenu()">◀</div>

    <div id="menu_wrap" class="bg_white">
        <div class="option">
            <b style="font-size: 14px;">"${p_name}" 주변 탐색</b>
        </div>
        <hr>
        <ul id="placesList"></ul>
    </div>
</div>

<script type="text/javascript" src="http://dapi.kakao.com/v2/maps/sdk.js?appkey=4a7565c6c1f5c232fc4970f7e8bd8d7f&libraries=services&autoload=false"></script>
<script>
	// 전역 변수로 선언(외부 접근을 위함)
	var map;
	var searchData = []; // 검색된 장소 데이터를 저장할 변수
	var infowindow;
    var markers = []; // 마커를 관리하기 위한 배열
    var selectedMarker = null; // 현재 선택된 마커
    var currentPlace = null; // 현재 선택된 장소 데이터(인포윈도우용)
    var currCategory = 'AT4'; // 기본 카테고리
    var closeTimeout; // 타임아웃 관리를 위한 변수
    
	// 맵 로드
    kakao.maps.load(function() {
        var container = document.getElementById('map');
        var options = {
            center: new kakao.maps.LatLng(37.566826, 126.9786567),
            level: 4
        };
        map = new kakao.maps.Map(container, options);
        ps = new kakao.maps.services.Places(map);
        infowindow = new kakao.maps.InfoWindow({zIndex:1});
		
	    // 초기 검색.. 검색 이름을 가지고 오는 방식이 2가지..
        var keyword = "${p_name}" || "${scheduleDTO.p_name}"; 
        if (keyword) {
            // 키워드 검색 시 '관광명소(AT4)' 카테고리 필터링 적용
            ps.keywordSearch(keyword, placesSearchCB, {
                category_group_code: 'AT4'
            });
        }
        
     	// 지도 이동/확대 축소 시, 현재 카테고리로 재검색
        // 너무 잦은 요청을 막기 위해 idle 이벤트 사용
        kakao.maps.event.addListener(map, 'idle', function() {
            // 목록이 켜져있거나 특정 조건일 때만 재검색하려면 여기에 조건 추가
            searchCategory(currCategory); // 지도를 움직일 때마다 리스트 갱신
        });
    });
	
	// 이 함수가 호출되면 저장된 장소 데이터로 목록을 다시 그린다.
    window.refreshMapList = function() {
        if (searchData && searchData.length > 0) {
        	// 기존 데이터를 가지고 목록과 마커를 다시 그림 (이때 calculateTotalDays가 새 값을 읽음)
            displayPlaces(searchData, false);
        }
    }
	
	// 카테고리 검색 함수
    window.searchCategory = function(code, btn) {
        currCategory = code;
        
        // 버튼 스타일 활성화
        if(btn) {
            var btns = document.querySelectorAll('.cat_btn');
            btns.forEach(b => b.classList.remove('active'));
            btn.classList.add('active');
        }

        // 현재 지도 범위 내에서 카테고리 검색 (useMapBounds: true)
        ps.categorySearch(code, function(data, status) {
            if (status === kakao.maps.services.Status.OK) {
                displayPlaces(data, false); 
            }
        }, {useMapBounds: true});
    };
    
    function placesSearchCB(data, status) {
        if (status === kakao.maps.services.Status.OK) {
        	searchData = data; // 데이터를 전역 변수에 미리 저장(재활용을 위함)
            displayPlaces(data, true);
        } else if (status === kakao.maps.services.Status.ZERO_RESULT) {
            
        } else {
            alert('검색 중 오류가 발생했습니다.');
        }
    }
    
	// 3. 목록 및 마커 표출
    function displayPlaces(places, shouldMove) {
        var listEl = document.getElementById('placesList'),
        	menuEl = document.getElementById('menu_wrap'),
            bounds = new kakao.maps.LatLngBounds();
        
        removeAllMarkers(); // 기존 마커 제거
        listEl.innerHTML = '';
        // 여행 기간 계산 (버튼 생성용)
        const totalDays = calculateTotalDays();
            
        for (var i = 0; i < places.length; i++) {
            var placePosition = new kakao.maps.LatLng(places[i].y, places[i].x),
                marker = addMarker(placePosition), 
                itemEl = getListItem(i, places[i], totalDays); 

            bounds.extend(placePosition);

            // 클로저를 이용한 이벤트 바인딩
            (function(marker, place) {
            	// 마커 클릭 시
                kakao.maps.event.addListener(marker, 'click', function() {
                    selectMarker(marker, place); // 마커 선택 및 인포윈도우 열기
                });
                // 리스트 아이템 클릭 시
                itemEl.onclick = function() {
                    map.panTo(marker.getPosition());
                    selectMarker(marker, place);
                };
            	// 마커에 마우스오버 시
                kakao.maps.event.addListener(marker, 'mouseover', function() {
                    clearTimeout(closeTimeout); // 닫기 예약 취소
                    displayInfowindow(marker, place);
                });
	            //마커에서 마우스아웃 시 인포윈도우 닫기
	            kakao.maps.event.addListener(marker, 'mouseout', function() {
	            	// 1000ms(1초) 후에 닫도록 예약
	                closeTimeout = setTimeout(function() {
	                    infowindow.close();
	                }, 1000);
	            });
	            kakao.maps.event.addListener(marker, 'mouseover', function() {
	                marker.setZIndex(10); // 마우스가 올라간 마커를 위로
	            });
	            kakao.maps.event.addListener(marker, 'mouseout', function() {
	                marker.setZIndex(0); // 다시 원래대로
	            });

            })(marker, places[i]);

            listEl.appendChild(itemEl);
        }
    	// 초기 검색일 때만 bounds 변경 (카테고리 검색 등 이동 후 검색 시에는 지도 안 움직임)
        // 필요하다면 조건 추가
        if (shouldMove) {
             map.setBounds(bounds);
        }
    }
	
	// 인포윈도우 생성
    function getInfoWindowContent(place) {
        const totalDays = calculateTotalDays();
        let btns = '';
        
        for(let d=1; d<=totalDays; d++){
            // 인라인 onclick에서 전역 함수 호출
            btns += `<button class="day-add-btn" onclick="addCurrentPlaceToSchedule(\${d})">Day \${d}</button>`;
        }
        
        return `
            <div class="iw_inner">
                <span class="iw_title">\${place.place_name}</span>
                <span style="font-size:11px; color:#666;">\${place.category_name}</span>
                <div class="iw_btn_group">
                    \${btns}
                </div>
            </div>`;
    }
	
	// 인포윈도우 내 버튼 클릭 시 실행되는 함수
    window.addCurrentPlaceToSchedule = function(day) {
        if(currentPlace) {
            // schedule.jsp에 있는 addRoute 함수 호출
            // 주의: addRoute가 전역 범위에 있어야 함
            if(window.parent && window.parent.addRoute) {
                 window.parent.addRoute(day, currentPlace);
            } else if (window.addRoute) {
                 window.addRoute(day, currentPlace);
            }
            alert(day + "일차에 추가되었습니다.");
            // 인포윈도우 닫기 (선택사항)
            // infowindow.close(); 
        }
    };
    
    // 마커 생성 및 삭제
    function addMarker(position) {
        var marker = new kakao.maps.Marker({
            position: position,
            map: map
        });
        markers.push(marker);
        return marker;
    }
    
    function removeAllMarkers() {
        for (var i = 0; i < markers.length; i++) {
            markers[i].setMap(null);
        }
        markers = [];
    }
    
    function selectMarker(marker, place) {
        selectedMarker = marker;
        displayInfowindow(marker, place); 
    }
    
    function getListItem(index, place, totalDays) {
        var el = document.createElement('li');
        el.className = 'item';
        
        // 버튼을 생성할 태그를 함수에 저장
        let buttonsHtml = '';
        for (let d = 1; d <= totalDays; d++) {
            // JSON 데이터를 안전하게 넘기기 위해 임시 변수에 저장하거나 파라미터로 직접 전달
            buttonsHtml += `<button type="button" class="day-add-btn" data-day="\${d}">Day \${d}</button> `;
        }
        
        // 기본 장소 정보 HTML
        el.innerHTML = `
		    <div class="info">
		        <span class="title">\${index + 1}. \${place.place_name}</span>
		        <div class="addr">\${place.road_address_name || place.address_name}</div>
		        <div class="add-buttons" style="margin-top:7px;">\${buttonsHtml}</div>
		    </div>
		`;

        // 리스트 내 버튼 이벤트
		const btns = el.querySelectorAll('.day-add-btn');
		btns.forEach(btn => {
		    btn.onclick = function(e) {
		        e.stopPropagation(); // li의 클릭 이벤트(지도 이동) 방지
		        const day = this.getAttribute('data-day');
		        if(window.addRoute) window.addRoute(day, place); // schedule.jsp의 함수 호출
		    };
		});
        return el;
    }
    
    // 인포윈도우 표시
    function displayInfowindow(marker, place) {
    	currentPlace = place;
    	var content = getInfoWindowContent(place);
        infowindow.setContent(content);
        infowindow.open(map, marker);
        
     	// 인포윈도우가 열린 후, 그 안으로 마우스가 들어가면 닫기 취소
        var iwElement = document.querySelector('.iw_inner');
        if (iwElement) {
            iwElement.onmouseover = function() {
                clearTimeout(closeTimeout);
            };
            iwElement.onmouseout = function() {
                closeTimeout = setTimeout(function() {
                    infowindow.close();
                }, 300);
            };
        }
    }
    
    // 날짜 차이 계산 함수
    function calculateTotalDays() {
        const sStartVal = document.getElementById('s_start') ? document.getElementById('s_start').value : null;
        const sEndVal = document.getElementById('s_end') ? document.getElementById('s_end').value : null;
        let day = 1;
        if (sStartVal && sEndVal) {
            const start = new Date(sStartVal);
            const end = new Date(sEndVal);
            day = Math.round(Math.abs(end - start) / (1000 * 60 * 60 * 24)) + 1;
        }
        return day;
    }
    
	// 4. 목록 토글 기능
    window.toggleMenu = function() {
        var menu = document.getElementById('menu_wrap');
        var btn = document.getElementById('toggle_btn');
        
        menu.classList.toggle('hidden');
        btn.classList.toggle('hidden');
        
        if (menu.classList.contains('hidden')) {
            btn.innerHTML = '▶';
            btn.style.left = '0px'; 
        } else {
            btn.innerHTML = '◀';
            btn.style.left = '270px';
        }
    };

</script>
</body>
</html>