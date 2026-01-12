<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<!DOCTYPE html>
<html>
<head>
<meta charset="UTF-8">
<style>
    /* 전체 레이아웃: include될 것을 고려하여 여백 제거 */
    body, html {margin:0; padding:0; width:100%; height:100%; overflow:hidden;}
    
    .map_wrap {position:relative; width:100%; height:100%;}
    #map {width:100%; height:100%; position:relative; overflow:hidden;}
    
    /* 지도 내부 목록 스타일 (오버레이) */
    #menu_wrap {
        position: absolute;
        top: 10px;
        left: 10px;
        bottom: 10px;
        width: 250px; /* 목록 너비 조절 */
        margin: 10px 0 30px 10px;
        padding: 5px;
        overflow-y: auto;
        background: rgba(255, 255, 255, 0.9); /* 반투명 흰색 */
        z-index: 2;
        font-size: 12px;
        border-radius: 10px;
        box-shadow: 0 2px 5px rgba(0,0,0,0.2);
    }
    
    #menu_wrap hr {display: block; height: 1px; border: 0; border-top: 2px solid #5F5F5F; margin:3px 0;}
    #placesList li {list-style: none;}
    #placesList .item {position:relative; border-bottom:1px solid #888; overflow: hidden; cursor: pointer; padding: 10px 5px;}
    #placesList .item:hover {background-color: #f1f1f1;}
    #placesList .item .title {font-weight: bold; font-size: 14px; color: #333;}
    #placesList .item .info {margin-top: 5px;}
</style>
</head>
<body>

<div class="map_wrap">
    <div id="map"></div>

    <div id="menu_wrap" class="bg_white">
        <div class="option">
            <b style="font-size: 14px;">"${p_name}" 추천 관광지</b>
        </div>
        <hr>
        <ul id="placesList"></ul>
    </div>
</div>

<script type="text/javascript" src="http://dapi.kakao.com/v2/maps/sdk.js?appkey=4a7565c6c1f5c232fc4970f7e8bd8d7f&libraries=services&autoload=false"></script>
<script>
	// 전역 변수로 선언(외부 접근을 위함)
	var map;
	
    kakao.maps.load(function() {
        var container = document.getElementById('map');
        var options = {
            center: new kakao.maps.LatLng(37.566826, 126.9786567),
            level: 3
        };
        map = new kakao.maps.Map(container, options);
        var ps = new kakao.maps.services.Places();
        var infowindow = new kakao.maps.InfoWindow({zIndex:1});

        var keyword = "${p_name}";

        if (keyword) {
            // 키워드 검색 시 '관광명소(AT4)' 카테고리 필터링 적용
            ps.keywordSearch(keyword, placesSearchCB, {
                category_group_code: 'AT4'
            });
        }

        function placesSearchCB(data, status) {
            if (status === kakao.maps.services.Status.OK) {
                displayPlaces(data);
            } else if (status === kakao.maps.services.Status.ZERO_RESULT) {
                alert('검색 결과가 존재하지 않습니다.');
            } else {
                alert('검색 중 오류가 발생했습니다.');
            }
        }
        
        function displayPlaces(places) {
            var listEl = document.getElementById('placesList'), 
                bounds = new kakao.maps.LatLngBounds();
            
            listEl.innerHTML = '';

            // 현재 선택된 여행 기간 계산 (메인 JSP의 hidden 필드 참조)
            const start = new Date(document.getElementById('s_start').value);
            const end = new Date(document.getElementById('s_end').value);
            let day = Math.round(Math.abs(end - start) / (1000 * 60 * 60 * 24)) + 1;

            for (var i = 0; i < places.length; i++) {
                var placePosition = new kakao.maps.LatLng(places[i].y, places[i].x),
                    marker = addMarker(placePosition), 
                    itemEl = getListItem(i, places[i], day); // totalDays 전달

                bounds.extend(placePosition);

                // 클로저를 이용한 이벤트 바인딩
                (function(marker, place) {
                	// 마커에 마우스오버 시 인포윈도우 표시
                    kakao.maps.event.addListener(marker, 'mouseover', function() {
                        displayInfowindow(marker, place);
                    });

                    //마커에서 마우스아웃 시 인포윈도우 닫기
                    kakao.maps.event.addListener(marker, 'mouseout', function() {
                        infowindow.close();
                    });
                    
                 	// 목록 아이템에 마우스 오버 시 인포윈도우 표시
                    itemEl.onmouseover = function() {
                        displayInfowindow(marker, place);
                    };
                    // 목록 아이템에서 마우스 아웃 시 인포윈도우 닫기
                    itemEl.onmouseout = function() {
                         infowindow.close();
                    };
                    // 목록 아이템 클릭 시 해당 마커로 지도 이동
                    itemEl.onclick = function() {
                        map.panTo(marker.getPosition());
                    };
                })(marker, places[i]);

                listEl.appendChild(itemEl);
            }
            map.setBounds(bounds);
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
		            <div class="add-buttons" style="margin-top:7px;">
		                \${buttonsHtml}
		            </div>
		        </div>
		    `;

            // 버튼 클릭 이벤트 바인딩
		    const btns = el.querySelectorAll('.day-add-btn');
		    btns.forEach(btn => {
		        btn.onclick = function(e) {
		            //e.stopPropagation(); // li의 클릭 이벤트(지도 이동) 방지
		            const day = this.getAttribute('data-day');
		            addRoute(day, place); // schedule.jsp의 함수 호출
		        };
		    });

            return el;
        }

        function addMarker(position) {
            var marker = new kakao.maps.Marker({
                position: position,
                map: map
            });
            return marker;
        }

        
        function displayInfowindow(marker, place) {
            // 장소 데이터를 JSON 문자열로 변환하여 함수 인자로 전달 (따옴표 주의)
            var placeJson = JSON.stringify(place).replace(/"/g, '&quot;');
            
            var content = `
                <div style="padding:10px; min-width:150px;">
                    <strong>\${place.place_name}</strong><br>
                    <span style="font-size:11px; color:#666;">\${place.road_address_name || place.address_name}</span><br>
                    <p style="font-size:11px; color:blue; margin-top:5px;">← 왼쪽 목록에서 날짜별 추가 버튼을 누르세요</p>
                </div>`;
                          
            infowindow.setContent(content);
            infowindow.open(map, marker);
        }
        
    });

</script>
</body>
</html>