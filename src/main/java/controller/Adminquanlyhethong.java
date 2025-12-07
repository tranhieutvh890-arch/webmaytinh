package controller;
import dao.UserDAO;
import model.User;
import javax.servlet.RequestDispatcher;
import javax.servlet.ServletException;
import javax.servlet.http.HttpServlet;
import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;
import java.io.IOException;
import java.util.List;
public class Adminquanlyhethong extends HttpServlet {
    private UserDAO userDAO;
    @Override
    public void init() throws ServletException {
        super.init();
        userDAO = new UserDAO();
    }
    private void setUtf8(HttpServletRequest req, HttpServletResponse resp) throws IOException {
        req.setCharacterEncoding("UTF-8");
        resp.setCharacterEncoding("UTF-8");
        resp.setContentType("text/html; charset=UTF-8");
    }
    @Override
    protected void doGet(HttpServletRequest req, HttpServletResponse resp)
            throws ServletException, IOException {
        setUtf8(req, resp);
        String path = req.getServletPath();
        String view;
        try {
            switch (path) {
                case "/admin/dashboard":
                    view = "/views/admin/tongquanhethong.jsp";
                    break;
                case "/admin/orders":
                    view = "/views/admin/quanlydonhang.jsp";
                    break;
                case "/admin/customers":
                    int pageSize = 10;
                    int page = 1;
                    String pageParam = req.getParameter("page");
                    if (pageParam != null) {
                        try {
                            page = Integer.parseInt(pageParam);
                        } catch (NumberFormatException ignored) {}
                    }
                    if (page < 1) page = 1;
                    try {
                        int totalUsers = userDAO.countAll();
                        int totalPages = (int) Math.ceil(totalUsers * 1.0 / pageSize);
                        if (totalPages == 0) totalPages = 1;
                        if (page > totalPages) page = totalPages;
                        int offset = (page - 1) * pageSize;
                        List<User> users = userDAO.findAll(offset, pageSize);
                        req.setAttribute("users", users);
                        req.setAttribute("currentPage", page);
                        req.setAttribute("totalPages", totalPages);
                        String action = req.getParameter("action");
                        String idParam = req.getParameter("id");
                        if ("edit".equals(action) && idParam != null) {
                            try {
                                int id = Integer.parseInt(idParam);
                                User editingUser = userDAO.findById(id);
                                req.setAttribute("editingUser", editingUser);
                            } catch (NumberFormatException ignored) {}
                        }
                    } catch (Exception e) {
                        e.printStackTrace();
                        req.setAttribute("error", "CÃ³ lá»—i khi táº£i danh sÃ¡ch ngÆ°á»i dÃ¹ng: " + e.getMessage());
                    }
                    view = "/views/admin/quanlykhachhang.jsp";
                    break;
                default:
                    resp.sendRedirect(req.getContextPath() + "/admin/dashboard");
                    return;
            }
            RequestDispatcher rd = req.getRequestDispatcher(view);
            rd.forward(req, resp);
        } catch (Exception e) {
            e.printStackTrace();
            resp.sendError(500, "Lá»—i server: " + e.getMessage());
        }
    }
    @Override
    protected void doPost(HttpServletRequest req, HttpServletResponse resp)
            throws ServletException, IOException {
        setUtf8(req, resp);
        String path = req.getServletPath();
        try {
            switch (path) {
                case "/admin/customers": {
                    String action = req.getParameter("action");
                    try {
                        if ("delete".equals(action)) {
                            String idParam = req.getParameter("id");
                            int id = Integer.parseInt(idParam);
                            userDAO.deleteUser(id);
                        } else if ("update".equals(action)) {
                            int id = Integer.parseInt(req.getParameter("id"));
                            String hoTen = req.getParameter("hoTen");
                            String email = req.getParameter("email");
                            String phone = req.getParameter("soDienThoai");
                            int maQuyen = Integer.parseInt(req.getParameter("maQuyen"));
                            boolean trangThai = "on".equals(req.getParameter("trangThai"));
                            User u = userDAO.findById(id);
                            if (u != null) {
                                u.setHoTen(hoTen);
                                u.setEmail(email);
                                u.setSoDienThoai(phone);
                                u.setMaQuyen(maQuyen);
                                u.setTrangThai(trangThai);
                                userDAO.updateUser(u);
                            }
                        }
                    } catch (Exception e) {
                        e.printStackTrace();
                        req.getSession().setAttribute("errorMessage",
                                "CÃ³ lá»—i khi xá»­ lÃ½ ngÆ°á»i dÃ¹ng: " + e.getMessage());
                    }
                    resp.sendRedirect(req.getContextPath() + "/admin/customers");
                    break;
                }
                default:
                    doGet(req, resp);
            }
        } catch (Exception e) {
            e.printStackTrace();
            resp.sendError(500, "Lá»—i server: " + e.getMessage());
        }
    }
}
