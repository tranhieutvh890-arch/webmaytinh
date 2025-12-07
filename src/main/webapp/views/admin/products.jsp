<%@ page contentType="text/html; charset=UTF-8" language="java" %>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<%@ taglib prefix="fn" uri="http://java.sun.com/jsp/jstl/functions" %>
<%@ taglib prefix="fmt" uri="http://java.sun.com/jsp/jstl/fmt" %>

<%
    model.Product product = (model.Product) request.getAttribute("product");
    boolean editMode = (product != null);
%>

<!DOCTYPE html>
<html lang="vi">
<head>
    <meta charset="UTF-8">
    <title>Quản lý sản phẩm - Admin</title>
    <!-- CSS riêng cho trang admin sản phẩm -->
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
            <a href="<c:url value='/admin/products'/>" class="nav-item active">
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
        <!-- Thanh trên cùng -->
        <header class="topbar">
            <div class="topbar-left">
                <h1 class="page-title">Quản lý sản phẩm</h1>
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

        <!-- Thông báo -->
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

        <!-- Card danh sách sản phẩm -->
        <section class="card product-card">
            <div class="card-header">
                <div class="card-title">Danh sách Laptop</div>

                <div class="card-tools">
                    <!-- Ô tìm kiếm -->
                    <form action="${pageContext.request.contextPath}/admin/products" method="get" class="search-form">
                        <input type="hidden" name="action" value="search">
                        <input type="text" class="search-input"
                               name="keyword"
                               placeholder="Tìm tên sản phẩm..."
                               value="${param.keyword != null ? param.keyword : ''}">
                        <button type="submit" class="btn btn-icon">
                            🔍
                        </button>
                    </form>

                    <!-- Nút Thêm mới -->
                    <button type="button" id="btnOpenForm" class="btn btn-primary">
                        + Thêm mới
                    </button>
                </div>
            </div>

            <!-- Bảng sản phẩm -->
            <div class="table-wrapper">
                <table class="product-table">
                    <thead>
                    <tr>
                        <th style="width:60px;">ID</th>
                        <th style="width:80px;">Ảnh</th>
                        <th style="min-width:260px;">Tên sản phẩm</th>
                        <th style="min-width:180px;">Cấu hình / Mô tả</th>
                        <th style="width:160px;">Giá tiền</th>
                        <th style="width:70px;">Số lượng tồn kho</th>
                        <th style="width:120px;">Thao tác</th>
                    </tr>
                    </thead>
                    <tbody>
                    <c:forEach var="p" items="${products}">
                        <tr>
                            <td class="col-id">#<c:out value="${p.maSanPham}"/></td>

                            <td>
    <c:choose>
        <c:when test="${not empty p.anhDaiDien}">
            <img class="product-img-thumb"
     		src="<c:url value='${p.anhDaiDien}'/>"
    	 	alt="${fn:escapeXml(p.tenSanPham)}">

        </c:when>
        <c:otherwise>
            <img class="product-img-thumb"
                 src="<c:url value='/static/images/no-image.jpg'/>"
                 alt="No image">
        </c:otherwise>
    </c:choose>
</td>

                            <td>
                                <div class="product-name">
                                    <c:out value="${p.tenSanPham}"/>
                                </div>
                                <div class="product-sub">
                                    Danh mục:
                                    <c:choose>
                                        <c:when test="${not empty p.tenDanhMuc}">
                                            <c:out value="${p.tenDanhMuc}"/>
                                        </c:when>
                                        <c:otherwise>
                                            #<c:out value="${p.maDanhMuc}"/>
                                        </c:otherwise>
                                    </c:choose>
                                </div>
                            </td>

                            <td>
                                <div class="product-config">
                                    <c:out value="${p.moTaNgan}"/>
                                </div>
                            </td>

                            <td>
                                <div class="price-current">
                                    <fmt:formatNumber value="${p.gia}" type="number" groupingUsed="true"/>₫
                                </div>
                                <c:if test="${not empty p.giaCu}">
                                    <div class="price-old">
                                        <fmt:formatNumber value="${p.giaCu}" type="number" groupingUsed="true"/>₫
                                    </div>
                                </c:if>
                            </td>

                            <td>
                                <span class="stock-badge">
                                    <c:out value="${p.soLuongTon}"/>
                                </span>
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
                            <td colspan="7" class="text-muted text-center">
                                Chưa có sản phẩm nào trong hệ thống.
                            </td>
                        </tr>
                    </c:if>
                    </tbody>
                </table>
            </div>
        </section>
    </main>
</div>

