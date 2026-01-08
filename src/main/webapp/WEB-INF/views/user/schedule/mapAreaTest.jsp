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
    kakao.maps.load(function() {
        var container = document.getElementById('map');
        var options = {
            center: new kakao.maps.LatLng(37.566826, 126.9786567),
            level: 3
        };
        var map = new kakao.maps.Map(container, options);
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

            for (var i = 0; i < places.length; i++) {
                var placePosition = new kakao.maps.LatLng(places[i].y, places[i].x),
                    marker = addMarker(placePosition), 
                    itemEl = getListItem(i, places[i]);

                bounds.extend(placePosition);

                (function(marker, title) {
                    kakao.maps.event.addListener(marker, 'mouseover', function() {
                        displayInfowindow(marker, title);
                    });
                    kakao.maps.event.addListener(marker, 'mouseout', function() {
                        infowindow.close();
                    });
                    itemEl.onmouseover = function() {
                        displayInfowindow(marker, title);
                    };
                    itemEl.onmouseout = function() {
                        infowindow.close();
                    };
                    itemEl.onclick = function() {
                        map.panTo(marker.getPosition());
                    };
                })(marker, places[i].place_name);

                listEl.appendChild(itemEl);
            }
            map.setBounds(bounds);
        }

        function getListItem(index, places) {
            var el = document.createElement('li');
            var itemStr = '<div class="item">' +
                '   <div class="info">' +
                '       <span class="title">' + (index + 1) + '. ' + places.place_name + '</span>' +
                '       <div class="addr">' + (places.road_address_name ? places.road_address_name : places.address_name) + '</div>' +
                '   </div>' +
                '</div>';
            el.innerHTML = itemStr;
            return el;
        }

        function addMarker(position) {
            var marker = new kakao.maps.Marker({
                position: position,
                map: map
            });
            return marker;
        }

        function displayInfowindow(marker, title) {
            var content = '<div style="padding:5px;z-index:1;font-size:12px;">' + title + '</div>';
            infowindow.setContent(content);
            infowindow.open(map, marker);
        }
    });
</script>
</body>
</html>