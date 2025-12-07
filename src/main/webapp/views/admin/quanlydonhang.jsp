<%@ page contentType="text/html; charset=UTF-8" language="java" %>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>

<!DOCTYPE html>
<html lang="vi">
<head>
    <meta charset="UTF-8">
    <title>Quáº£n lÃ½ ÄÆ¡n hÃ ng - Admin</title>
    <link rel="stylesheet" href="<c:url value='/static/css/styleproduct.css'/>">
</head>
<body class="admin-body">

<div class="admin-layout">

    
    <aside class="sidebar">
        <div class="sidebar-logo">
            <span class="logo-main">N4</span><span class="logo-sub">Computer</span>
        </div>

        <nav class="sidebar-nav">
            <a href="<c:url value='/admin/dashboard'/>" class="nav-item">
                <span class="nav-icon">ðŸ </span> Dá»¯ liá»‡u thá»‘ng kÃª
            </a>
            <a href="<c:url value='/admin/products'/>" class="nav-item">
                <span class="nav-icon">ðŸ’»</span> Quáº£n lÃ½ Sáº£n pháº©m
            </a>
            <a href="<c:url value='/admin/orders'/>" class="nav-item active">
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
                <h1 class="page-title">Quáº£n lÃ½ ÄÆ¡n hÃ ng</h1>
                <p class="page-subtitle">Danh sÃ¡ch ÄÆ¡n hÃ ng â€“ Quáº£n lÃ½ vÃ  cáº­p nháº­t tráº¡ng thÃ¡i Ä‘Æ¡n hÃ ng</p>
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

        
        <section class="card">
            <div class="card-header">
                <div class="card-title">Danh sÃ¡ch ÄÆ¡n hÃ ng</div>

                
                <form method="get" action="${pageContext.request.contextPath}/admin/orders"
                      class="order-filter">
                    <label for="status">Tráº¡ng thÃ¡i:</label>
                    <select id="status" name="status" onchange="this.form.submit()">
                        <option value="">Táº¥t cáº£</option>
                        <option value="PENDING"  ${param.status == 'PENDING'  ? 'selected' : ''}>Chá» xá»­ lÃ½</option>
                        <option value="SHIPPING" ${param.status == 'SHIPPING' ? 'selected' : ''}>Äang giao</option>
                        <option value="CANCELLED"${param.status == 'CANCELLED'? 'selected' : ''}>ÄÃ£ há»§y</option>
                    </select>
                </form>
            </div>

            <div class="table-wrapper">
                <table class="product-table">
                    <thead>
                    <tr>
                        <th style="width:80px;">MÃ£ Ä‘Æ¡n</th>
                        <th>KhÃ¡ch hÃ ng</th>
                        <th style="width:200px;">NgÃ y Ä‘áº·t</th>
                        <th style="width:160px;">Tá»•ng tiá»n</th>
                        <th style="width:150px;">Tráº¡ng thÃ¡i</th>
                        <th style="width:120px;">Chi tiáº¿t</th>
                    </tr>
                    </thead>
                    <tbody>
                    <c:forEach var="o" items="${orders}">
                        <tr>
                            <td>#<c:out value="${o.id}"/></td>
                            <td>
                                <div class="customer-name"><c:out value="${o.customerName}"/></div>
                                <div class="customer-email">
                                    ðŸ“§ <c:out value="${o.customerEmail}"/>
                                </div>
                            </td>
                            <td>
                                ðŸ—“ <c:out value="${o.orderDate}"/>
                            </td>
                            <td class="price-current">
                                <c:out value="${o.totalAmount}"/> Ä‘
                            </td>
                            <td>
                                <span class="badge status-${o.status}">
                                    <c:out value="${o.statusLabel}"/>
                                </span>
                            </td>
                            <td>
                                <a href="${pageContext.request.contextPath}/admin/orders?action=detail&id=${o.id}"
                                   class="btn btn-secondary btn-icon-only">
                                    ðŸ‘
                                </a>
                            </td>
                        </tr>
                    </c:forEach>

                    <c:if test="${empty orders}">
                        <tr>
                            <td colspan="6" class="text-center text-muted">
                                KhÃ´ng cÃ³ Ä‘Æ¡n hÃ ng nÃ o.
                            </td>
                        </tr>
                    </c:if>
                    </tbody>
                </table>
            </div>

            
            <c:if test="${totalPages > 1}">
                <div class="pagination">
                    <c:forEach var="i" begin="1" end="${totalPages}">
                        <a href="${pageContext.request.contextPath}/admin/orders?page=${i}"
                           class="page-item ${i == currentPage ? 'active' : ''}">
                            ${i}
                        </a>
                    </c:forEach>
                </div>
            </c:if>
        </section>
    </main>
</div>

</body>
</html>