<!-- ========== POPUP FORM THÊM / SỬA ========== -->
<div id="productFormModal" class="modal-overlay">
    <div class="modal-panel">
        <div class="modal-header">
            <div class="modal-title">
                <%= editMode ? "Sửa sản phẩm" : "Thêm sản phẩm mới" %>
            </div>
            <button type="button" class="btn-close" id="btnCloseForm">&times;</button>
        </div>

        <div class="modal-body">
            <p class="form-note">
                Nhập đầy đủ thông tin sản phẩm. Các trường có dấu * là bắt buộc.
            </p>

            <form action="${pageContext.request.contextPath}/admin/products"
     			 method="post"
      			enctype="multipart/form-data">

                <input type="hidden" name="action" value="<%= editMode ? "update" : "create" %>"/>
                <% if (editMode) { %>
                <input type="hidden" name="maSanPham" value="<%= product.getMaSanPham() %>"/>
                <% } %>

                <div class="form-row">
                    <label for="tenSanPham">Tên sản phẩm *</label>
                    <input type="text" id="tenSanPham" name="tenSanPham"
                           value="<%= editMode ? product.getTenSanPham() : "" %>"
                           required/>
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
                    <label for="anhDaiDien">Ảnh đại diện (tên file)</label>
                    <input type="text" id="anhDaiDien" name="anhDaiDien"
                           value="<%= editMode ? product.getAnhDaiDien() : "" %>"/>
                    <small>Ví dụ: <code>sp14.jpg</code> (ảnh nằm trong <code>/static/images/</code>)</small>
                </div>
                <div class="form-row">
    			<label for="imageFile">Chọn ảnh từ máy</label>
    			<input type="file" id="imageFile" name="image" accept="image/*"/>
    			<small>Nếu chọn file, hệ thống sẽ tự copy vào <code>/static/images</code>
       					 và cập nhật đường dẫn trong CSDL. Nếu không chọn, sẽ dùng giá trị nhập ở ô trên.</small>
				</div>
                

                <div class="form-row">
                <label for="maDanhMuc">Danh mục *</label>
   					<select id="maDanhMuc" name="maDanhMuc" required>
        		<c:forEach var="dm" items="${danhMucList}">
            		<option value="${dm.maDanhMuc}"
                <c:if test="${editMode and product.maDanhMuc == dm.maDanhMuc}">selected</c:if>>
      	          <c:out value="${dm.tenDanhMuc}"/>
         				   </option>
    	  				  </c:forEach>
   						 </select>
				</div>


                <div class="form-row">
    			<label for="maThuongHieu">Thương hiệu</label>
    			<select id="maThuongHieu" name="maThuongHieu">
        		<option value="">-- Không chọn --</option>
        		<c:forEach var="th" items="${thuongHieuList}">
            	<option value="${th.maThuongHieu}"
                <c:if test="${editMode and product.maThuongHieu == th.maThuongHieu}">selected</c:if>>
                <c:out value="${th.tenThuongHieu}"/>
            		</option>
       		 </c:forEach>
    		</select>
    					<small>Nếu để trống sẽ không gán thương hiệu cho sản phẩm.</small>
					</div>


                <div class="form-row checkbox-row">
                    <input type="checkbox" id="sanPhamCu" name="sanPhamCu"
                        <%= editMode && product.isSanPhamCu() ? "checked" : "" %> />
                    <label for="sanPhamCu">Sản phẩm cũ (đã qua sử dụng)</label>
                </div>

                <div class="modal-footer">
                    <button type="button" class="btn btn-secondary" id="btnCancelForm">Hủy</button>
                    <button type="submit" class="btn btn-primary">
                        <%= editMode ? "Cập nhật sản phẩm" : "Thêm mới sản phẩm" %>
                    </button>
                </div>
            </form>
        </div>
    </div>
</div>

<script>
    const modal = document.getElementById("productFormModal");
    const btnOpen = document.getElementById("btnOpenForm");
    const btnClose = document.getElementById("btnCloseForm");
    const btnCancel = document.getElementById("btnCancelForm");

    function openForm() { modal.classList.add("show"); }
    function closeForm() { modal.classList.remove("show"); }

    if (btnOpen)  btnOpen.addEventListener("click", openForm);
    if (btnClose) btnClose.addEventListener("click", closeForm);
    if (btnCancel) btnCancel.addEventListener("click", closeForm);

    window.addEventListener("click", function(e) {
        if (e.target === modal) { closeForm(); }
    });

    // Nếu đang sửa -> tự mở popup
    <% if (editMode) { %>
    document.addEventListener("DOMContentLoaded", function () {
        openForm();
    });
    <% } %>
</script>

</body>
</html>