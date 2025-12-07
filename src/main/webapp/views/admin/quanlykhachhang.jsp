<%@ page contentType="text/html; charset=UTF-8" language="java" %>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<%@ taglib prefix="fn" uri="http://java.sun.com/jsp/jstl/functions" %>

<!DOCTYPE html>
<html lang="vi">
<head>
    <meta charset="UTF-8">
    <title>Quáº£n lÃ½ KhÃ¡ch hÃ ng - Admin</title>
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
            <a href="<c:url value='/admin/orders'/>" class="nav-item">
                <span class="nav-icon">ðŸ“¦</span> Quáº£n lÃ½ ÄÆ¡n hÃ ng
            </a>
            <a href="<c:url value='/admin/customers'/>" class="nav-item active">
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
                <h1 class="page-title">Quáº£n lÃ½ KhÃ¡ch hÃ ng</h1>
                <p class="page-subtitle">Danh sÃ¡ch TÃ i khoáº£n â€“ Quáº£n lÃ½ thÃ´ng tin ngÆ°á»i dÃ¹ng há»‡ thá»‘ng</p>
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

        
        <section class="card">
            <div class="card-header">
                <div class="card-title">Danh sÃ¡ch TÃ i khoáº£n</div>
            </div>

            <div class="table-wrapper">
                <table class="product-table">
                    <thead>
                    <tr>
                        <th style="width:60px;">ID</th>
                        <th style="width:80px;">Avatar</th>
                        <th>ThÃ´ng tin tÃ i khoáº£n</th>
                        <th style="width:220px;">LiÃªn há»‡</th>
                        <th style="width:120px;">Vai trÃ²</th>
                        <th style="width:120px;">Tráº¡ng thÃ¡i</th>
                        <th style="width:130px;">Thao tÃ¡c</th>
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
                                    NgÃ y táº¡o:
                                    <c:out value="${u.ngayTao}"/>
                                </div>
                            </td>
                            <td>
                                <div>ðŸ“§ <c:out value="${u.email}"/></div>
                                <div>ðŸ“ž <c:out value="${empty u.soDienThoai ? 'N/A' : u.soDienThoai}"/></div>
                            </td>
                            <td>
                                <span class="badge">
                                    <c:choose>
                                        <c:when test="${u.maQuyen == 1}">Admin</c:when>
                                        <c:otherwise>KhÃ¡ch hÃ ng</c:otherwise>
                                    </c:choose>
                                </span>
                            </td>
                            <td>
                                <span class="badge ${u.trangThai ? 'badge-success' : 'badge-danger'}">
                                    <c:choose>
                                        <c:when test="${u.trangThai}">Hoáº¡t Ä‘á»™ng</c:when>
                                        <c:otherwise>Bá»‹ khÃ³a</c:otherwise>
                                    </c:choose>
                                </span>
                            </td>
                            <td>
                                <div style="display:flex; gap:6px;">
                                    
                                    <a href="${pageContext.request.contextPath}/admin/customers?action=edit&id=${u.maNguoiDung}"
                                       class="btn btn-primary btn-icon-only"
                                       title="Xem / Sá»­a">
                                        âœ
                                    </a>

                                    
                                    <form action="${pageContext.request.contextPath}/admin/customers" method="post"
                                          onsubmit="return confirm('XÃ³a tÃ i khoáº£n nÃ y?');">
                                        <input type="hidden" name="action" value="delete">
                                        <input type="hidden" name="id" value="${u.maNguoiDung}">
                                        <button type="submit" class="btn btn-danger btn-icon-only" title="XÃ³a">
                                            ðŸ—‘
                                        </button>
                                    </form>
                                </div>
                            </td>
                        </tr>
                    </c:forEach>

                    <c:if test="${empty users}">
                        <tr>
                            <td colspan="7" class="text-center text-muted">
                                ChÆ°a cÃ³ tÃ i khoáº£n nÃ o.
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

        
        <c:if test="${not empty editingUser}">
            <section class="card" style="margin-top: 24px;">
                <div class="card-header">
                    <div class="card-title">Sá»­a thÃ´ng tin tÃ i khoáº£n</div>
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
                                <label>Há» tÃªn</label>
                                <input type="text" name="hoTen" value="${editingUser.hoTen}" class="input" required>
                            </div>
                        </div>

                        <div class="form-row">
                            <div class="form-group">
                                <label>Email</label>
                                <input type="email" name="email" value="${editingUser.email}" class="input" required>
                            </div>
                            <div class="form-group">
                                <label>Sá»‘ Ä‘iá»‡n thoáº¡i</label>
                                <input type="text" name="soDienThoai" value="${editingUser.soDienThoai}" class="input">
                            </div>
                        </div>

                        <div class="form-row">
                            <div class="form-group">
                                <label>Vai trÃ²</label>
                                <select name="maQuyen" class="input">
                                    <option value="1" ${editingUser.maQuyen == 1 ? 'selected' : ''}>Admin</option>
                                    <option value="2" ${editingUser.maQuyen == 2 ? 'selected' : ''}>KhÃ¡ch hÃ ng</option>
                                </select>
                            </div>
                            <div class="form-group" style="display:flex; align-items:center; gap:8px;">
                                <label>Tráº¡ng thÃ¡i</label>
                                <input type="checkbox" name="trangThai"
                                       ${editingUser.trangThai ? 'checked' : ''}>
                                <span>Hoáº¡t Ä‘á»™ng (bá» check = khÃ³a)</span>
                            </div>
                        </div>

                        <div class="form-actions">
                            <button type="submit" class="btn btn-primary">LÆ°u thay Ä‘á»•i</button>
                            <a href="${pageContext.request.contextPath}/admin/customers" class="btn btn-secondary">
                                Há»§y
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


