<%@ page contentType="text/html; charset=UTF-8" language="java" %>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>

<!DOCTYPE html>
<html lang="vi">
<head>
    <meta charset="UTF-8">
    <title>Dashboard - Admin</title>
    <link rel="stylesheet" href="<c:url value='/static/css/styleproduct.css'/>">
</head>
<body class="admin-body">

<div class="admin-layout">

    
    <aside class="sidebar">
        <div class="sidebar-logo">
            <span class="logo-main">N4</span><span class="logo-sub">Computer</span>
        </div>

        <nav class="sidebar-nav">
            <a href="<c:url value='/admin/dashboard'/>" class="nav-item active">
                <span class="nav-icon">ðŸ </span> Dá»¯ liá»‡u thá»‘ng kÃª
            </a>
            <a href="<c:url value='/admin/products'/>" class="nav-item">
                <span class="nav-icon">ðŸ’»</span> Quáº£n lÃ½ Sáº£n pháº©m
            </a>
            <a href="<c:url value='/admin/orders'/>" class="nav-item">
                <span class="nav-icon">ðŸ“¦</span> Quáº£n lÃ½ ÄÆ¡n hÃ ng
            </a>
            <a href="<c:url value='/admin/customers'/>" class="nav-item">
                <span class="nav-icon">ðŸ‘¥</span> Quáº£n lÃ½ KhÃ¡ch hÃ ng
            </a>
        </nav>

        <a href="${pageContext.request.contextPath}/home" class="back-store">
            â† Vá» trang bÃ¡n hÃ ng
        </a>
    </aside>

    
    <main class="main">

        
        <header class="topbar">
            <div class="topbar-left">
                <h1 class="page-title">Tá»•ng quan há»‡ thá»‘ng</h1>
            </div>
            <div class="topbar-right">
                <span class="hello-text">
                    Xin chÃ o,
                    <strong>
                        <c:choose>
                            <c:when test="${not empty sessionScope.hoTen}">
                                <c:out value="${sessionScope.hoTen}"/>
                            </c:when>
                            <c:otherwise>Quáº£n trá»‹ viÃªn</c:otherwise>
                        </c:choose>
                    </strong>
                </span>
                <a class="btn-link" href="<c:url value='/logout'/>">ÄÄƒng xuáº¥t</a>
            </div>
        </header>

        
        <section class="dashboard-cards">
            <div class="dash-card">
                <div class="dash-card-title">Tá»”NG DOANH THU</div>
                <div class="dash-card-value">
                    <c:out value="${totalRevenue != null ? totalRevenue : ''}"/> Ä‘
                </div>
                <div class="dash-card-icon">ðŸ’°</div>
            </div>

            <div class="dash-card">
                <div class="dash-card-title">ÄÆ N HÃ€NG Má»šI</div>
                <div class="dash-card-value">
                    <c:out value="${newOrdersCount != null ? newOrdersCount : ''}"/>
                </div>
                <div class="dash-card-icon">ðŸ›’</div>
            </div>

            <div class="dash-card">
                <div class="dash-card-title">Sáº¢N PHáº¨M</div>
                <div class="dash-card-value">
                    <c:out value="${productCount != null ? productCount : ''}"/>
                </div>
                <div class="dash-card-icon">ðŸ’»</div>
            </div>

            <div class="dash-card">
                <div class="dash-card-title">KHÃCH HÃ€NG</div>
                <div class="dash-card-value">
                    <c:out value="${customerCount != null ? customerCount : ''}"/>
                </div>
                <div class="dash-card-icon">ðŸ‘¤</div>
            </div>
        </section>

        
        <section class="card">
            <div class="card-header">
                <div class="card-title">ÄÆ¡n hÃ ng cáº§n xá»­ lÃ½ (Má»›i nháº¥t)</div>
                <a href="<c:url value='/admin/orders'/>" class="btn btn-primary">Xem táº¥t cáº£</a>
            </div>

            <div class="table-wrapper">
                <table class="product-table">
                    <thead>
                    <tr>
                        <th style="width:80px;">MÃ£ Ä‘Æ¡n</th>
                        <th>KhÃ¡ch hÃ ng</th>
                        <th style="width:180px;">Tá»•ng tiá»n</th>
                        <th style="width:140px;">Tráº¡ng thÃ¡i</th>
                        <th style="width:160px;">NgÃ y Ä‘áº·t</th>
                        <th style="width:120px;">HÃ nh Ä‘á»™ng</th>
                    </tr>
                    </thead>
                    <tbody>
                    <c:forEach var="o" items="${latestOrders}">
                        <tr>
                            <td>#<c:out value="${o.id}"/></td>
                            <td><c:out value="${o.customerName}"/></td>
                            <td class="price-current">
                                <c:out value="${o.totalAmount}"/> Ä‘
                            </td>
                            <td>
                                <span class="badge status-${o.status}">
                                    <c:out value="${o.statusLabel}"/>
                                </span>
                            </td>
                            <td><c:out value="${o.orderDate}"/></td>
                            <td>
                                <a href="${pageContext.request.contextPath}/admin/orders?action=detail&id=${o.id}"
                                   class="btn btn-secondary">
                                    Chi tiáº¿t
                                </a>
                            </td>
                        </tr>
                    </c:forEach>

                    <c:if test="${empty latestOrders}">
                        <tr>
                            <td colspan="6" class="text-center text-muted">
                                ChÆ°a cÃ³ Ä‘Æ¡n hÃ ng nÃ o cáº§n xá»­ lÃ½.
                            </td>
                        </tr>
                    </c:if>
                    </tbody>
                </table>
            </div>
        </section>

    </main>
</div>

</body>
</html>


