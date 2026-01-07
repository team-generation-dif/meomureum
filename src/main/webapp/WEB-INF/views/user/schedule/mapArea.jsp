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
					center: new kakao.maps.LatLng(33.450701, 126.570667), //지도의 중심좌표.
					level: 3 //지도의 레벨(확대, 축소 정도)
				};
				
				var map = new kakao.maps.Map(container, options); //지도 생성 및 객체 리턴
				
				// 장소 검색 객체 (kakao.maps.services 라이브러리 == 장소 검색 및 주소-좌표 간 변환 서비스)
		        var ps = new kakao.maps.services.Places(); 

		        // 이전 페이지에서 넘겨받은 검색어 (JSP 표현식 사용)
		        var keyword = "${p_name}"; 
		        
	            // 키워드로 장소를 검색하는 메소드
	            ps.keywordSearch(keyword, placesSearchCB); 

		        // 키워드 검색 완료 시 호출되는 콜백함수입니다
		        function placesSearchCB (data, status) {
		            if (status === kakao.maps.services.Status.OK) {

		                // 검색된 장소 위치를 기준으로 지도 범위를 재설정하기위해 LatLngBounds 객체에 좌표를 추가
		                var bounds = new kakao.maps.LatLngBounds();

		                // 검색 결과 중 첫 번째 장소의 좌표를 기준으로 마커를 표시하거나 이동 --> 좀 다른 방법이 필요할 듯?
		                var coords = new kakao.maps.LatLng(data[0].y, data[0].x);
		                
		                // 마커 생성
		                var marker = new kakao.maps.Marker({
		                    map: map,
		                    position: coords
		                });

		                // 지도 중심을 결과값으로 받은 위치로 이동
		                map.setCenter(coords);
		            } else {
		                alert("검색 결과가 없습니다.");
		            }
		        }
			}
		);
	</script>
</body>
</html>