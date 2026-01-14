<%@ page language="java" contentType="text/html; charset=UTF-8"
    pageEncoding="UTF-8"%>
<%@ taglib prefix="c" uri="jakarta.tags.core"%>
<!DOCTYPE html>
<html>
<head>
<!-- 달력 flatpickr 라이브러리 사용 -->
<link rel="stylesheet" href="https://cdn.jsdelivr.net/npm/flatpickr/dist/flatpickr.min.min.css">
<script src="https://cdn.jsdelivr.net/npm/flatpickr"></script>
<script src="https://cdn.jsdelivr.net/npm/flatpickr/dist/l10n/ko.js"></script>
<!-- SortableJS 라이브러리 사용 (노트 리스트에 드래그 앤 드롭 기능 부여) -->
<script src="https://cdn.jsdelivr.net/npm/sortablejs@1.15.0/Sortable.min.js"></script>
<script src="/JS/noteControl.js"></script>
<script src="/JS/routeControl.js"></script>
<script src="/JS/scheduleOrder.js"></script>

<style>
	.container {
	    display: flex;
	    width: 100vw;
	    height: 100vh;
	    overflow: hidden;
	}
	
	.pane { height: 100%; overflow-y: auto; background: white; }
	
	#sidebar { width: 200px; min-width: 100px; }
	#left-content { flex: 1; min-width: 300px; border-left: 1px solid #ddd; }
	#right-side { width: 40%; min-width: 200px; position: relative; }
	
	.resizer {
	    width: 6px;
	    cursor: col-resize;
	    background: #f1f1f1;
	    transition: background 0.2s;
	    z-index: 10;
	}
	.resizer:hover { background: #007bff; }
	
	.nav-group h4 {
	    font-size: 14px;
	    color: #666;
	    margin: 20px 0 10px 15px;
	}
	
	.nav-item {
		display: block;
	    width: calc(100% - 30px);
	    margin: 5px 15px;
	    padding: 12px;
	    text-align: left;
	    background-color: #f8f9fa;
	    border: 1px solid #e9ecef;
	    border-radius: 6px;
	    cursor: pointer;
	    font-size: 13px;
	    transition: all 0.2s;
	    white-space: nowrap;
	    overflow: hidden;
	    text-overflow: ellipsis;
	}
	
	.nav-item:hover {
	    background-color: #e7f1ff;
	    border-color: #007bff;
	    color: #007bff;
	}
	
	.sortable-ghost {
	    opacity: 0.4;
	    background-color: #cfe2ff !important;
	}
</style>
<meta charset="UTF-8">
<title>머무름 - 당신의 여행 계획</title>
</head>
<body>
 	<%@ include file="../../guest/header.jsp" %>
	<div class="container">
		<div id="sidebar" class="pane">
	        <%@ include file="sidebar.jsp" %>
	    </div>
	    <div id="resizer-sidebar" class="resizer"></div>
	    <div id="left-content" class="pane content">
	       
			<form name="schedule" method="post" action="/user/schedule/insertSchedule" onsubmit="setOrder()">
				<!-- 여행 계획을 새로 작성할 때 -->
				<c:if test="${mode == 'new'}">
					<input type="hidden" value="${mode}">
					<!-- 여행 계획 정보 -->
					<div id="">
						<div><input type="text" name="s_name" id="s_name" value="To ${p_name}"></div>
						<div>
							<input type="text" id="dateSchedule" placeholder="여행 기간을 선택하세요">
							<input type="hidden" name="s_start" id="s_start" value="${s_start}">
							<input type="hidden" name="s_end" id="s_end" value="${s_end}">
							<input type="hidden" name="m_code" value="${member.m_code}">
							<input type="hidden" name="p_name" value="${p_name}">
						</div>
					</div>
					<!-- 노트 영역 -->
					<div>
						<div id="n_container"></div>
						<input type="button" value="새 노트 작성" onclick="newNote()">
						
					</div>
					<!-- 루트 영역 -->
					<div>
						<div id="r_container"></div>
					</div>
					
				</c:if>
				<!-- 수정으로 들어왔을 때 (마이페이지 등) -->
				<c:if test="${mode == 'update'}">
					<input type="hidden" name="s_code" value="${scheduleDTO.s_code}">
					<input type="hidden" name="mode" value="${mode}">
					<input type="hidden" name="p_name" value="${scheduleDTO.p_name}">
					<!-- 여행 계획 정보 -->
					<div id="">
						<div><input type="text" name="s_name" id="s_name" value="${scheduleDTO.s_name}"></div>
						<div>
							<input type="text" id="dateSchedule" placeholder="여행 기간을 선택하세요">
							<input type="hidden" name="s_start" id="s_start" value="${scheduleDTO.s_start}">
							<input type="hidden" name="s_end" id="s_end" value="${scheduleDTO.s_end}">
							<input type="hidden" name="m_code" value="${scheduleDTO.m_code}">
						</div>
					</div>
					<!-- 노트 영역 -->
					<div>
						<div id="n_container">
							<c:forEach var="note" items="${noteDTO}">
				                <div class="n_item">
				                    <div>
				                        <input type="text" name="n_title" value="${note.n_title}">
				                        <input type="button" value="▲" onclick="moveUpNote(this); setOrder();">
				                        <input type="button" value="▼" onclick="moveDownNote(this); setOrder();">
				                    </div>
				                    <textarea name="n_content">${note.n_content}</textarea>
				                    <input type="hidden" name="n_order" value="${note.n_order}">
				                    <input type="button" value="노트 삭제" onclick="deleteNote(this)">
				                </div>
				            </c:forEach>
			            </div>
						<input type="button" value="새 노트 작성" onclick="newNote()">
					</div>
					<!-- 루트 영역 -->
					<div>
						<div id="r_container">
							<c:forEach var="dayNum" begin="1" end="${dayDiff}"> 
								<div class="r_day">
					            	<div>
					                	<h4>Day ${dayNum}</h4>
					               		<ul id="day_${dayNum}_list" class="route_list">
										<c:forEach var="route" items="${routeDTO}">
											<c:if test="${route.r_day == dayNum}">
												<li class="r_item">
													<strong>${route.p_place}</strong>
													<input type="button" value="▲" onclick="moveUpNote(this); setOrder();">
													<input type="button" value="▼" onclick="moveDownNote(this); setOrder();">
													<br>
											        <input type="text" name="r_memo" value="${route.r_memo}" placeholder="메모 입력">
											        <input type="button" value="X" onclick="this.closest('.r_item').remove(); setOrder();">
											        <input type="hidden" name="r_day" value="${route.r_day}">
											        <input type="hidden" name="r_order" value="${route.r_order}">
											        
											        <input type="hidden" name="api_code" value="${route.api_code}">
											        <input type="hidden" name="p_place" value="${route.p_place}">
											        <input type="hidden" name="p_category" value="${route.p_category}">
											        <input type="hidden" name="p_lat" value="${route.p_lat}">
											        <input type="hidden" name="p_lon" value="${route.p_lon}">
											        <input type="hidden" name="p_addr" value="${route.p_addr}">
										        </li>
									        </c:if>
										</c:forEach>
										</ul>
									</div>
								</div>
							</c:forEach>
						</div>
					</div>
				
				</c:if>
				<input type="submit" value="계획 저장">
				<script type="text/template" id="n_template">
					<div>
						<div>
							<input type="text" name="n_title" placeholder="새로운 경험을 작성하세요">
							<input type="button" value="▲" onclick="moveUpNote(this); setOrder();">
							<input type="button" value="▼" onclick="moveDownNote(this); setOrder();">
						</div>
						<textarea name="n_content"></textarea>
						<input type="hidden" name="n_order">
						<input type="button" value="노트 삭제" onclick="deleteNote(this)">
					</div>
				</script>
			</form>
			
			<script>
				const c_start = "${mode == 'update' ? scheduleDTO.s_start : s_start}";
			    const c_end = "${mode == 'update' ? scheduleDTO.s_end : s_end}";
				
			    flatpickr("#dateSchedule", {
			        local: "ko",        // 한국어 설정
			        mode: "range",      // 범위 선택 모드(시작과 끝을 선택하는 범위)
			        showMonths: 2,      // 2개월씩 보기
			        dateFormat: "Y-m-d", // 데이터 형식
			        minDate: "today",    // 오늘 이전 날짜 선택 불가
			     	//  초기값 설정: 시작일과 종료일이 모두 있을 경우 달력에 표시
			        defaultDate: (c_start && c_end) ? [c_start, c_end] : [],
			        onClose: function(selectedDates, dateStr, instance) {
			            // 날짜가 두 개 모두 선택되었을 때 실행
			            if (selectedDates.length === 2) {
			                // s_start와 s_end 히든 필드에 각각 날짜 할당
			                document.getElementById("s_start").value = instance.formatDate(selectedDates[0], "Y-m-d");
			                document.getElementById("s_end").value = instance.formatDate(selectedDates[1], "Y-m-d");
			                newRoute();
			                
			                if (typeof window.refreshMapList === 'function') {
			                    window.refreshMapList();
			                }
			            }
			        },
			        onReady: function(selectedDates, dateStr, instance) {
			            if (selectedDates.length === 2) {
			            	newRoute();
			                // 수정 모드일 때는 이미 HTML이 그려져 있으므로 
			                // 새로 생성하는 대신 기존 ul들에 Sortable만 바인딩
			                const lists = document.querySelectorAll('.route_list');
			                lists.forEach(list => {
			                    if(list.id) makeSortable(list.id);
			                });
			                // 초기 순서 세팅
			                setOrder();
			            }
			        }
			    });
			</script>
		</div>
		<div id="resizer-map" class="resizer"></div>
	
	    <div id="right-side" class="pane">
	        <%@ include file="mapAreaTest.jsp" %>
	    </div>
	</div>
	<!-- 카카오맵 대응 리사이저 설정(지도 깨짐 방지), 사이드바|리사이저|스케쥴러|리사이저|지도 구조로 나눈다. -->
	<script>
		// 문서가 로딩되면 적용되는 스크립트 (사이드바 초기화)
		document.addEventListener("DOMContentLoaded", function() {
		    initResizer("resizer-sidebar", "sidebar", "left-to-right"); // 왼쪽에서 오른쪽으로 조절
		    initResizer("resizer-map", "right-side", "right-to-left"); // 스케줄러 너비 조절
		});
		
		// target = 너비를 조절할 요소
		function initResizer(resizerId, targetId, type) {
		    const resizer = document.getElementById(resizerId);
		    const target = document.getElementById(targetId);
	
		    resizer.addEventListener("mousedown", function(e) {
		        e.preventDefault();
		        document.addEventListener("mousemove", resize);
		        document.addEventListener("mouseup", stopResize);
		        document.body.style.cursor = "col-resize";
		    });
	
		    function resize(e) {
		    	let newWidth; // 변경된 너비의 값이 들어감
		        
		        if (type === 'left-to-right') {
		            // 사이드바와 스케줄러-> 왼쪽에서부터 너비를 잴 때
		            newWidth = e.clientX - target.getBoundingClientRect().left;
		        } else {
		            // 지도-> 오른쪽 끝에서부터 너비를 잴 때('right-to-left')
		            newWidth = window.innerWidth - e.clientX;
		        }

		        // 최소/최대 너비 제한 (너무 작아지거나 커지지 않게)
		        if (newWidth > 150 && newWidth < window.innerWidth * 0.7) {
		            target.style.width = newWidth + "px"; // 새로운 너비 설정
		            target.style.flex = "none"; // flex를 무효화해야 설정한 width가 고정됨
		            
		            // 카카오맵의 깨짐 방지.. 라고 하더라(지도 동기화)
		            if (typeof map !== 'undefined') {
		                map.relayout();
		            }
		        } 
		    }
	
		    function stopResize() {
		        document.removeEventListener("mousemove", resize);
		        document.removeEventListener("mouseup", stopResize);
		        document.body.style.cursor = "default";
		    }
		}
	</script>
</body>
</html>