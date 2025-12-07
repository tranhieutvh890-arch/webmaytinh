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
    <title>Quáº£n lÃ½ sáº£n pháº©m - Admin</title>
    
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
            <a href="<c:url value='/admin/products'/>" class="nav-item active">
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
                <h1 class="page-title">Quáº£n lÃ½ sáº£n pháº©m</h1>
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
            <div class="alert alert-error">
                <c:out value="${error}"/>
            </div>
        </c:if>
        <c:if test="${not empty message}">
            <div class="alert alert-success">
                <c:out value="${message}"/>
            </div>
        </c:if>

        
        <section class="card product-card">
            <div class="card-header">
                <div class="card-title">Danh sÃ¡ch Laptop</div>

                <div class="card-tools">
                    
                    <form action="${pageContext.request.contextPath}/admin/products" method="get" class="search-form">
                        <input type="hidden" name="action" value="search">
                        <input type="text" class="search-input"
                               name="keyword"
                               placeholder="TÃ¬m tÃªn sáº£n pháº©m..."
                               value="${param.keyword != null ? param.keyword : ''}">
                        <button type="submit" class="btn btn-icon">
                            ðŸ”
                        </button>
                    </form>

                    
                    <button type="button" id="btnOpenForm" class="btn btn-primary">
                        + ThÃªm má»›i
                    </button>
                </div>
            </div>

            
            <div class="table-wrapper">
                <table class="product-table">
                    <thead>
                    <tr>
                        <th style="width:60px;">ID</th>
                        <th style="width:80px;">áº¢nh</th>
                        <th style="min-width:260px;">TÃªn sáº£n pháº©m</th>
                        <th style="min-width:180px;">Cáº¥u hÃ¬nh / MÃ´ táº£</th>
                        <th style="width:160px;">GiÃ¡ tiá»n</th>
                        <th style="width:70px;">Sá»‘ lÆ°á»£ng tá»“n kho</th>
                        <th style="width:120px;">Thao tÃ¡c</th>
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
                                    Danh má»¥c:
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
                                    <fmt:formatNumber value="${p.gia}" type="number" groupingUsed="true"/>â‚«
                                </div>
                                <c:if test="${not empty p.giaCu}">
                                    <div class="price-old">
                                        <fmt:formatNumber value="${p.giaCu}" type="number" groupingUsed="true"/>â‚«
                                    </div>
                                </c:if>
                            </td>

                            <td>
                                <span class="stock-badge">
                                    <c:out value="${p.soLuongTon}"/>
                                </span>
                            </td>

                            <td class="actions-col">
                                
                                <a class="btn btn-secondary"
                                   href="${pageContext.request.contextPath}/admin/products?action=edit&maSanPham=${p.maSanPham}">
                                    Sá»­a
                                </a>

                                
                                <form class="inline"
                                      action="${pageContext.request.contextPath}/admin/products"
                                      method="post"
                                      onsubmit="return confirm('XÃ³a sáº£n pháº©m nÃ y?');">
                                    <input type="hidden" name="action" value="delete"/>
                                    <input type="hidden" name="maSanPham" value="${p.maSanPham}"/>
                                    <button type="submit" class="btn btn-danger">XÃ³a</button>
                                </form>
                            </td>
                        </tr>
                    </c:forEach>

                    <c:if test="${empty products}">
                        <tr>
                            <td colspan="7" class="text-muted text-center">
                                ChÆ°a cÃ³ sáº£n pháº©m nÃ o trong há»‡ thá»‘ng.
                            </td>
                        </tr>
                    </c:if>
                    </tbody>
                </table>
            </div>
        </section>
    </main>
</div>


