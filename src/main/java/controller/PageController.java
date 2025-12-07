package controller;
import dao.ProductDAO;
import model.Product;
import javax.servlet.ServletException;
import javax.servlet.http.*;
import java.io.IOException;
import java.util.List;
import java.util.Set;
public class PageController extends HttpServlet {
    private static final Set<String> ALLOWED = Set.of(
            "trangchumaytinh",
            "laptop", "pc", "manhinh", "tablet", "maycu",
            "linhkien", "phukien", "dichvu", "giohang",
            "chitietsanpham"
    );
    private static final String BASE = "/views/pages/";
    private ProductDAO productDAO;
    @Override
    public void init() throws ServletException {
        super.init();
        productDAO = new ProductDAO();
    }
    @Override
    protected void doGet(HttpServletRequest req, HttpServletResponse resp)
            throws ServletException, IOException {
        req.setCharacterEncoding("UTF-8");
        resp.setCharacterEncoding("UTF-8");
        resp.setContentType("text/html; charset=UTF-8");
        HttpSession session = req.getSession(false);
        String role = null;
        if (session != null && session.getAttribute("TEN_QUYEN") != null) {
            role = session.getAttribute("TEN_QUYEN").toString();
        }
        String servletPath = req.getServletPath();
        if ("ADMIN".equalsIgnoreCase(role) && "/home".equals(servletPath)) {
            resp.sendRedirect(req.getContextPath() + "/admin/products");
            return;
        }
        String name;
        if ("/home".equals(servletPath)) {
            name = "trangchumaytinh";
        } else if ("/giohang".equals(servletPath)) {
            name = "giohang";
        } else {
            String pathInfo = req.getPathInfo();
            name = (pathInfo == null) ? "" : pathInfo.replaceFirst("^/", "");
            int slash = name.indexOf('/');
            if (slash >= 0) name = name.substring(0, slash);
            name = name.replaceAll("[^a-zA-Z0-9_-]", "");
            if (name.isEmpty()) name = "trangchumaytinh";
            if (!ALLOWED.contains(name)) {
                resp.sendError(HttpServletResponse.SC_NOT_FOUND);
                return;
            }
        }
        String view = BASE + name + ".jsp";
        if (getServletContext().getResource(view) == null) {
            resp.sendError(HttpServletResponse.SC_NOT_FOUND, "Missing view: " + view);
            return;
        }
        try {
            if ("chitietsanpham".equals(name)) {
                String idParam = req.getParameter("id");
                if (idParam == null || idParam.isBlank()) {
                    resp.sendError(HttpServletResponse.SC_BAD_REQUEST, "Thiáº¿u id sáº£n pháº©m");
                    return;
                }
                int maSanPham;
                try {
                    maSanPham = Integer.parseInt(idParam);
                } catch (Exception e) {
                    resp.sendError(HttpServletResponse.SC_BAD_REQUEST, "Id sáº£n pháº©m khÃ´ng há»£p lá»‡");
                    return;
                }
                Product p = productDAO.findById(maSanPham);
                if (p == null) {
                    resp.sendError(HttpServletResponse.SC_NOT_FOUND, "KhÃ´ng tÃ¬m tháº¥y sáº£n pháº©m");
                    return;
                }
                req.setAttribute("product", p);
            }
            if (!"chitietsanpham".equals(name) && !"giohang".equals(name)) {
                List<Product> products = productDAO.findAll();
                getServletContext().log("Loaded products size = " + products.size() + " for page " + name);
                req.setAttribute("products", products);
            }
        } catch (Exception e) {
            throw new ServletException("Lá»—i khi load dá»¯ liá»‡u: " + e.getMessage(), e);
        }
        getServletContext().log("Forward to view: " + view);
        req.getRequestDispatcher(view).forward(req, resp);
    }
}
