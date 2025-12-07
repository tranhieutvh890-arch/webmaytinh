<%@ page contentType="text/html; charset=UTF-8" language="java" %>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>

<!DOCTYPE html>
<html lang="vi">
<head>
    <meta charset="UTF-8">
    <title>Quản lý Đơn hàng - Admin</title>
    <link rel="stylesheet" href="<c:url value='/static/css/styleproduct.css'/>">
</head>
<body class="admin-body">

<div class="admin-layout">

    <!-- ========== SIDEBAR ========== -->
    <aside class="sidebar">
        <div class="sidebar-logo">
            <span class="logo-main">N4</span><span class="logo-sub">Computer</span>
        </div>

        <nav class="sidebar-nav">
            <a href="<c:url value='/admin/dashboard'/>" class="nav-item">
                <span class="nav-icon">🏠</span> Dữ liệu thống kê
            </a>
            <a href="<c:url value='/admin/products'/>" class="nav-item">
                <span class="nav-icon">💻</span> Quản lý Sản phẩm
            </a>
            <a href="<c:url value='/admin/orders'/>" class="nav-item active">
                <span class="nav-icon">📦</span> Quản lý Đơn hàng
            </a>
            <a href="<c:url value='/admin/customers'/>" class="nav-item">
                <span class="nav-icon">👥</span> Quản lý Khách hàng
            </a>
        </nav>

        <a href="${pageContext.request.contextPath}/home" class="back-store">
            ← Về trang bán hàng
        </a>
    </aside>

    <!-- ========== MAIN CONTENT ========== -->
    <main class="main">
        <header class="topbar">
            <div class="topbar-left">
                <h1 class="page-title">Quản lý Đơn hàng</h1>
                <p class="page-subtitle">Danh sách Đơn hàng – Quản lý và cập nhật trạng thái đơn hàng</p>
            </div>
            <div class="topbar-right">
                <span class="hello-text">
                    Xin chào,
                    <strong>
                        <c:choose>
                            <c:when test="${not empty sessionScope.hoTen}">
                                <c:out value="${sessionScope.hoTen}"/>
                            </c:when>
                            <c:otherwise>Quản trị viên</c:otherwise>
                        </c:choose>
                    </strong>
                </span>
                <a class="btn-link" href="<c:url value='/logout'/>">Đăng xuất</a>
            </div>
        </header>

        <!-- CARD DANH SÁCH ĐƠN -->
        <section class="card">
            <div class="card-header">
                <div class="card-title">Danh sách Đơn hàng</div>

                <!-- Filter trạng thái -->
                <form method="get" action="${pageContext.request.contextPath}/admin/orders"
                      class="order-filter">
                    <label for="status">Trạng thái:</label>
                    <select id="status" name="status" onchange="this.form.submit()">
                        <option value="">Tất cả</option>
                        <option value="PENDING"  ${param.status == 'PENDING'  ? 'selected' : ''}>Chờ xử lý</option>
                        <option value="SHIPPING" ${param.status == 'SHIPPING' ? 'selected' : ''}>Đang giao</option>
                        <option value="CANCELLED"${param.status == 'CANCELLED'? 'selected' : ''}>Đã hủy</option>
                    </select>
                </form>
            </div>

            <div class="table-wrapper">
                <table class="product-table">
                    <thead>
                    <tr>
                        <th style="width:80px;">Mã đơn</th>
                        <th>Khách hàng</th>
                        <th style="width:200px;">Ngày đặt</th>
                        <th style="width:160px;">Tổng tiền</th>
                        <th style="width:150px;">Trạng thái</th>
                        <th style="width:120px;">Chi tiết</th>
                    </tr>
                    </thead>
                    <tbody>
                    <c:forEach var="o" items="${orders}">
                        <tr>
                            <td>#<c:out value="${o.id}"/></td>
                            <td>
                                <div class="customer-name"><c:out value="${o.customerName}"/></div>
                                <div class="customer-email">
                                    📧 <c:out value="${o.customerEmail}"/>
                                </div>
                            </td>
                            <td>
                                🗓 <c:out value="${o.orderDate}"/>
                            </td>
                            <td class="price-current">
                                <c:out value="${o.totalAmount}"/> đ
                            </td>
                            <td>
                                <span class="badge status-${o.status}">
                                    <c:out value="${o.statusLabel}"/>
                                </span>
                            </td>
                            <td>
                                <a href="${pageContext.request.contextPath}/admin/orders?action=detail&id=${o.id}"
                                   class="btn btn-secondary btn-icon-only">
                                    👁
                                </a>
                            </td>
                        </tr>
                    </c:forEach>

                    <c:if test="${empty orders}">
                        <tr>
                            <td colspan="6" class="text-center text-muted">
                                Không có đơn hàng nào.
                            </td>
                        </tr>
                    </c:if>
                    </tbody>
                </table>
            </div>

            <!-- Phân trang (nếu có) -->
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
