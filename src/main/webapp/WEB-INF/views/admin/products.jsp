<%@ page contentType="text/html; charset=UTF-8" language="java" %>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>

<%
    // Lấy thông tin sản phẩm để biết đang ở chế độ thêm hay sửa
    model.Product product = (model.Product) request.getAttribute("product");
    boolean editMode = (product != null);
%>

<!DOCTYPE html>
<html lang="vi">
<head>
    <meta charset="UTF-8">
    <title>Trang quản trị - Quản lý sản phẩm</title>
    <style>
        /* ========= RESET NHẸ ========= */
        * {
            box-sizing: border-box;
            margin: 0;
            padding: 0;
        }

        body {
            font-family: Arial, sans-serif;
            background: #f4f6f8;
            color: #333;
        }

        a {
            text-decoration: none;
            color: #0d6efd;
        }

        a:hover {
            text-decoration: underline;
        }

        /* ========= LAYOUT CHÍNH ========= */
        .container {
            max-width: 1200px;
            margin: 24px auto;
            padding: 16px 20px 32px;
            background: #ffffff;
            border-radius: 10px;
            box-shadow: 0 4px 20px rgba(0,0,0,0.06);
        }

        .page-header {
            display: flex;
            justify-content: space-between;
            align-items: center;
            margin-bottom: 16px;
        }

        .page-title {
            font-size: 24px;
            font-weight: 600;
        }

        .admin-info {
            text-align: right;
            font-size: 14px;
        }

        .admin-info span {
            font-weight: 600;
        }

        .top-actions {
            margin-top: 8px;
        }

        .btn-link {
            font-size: 14px;
        }

        .alert {
            margin-top: 8px;
            padding: 8px 12px;
            border-radius: 6px;
            font-size: 14px;
        }

        .alert-error {
            background: #ffe5e5;
            color: #b02a37;
            border: 1px solid #f5c2c7;
        }

        .alert-success {
            background: #e6ffed;
            color: #0f5132;
            border: 1px solid #badbcc;
        }

        /* ========= GRID FORM + TABLE ========= */
        .content-grid {
            display: grid;
            grid-template-columns: 1.1fr 1.9fr;
            gap: 20px;
            margin-top: 20px;
        }

        /* ========= FORM ========= */
        .form-block {
            border-radius: 10px;
            border: 1px solid #e1e5ea;
            padding: 16px 16px 20px;
            background: #fafbfc;
        }

        .form-block h3 {
            margin-bottom: 10px;
            font-size: 18px;
            border-left: 4px solid #0d6efd;
            padding-left: 8px;
        }

        .form-note {
            font-size: 12px;
            color: #777;
            margin-bottom: 10px;
        }

        .form-row {
            margin-bottom: 10px;
        }

        .form-row label {
            display: block;
            font-size: 14px;
            margin-bottom: 4px;
            font-weight: 500;
        }

        .form-row input[type=text],
        .form-row input[type=number],
        .form-row textarea {
            width: 100%;
            padding: 7px 9px;
            border-radius: 6px;
            border: 1px solid #ced4da;
            font-size: 14px;
            transition: border-color 0.2s, box-shadow 0.2s;
        }

        .form-row textarea {
            resize: vertical;
        }

        .form-row input:focus,
        .form-row textarea:focus {
            border-color: #0d6efd;
            box-shadow: 0 0 0 2px rgba(13,110,253,0.15);
            outline: none;
        }

        .checkbox-row {
            display: flex;
            align-items: center;
            gap: 8px;
            font-size: 14px;
        }

        /* ========= BUTTONS ========= */
        .btn {
            display: inline-block;
            padding: 7px 16px;
            font-size: 14px;
            border-radius: 6px;
            border: none;
            cursor: pointer;
            transition: background 0.15s, box-shadow 0.15s, transform 0.05s;
        }

        .btn-primary {
            background: #0d6efd;
            color: #fff;
        }

        .btn-primary:hover {
            background: #0b5ed7;
            box-shadow: 0 2px 8px rgba(13,110,253,0.35);
        }

        .btn-secondary {
            background: #6c757d;
            color: #fff;
        }

        .btn-secondary:hover {
            background: #5c636a;
        }

        .btn-danger {
            background: #dc3545;
            color: #fff;
        }

        .btn-danger:hover {
            background: #bb2d3b;
        }

        .btn-ghost {
            background: transparent;
            color: #0d6efd;
            border: 1px solid #0d6efd;
        }

        .btn-ghost:hover {
            background: rgba(13,110,253,0.06);
        }

        .btn + .btn {
            margin-left: 6px;
        }

        .form-actions {
            margin-top: 12px;
        }

        /* ========= TABLE ========= */
        .table-card {
            border-radius: 10px;
            border: 1px solid #e1e5ea;
            padding: 16px;
            background: #fff;
        }

        .table-header {
            display: flex;
            justify-content: space-between;
            align-items: center;
            margin-bottom: 10px;
        }

        .table-header h3 {
            font-size: 18px;
        }

        .table-tools {
            display: flex;
            gap: 8px;
            align-items: center;
        }

        .table-wrapper {
            max-height: 460px;
            overflow: auto;
            border-radius: 6px;
            border: 1px solid #e1e5ea;
        }

        table {
            border-collapse: collapse;
            width: 100%;
            font-size: 13px;
            background: #fff;
        }

        thead {
            position: sticky;
            top: 0;
            background: #f1f3f5;
            z-index: 1;
        }

        th, td {
            padding: 8px 10px;
            border-bottom: 1px solid #e9ecef;
            text-align: left;
            vertical-align: top;
        }

        th {
            font-weight: 600;
            white-space: nowrap;
        }

        tbody tr:nth-child(even) {
            background: #fafbfc;
        }

        .text-muted {
            color: #6c757d;
            font-size: 12px;
        }

        .price-current {
            font-weight: 600;
        }

        .price-old {
            text-decoration: line-through;
            color: #999;
            font-size: 12px;
        }

        .badge {
            display: inline-block;
            padding: 2px 6px;
            border-radius: 999px;
            font-size: 11px;
        }

        .badge-new {
            background: #e7f5ff;
            color: #1c7ed6;
        }

        .badge-old {
            background: #fff4e6;
            color: #d9480f;
        }

        .product-img-thumb {
            width: 60px;
            height: 45px;
            object-fit: cover;
            border-radius: 4px;
            border: 1px solid #dee2e6;
        }

        .actions-col {
            white-space: nowrap;
        }

        form.inline {
            display: inline;
        }

        /* Responsive */
        @media (max-width: 960px) {
            .content-grid {
                grid-template-columns: 1fr;
            }
        }
    </style>
