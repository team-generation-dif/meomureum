<%@ page language="java" contentType="text/html; charset=UTF-8"
    pageEncoding="UTF-8"%>
<%@ taglib prefix="c" uri="jakarta.tags.core"%>
<!DOCTYPE html>
<html>
<head>
<link rel="stylesheet" href="https://cdn.jsdelivr.net/npm/flatpickr/dist/flatpickr.min.css">
<script src="https://cdn.jsdelivr.net/npm/flatpickr"></script>
<script src="https://cdn.jsdelivr.net/npm/flatpickr/dist/l10n/ko.js"></script>
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
	    height: auto;
	    min-height: 100%;
	    display: flex;
	    flex-direction: column;
	    gap: 15px;
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
	
    /* 상단 내비게이션 바 (메인으로 돌아가기 추가) */
    .plan-header {
        display: flex;
        justify-content: space-between;
        align-items: center;
        margin-bottom: 20px;
    }

    .btn-home {
        background: white;
        border: 1px solid var(--primary-color);
        color: var(--primary-color);
        padding: 6px 15px;
        border-radius: 8px;
        text-decoration: none;
        font-size: 0.85rem;
        font-weight: 600;
        transition: 0.2s;
    }

    .btn-home:hover {
        background: var(--primary-color);
        color: white;
    }

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
	
    #s_name {
        font-size: 1.2rem;
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
	    list-style: none;
	    padding: 0;
	    margin: 0;
	}
	
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
	
    .control-btns-with-title {
    	display: flex;
    	margin-bottom: 8px;
    	gap: 5px; 
    	align-items: center; 
    }
    
    .control-btns-with-title input[type="text"] {
    	flex: 1; 
    }
    
    .r_item_header {
    	display: flex;
    	justify-content: space-between;
    	align-items: center;
    }
    
    .item_x {
    	display: flex;
    	justify-content: flex-end;
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
	       
            <div class="plan-header">
                <a href="/user/mypage/main" class="btn-home">← 메인으로</a>
                <span style="font-size: 0.85rem; color: #b2bec3;">새로운 추억을 계획해보세요</span>
            </div>

			<form name="schedule" method="post" action="/user/schedule/insertSchedule" onsubmit="return validateForm()">
				<c:if test="${mode == 'new'}">
					<input type="hidden" name="mode" value="${mode}">
					<div id="">
						<div><input type="text" name="s_name" id="s_name" value="To ${p_name}"></div>
						<div>
							<input type="text" id="dateSchedule" placeholder="여행 기간을 선택하세요" readonly>
							<input type="hidden" name="s_start" id="s_start" value="${s_start}">
							<input type="hidden" name="s_end" id="s_end" value="${s_end}">
							<input type="hidden" name="m_code" value="${member.m_code}">
							<input type="hidden" name="p_name" value="${p_name}">
						</div>
					</div>
					<div>
						<div id="n_container"></div>
						<input type="button" value="새 노트 작성" onclick="newNote()">
					</div>
					<div>
						<div id="r_container"></div>
					</div>
				</c:if>

				<c:if test="${mode == 'update'}">
					<input type="hidden" name="s_code" value="${scheduleDTO.s_code}">
					<input type="hidden" name="mode" value="${mode}">
					<input type="hidden" name="p_name" value="${scheduleDTO.p_name}">
					<div id="">
						<div><input type="text" name="s_name" id="s_name" value="${scheduleDTO.s_name}"></div>
						<div>
							<input type="text" id="dateSchedule" placeholder="여행 기간을 선택하세요" readonly>
							<input type="hidden" name="s_start" id="s_start" value="${scheduleDTO.s_start}">
							<input type="hidden" name="s_end" id="s_end" value="${scheduleDTO.s_end}">
							<input type="hidden" name="m_code" value="${scheduleDTO.m_code}">
						</div>
					</div>
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
							                        <div style="width:70px;height:70px;background:#eee;border-radius:12px;display:flex;align-items:center;justify-content:center;font-size:0.7rem;">No Image</div>
							                    </c:otherwise>
							                </c:choose>
							                <div class="info-text">
							                    <div class="info-addr">${note.p_addr}</div>
							                    <div class="info-tel" style="color:#a29bfe;">${note.p_tel}</div>
							                </div>
							            </div>
						            </c:if>
							        <input type="hidden" name="n_api_code" value="${note.api_code != null ? note.api_code : ''}">
							        <input type="hidden" name="n_p_name" value="${note.p_name != null ? note.p_name : ''}">
							        <input type="hidden" name="n_p_addr" value="${note.p_addr != null ? note.p_addr : ''}">
							        <input type="hidden" name="n_p_tel" value="${note.p_tel != null ? note.p_tel : ''}">
							        <input type="hidden" name="n_p_img" value=""> 
							        <input type="hidden" name="n_p_cat" value="">
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
			</form>
		</div>
		
		<div id="resizer-map" class="resizer"></div>
	    <div id="right-side" class="pane">
	        <%@ include file="mapAreaTest.jsp" %>
	    </div>
	</div>

	<script>
        // [유효성 검사 함수] - 날짜 선택 안 하면 전송 방지
        function validateForm() {
            const start = document.getElementById("s_start").value;
            const end = document.getElementById("s_end").value;

            if (!start || !end) {
                alert("여행 기간을 선택해주세요! (달력에서 날짜 범위를 클릭하세요)");
                return false; 
            }
            
            if (typeof setOrder === 'function') {
                setOrder();
            }
            return true;
        }

		const c_start = "${mode == 'update' ? scheduleDTO.s_start : s_start}";
	    const c_end = "${mode == 'update' ? scheduleDTO.s_end : s_end}";
		
	    flatpickr("#dateSchedule", {
	        locale: "ko",
	        mode: "range",
	        showMonths: 2,
	        dateFormat: "Y-m-d",
	        minDate: "today",
	        defaultDate: (c_start && c_end) ? [c_start, c_end] : [],
	        onClose: function(selectedDates, dateStr, instance) {
	            if (selectedDates.length === 2) {
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
	                const lists = document.querySelectorAll('.route_list');
	                lists.forEach(list => {
	                    if(list.id) makeSortable(list.id);
	                });
	                setOrder();
	            }
	        }
	    });

		// 리사이저 초기화
		document.addEventListener("DOMContentLoaded", function() {
		    initResizer("resizer-sidebar", "sidebar", "left-to-right");
		    initResizer("resizer-map", "right-side", "right-to-left");
		});
		
		function initResizer(resizerId, targetId, type) {
		    const resizer = document.getElementById(resizerId);
		    const target = document.getElementById(targetId);
		    if(!resizer || !target) return;

		    resizer.addEventListener("mousedown", function(e) {
		        e.preventDefault();
		        document.addEventListener("mousemove", resize);
		        document.addEventListener("mouseup", stopResize);
		        document.body.style.cursor = "col-resize";
		    });
	
		    function resize(e) {
		    	let newWidth;
		        if (type === 'left-to-right') {
		            newWidth = e.clientX - target.getBoundingClientRect().left;
		        } else {
		            newWidth = window.innerWidth - e.clientX;
		        }
		        if (newWidth > 150 && newWidth < window.innerWidth * 0.7) {
		            target.style.width = newWidth + "px";
		            target.style.flex = "none";
		            if (typeof map !== 'undefined') { map.relayout(); }
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