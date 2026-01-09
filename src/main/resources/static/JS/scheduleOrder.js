// 제출 전 순서(n_order, r_order)를 1, 2, 3...으로 채워주는 함수
function setOrder() {
    const n_orders = document.querySelectorAll('input[name="n_order"]');
    n_orders.forEach((order, index) => {
        order.value = index + 1;
    });
    
    const dayLists = document.querySelectorAll('ul[id$="_list"]');
    dayLists.forEach((list) => {
	    const r_orders = list.querySelectorAll('input[name="r_order"]');
	    r_orders.forEach((order, index) => {
	        order.value = index + 1;
	    });
    });
}