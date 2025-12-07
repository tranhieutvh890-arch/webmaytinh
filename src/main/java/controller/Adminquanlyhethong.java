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
        userDAO = new UserDAO();   // dÃ¹ng cho /admin/customers
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

        // VÃ­ dá»¥: /webmaytinh/admin/dashboard  -> servletPath = /admin/dashboard
        String path = req.getServletPath();
        String view;

        try {
            switch (path) {
                case "/admin/dashboard":
                    // TODO: sau nÃ y truyá»n sá»‘ liá»‡u thá»‘ng kÃª vÃ o Ä‘Ã¢y
                    // req.setAttribute("totalRevenue", ...);
                    view = "/views/admin/tongquanhethong.jsp";
                    break;

                case "/admin/orders":
                    // TODO: sau nÃ y gá»i OrderDAO láº¥y danh sÃ¡ch Ä‘Æ¡n hÃ ng
                    // req.setAttribute("orders", ...);
                    // req.setAttribute("currentPage", ...);
                    // req.setAttribute("totalPages", ...);
                    view = "/views/admin/quanlydonhang.jsp";
                    break;

                case "/admin/customers":
                    // ==== THÃŠM CHá»¨C NÄ‚NG Láº¤Y Dá»® LIá»†U NGÆ¯á»œI DÃ™NG Tá»ª DB ====

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

                        // Náº¿u cÃ³ action=edit & id => láº¥y thÃ´ng tin 1 user Ä‘á»ƒ hiá»ƒn thá»‹ form sá»­a
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
                    // Náº¿u vÃ o sai Ä‘Æ°á»ng dáº«n thÃ¬ Ä‘áº©y vá» dashboard
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

    // Xá»­ lÃ½ POST cho /admin/customers (sá»­a, xÃ³a)
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
                            // XÃ“A NGÆ¯á»œI DÃ™NG
                            String idParam = req.getParameter("id");
                            int id = Integer.parseInt(idParam);
                            userDAO.deleteUser(id);

                        } else if ("update".equals(action)) {
                            // Cáº¬P NHáº¬T THÃ”NG TIN NGÆ¯á»œI DÃ™NG
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

                    // Sau khi xá»­ lÃ½ xong quay láº¡i trang danh sÃ¡ch
                    resp.sendRedirect(req.getContextPath() + "/admin/customers");
                    break;
                }

                default:
                    // CÃ¡c Ä‘Æ°á»ng dáº«n khÃ¡c váº«n xá»­ lÃ½ nhÆ° cÅ©
                    doGet(req, resp);
            }

        } catch (Exception e) {
            e.printStackTrace();
            resp.sendError(500, "Lá»—i server: " + e.getMessage());
        }
    }
}

