package servlet;

import dao.ProductDAO;
import model.Product;
import com.google.gson.Gson;

import javax.servlet.ServletException;
import javax.servlet.annotation.MultipartConfig;
import javax.servlet.http.*;
import javax.servlet.http.Part;
import java.io.*;
import java.math.BigDecimal;
import java.nio.file.*;
import java.util.Optional;

@MultipartConfig
public class AdminProductServlet extends HttpServlet {

    private ProductDAO dao;
    private final Gson gson = new Gson();

    @Override
    public void init() throws ServletException {
        dao = new ProductDAO();
    }

    /** CHECK QUYỀN ADMIN */
    private boolean checkAdmin(HttpServletRequest req) {
        HttpSession ses = req.getSession(false);
        return ses != null && "ADMIN".equals(ses.getAttribute("TEN_QUYEN"));
    }

    /* ============================================================
                               UTILS
       ============================================================ */

    private void setUtf8(HttpServletRequest req, HttpServletResponse resp) throws UnsupportedEncodingException {
        req.setCharacterEncoding("UTF-8");
        resp.setCharacterEncoding("UTF-8");
    }

    private Integer parseIntOrNull(String v) {
        try { return (v == null || v.trim().isEmpty()) ? null : Integer.parseInt(v.trim()); }
        catch (Exception e) { return null; }
    }

    private BigDecimal parseDecimalOrNull(String v) {
        try { return (v == null || v.trim().isEmpty()) ? null : new BigDecimal(v.trim()); }
        catch (Exception e) { return null; }
    }

    /** Upload ảnh, trả về relative URL */
    private String saveImageIfUploaded(HttpServletRequest req) throws IOException, ServletException {
        Part part = null;
        try { part = req.getPart("image"); } catch (Exception ignore) {}

        if (part == null || part.getSize() == 0) return null;

        String original = Paths.get(part.getSubmittedFileName()).getFileName().toString().replaceAll("\\s+", "_");
        String fileName = System.currentTimeMillis() + "_" + original;
        String uploadDir = req.getServletContext().getRealPath("/uploads");

        Files.createDirectories(Paths.get(uploadDir));
        Path output = Paths.get(uploadDir, fileName);

        try (InputStream in = part.getInputStream()) {
            Files.copy(in, output, StandardCopyOption.REPLACE_EXISTING);
        }

        return "uploads/" + fileName;
    }


    /* ============================================================
                               CREATE  (POST)
       ============================================================ */

    @Override
    protected void doPost(HttpServletRequest req, HttpServletResponse resp) throws IOException, ServletException {
        if (!checkAdmin(req)) { resp.sendError(403); return; }
        setUtf8(req, resp);

        Product p = new Product();
        p.setMaDanhMuc(parseIntOrNull(req.getParameter("categoryId")));
        p.setMaThuongHieu(parseIntOrNull(req.getParameter("brandId")));
        p.setTenSanPham(Optional.ofNullable(req.getParameter("tenSanPham")).orElse("").trim());
        p.setMoTaNgan(req.getParameter("moTaNgan"));
        p.setMoTaChiTiet(req.getParameter("moTaChiTiet"));
        p.setGia(parseDecimalOrNull(req.getParameter("gia")));
        p.setGiaCu(parseDecimalOrNull(req.getParameter("giaCu")));
        p.setSoLuongTon(Optional.ofNullable(parseIntOrNull(req.getParameter("soLuongTon"))).orElse(0));
        p.setBaoHanhThang(parseIntOrNull(req.getParameter("baoHanhThang")));
        p.setSanPhamCu("on".equals(req.getParameter("sanPhamCu")));

        String imgPath = saveImageIfUploaded(req);
        p.setAnhDaiDien(imgPath);

        try (PrintWriter out = resp.getWriter()) {
            int newId = dao.create(p);
            if (newId > 0) {
                p.setMaSanPham(newId);
                resp.setStatus(201);
                resp.setContentType("application/json;charset=UTF-8");
                out.print(gson.toJson(p));
            } else {
                resp.sendError(500, "Không thể tạo sản phẩm");
            }
        } catch (Exception e) {
            resp.sendError(500, e.getMessage());
        }
    }


    /* ============================================================
                               UPDATE  (PUT)
       ============================================================ */

    @Override
    protected void doPut(HttpServletRequest req, HttpServletResponse resp) throws IOException, ServletException {
        if (!checkAdmin(req)) { resp.sendError(403); return; }
        setUtf8(req, resp);

        Integer id = parseIntOrNull(req.getParameter("maSanPham"));
        if (id == null) { resp.sendError(400, "Thiếu tham số maSanPham"); return; }

        Product old;
        try {
            old = dao.findById(id);
        } catch (Exception e) {
            resp.sendError(500, e.getMessage());
            return;
        }
        if (old == null) { resp.sendError(404, "Không tìm thấy sản phẩm"); return; }

        Product p = new Product();
        p.setMaSanPham(id);
        p.setMaDanhMuc(Optional.ofNullable(parseIntOrNull(req.getParameter("maDanhMuc"))).orElse(old.getMaDanhMuc()));
        p.setMaThuongHieu(Optional.ofNullable(parseIntOrNull(req.getParameter("maThuongHieu"))).orElse(old.getMaThuongHieu()));
        p.setTenSanPham(Optional.ofNullable(req.getParameter("tenSanPham")).orElse(old.getTenSanPham()));
        p.setMoTaNgan(Optional.ofNullable(req.getParameter("moTaNgan")).orElse(old.getMoTaNgan()));
        p.setMoTaChiTiet(Optional.ofNullable(req.getParameter("moTaChiTiet")).orElse(old.getMoTaChiTiet()));
        p.setGia(Optional.ofNullable(parseDecimalOrNull(req.getParameter("gia"))).orElse(old.getGia()));
        p.setGiaCu(Optional.ofNullable(parseDecimalOrNull(req.getParameter("giaCu"))).orElse(old.getGiaCu()));
        p.setSoLuongTon(Optional.ofNullable(parseIntOrNull(req.getParameter("soLuongTon"))).orElse(old.getSoLuongTon()));
        p.setBaoHanhThang(Optional.ofNullable(parseIntOrNull(req.getParameter("baoHanhThang"))).orElse(old.getBaoHanhThang()));
        p.setSanPhamCu("on".equals(req.getParameter("sanPhamCu")));

        String img = saveImageIfUploaded(req);
        p.setAnhDaiDien(img != null ? img : old.getAnhDaiDien());

        try (PrintWriter out = resp.getWriter()) {
            boolean updated = dao.update(p);
            if (updated) {
                resp.setContentType("application/json;charset=UTF-8");
                out.print(gson.toJson(p));
            } else {
                resp.sendError(500, "Cập nhật thất bại");
            }
        } catch (Exception e) {
            resp.sendError(500, e.getMessage());
        }
    }


    /* ============================================================
                               DELETE  (DELETE)
       ============================================================ */

    @Override
    protected void doDelete(HttpServletRequest req, HttpServletResponse resp) throws IOException {
        if (!checkAdmin(req)) { resp.sendError(403); return; }

        Integer id = parseIntOrNull(req.getParameter("maSanPham"));
        if (id == null) { resp.sendError(400, "Thiếu tham số maSanPham"); return; }

        try {
            boolean deleted = dao.delete(id);
            if (deleted) resp.setStatus(204);
            else resp.sendError(404, "Không tìm thấy sản phẩm");
        } catch (Exception e) {
            resp.sendError(500, e.getMessage());
        }
    }
}
