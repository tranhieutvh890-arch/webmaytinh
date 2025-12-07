<%@ page contentType="text/html; charset=UTF-8" language="java" %>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<%@ taglib prefix="fn" uri="http://java.sun.com/jsp/jstl/functions" %>

<!DOCTYPE html>
<html lang="vi">
<head>
    <meta charset="UTF-8">
    <title>Quản lý Khách hàng - Admin</title>
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
            <a href="<c:url value='/admin/orders'/>" class="nav-item">
                <span class="nav-icon">📦</span> Quản lý Đơn hàng
            </a>
            <a href="<c:url value='/admin/customers'/>" class="nav-item active">
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
                <h1 class="page-title">Quản lý Khách hàng</h1>
                <p class="page-subtitle">Danh sách Tài khoản – Quản lý thông tin người dùng hệ thống</p>
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

        <c:if test="${not empty error}">
            <div class="alert alert-danger">
                <c:out value="${error}"/>
            </div>
        </c:if>

        <c:if test="${not empty sessionScope.errorMessage}">
            <div class="alert alert-danger">
                <c:out value="${sessionScope.errorMessage}"/>
            </div>
            <c:remove var="errorMessage" scope="session"/>
        </c:if>

        <!-- ========== DANH SÁCH TÀI KHOẢN ========== -->
        <section class="card">
            <div class="card-header">
                <div class="card-title">Danh sách Tài khoản</div>
            </div>

            <div class="table-wrapper">
                <table class="product-table">
                    <thead>
                    <tr>
                        <th style="width:60px;">ID</th>
                        <th style="width:80px;">Avatar</th>
                        <th>Thông tin tài khoản</th>
                        <th style="width:220px;">Liên hệ</th>
                        <th style="width:120px;">Vai trò</th>
                        <th style="width:120px;">Trạng thái</th>
                        <th style="width:130px;">Thao tác</th>
                    </tr>
                    </thead>
                    <tbody>
                    <c:forEach var="u" items="${users}">
                        <tr>
                            <td>#<c:out value="${u.maNguoiDung}"/></td>
                            <td>
                                <div class="avatar-circle">
                                    <span>
                                        <c:out value="${fn:substring(u.hoTen, 0, 1)}"/>
                                    </span>
                                </div>
                            </td>
                            <td>
                                <div class="customer-name">
                                    <c:out value="${u.hoTen}"/>
                                </div>
                                <div class="customer-username">
                                    Username: <c:out value="${u.tenDangNhap}"/>
                                </div>
                                <div class="customer-created">
                                    Ngày tạo:
                                    <c:out value="${u.ngayTao}"/>
                                </div>
                            </td>
                            <td>
                                <div>📧 <c:out value="${u.email}"/></div>
                                <div>📞 <c:out value="${empty u.soDienThoai ? 'N/A' : u.soDienThoai}"/></div>
                            </td>
                            <td>
                                <span class="badge">
                                    <c:choose>
                                        <c:when test="${u.maQuyen == 1}">Admin</c:when>
                                        <c:otherwise>Khách hàng</c:otherwise>
                                    </c:choose>
                                </span>
                            </td>
                            <td>
                                <span class="badge ${u.trangThai ? 'badge-success' : 'badge-danger'}">
                                    <c:choose>
                                        <c:when test="${u.trangThai}">Hoạt động</c:when>
                                        <c:otherwise>Bị khóa</c:otherwise>
                                    </c:choose>
                                </span>
                            </td>
                            <td>
                                <div style="display:flex; gap:6px;">
                                    <!-- Nút sửa / xem chi tiết -->
                                    <a href="${pageContext.request.contextPath}/admin/customers?action=edit&id=${u.maNguoiDung}"
                                       class="btn btn-primary btn-icon-only"
                                       title="Xem / Sửa">
                                        ✏
                                    </a>

                                    <!-- Nút xóa -->
                                    <form action="${pageContext.request.contextPath}/admin/customers" method="post"
                                          onsubmit="return confirm('Xóa tài khoản này?');">
                                        <input type="hidden" name="action" value="delete">
                                        <input type="hidden" name="id" value="${u.maNguoiDung}">
                                        <button type="submit" class="btn btn-danger btn-icon-only" title="Xóa">
                                            🗑
                                        </button>
                                    </form>
                                </div>
                            </td>
                        </tr>
                    </c:forEach>

                    <c:if test="${empty users}">
                        <tr>
                            <td colspan="7" class="text-center text-muted">
                                Chưa có tài khoản nào.
                            </td>
                        </tr>
                    </c:if>
                    </tbody>
                </table>
            </div>

            <c:if test="${totalPages > 1}">
                <div class="pagination">
                    <c:forEach var="i" begin="1" end="${totalPages}">
                        <a href="${pageContext.request.contextPath}/admin/customers?page=${i}"
                           class="page-item ${i == currentPage ? 'active' : ''}">
                            ${i}
                        </a>
                    </c:forEach>
                </div>
            </c:if>
        </section>

        <!-- ========== FORM SỬA THÔNG TIN USER ========== -->
        <c:if test="${not empty editingUser}">
            <section class="card" style="margin-top: 24px;">
                <div class="card-header">
                    <div class="card-title">Sửa thông tin tài khoản</div>
                </div>
                <div class="card-body">
                    <form action="${pageContext.request.contextPath}/admin/customers" method="post" class="form">
                        <input type="hidden" name="action" value="update">
                        <input type="hidden" name="id" value="${editingUser.maNguoiDung}">

                        <div class="form-row">
                            <div class="form-group">
                                <label>Username</label>
                                <input type="text" value="${editingUser.tenDangNhap}" disabled class="input">
                            </div>
                            <div class="form-group">
                                <label>Họ tên</label>
                                <input type="text" name="hoTen" value="${editingUser.hoTen}" class="input" required>
                            </div>
                        </div>

                        <div class="form-row">
                            <div class="form-group">
                                <label>Email</label>
                                <input type="email" name="email" value="${editingUser.email}" class="input" required>
                            </div>
                            <div class="form-group">
                                <label>Số điện thoại</label>
                                <input type="text" name="soDienThoai" value="${editingUser.soDienThoai}" class="input">
                            </div>
                        </div>

                        <div class="form-row">
                            <div class="form-group">
                                <label>Vai trò</label>
                                <select name="maQuyen" class="input">
                                    <option value="1" ${editingUser.maQuyen == 1 ? 'selected' : ''}>Admin</option>
                                    <option value="2" ${editingUser.maQuyen == 2 ? 'selected' : ''}>Khách hàng</option>
                                </select>
                            </div>
                            <div class="form-group" style="display:flex; align-items:center; gap:8px;">
                                <label>Trạng thái</label>
                                <input type="checkbox" name="trangThai"
                                       ${editingUser.trangThai ? 'checked' : ''}>
                                <span>Hoạt động (bỏ check = khóa)</span>
                            </div>
                        </div>

                        <div class="form-actions">
                            <button type="submit" class="btn btn-primary">Lưu thay đổi</button>
                            <a href="${pageContext.request.contextPath}/admin/customers" class="btn btn-secondary">
                                Hủy
                            </a>
                        </div>
                    </form>
                </div>
            </section>
        </c:if>

    </main>
</div>

</body>
</html>
