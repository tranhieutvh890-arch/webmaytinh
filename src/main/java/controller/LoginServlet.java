package controller;

import dao.UserDAO;
import model.User;

import javax.servlet.ServletException;
import javax.servlet.http.*;
import java.io.IOException;
import java.io.PrintWriter;

public class LoginServlet extends HttpServlet {

    private UserDAO userDAO;

    @Override
    public void init() throws ServletException {
        super.init();
        userDAO = new UserDAO();
    }

    @Override
    protected void doPost(HttpServletRequest req, HttpServletResponse resp) throws IOException {
        req.setCharacterEncoding("UTF-8");
        resp.setCharacterEncoding("UTF-8");
        resp.setContentType("text/plain; charset=UTF-8");

        String tenDangNhap = req.getParameter("username");
        String matKhauNhap = req.getParameter("password");

        try (PrintWriter out = resp.getWriter()) {

            if (tenDangNhap == null || tenDangNhap.isEmpty()
                    || matKhauNhap == null || matKhauNhap.isEmpty()) {
                resp.setStatus(HttpServletResponse.SC_BAD_REQUEST);
                out.write("Vui lÃ²ng nháº­p tÃªn Ä‘Äƒng nháº­p vÃ  máº­t kháº©u!");
                return;
            }

            // gá»i DAO login (Ä‘Ã£ check BCrypt + tráº¡ng thÃ¡i)
            User user = userDAO.login(tenDangNhap, matKhauNhap);

            if (user == null) {
                resp.setStatus(HttpServletResponse.SC_UNAUTHORIZED);
                out.write("Sai tÃªn Ä‘Äƒng nháº­p hoáº·c máº­t kháº©u, hoáº·c tÃ i khoáº£n Ä‘Ã£ bá»‹ khÃ³a!");
                return;
            }

            // LOGIN OK â†’ set session
            HttpSession session = req.getSession(true);
            session.setAttribute("maNguoiDung", user.getMaNguoiDung());
            session.setAttribute("username", user.getTenDangNhap());
            session.setAttribute("hoTen", user.getHoTen());
            session.setAttribute("TEN_QUYEN", user.getTenQuyen());   // vÃ­ dá»¥: ADMIN / CUSTOMER
            session.setAttribute("userLogin", user);                 // náº¿u sau nÃ y cáº§n tá»›i

            boolean isAdmin = user.isAdmin();
            session.setAttribute("isAdmin", isAdmin);

            System.out.println(">>> LOGIN OK: " + user.getTenDangNhap()
                    + " | tenQuyen=" + user.getTenQuyen()
                    + " | isAdmin()=" + user.isAdmin());

            resp.setStatus(HttpServletResponse.SC_OK);
            if (isAdmin) {
                out.write("admin");
            } else {
                out.write("user");
            }

        } catch (Exception e) {
            e.printStackTrace();
            resp.setStatus(HttpServletResponse.SC_INTERNAL_SERVER_ERROR);
            resp.getWriter().write("Lá»—i mÃ¡y chá»§: " + e.getMessage());
        }
    }
}

