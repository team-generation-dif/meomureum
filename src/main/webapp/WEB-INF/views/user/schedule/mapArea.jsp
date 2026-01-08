<%@ page language="java" contentType="text/html; charset=UTF-8"
    pageEncoding="UTF-8"%>
<!DOCTYPE html>
<html>
<head>

<meta charset="UTF-8">
<title>지도</title>
</head>
<body>
	<div id="map" style="width:500px;height:400px;"></div>
	<script type="text/javascript" src="http://dapi.kakao.com/v2/maps/sdk.js?appkey=4a7565c6c1f5c232fc4970f7e8bd8d7f&libraries=services&autoload=false"></script>
	<script>
		kakao.maps.load(
			function() {
				var container = document.getElementById('map'); //지도를 담을 영역의 DOM 레퍼런스
				var options = { //지도를 생성할 때 필요한 기본 옵션
					center: new kakao.maps.LatLng(33.450701, 126.570667), //지도의 중심좌표
					level: 3 //지도의 레벨(확대, 축소 정도)
				};
				
				var map = new kakao.maps.Map(container, options); //지도 생성 및 객체 리턴
				
				// 장소 검색 객체 (kakao.maps.services 라이브러리 == 장소 검색 및 주소-좌표 간 변환 서비스)
		        var ps = new kakao.maps.services.Places(); 
				// 인포 윈도우의 z축 위치
		        var infowindow = new kakao.maps.InfoWindow({
		        	zIndex:1
		        });
		        
		        // 이전 페이지에서 넘겨받은 검색어
		        var keyword = "${p_name}"; 
		        
	            // 키워드로 장소를 검색하는 메소드
	            if (keyword) {
	                // 키워드와 카테고리(AT4: 관광명소)를 조합하여 검색
	                ps.keywordSearch(keyword, placesSearchCB, {
	                    category_group_code: 'AT4' 
	                });
	            }

		        // 키워드 검색 완료 시 호출되는 콜백함수
		        function placesSearchCB (data, status) {
		            if (status === kakao.maps.services.Status.OK) {

		                // 검색된 장소 위치를 기준으로 지도 범위를 재설정하기위해 LatLngBounds 객체에 좌표를 추가
		                var bounds = new kakao.maps.LatLngBounds();

		                for (var i = 0; i < data.length; i++) {
		                    var coords = new kakao.maps.LatLng(data[i].y, data[i].x);
		                    
		                    // 마커 생성
		                    var marker = new kakao.maps.Marker({
		                        map: map,
		                        position: coords
		                    });

		                    // 검색된 장소의 이름으로 인포윈도우(말풍선) 표시 (옵션)
		                    var infowindow = new kakao.maps.InfoWindow({
		                        content: '<div style="padding:5px;font-size:12px;">' + data[i].place_name + '</div>'
		                    });
		                    infowindow.open(map, marker);

		                    // 범위에 현재 마커 좌표 추가
		                    bounds.extend(coords);
		                }

		                // 모든 마커가 포함되도록 지도 중심과 확대 레벨 자동 조정
		                map.setBounds(bounds);
		                
		            } else {
		                alert("검색 결과가 없습니다.");
		            }
		        }
		        
		    	 // 지도에 마커를 표시하는 함수입니다
		        function displayMarker(place) {
		            // 마커를 생성하고 지도에 표시합니다
		            var marker = new kakao.maps.Marker({
		                map: map,
		                position: new kakao.maps.LatLng(place.y, place.x) 
		            });

		            // 마커에 클릭이벤트를 등록합니다
		            kakao.maps.event.addListener(marker, 'click', function() {
		                // 마커를 클릭하면 장소명이 인포윈도우에 표출됩니다
		                infowindow.setContent('<div style="padding:5px;font-size:12px;">' + place.place_name + '</div>');
		                infowindow.open(map, marker);
		            });
		        }
			}
		);
	</script>
</body>
</html>