<div id="productFormModal" class="modal-overlay">
    <div class="modal-panel">
        <div class="modal-header">
            <div class="modal-title">
                <%= editMode ? "Sá»­a sáº£n pháº©m" : "ThÃªm sáº£n pháº©m má»›i" %>
            </div>
            <button type="button" class="btn-close" id="btnCloseForm">&times;</button>
        </div>

        <div class="modal-body">
            <p class="form-note">
                Nháº­p Ä‘áº§y Ä‘á»§ thÃ´ng tin sáº£n pháº©m. CÃ¡c trÆ°á»ng cÃ³ dáº¥u * lÃ  báº¯t buá»™c.
            </p>

            <form action="${pageContext.request.contextPath}/admin/products"
     			 method="post"
      			enctype="multipart/form-data">

                <input type="hidden" name="action" value="<%= editMode ? "update" : "create" %>"/>
                <% if (editMode) { %>
                <input type="hidden" name="maSanPham" value="<%= product.getMaSanPham() %>"/>
                <% } %>

                <div class="form-row">
                    <label for="tenSanPham">TÃªn sáº£n pháº©m *</label>
                    <input type="text" id="tenSanPham" name="tenSanPham"
                           value="<%= editMode ? product.getTenSanPham() : "" %>"
                           required/>
                </div>

                <div class="form-row">
                    <label for="moTaNgan">MÃ´ táº£ ngáº¯n</label>
                    <textarea id="moTaNgan" name="moTaNgan" rows="2"><%= editMode ? product.getMoTaNgan() : "" %></textarea>
                </div>

                <div class="form-row">
                    <label for="moTaChiTiet">MÃ´ táº£ chi tiáº¿t</label>
                    <textarea id="moTaChiTiet" name="moTaChiTiet" rows="4"><%= editMode ? product.getMoTaChiTiet() : "" %></textarea>
                </div>

                <div class="form-row">
                    <label for="gia">GiÃ¡ hiá»‡n táº¡i *</label>
                    <input type="text" id="gia" name="gia"
                           value="<%= editMode && product.getGia() != null ? product.getGia().toString() : "" %>"
                           required/>
                </div>

                <div class="form-row">
                    <label for="giaCu">GiÃ¡ cÅ© (náº¿u cÃ³)</label>
                    <input type="text" id="giaCu" name="giaCu"
                           value="<%= editMode && product.getGiaCu() != null ? product.getGiaCu().toString() : "" %>"/>
                </div>

                <div class="form-row">
                    <label for="soLuongTon">Sá»‘ lÆ°á»£ng tá»“n *</label>
                    <input type="number" id="soLuongTon" name="soLuongTon" min="0"
                           value="<%= editMode ? product.getSoLuongTon() : 0 %>" required/>
                </div>

                <div class="form-row">
                    <label for="baoHanhThang">Báº£o hÃ nh (thÃ¡ng)</label>
                    <input type="number" id="baoHanhThang" name="baoHanhThang" min="0"
                           value="<%= editMode && product.getBaoHanhThang() != null ? product.getBaoHanhThang() : 0 %>"/>
                </div>

                <div class="form-row">
                    <label for="anhDaiDien">áº¢nh Ä‘áº¡i diá»‡n (tÃªn file)</label>
                    <input type="text" id="anhDaiDien" name="anhDaiDien"
                           value="<%= editMode ? product.getAnhDaiDien() : "" %>"/>
                    <small>VÃ­ dá»¥: <code>sp14.jpg</code> (áº£nh náº±m trong <code>/static/images/</code>)</small>
                </div>
                <div class="form-row">
    			<label for="imageFile">Chá»n áº£nh tá»« mÃ¡y</label>
    			<input type="file" id="imageFile" name="image" accept="image/*"/>
    			<small>Náº¿u chá»n file, há»‡ thá»‘ng sáº½ tá»± copy vÃ o <code>/static/images</code>
       					 vÃ  cáº­p nháº­t Ä‘Æ°á»ng dáº«n trong CSDL. Náº¿u khÃ´ng chá»n, sáº½ dÃ¹ng giÃ¡ trá»‹ nháº­p á»Ÿ Ã´ trÃªn.</small>
				</div>
                

                <div class="form-row">
                <label for="maDanhMuc">Danh má»¥c *</label>
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
    			<label for="maThuongHieu">ThÆ°Æ¡ng hiá»‡u</label>
    			<select id="maThuongHieu" name="maThuongHieu">
        		<option value="">-- KhÃ´ng chá»n --</option>
        		<c:forEach var="th" items="${thuongHieuList}">
            	<option value="${th.maThuongHieu}"
                <c:if test="${editMode and product.maThuongHieu == th.maThuongHieu}">selected</c:if>>
                <c:out value="${th.tenThuongHieu}"/>
            		</option>
       		 </c:forEach>
    		</select>
    					<small>Náº¿u Ä‘á»ƒ trá»‘ng sáº½ khÃ´ng gÃ¡n thÆ°Æ¡ng hiá»‡u cho sáº£n pháº©m.</small>
					</div>


                <div class="form-row checkbox-row">
                    <input type="checkbox" id="sanPhamCu" name="sanPhamCu"
                        <%= editMode && product.isSanPhamCu() ? "checked" : "" %> />
                    <label for="sanPhamCu">Sáº£n pháº©m cÅ© (Ä‘Ã£ qua sá»­ dá»¥ng)</label>
                </div>

                <div class="modal-footer">
                    <button type="button" class="btn btn-secondary" id="btnCancelForm">Há»§y</button>
                    <button type="submit" class="btn btn-primary">
                        <%= editMode ? "Cáº­p nháº­t sáº£n pháº©m" : "ThÃªm má»›i sáº£n pháº©m" %>
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

    // Náº¿u Ä‘ang sá»­a -> tá»± má»Ÿ popup
    <% if (editMode) { %>
    document.addEventListener("DOMContentLoaded", function () {
        openForm();
    });
    <% } %>
</script>

</body>
</html>

