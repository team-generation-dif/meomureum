<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>

<link rel="stylesheet" href="/CSS/map.css">

<div class="map_wrap">
    <div id="map"></div>

	<div class="category_bar">
	    <button class="cat_btn active" onclick="searchCategory('12', this)">관광지</button>
	    <button class="cat_btn" onclick="searchCategory('39', this)">음식점/카페</button>
	    <button class="cat_btn" onclick="searchCategory('32', this)">숙박</button>
	    <button class="cat_btn" onclick="searchCategory('14', this)">문화시설</button>
	    <button class="cat_btn" onclick="searchCategory('28', this)">레포츠</button>
	</div>

    <div id="toggle_btn" onclick="toggleMenu()">◀</div>

    <div id="menu_wrap" class="bg_white">
	    <div class="option" style="padding-bottom: 10px; position:relative;"> <form onsubmit="searchPlaces(); return false;" style="display:flex; justify-content: space-between;">
	            <input type="text" value="${p_name}" id="keyword" size="15" placeholder="장소 검색" 
	                   onkeyup="onKeywordChange()" 
	                   style="width:70%; padding:5px; border:1px solid #ddd; border-radius:3px;"> 
	            <button type="submit" 
	                    style="width:25%; background:#007bff; color:white; border:none; border-radius:3px; cursor:pointer;">
	                검색
	            </button>
	        </form>
	        <div id="suggestion_box"></div>
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
    var currCategory = '12'; // 기본 카테고리
    var closeTimeout; // 타임아웃 관리를 위한 변수
    var lastCenterLat = 0;
    var lastCenterLon = 0;
    var isKeywordSearch = false; // 키워드 검색 중인지 확인하는 플래그 변수
	
    // TourAPI 설정
    const TOUR_API_KEY = '40573ff235c2383e4d10b5575bbc8200ae3d0abf8995e811fc9285796bc2d3a2'; 
	
	// 검색 버튼 클릭 시 실행될 함수
    function searchPlaces() {
        var keyword = document.getElementById('keyword').value;

        if (!keyword.replace(/^\s+|\s+$/g, '')) {
            alert('키워드를 입력해주세요!');
            return false;
        }

        // 키워드 검색임을 표시 (idle 이벤트에서 카테고리 검색 방지용)
        isKeywordSearch = true; 
        
    	// TourAPI(searchTourAPI) 대신 카카오(ps.keywordSearch) 사용
        ps.keywordSearch(keyword, function(data, status) {
            if (status === kakao.maps.services.Status.OK) {
                // 검색된 장소 중 첫 번째 장소로 지도 이동
                var bounds = new kakao.maps.LatLngBounds();
                bounds.extend(new kakao.maps.LatLng(data[0].y, data[0].x));
                map.setBounds(bounds);
                
                // (선택 사항) 지도 레벨을 적당히 조정 (너무 확대되는 것 방지)
                if(map.getLevel() < 3) map.setLevel(3);

                // 지도가 이동하면 idle 이벤트가 발생하여 -> searchTourAPILocation이 실행됨
                // 즉, "이동한 위치 주변의 관광지"를 TourAPI에서 가져오게 됨
            } else if (status === kakao.maps.services.Status.ZERO_RESULT) {
                alert('검색 결과가 존재하지 않습니다.');
                isKeywordSearch = false; // 플래그 해제
            } else {
                alert('검색 중 오류가 발생했습니다.');
                isKeywordSearch = false;
            }
        });
    }
    
 	// 자동완성 기능 (키보드 입력 시 호출)
    var searchTimeout; // 디바운싱용 (타자 칠 때마다 요청하는 것 방지)
    
    function onKeywordChange() {
        var keyword = document.getElementById('keyword').value;
        var box = document.getElementById('suggestion_box');

        if (keyword.length < 2) { // 2글자 미만이면 숨김
            box.style.display = 'none';
            return;
        }

        // 이전 요청 취소 (디바운싱: 0.5초 대기)
        clearTimeout(searchTimeout);
        searchTimeout = setTimeout(function() {
            // 카카오 검색 API 호출
            ps.keywordSearch(keyword, function(data, status) {
                if (status === kakao.maps.services.Status.OK) {
                    var html = '';
                    // 최대 5개까지만 표시
                    var len = data.length > 5 ? 5 : data.length;
                    
                    for (var i = 0; i < len; i++) {
                        // 검색어와 일치하는 부분 강조
                        var placeName = data[i].place_name;
                        var address = data[i].road_address_name || data[i].address_name;
                        
                        html += '<div onclick="selectSuggestion(\'' + placeName + '\', ' + data[i].y + ', ' + data[i].x + ')">';
                        html += '  <b>' + placeName + '</b><br>';
                        html += '  <span style="color:#888; font-size:11px;">' + address + '</span>';
                        html += '</div>';
                    }
                    box.innerHTML = html;
                    box.style.display = 'block';
                } else {
                    box.style.display = 'none';
                }
            });
        }, 500);
    }

    // 자동완성 항목 클릭 시 실행
    function selectSuggestion(name, lat, lng) {
        // 검색창에 이름 넣기
        document.getElementById('keyword').value = name;
        document.getElementById('suggestion_box').style.display = 'none';
        
        // 해당 좌표로 지도 이동 -> 지도가 이동했으므로 idle 이벤트가 발생하여 TourAPI 데이터가 로드
        isKeywordSearch = true;
        var moveLatLon = new kakao.maps.LatLng(lat, lng);
        map.setCenter(moveLatLon);
    }
    
	// 화면 아무곳이나 클릭하면 자동완성 박스 닫기
    document.addEventListener('click', function(e) {
        if (!e.target.closest('.option')) {
            document.getElementById('suggestion_box').style.display = 'none';
        }
    });
	
    // TourAPI 키워드 검색 함수
    function searchTourAPI(keyword) {
        const url = `http://apis.data.go.kr/B551011/KorService2/searchKeyword2`;
        const params = {
            serviceKey: TOUR_API_KEY,
            numOfRows: 20,
            pageNo: 1,
            MobileOS: 'ETC',
            MobileApp: 'Meomureum',
            _type: 'json',
            keyword: keyword,
            arrange: 'Q' // 대표이미지가 있는 정렬(Q) 혹은 제목순(A)
        };

        // 쿼리 스트링 생성
        const queryString = new URLSearchParams(params).toString();
        
        fetch(`\${url}?\${queryString}`)
            .then(response => response.json())
            .then(data => {
                const items = data.response.body.items.item;
                if (items) {
                    // TourAPI 데이터를 기존 displayPlaces 포맷에 맞게 변환
                    const places = items.map(item => ({
                        place_name: item.title,
                        road_address_name: item.addr1,
                        address_name: item.addr1, // 지번 주소가 따로 없으면 addr1 사용
                        x: item.mapx, // 경도
                        y: item.mapy, // 위도
                        id: item.contentid, // TourAPI contentid
                        category_name: item.contenttypeid, // 혹은 매핑된 이름
                        image_url: item.firstimage, // 이미지 URL
                        phone: item.tel // 전화번호 (공통정보에 있음)
                    }));
                    
                    searchData = places; // 전역 변수 업데이트
                    displayPlaces(places, true);
                } else {
                    alert('검색 결과가 없습니다.');
                }
            })
            .catch(error => console.error('TourAPI Error:', error));
    }
    
	// TourAPI 위치 기반 검색 함수
    function searchTourAPILocation(x, y, currCategory) {
		
    	// 현재 지도 레벨 가져오기
        var level = map.getLevel();
        var radius = 1000; // 기본값 (1km)

        // 레벨에 따른 반경 설정 (단위: m)
        // 레벨 1~3 (상세): 1km
        if (level <= 3) {
            radius = 1000; 
        } 
        
        else if (level <= 6) {
            radius = 3000; 
        } 
        
        else if (level <= 9) {
            radius = 5000; 
        } 
        
        else if (level <= 12) {
            radius = 10000; 
        } 
        // 그 이상 (광역): 20km (TourAPI 최대 반경이 보통 20km)
        else {
            radius = 20000; 
        }
        const url = `http://apis.data.go.kr/B551011/KorService2/locationBasedList2`;
        const params = {
            serviceKey: TOUR_API_KEY,
            numOfRows: 20,
            pageNo: 1,
            MobileOS: 'ETC',
            MobileApp: 'Meomureum',
            _type: 'json',
            mapX: x,
            mapY: y,
            radius: radius, // 3km 반경.. 지도의 확대 레벨에 따라 수정해야 함
            contentTypeId: currCategory,
            arrange: 'Q'
        };
        
        const queryString = new URLSearchParams(params).toString();
        
        fetch(`\${url}?\${queryString}`)
            .then(response => response.json())
            .then(data => {
                const items = data.response.body.items.item;
                if (items) {
                    // TourAPI 데이터를 우리 지도 포맷에 맞게 변환
                    const places = items.map(item => ({
                        place_name: item.title,
                        road_address_name: item.addr1,
                        address_name: item.addr1,
                        x: item.mapx, 
                        y: item.mapy, 
                        id: item.contentid, // TourAPI 고유 ID
                        category_name: item.contenttypeid, 
                        image_url: item.firstimage,
                        phone: item.tel
                    }));
                    
                    searchData = places; // 전역 데이터 갱신
                    displayPlaces(places, false); // 목록 및 마커 그리기 (지도 이동 X)
                } else {
                    // 검색 결과가 없을 때 (마커 제거 등)
                    removeAllMarkers();
                    document.getElementById('placesList').innerHTML = '<li class="item" style="padding:10px;">주변에 해당 장소가 없습니다.</li>';
                }
            })
            .catch(error => {
                console.error('TourAPI Error:', error);
            });
    }
    
	// TourAPI 상세 정보(공통+소개) 가져오는 함수
    async function getPlaceDetails(contentId, contentTypeId) {
        // 공통정보(개요, 홈페이지) URL
        const commonUrl = `https://apis.data.go.kr/B551011/KorService2/detailCommon2?serviceKey=\${TOUR_API_KEY}&MobileOS=ETC&MobileApp=Meomureum&_type=json&contentId=\${contentId}&defaultYN=Y&overviewYN=Y`;
        // 소개정보(휴무일, 영업시간) URL
        const introUrl = `https://apis.data.go.kr/B551011/KorService2/detailIntro2?serviceKey=\${TOUR_API_KEY}&MobileOS=ETC&MobileApp=Meomureum&_type=json&contentId=\${contentId}&contentTypeId=\${contentTypeId}`;

        try {
            // 두 API를 병렬로 호출 (속도 향상)
            const [commonRes, introRes] = await Promise.all([
                fetch(commonUrl).then(r => r.json()),
                fetch(introUrl).then(r => r.json())
            ]);
            
            // 데이터가 없는 경우를 위한 방어 코드 (TypeError 해결)
            const commonItem = commonRes?.response?.body?.items?.item?.[0] || {};
            const introItem = introRes?.response?.body?.items?.item?.[0] || {};
            
            // 카테고리별 필드명 파싱 (API마다 필드명이 다름)
            let timeInfo = "", restDate = "";
            
            if (contentTypeId == '12') { // 관광지
                timeInfo = introItem.usetime;
                restDate = introItem.restdate;
            } else if (contentTypeId == '39') { // 음식점
                timeInfo = introItem.opentimefood;
                restDate = introItem.restdatefood;
            } else if (contentTypeId == '32') { // 숙박
                timeInfo = `입실: \${introItem.checkintime} / 퇴실: \${introItem.checkouttime}`;
                restDate = ""; // 숙박은 보통 연중무휴
            } else if (contentTypeId == '14') { // 문화시설
                timeInfo = introItem.usetimeculture;
                restDate = introItem.restdateculture;
            } else if (contentTypeId == '28') { // 레포츠
                timeInfo = introItem.usetimeleports;
                restDate = introItem.restdateleports;
            }

            return {
                overview: commonItem.overview ? commonItem.overview.substr(0, 100) + "..." : "", // 개요(너무 길면 자름)
                homepage: commonItem.homepage || "",
                time: timeInfo || "정보 없음",
                rest: restDate || "정보 없음"
            };
        } catch (e) {
            console.error("Detail Fetch Error", e);
            return null;
        }
    }
	
    
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
            // 가져온 키워드를 검색창(input)에 먼저 넣는다.
            var keywordInput = document.getElementById('keyword');
            if (keywordInput) {
                keywordInput.value = keyword;
            }

            // 검색 함수 호출
            searchPlaces(); 
        }
        
     	// 지도 이동/확대 축소 시, 현재 카테고리로 재검색
        // 너무 잦은 요청을 막기 위해 idle 이벤트 사용
        kakao.maps.event.addListener(map, 'idle', function() {
        	// 키워드 검색으로 인해 지도가 이동한 경우, 주변 재검색을 하지 않음
            if (isKeywordSearch) {
                isKeywordSearch = false; // 플래그 초기화 (다음 이동부터는 정상 동작)
                
                // 검색 결과 중심 좌표 저장 (무한 루프 방지 로직과 동기화)
                var center = map.getCenter();
                lastCenterLat = center.getLat();
                lastCenterLon = center.getLng();
            }
        	
         	// 기존 무한 루프 방지 로직 (미세한 움직임 무시)
            var center = map.getCenter();
            var lat = center.getLat();
            var lon = center.getLng();

            // 이전 좌표와 비교하여 변화가 거의 없으면(0.0001도 미만) API 호출 중단
            // (API 호출로 마커가 찍히면서 미세하게 지도가 움직이는 것을 방지)
            if (Math.abs(lat - lastCenterLat) < 0.0001 && Math.abs(lon - lastCenterLon) < 0.0001) {
                return; 
            }

            // 변화가 컸다면 좌표 업데이트 후 검색 실행
            lastCenterLat = lat;
            lastCenterLon = lon;

            // 현재 선택된 카테고리로 주변 검색
            searchCategory(currCategory); 
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
    window.searchCategory = function(typeId, btn) {
    	currCategory = typeId;
        
        // 버튼 스타일 활성화
        if(btn) {
            var btns = document.querySelectorAll('.cat_btn');
            btns.forEach(b => b.classList.remove('active'));
            btn.classList.add('active');
            
        	// 현재 지도의 중심 좌표 가져오기
            var center = map.getCenter(); 
            lastCenterLat = center.getLat();
            lastCenterLon = center.getLng();
        }
        // TourAPI 위치 기반 검색 호출
        // 인자: 경도(x), 위도(y), contentTypeId
        var center = map.getCenter();
        searchTourAPILocation(center.getLng(), center.getLat(), typeId);
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
    function getInfoWindowContent(place, details) {
        const totalDays = calculateTotalDays();
        
        // 드롭다운 옵션 생성
        let dayOptions = '';
        for(let d=1; d<=totalDays; d++){
            dayOptions += `<option value="\${d}">Day \${d}</option>`;
        }
        
        // 인포윈도우는 HTML 문자열로 넘기므로 id를 부여하거나 인라인 함수에서 값을 찾아야 함..
        const controlHtml = `
            <select class="day-select" id="iw_day_select_\${place.id}" style="width: auto;">
                \${dayOptions}
            </select>
            <button class="day-add-confirm-btn" onclick="addPlaceFromInfoWindow('\${place.id}')">추가</button>
            <button class="note-add-btn" onclick="addCurrentPlaceToNote()">Note</button>
        `;
        
        // 이미지 로드
        const imgHtml = place.image_url ? 
            `<img src="\${place.image_url}" style="width:100%; height:100px; object-fit:cover; margin-bottom:5px;">` : '';
        
        // 상세 정보 HTML 조립
        let detailHtml = '';
        if (details) {
            // 데이터가 로드되었을 때
            // HTML 태그 제거 (API에서 <br> 등이 섞여 올 수 있음)
            const cleanOverview = details.overview.replace(/(<([^>]+)>)/gi, "");
            
            detailHtml = `
                <div style="margin-top:5px; font-size:11px; color:#555; line-height:1.4;">
                    <div><b>시간:</b> \${details.time}</div>
                    <div><b>휴무:</b> \${details.rest}</div>
                    <div style="margin-top:3px; color:#888;">\${cleanOverview}</div>
                    \${details.homepage ? `<div style="margin-top:3px;">\${details.homepage}</div>` : ''}
                </div>
            `;
        } else {
            // 로딩 중일 때 표시할 UI
            detailHtml = `<div style="margin-top:5px; font-size:11px; color:#999;">상세 정보 불러오는 중...</div>`;
        }
        
        return `
	        <div class="iw_inner" style="width:220px;">
		        \${imgHtml}
		        <div style="margin-top:5px;">
		            <span class="iw_title" style="font-size:15px;">\${place.place_name}</span>
		            <span style="font-size:12px; color:#007bff; display:block;">\${place.phone || ''}</span>
		        </div>
		        \${detailHtml}
		        <div class="iw_btn_group">
		            \${controlHtml}
		        </div>
		    </div>`;
    }
	
 	// 인포윈도우에서 '추가' 버튼 눌렀을 때 실행될 함수
    window.addPlaceFromInfoWindow = function(placeId) {
        // 해당 장소의 select 박스를 찾음
        const selectEl = document.getElementById(`iw_day_select_\${placeId}`);
        if(selectEl && currentPlace) {
            const day = selectEl.value;
            
            if(window.parent && window.parent.addRoute) {
                 window.parent.addRoute(day, currentPlace);
            } else if (window.addRoute) {
                 window.addRoute(day, currentPlace);
            }
            alert(day + "일차에 추가되었습니다.");
        }
    };
	    
 	// 인포윈도우 내 노트 버튼 클릭 시 실행되는 함수
    window.addCurrentPlaceToNote = function() {
        if(currentPlace) {
            if(window.addNoteWithPlace) {
                window.addNoteWithPlace(currentPlace);
            } else if(window.parent && window.parent.addNoteWithPlace) {
                window.parent.addNoteWithPlace(currentPlace);
            }
            alert("새 노트에 추가되었습니다.");
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
        
        // 드롭다운 옵션 생성
        let dayOptions = '';
        for (let d = 1; d <= totalDays; d++) {
            dayOptions += `<option value="\${d}">Day \${d}</option>`;
        }
        
     	// 드롭다운 + 추가 버튼 조합
        // onclick="event.stopPropagation()" : 드롭다운 클릭 시 지도 이동 방지
        const selectHtml = `
            <select class="day-select" onclick="event.stopPropagation()">
                \${dayOptions}
            </select>
            <button type="button" class="day-add-confirm-btn">추가</button>
        `;
        
  	   	// 이미지 HTML 처리 -> 이미지가 있으면 img 태그, 없으면 '이미지 없음' 텍스트
        let imgHtml = '';
        if(place.image_url) {
            imgHtml = `<img src="\${place.image_url}" alt="\${place.place_name}">`;
        } else {
            imgHtml = `<span class="no-img">이미지 없음</span>`;
        }
        
   		// HTML 조립
        el.innerHTML = `
            <div class="img-box">\${imgHtml}</div>
            <div class="info-box">
                <span class="title">\${index + 1}. \${place.place_name}</span>
                <div class="addr">\${place.road_address_name || place.address_name}</div>
                <div class="tel">\${place.phone || ''}</div>
                <div class="btn-group">
                    \${selectHtml}
                    <button type="button" class="note-add-btn">Note</button>
                </div>
            </div>
        `;

        // 리스트 내 버튼 이벤트
		const addBtn = el.querySelector('.day-add-confirm-btn');
        if(addBtn) {
            addBtn.onclick = function(e) {
                e.stopPropagation(); // 부모 클릭 방지
                
                // 형제 요소인 select 박스를 찾아서 값을 가져옴
                const selectBox = this.parentElement.querySelector('.day-select');
                const selectedDay = selectBox.value;
                
                if(window.addRoute) {
                    window.addRoute(selectedDay, place);
                    alert(`Day \${selectedDay}에 추가되었습니다.`);
                }
            };
        }
		
		// 노트 버튼 이벤트
	    const noteBtn = el.querySelector('.note-add-btn');
	    if(noteBtn) {
	        noteBtn.onclick = function(e) {
	            e.stopPropagation();
	            // 부모창(schedule.jsp)에 있는 addNoteWithPlace 함수 호출
	            if(window.addNoteWithPlace) {
	                window.addNoteWithPlace(place);
	            } else if(window.parent && window.parent.addNoteWithPlace) {
	                window.parent.addNoteWithPlace(place);
	            }
	        };
	    }
		
        return el;
    }
    
    // 인포윈도우 표시
    function displayInfowindow(marker, place) {
    	currentPlace = place;
    	var content = getInfoWindowContent(place, null);
        infowindow.setContent(content);
        infowindow.open(map, marker);
        
  	    // 상세 정보 API 호출 후 업데이트
        getPlaceDetails(place.id, place.category_name).then(details => {
            if(details) {
                // 기존 place 객체에 상세정보 병합은 하지 않고 화면만 갱신하거나,
                // 필요하면 place.details = details; 로 저장해도 됨.
                var newContent = getInfoWindowContent(place, details);
                infowindow.setContent(newContent);
            }
        });
  	    
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