</head>
<body>
<div class="container">

    <!-- HEADER -->
    <div class="page-header">
        <div>
            <div class="page-title">Trang quản trị - Quản lý sản phẩm</div>
        </div>
        <div class="admin-info">
            Xin chào:
            <span>
                <c:choose>
                    <c:when test="${not empty sessionScope.hoTen}">
                        <c:out value="${sessionScope.hoTen}" />
                    </c:when>
                    <c:otherwise>Admin</c:otherwise>
                </c:choose>
            </span>
            <div class="top-actions">
                <a class="btn-link" href="<c:url value='/logout'/>">Về trang người dùng</a>
            </div>
        </div>
    </div>

    <!-- THÔNG BÁO -->
    <c:if test="${not empty error}">
        <div class="alert alert-error">
            <c:out value="${error}"/>
        </div>
    </c:if>
    <c:if test="${not empty message}">
        <div class="alert alert-success">
            <c:out value="${message}"/>
        </div>
    </c:if>

    <!-- GRID: FORM + TABLE -->
    <div class="content-grid">

        <!-- FORM THÊM / SỬA -->
        <div class="form-block">
            <h3><%= editMode ? "Sửa sản phẩm" : "Thêm sản phẩm mới" %></h3>
            <p class="form-note">
                Nhập đầy đủ thông tin sản phẩm. Các trường có dấu * là bắt buộc.
            </p>

            <form action="${pageContext.request.contextPath}/admin/products" method="post">
                <input type="hidden" name="action" value="<%= editMode ? "update" : "create" %>"/>

                <% if (editMode) { %>
                    <input type="hidden" name="maSanPham" value="<%= product.getMaSanPham() %>"/>
                <% } %>

                <div class="form-row">
                    <label for="tenSanPham">Tên sản phẩm *</label>
                    <input type="text" id="tenSanPham" name="tenSanPham"
                           value="<%= editMode ? product.getTenSanPham() : "" %>" required/>
                </div>

                <div class="form-row">
                    <label for="moTaNgan">Mô tả ngắn</label>
                    <textarea id="moTaNgan" name="moTaNgan" rows="2"><%= editMode ? product.getMoTaNgan() : "" %></textarea>
                </div>

                <div class="form-row">
                    <label for="moTaChiTiet">Mô tả chi tiết</label>
                    <textarea id="moTaChiTiet" name="moTaChiTiet" rows="4"><%= editMode ? product.getMoTaChiTiet() : "" %></textarea>
                </div>

                <div class="form-row">
                    <label for="gia">Giá hiện tại *</label>
                    <input type="text" id="gia" name="gia"
                           value="<%= editMode && product.getGia() != null ? product.getGia().toString() : "" %>"
                           required/>
                </div>

                <div class="form-row">
                    <label for="giaCu">Giá cũ (nếu có)</label>
                    <input type="text" id="giaCu" name="giaCu"
                           value="<%= editMode && product.getGiaCu() != null ? product.getGiaCu().toString() : "" %>"/>
                </div>

                <div class="form-row">
                    <label for="soLuongTon">Số lượng tồn *</label>
                    <input type="number" id="soLuongTon" name="soLuongTon" min="0"
                           value="<%= editMode ? product.getSoLuongTon() : 0 %>" required/>
                </div>

                <div class="form-row">
                    <label for="baoHanhThang">Bảo hành (tháng)</label>
                    <input type="number" id="baoHanhThang" name="baoHanhThang" min="0"
                           value="<%= editMode && product.getBaoHanhThang() != null ? product.getBaoHanhThang() : 0 %>"/>
                </div>

                <div class="form-row">
                    <label for="anhDaiDien">Ảnh đại diện (URL / tên file)</label>
                    <input type="text" id="anhDaiDien" name="anhDaiDien"
                           value="<%= editMode ? product.getAnhDaiDien() : "" %>"/>
                </div>

                <div class="form-row">
                    <label for="maDanhMuc">Mã danh mục</label>
                    <input type="number" id="maDanhMuc" name="maDanhMuc" min="0"
                           value="<%= editMode ? product.getMaDanhMuc() : 0 %>"/>
                </div>

                <div class="form-row">
                    <label for="maThuongHieu">Mã thương hiệu</label>
                    <input type="number" id="maThuongHieu" name="maThuongHieu" min="0"
                           value="<%= editMode && product.getMaThuongHieu() != null ? product.getMaThuongHieu() : 0 %>"/>
                </div>

                <div class="form-row">
                    <div class="checkbox-row">
                        <input type="checkbox" id="sanPhamCu" name="sanPhamCu"
                               <%= editMode && product.isSanPhamCu() ? "checked" : "" %> />
                        <label for="sanPhamCu" style="margin-bottom:0;">Sản phẩm cũ (đã qua sử dụng)</label>
                    </div>
                </div>

                <div class="form-actions">
                    <button type="submit" class="btn btn-primary">
                        <%= editMode ? "Cập nhật sản phẩm" : "Thêm mới sản phẩm" %>
                    </button>
                    <% if (editMode) { %>
                        <a class="btn btn-secondary"
                           href="${pageContext.request.contextPath}/admin/products">Hủy</a>
                    <% } %>
                </div>
            </form>
        </div>

        <!-- DANH SÁCH SẢN PHẨM -->
        <div class="table-card">
            <div class="table-header">
                <h3>Danh sách sản phẩm</h3>
                <div class="table-tools">
                    <!-- NÚT HIỂN THỊ TẤT CẢ SẢN PHẨM -->
                    <form action="${pageContext.request.contextPath}/admin/products" method="get">
                        <input type="hidden" name="action" value="listAll"/>
                        <button type="submit" class="btn btn-ghost">
                            Hiển thị tất cả
                        </button>
                    </form>
                </div>
            </div>

            <div class="table-wrapper">
                <table>
                    <thead>
                    <tr>
                        <th>Mã</th>
                        <th>Tên sản phẩm</th>
                        <th>Mô tả ngắn</th>
                        <th>Giá</th>
                        <th>Tồn kho</th>
                        <th>Bảo hành</th>
                        <th>Ảnh</th>
                        <th>DM / TH</th>
                        <th>Tình trạng</th>
                        <th>Hành động</th>
                    </tr>
                    </thead>
                    <tbody>
                    <c:forEach var="p" items="${products}">
                        <tr>
                            <td><c:out value="${p.maSanPham}"/></td>
                            <td><c:out value="${p.tenSanPham}"/></td>
                            <td class="text-muted">
                                <c:out value="${p.moTaNgan}"/>
                            </td>
                            <td>
                                <div class="price-current">
                                    <c:out value="${p.gia}"/>
                                </div>
                                <c:if test="${not empty p.giaCu}">
                                    <div class="price-old">
                                        <c:out value="${p.giaCu}"/>
                                    </div>
                                </c:if>
                            </td>
                            <td><c:out value="${p.soLuongTon}"/></td>
                            <td>
                                <c:if test="${not empty p.baoHanhThang}">
                                    <c:out value="${p.baoHanhThang}"/> tháng
                                </c:if>
                            </td>
                            <td>
                                <c:choose>
                                    <c:when test="${not empty p.anhDaiDien}">
                                        <img class="product-img-thumb"
                                             src="${p.anhDaiDien}"
                                             alt="${p.tenSanPham}"/>
                                    </c:when>
                                    <c:otherwise>
                                        <span class="text-muted">Không có ảnh</span>
                                    </c:otherwise>
                                </c:choose>
                            </td>
                            <td>
                                <div class="text-muted">
                                    DM: <c:out value="${p.maDanhMuc}"/><br/>
                                    TH: <c:out value="${p.maThuongHieu}"/>
                                </div>
                            </td>
                            <td>
                                <c:choose>
                                    <c:when test="${p.sanPhamCu}">
                                        <span class="badge badge-old">Cũ</span>
                                    </c:when>
                                    <c:otherwise>
                                        <span class="badge badge-new">Mới</span>
                                    </c:otherwise>
                                </c:choose>
                            </td>
                            <td class="actions-col">
                                <!-- Sửa -->
                                <a class="btn btn-secondary"
                                   href="${pageContext.request.contextPath}/admin/products?action=edit&maSanPham=${p.maSanPham}">
                                    Sửa
                                </a>

                                <!-- Xóa -->
                                <form class="inline"
                                      action="${pageContext.request.contextPath}/admin/products"
                                      method="post"
                                      onsubmit="return confirm('Xóa sản phẩm này?');">
                                    <input type="hidden" name="action" value="delete"/>
                                    <input type="hidden" name="maSanPham" value="${p.maSanPham}"/>
                                    <button type="submit" class="btn btn-danger">Xóa</button>
                                </form>
                            </td>
                        </tr>
                    </c:forEach>

                    <c:if test="${empty products}">
                        <tr>
                            <td colspan="10" class="text-muted">
                                Chưa có sản phẩm nào trong hệ thống.
                            </td>
                        </tr>
                    </c:if>
                    </tbody>
                </table>
            </div>
        </div>

    </div> <!-- /content-grid -->

</div> <!-- /container -->
</body>
</html>
