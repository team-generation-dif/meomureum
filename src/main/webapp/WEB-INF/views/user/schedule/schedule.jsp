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
	/* 대시보드(user/mypage/main.jsp)의 컬러 정보 참조 */
	:root {
        --primary-color: #a29bfe;
        --primary-hover: #6c5ce7;
        --bg-color: #f8f9ff;
        --text-color: #2d3436;
        --border-color: #f1f3ff;
        --shadow-soft: 0 10px 30px rgba(162, 155, 254, 0.05);
    }

	body {
        font-family: 'Pretendard', sans-serif;
        margin: 0;
        padding: 0;
        color: var(--text-color);
        background-color: var(--bg-color);
        overflow: hidden; /* 전체 스크롤 방지 */
    }
	
	.container {
	    display: flex;
	    width: 100vw;
	    height: calc(100vh - 70px);
	    overflow: hidden;
	}
	
	.pane { height: 100%; overflow-y: auto; background: white; box-sizing: border-box;}
	
	#sidebar { width: 200px; min-width: 100px; }
	#left-content { 
	    flex: 1; 
	    min-width: 350px; 
	    background-color: var(--bg-color); /* 배경색 */
	    padding: 20px 20px 100px 20px;
	    display: block; 
	    overflow-y: auto; 
	}
	#left-content form {
	    height: auto; /* 높이를 내용물에 맞춤 */
	    min-height: 100%; /* 최소한 화면만큼은 채움 */
	    display: flex;
	    flex-direction: column;
	    gap: 15px; /* 요소 간 간격 */
	}
	
	#right-side { width: 40%; min-width: 200px; position: relative; }
	
	.resizer {
        width: 5px;
        cursor: col-resize;
        background: transparent;
        transition: background 0.2s;
        z-index: 10;
    }
    .resizer:hover { background: var(--primary-color); }
	
	/* [입력 폼 스타일] */
    input[type="text"], textarea {
        width: 100%;
        padding: 12px 15px;
        border: 1px solid #dfe6e9;
        border-radius: 12px;
        font-family: inherit;
        font-size: 0.95rem;
        box-sizing: border-box;
        transition: 0.2s;
        background: white;
    }
    
    input[type="text"]:focus, textarea:focus {
        outline: none;
        border-color: var(--primary-color);
        box-shadow: 0 0 0 3px rgba(162, 155, 254, 0.1);
    }

    textarea {
        resize: vertical;
        min-height: 80px;
        line-height: 1.5;
    }
	
	/* 제목 입력 스타일 */
    #s_name {
        font-size: 1.4rem;
        font-weight: bold;
        color: var(--primary-color);
        border: none;
        background: transparent;
        padding: 10px 0;
        border-bottom: 2px solid var(--border-color);
        border-radius: 0;
    }
    
    #s_name:focus { 
    	box-shadow: none; 
    	border-bottom-color: var(--primary-color); 
   	}
   	
	/* [버튼 스타일] - 대시보드 btn-add 스타일 적용 */
    input[type="button"], input[type="submit"], button {
        background-color: white;
        border: 1px solid #dfe6e9;
        color: #636e72;
        padding: 8px 16px;
        border-radius: 10px;
        cursor: pointer;
        font-weight: 600;
        font-size: 0.9rem;
        transition: all 0.2s;
        font-family: 'Pretendard', sans-serif;
    }

    input[type="button"]:hover, button:hover {
        background-color: #f1f3ff;
        color: var(--primary-color);
        border-color: var(--primary-color);
    }

    /* 메인 액션 버튼 (저장, 새 노트 등) */
    input[type="submit"], input[value="새 노트 작성"] {
        background: var(--primary-color);
        color: white;
        border: none;
        padding: 12px 20px;
        width: 100%;
        margin-top: 10px;
        box-shadow: 0 4px 10px rgba(162, 155, 254, 0.3);
    }
    
    input[type="submit"]:hover, input[value="새 노트 작성"]:hover {
        background: var(--primary-hover);
        transform: translateY(-2px);
    }

    /* [카드 아이템 스타일] - 노트/루트 */
    .n_item, .r_item {
        background: white;
        border-radius: 20px;
        padding: 20px;
        margin-bottom: 15px;
        box-shadow: var(--shadow-soft);
        border: 1px solid var(--border-color);
        transition: transform 0.2s, box-shadow 0.2s;
    }
    
    .n_item:hover, .r_item:hover {
        transform: translateY(-2px);
        box-shadow: 0 8px 20px rgba(162, 155, 254, 0.15);
        border-color: var(--primary-color);
    }

	.r_item > input[type="text"] {
		margin: 0px 0px 10px 0px;
	}
	
    .r_day {
        margin-bottom: 30px;
    }
    
    .r_day h4 {
        font-size: 1.1rem;
        color: var(--primary-color);
        margin: 0 0 15px 5px;
        font-weight: 700;
    }

	.route_list {
	    list-style: none; /* 글머리 기호(검은 점) 제거 */
	    padding: 0;
	    margin: 0;
	}
	
    /* 노트 내 장소 정보 카드 */
    .note-place-info {
        display: flex;
        gap: 15px;
        background-color: #fafaff;
        border: 1px dashed #dce0ff;
        border-radius: 15px;
        padding: 12px;
        margin-bottom: 12px;
    }
    
    .note-place-info img {
        width: 70px;
        height: 70px;
        object-fit: cover;
        border-radius: 12px;
        box-shadow: 0 2px 5px rgba(0,0,0,0.05);
    }
    
    .note-place-info .info-text {
        flex: 1;
        display: flex;
        flex-direction: column;
        justify-content: center;
        font-size: 0.85rem;
        color: #636e72;
    }
    
    .note-place-info .info-addr {
        font-weight: bold;
        color: #2d3436;
        margin-bottom: 4px;
    }
	
    /* 조작 버튼 그룹 (▲ ▼ X) */
    .control-btns {
        display: flex;
        gap: 5px;
        margin-bottom: 10px;
        justify-content: flex-end;
    }
    
    .control-btns-with-title {
    	display: flex;
    	margin-bottom: 8px;
    	gap: 5px; 
    	align-items: center; 
    }
    
    .control-btns-with-title input[type="text"] {
    	flex: 1; 
    }
    
    .control-btns input[type="button"] {
        padding: 4px 8px;
        font-size: 0.5rem;
        border-radius: 6px;
    }
    
    .r_item_header {
    	display: flex;
    	justify-content: space-between; /* 두 부분으로 구분해서 양쪽 끝 정렬 */
    	align-items: center;
    }
    
    .item_x {
    	display: flex;
    	justify-content: flex-end; /* 오른쪽 정렬 */
    }
    
	.sortable-ghost {
	    opacity: 0.6;
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
						<button type="button" style="color: #6c5ce7;" onclick="location.href='/user/mypage/main'">메인으로</button>
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
				                    <div class="control-btns-with-title">
				                        <input type="text" name="n_title" value="${note.n_title}">
				                        <input type="button" value="▲" onclick="moveUpNote(this); setOrder();">
				                        <input type="button" value="▼" onclick="moveDownNote(this); setOrder();">
				                    </div>
				                    <c:if test="${not empty note.p_code}">
							            <div class="note-place-info">
							                <c:choose>
							                    <c:when test="${not empty note.file_path}">
							                        <img src="${note.file_path}" alt="${note.p_name}">
							                    </c:when>
							                    <c:otherwise>
							                        <div style="...">No Image</div>
							                    </c:otherwise>
							                </c:choose>
							                <div class="info-text">
							                    <div class="info-addr">${note.p_addr}</div>
							                    <div class="info-tel" style="color:#007bff;">${note.p_tel}</div>
							                </div>
							            </div>
						            </c:if>
						        	<%-- 값이 있으면 넣고, 없으면 빈 값("")을 넣어 배열 순서를 맞춤 --%>
							        <input type="hidden" name="n_api_code" value="${note.api_code != null ? note.api_code : ''}">
							        <input type="hidden" name="n_p_name" value="${note.p_name != null ? note.p_name : ''}">
							        <input type="hidden" name="n_p_addr" value="${note.p_addr != null ? note.p_addr : ''}">
							        <input type="hidden" name="n_p_tel" value="${note.p_tel != null ? note.p_tel : ''}">
							        
							        <%-- 이미지는 URL이 아니라 DB 경로이므로 재저장 방지 등을 위해 비워두거나, 
							             새로 이미지를 바꿀 게 아니라면 굳이 다시 보낼 필요는 없지만 배열 맞춤용으로 빈 값 전송 --%>
							        <input type="hidden" name="n_p_img" value=""> 
							        
							        <input type="hidden" name="n_p_cat" value=""> <%-- 카테고리 등은 필요시 DTO에 추가해서 바인딩 --%>
							        <input type="hidden" name="n_p_x" value="0">
							        <input type="hidden" name="n_p_y" value="0">
				                    <textarea name="n_content">${note.n_content}</textarea>
				                    <input type="hidden" name="n_order" value="${note.n_order}">
				                    <div class="item_x">
				                   		<input type="button" value="노트 삭제" onclick="deleteNote(this)">
				                    </div>
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
													<div class="r_item_header">
														<strong>${route.p_place}</strong>
														<div>
															<input type="button" value="▲" onclick="moveUpNote(this); setOrder();">
															<input type="button" value="▼" onclick="moveDownNote(this); setOrder();">
														</div>
													</div>
													<br>
											        <input type="text" name="r_memo" value="${route.r_memo}" placeholder="메모 입력">
											        <div class="item_x">
											        	<input type="button" value="X" onclick="this.closest('.r_item').remove(); setOrder();">
											        </div>
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
						<div class="control-btns-with-title">
							<input type="text" name="n_title" placeholder="새로운 경험을 작성하세요">
							<input type="button" value="▲" onclick="moveUpNote(this); setOrder();">
							<input type="button" value="▼" onclick="moveDownNote(this); setOrder();">
						</div>
						<textarea name="n_content"></textarea>
						<input type="hidden" name="n_order">
						<div class="item_x">
							<input type="button" value="노트 삭제" onclick="deleteNote(this)">
						</div>
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
	<script>
		// 카카오맵 대응 리사이저 설정(지도 깨짐 방지), 사이드바|리사이저|스케쥴러|리사이저|지도 구조로 나눈다. 
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