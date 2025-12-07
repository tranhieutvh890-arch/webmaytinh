package controller;
import dao.ProductDAO;
import dao.ThuongHieuDAO;
import model.Product;
import model.ThuongHieu;
import com.google.gson.Gson;
import dao.DanhMucDAO;
import model.DanhMuc;
import javax.servlet.ServletException;
import javax.servlet.annotation.MultipartConfig;
import javax.servlet.http.*;
import javax.servlet.http.Part;
import java.io.*;
import java.math.BigDecimal;
import java.nio.file.*;
import java.util.List;
import java.util.Optional;
@MultipartConfig
public class AdminProductServlet extends HttpServlet {
    private ProductDAO dao;
    private final Gson gson = new Gson();
    @Override
    public void init() throws ServletException {
        dao = new ProductDAO();
    }
    /** CHECK QUYá»€N ADMIN */
    private boolean checkAdmin(HttpServletRequest req) {
        HttpSession ses = req.getSession(false);
        return ses != null && "ADMIN".equals(ses.getAttribute("TEN_QUYEN"));
    }
    /* ========== UTILS ========== */
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
    /** Upload áº£nh */
    /** Upload áº£nh vÃ o /static/images vÃ  tráº£ vá» Ä‘Æ°á»ng dáº«n lÆ°u trong DB */
    private String saveImageIfUploaded(HttpServletRequest req) throws IOException, ServletException {
        Part part = null;
        try {
            part = req.getPart("image");
        } catch (Exception ignore) {}
        if (part == null || part.getSize() == 0) {
            return null;
        }
        String original = Paths.get(part.getSubmittedFileName())
                .getFileName()
                .toString()
                .replaceAll("\\s+", "_");
        String fileName = System.currentTimeMillis() + "_" + original;
        String uploadDir = req.getServletContext().getRealPath("/static/images");
        Files.createDirectories(Paths.get(uploadDir));
        Path output = Paths.get(uploadDir, fileName);
        try (InputStream in = part.getInputStream()) {
            Files.copy(in, output, StandardCopyOption.REPLACE_EXISTING);
        }
        return "/static/images/" + fileName;
    }
    /* ===========================================================
       DOGET: hiá»ƒn thá»‹ danh sÃ¡ch hoáº·c chuyá»ƒn sang edit
       =========================================================== */
    @Override
    protected void doGet(HttpServletRequest req, HttpServletResponse resp) throws ServletException, IOException {
        System.out.println("SERVLET /admin[/*] -> doGet called");
        String action = Optional.ofNullable(req.getParameter("action")).orElse("listAll");
        try {
            DanhMucDAO dmDao = new DanhMucDAO();
            List<DanhMuc> danhMucList = dmDao.findAll();
            req.setAttribute("danhMucList", danhMucList);
            ThuongHieuDAO thDao = new ThuongHieuDAO();
            List<ThuongHieu> thuongHieuList = thDao.findAll();
            req.setAttribute("thuongHieuList", thuongHieuList);
            if ("listAll".equals(action)) {
                List<Product> products = dao.findAll();
                System.out.println("DEBUG: dao.findAll() returned size = " + (products == null ? 0 : products.size()));
                req.setAttribute("products", products);
                req.getRequestDispatcher("/views/admin/products.jsp").forward(req, resp);
                return;
            } else if ("edit".equals(action)) {
                String idStr = req.getParameter("maSanPham");
                if (idStr != null) {
                    Product p = dao.findById(Integer.parseInt(idStr));
                    req.setAttribute("product", p);
                }
                req.getRequestDispatcher("/views/admin/products.jsp").forward(req, resp);
                return;
            } else {
                resp.sendRedirect(req.getContextPath() + "/admin/products?action=listAll");
            }
        } catch (Exception e) {
            e.printStackTrace();
            req.setAttribute("error", "Lá»—i: " + e.getMessage());
            try {
                DanhMucDAO dmDao = new DanhMucDAO();
                List<DanhMuc> danhMucList = dmDao.findAll();
                req.setAttribute("danhMucList", danhMucList);
            } catch (Exception ignore) {}
            req.getRequestDispatcher("/views/admin/products.jsp").forward(req, resp);
        }
    }
    /* ===========================================================
       DOPOST: xá»­ lÃ½ create / update / delete
       =========================================================== */
    @Override
    protected void doPost(HttpServletRequest req, HttpServletResponse resp) throws IOException, ServletException {
        if (!checkAdmin(req)) { resp.sendError(403); return; }
        setUtf8(req, resp);
        String action = Optional.ofNullable(req.getParameter("action")).orElse("listAll");
        try {
            if ("create".equals(action)) {
                handleCreate(req, resp);
            } else if ("update".equals(action)) {
                handleUpdate(req, resp);
            } else if ("delete".equals(action)) {
                handleDelete(req, resp);
            } else {
                resp.sendRedirect(req.getContextPath() + "/admin/products?action=listAll");
            }
        } catch (Exception e) {
            e.printStackTrace();
            req.setAttribute("error", e.getMessage());
            req.getRequestDispatcher("/views/admin/products.jsp").forward(req, resp);
        }
    }
    /* ---------------- CREATE ---------------- */
    private void handleCreate(HttpServletRequest req, HttpServletResponse resp) throws Exception {
        Product p = new Product();
        p.setMaDanhMuc(parseIntOrNull(req.getParameter("maDanhMuc")));
        p.setMaThuongHieu(parseIntOrNull(req.getParameter("maThuongHieu")));
        p.setTenSanPham(Optional.ofNullable(req.getParameter("tenSanPham")).orElse("").trim());
        p.setMoTaNgan(req.getParameter("moTaNgan"));
        p.setMoTaChiTiet(req.getParameter("moTaChiTiet"));
        p.setGia(parseDecimalOrNull(req.getParameter("gia")));
        p.setGiaCu(parseDecimalOrNull(req.getParameter("giaCu")));
        p.setSoLuongTon(Optional.ofNullable(parseIntOrNull(req.getParameter("soLuongTon"))).orElse(0));
        p.setBaoHanhThang(parseIntOrNull(req.getParameter("baoHanhThang")));
        p.setSanPhamCu("on".equals(req.getParameter("sanPhamCu")));
        String imgPath = saveImageIfUploaded(req);
        String anhText = req.getParameter("anhDaiDien");
        p.setAnhDaiDien(imgPath != null ? imgPath : anhText);
        int newId = dao.create(p);
        if (newId > 0) {
            req.getSession().setAttribute("message", "ThÃªm sáº£n pháº©m thÃ nh cÃ´ng.");
            resp.sendRedirect(req.getContextPath() + "/admin/products?action=listAll");
        } else {
            throw new Exception("KhÃ´ng thá»ƒ táº¡o sáº£n pháº©m");
        }
    }
    /* ---------------- UPDATE ---------------- */
    private void handleUpdate(HttpServletRequest req, HttpServletResponse resp) throws Exception {
        Integer id = parseIntOrNull(req.getParameter("maSanPham"));
        if (id == null) throw new Exception("Thiáº¿u maSanPham");
        Product old = dao.findById(id);
        if (old == null) throw new Exception("KhÃ´ng tÃ¬m tháº¥y sáº£n pháº©m");
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
        boolean updated = dao.update(p);
        if (updated) {
            req.getSession().setAttribute("message", "Cáº­p nháº­t sáº£n pháº©m thÃ nh cÃ´ng.");
            resp.sendRedirect(req.getContextPath() + "/admin/products?action=listAll");
        } else {
            throw new Exception("Cáº­p nháº­t tháº¥t báº¡i");
        }
    }
    /* ---------------- DELETE ---------------- */
    private void handleDelete(HttpServletRequest req, HttpServletResponse resp) throws Exception {
        Integer id = parseIntOrNull(req.getParameter("maSanPham"));
        if (id == null) throw new Exception("Thiáº¿u maSanPham Ä‘á»ƒ xÃ³a");
        boolean deleted = dao.delete(id);
        if (deleted) {
            req.getSession().setAttribute("message", "XÃ³a sáº£n pháº©m thÃ nh cÃ´ng.");
            resp.sendRedirect(req.getContextPath() + "/admin/products?action=listAll");
        } else {
            throw new Exception("KhÃ´ng tÃ¬m tháº¥y sáº£n pháº©m Ä‘á»ƒ xÃ³a");
        }
    }
}
