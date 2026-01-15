<%@ page language="java" contentType="text/html; charset=UTF-8"
    pageEncoding="UTF-8"%>
<%@ taglib prefix="c" uri="jakarta.tags.core" %>
<style>
	.nav-group { 
        padding: 20px; 
    }
    
    .nav-group h4 {
        font-size: 0.85rem;
        color: #b2bec3;
        font-weight: 700;
        margin-bottom: 15px;
        padding-left: 10px;
        text-transform: uppercase;
        letter-spacing: 0.5px;
    }

    .nav-item {
        display: block; 
        width: 100%; 
        padding: 12px 18px; 
        margin-bottom: 8px;
        text-align: left; 
        background: white; 
        border: 1px solid transparent; /* 테두리 투명하게 시작 */
        border-radius: 15px; /* 둥근 모서리 */
        cursor: pointer; 
        transition: 0.3s;
        font-size: 0.95rem;
        color: #636e72;
        font-weight: 600;
    }
    
    .nav-item:hover { 
        background-color: #f1f3ff; 
        color: #a29bfe; 
        transform: translateX(3px); /* 살짝 오른쪽으로 이동 */
    }
    
    .nav-item.active {
        background-color: #a29bfe;
        color: white;
        box-shadow: 0 5px 15px rgba(162, 155, 254, 0.3);
    }
</style>

<div class="sidebar-nav">
    <div class="nav-group">
        <h4>노트</h4>
        <div id="sidebar-notes">
        	<c:if test="${mode == 'update'}">
        		<%-- 순서대로 번호를 부여 --%>
                   <c:forEach var="note" items="${noteDTO}" varStatus="status"> 
                       <button type="button" class="nav-item" id="nav_note_${status.index}" onclick="scrollToNote(${status.index})">
                           ${note.n_title != '' ? note.n_title : '새 노트'}
                       </button>
                   </c:forEach>
               </c:if>
           </div>
    </div>

    <div class="nav-group">
        <h4>여행 일정</h4>
        <div id="sidebar-routes">
            <c:if test="${mode == 'update'}">
                <c:forEach var="dayNum" begin="1" end="${dayDiff}">
                    <button type="button" class="nav-item" onclick="scrollToDay(${dayNum})">
                        Day ${dayNum}
                    </button>
                </c:forEach>
            </c:if>
        </div>
    </div>
</div>