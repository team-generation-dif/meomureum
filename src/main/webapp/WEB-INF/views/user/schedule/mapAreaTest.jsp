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

    /* 3. 목록 아이템 스타일 (카드형 디자인 적용) */
    #placesList { padding: 10px; background-color: #f7f7f7; } /* 배경색 추가 */
    
    #placesList .item {
        position: relative;
        background: white;
        border-radius: 8px; /* 둥근 모서리 */
        box-shadow: 0 2px 5px rgba(0,0,0,0.08); /* 그림자 효과 */
        overflow: hidden;
        cursor: pointer;
        margin-bottom: 15px; /* 아이템 간 간격 */
        transition: transform 0.2s, box-shadow 0.2s;
        border: 1px solid #eee;
    }
    
    #placesList .item:hover {
        transform: translateY(-3px); /* 마우스 올리면 살짝 뜸 */
        box-shadow: 0 5px 12px rgba(0,0,0,0.15);
        border-color: #cce5ff;
    }
    
    /* 이미지 영역 */
    #placesList .item .img-box {
        width: 100%;
        height: 120px;
        background-color: #eee;
        display: flex;
        align-items: center;
        justify-content: center;
        overflow: hidden;
    }
    
    #placesList .item .img-box img {
        width: 100%;
        height: 100%;
        object-fit: cover; /* 비율 유지하며 꽉 채우기 */
    }
    
    #placesList .item .img-box .no-img {
        font-size: 12px; color: #aaa;
    }

    /* 텍스트 정보 영역 */
    #placesList .item .info-box {
        padding: 10px;
    }

    #placesList .item .title {
        font-weight: bold; 
        font-size: 15px; 
        color: #333; 
        display: block; 
        margin-bottom: 4px;
    }
    
    #placesList .item .addr {
        font-size: 12px; color: #666; margin-bottom: 2px;
        white-space: nowrap; overflow: hidden; text-overflow: ellipsis;
    }
    
    #placesList .item .tel {
        font-size: 12px; color: #007bff; margin-bottom: 8px;
    }
    
    /* 버튼 그룹 (인포윈도우와 동일 스타일) */
    #placesList .item .btn-group {
        border-top: 1px solid #f1f1f1;
        padding-top: 8px;
        display: flex;
        flex-wrap: wrap;
        gap: 3px;
    }
    
    #placesList .item .day-add-btn {
        border: 1px solid #007bff; 
        background: white; 
        color: #007bff;
        padding: 2px 8px; 
        font-size: 11px; 
        cursor: pointer; 
        border-radius: 3px;
        transition: all 0.2s;
    }
    
    #placesList .item .day-add-btn:hover {
        background: #007bff; color: white;
    }
    
    /* 인포윈도우 스타일 */
    .iw_inner { padding: 5px; width: 200px; }
    .iw_title { font-weight: bold; margin-bottom: 5px; display: block;}
    .iw_btn_group { margin-top: 8px; display: flex; flex-wrap: wrap; gap: 3px; }
    .iw_btn_group button {
        border: 1px solid #007bff; background: white; color: #007bff;
        padding: 2px 6px; font-size: 11px; cursor: pointer; border-radius: 3px;
    }
    .iw_btn_group button:hover { background: #007bff; color: white; }
    
    /* 자동완성 박스 스타일 */
    #suggestion_box {
        display: none; /* 평소엔 숨김 */
        position: absolute;
        top: 45px; /* 검색창 바로 아래 */
        left: 5px;
        right: 5px;
        background: white;
        border: 1px solid #ccc;
        border-top: none;
        z-index: 10;
        max-height: 200px;
        overflow-y: auto;
        box-shadow: 0 2px 5px rgba(0,0,0,0.1);
        border-radius: 0 0 5px 5px;
    }
    #suggestion_box div {
        padding: 8px 10px;
        cursor: pointer;
        font-size: 12px;
        border-bottom: 1px solid #eee;
    }
    #suggestion_box div:hover {
        background-color: #f1f1f1;
    }
    #suggestion_box strong {
        color: #007bff;
    }
</style>
</head>
<body>

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
        let btns = '';
        
        // 버튼 생성
        for(let d=1; d<=totalDays; d++){
            // 인라인 onclick에서 전역 함수 호출
            btns += `<button class="day-add-btn" onclick="addCurrentPlaceToSchedule(\${d})">Day \${d}</button>`;
        }
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
            <div class="iw_inner">
        		\${imgHtml}
        		<div style="margin-top:5px;">
	                <span class="iw_title" style="font-size:15px;">\${place.place_name}</span>
	                <span style="font-size:12px; color:#007bff; display:block;">\${place.phone || ''}</span>
	            </div>
	            \${detailHtml}
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
  	   	// 이미지 HTML 처리 -> 이미지가 있으면 img 태그, 없으면 '이미지 없음' 텍스트
        let imgHtml = '';
        if(place.image_url) {
            imgHtml = `<img src="\${place.image_url}" alt="\${place.place_name}">`;
        } else {
            imgHtml = `<span class="no-img">이미지 없음</span>`;
        }
        
   		// HTML 조립
        el.innerHTML = `
            <div class="img-box">
                \${imgHtml}
            </div>
            <div class="info-box">
                <span class="title">\${index + 1}. \${place.place_name}</span>
                <div class="addr">\${place.road_address_name || place.address_name}</div>
                <div class="tel">\${place.phone || ''}</div>
                <div class="btn-group">\${buttonsHtml}</div>
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
</body>
</html>