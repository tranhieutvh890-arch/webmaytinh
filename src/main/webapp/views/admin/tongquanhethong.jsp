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

    <!-- ========== SIDEBAR ========== -->
    <aside class="sidebar">
        <div class="sidebar-logo">
            <span class="logo-main">N4</span><span class="logo-sub">Computer</span>
        </div>

        <nav class="sidebar-nav">
            <a href="<c:url value='/admin/dashboard'/>" class="nav-item active">
                <span class="nav-icon">🏠</span> Dữ liệu thống kê
            </a>
            <a href="<c:url value='/admin/products'/>" class="nav-item">
                <span class="nav-icon">💻</span> Quản lý Sản phẩm
            </a>
            <a href="<c:url value='/admin/orders'/>" class="nav-item">
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

        <!-- TOPBAR -->
        <header class="topbar">
            <div class="topbar-left">
                <h1 class="page-title">Tổng quan hệ thống</h1>
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

        <!-- THỐNG KÊ 4 Ô CARD -->
        <section class="dashboard-cards">
            <div class="dash-card">
                <div class="dash-card-title">TỔNG DOANH THU</div>
                <div class="dash-card-value">
                    <c:out value="${totalRevenue != null ? totalRevenue : ''}"/> đ
                </div>
                <div class="dash-card-icon">💰</div>
            </div>

            <div class="dash-card">
                <div class="dash-card-title">ĐƠN HÀNG MỚI</div>
                <div class="dash-card-value">
                    <c:out value="${newOrdersCount != null ? newOrdersCount : ''}"/>
                </div>
                <div class="dash-card-icon">🛒</div>
            </div>

            <div class="dash-card">
                <div class="dash-card-title">SẢN PHẨM</div>
                <div class="dash-card-value">
                    <c:out value="${productCount != null ? productCount : ''}"/>
                </div>
                <div class="dash-card-icon">💻</div>
            </div>

            <div class="dash-card">
                <div class="dash-card-title">KHÁCH HÀNG</div>
                <div class="dash-card-value">
                    <c:out value="${customerCount != null ? customerCount : ''}"/>
                </div>
                <div class="dash-card-icon">👤</div>
            </div>
        </section>

        <!-- BẢNG ĐƠN HÀNG CẦN XỬ LÝ -->
        <section class="card">
            <div class="card-header">
                <div class="card-title">Đơn hàng cần xử lý (Mới nhất)</div>
                <a href="<c:url value='/admin/orders'/>" class="btn btn-primary">Xem tất cả</a>
            </div>

            <div class="table-wrapper">
                <table class="product-table">
                    <thead>
                    <tr>
                        <th style="width:80px;">Mã đơn</th>
                        <th>Khách hàng</th>
                        <th style="width:180px;">Tổng tiền</th>
                        <th style="width:140px;">Trạng thái</th>
                        <th style="width:160px;">Ngày đặt</th>
                        <th style="width:120px;">Hành động</th>
                    </tr>
                    </thead>
                    <tbody>
                    <c:forEach var="o" items="${latestOrders}">
                        <tr>
                            <td>#<c:out value="${o.id}"/></td>
                            <td><c:out value="${o.customerName}"/></td>
                            <td class="price-current">
                                <c:out value="${o.totalAmount}"/> đ
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
                                    Chi tiết
                                </a>
                            </td>
                        </tr>
                    </c:forEach>

                    <c:if test="${empty latestOrders}">
                        <tr>
                            <td colspan="6" class="text-center text-muted">
                                Chưa có đơn hàng nào cần xử lý.
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
