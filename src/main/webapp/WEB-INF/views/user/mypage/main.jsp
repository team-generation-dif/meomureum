<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ taglib prefix="c" uri="jakarta.tags.core" %>
<!DOCTYPE html>
<html>
<head>
    <style>
        .dashboard-container { max-width: 1100px; margin: 40px auto; padding: 20px; display: grid; grid-template-columns: 1fr 1fr; gap: 30px; }
        .section-card { background: white; border-radius: 15px; padding: 25px; box-shadow: 0 4px 12px rgba(0,0,0,0.08); }
        .section-title { font-size: 1.3rem; font-weight: bold; margin-bottom: 20px; display: flex; align-items: center; color: #2c3e50; }
        .section-title i { margin-right: 10px; font-style: normal; }

        /* 일정 리스트 스타일 */
        .item-list { list-style: none; padding: 0; margin: 0; }
        .item { display: flex; align-items: center; padding: 15px; border-bottom: 1px solid #f1f1f1; transition: background 0.2s; }
        .item:hover { background-color: #f9fbfd; border-radius: 8px; }
        .item:last-child { border-bottom: none; }
        
        .date-badge { min-width: 60px; text-align: center; background: #3498db; color: white; padding: 5px; border-radius: 6px; font-size: 0.8rem; margin-right: 20px; }
        .past-badge { background: #95a5a6; } /* 다녀온 일정은 회색으로 */
        
        .item-info { flex: 1; }
        .item-info b { display: block; font-size: 1rem; color: #333; }
        .item-info span { font-size: 0.85rem; color: #888; }

        .empty-msg { text-align: center; color: #999; padding: 40px 0; }
    </style>
</head>
<body>
    <jsp:include page="../../guest/header.jsp" />

    <div class="dashboard-container">
        <div class="section-card">
            <div class="section-title"><i>🗓️</i> 나의 스케줄표 (다가올 일정)</div>
            <ul class="item-list">
                <c:choose>
                    <c:when test="${not empty schedules}">
                        <c:forEach var="sch" items="${schedules}">
                            <li class="item">
                                <div class="date-badge">${sch.s_date}</div>
                                <div class="item-info">
                                    <b>${sch.s_title}</b>
                                    <span>${sch.s_location} | ${sch.s_time}</span>
                                </div>
                            </li>
                        </c:forEach>
                    </c:when>
                    <c:otherwise>
                        <div class="empty-msg">등록된 예정 스케줄이 없습니다.</div>
                    </c:otherwise>
                </c:choose>
            </ul>
        </div>

        <div class="section-card">
            <div class="section-title"><i>📸</i> 다녀온 일정 (여행 기록)</div>
            <ul class="item-list">
                <c:choose>
                    <c:when test="${not empty histories}">
                        <c:forEach var="his" items="${histories}">
                            <li class="item">
                                <div class="date-badge past-badge">${his.h_date}</div>
                                <div class="item-info">
                                    <b>${his.h_title}</b>
                                    <span>${his.h_location} | 평점: ⭐${his.h_rating}</span>
                                </div>
                            </li>
                        </c:forEach>
                    </c:when>
                    <c:otherwise>
                        <div class="empty-msg">다녀온 기록이 아직 없습니다.</div>
                    </c:otherwise>
                </c:choose>
            </ul>
        </div>
    </div>
</body>
</html>