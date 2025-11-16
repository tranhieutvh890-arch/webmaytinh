package servlet;

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
                out.write("Vui lòng nhập tên đăng nhập và mật khẩu!");
                return;
            }

            // gọi DAO login (đã check BCrypt + trạng thái)
            User user = userDAO.login(tenDangNhap, matKhauNhap);

            if (user == null) {
                resp.setStatus(HttpServletResponse.SC_UNAUTHORIZED);
                out.write("Sai tên đăng nhập hoặc mật khẩu, hoặc tài khoản đã bị khóa!");
                return;
            }

            // LOGIN OK → set session
            HttpSession session = req.getSession(true);
            session.setAttribute("maNguoiDung", user.getMaNguoiDung());
            session.setAttribute("username", user.getTenDangNhap());
            session.setAttribute("hoTen", user.getHoTen());
            session.setAttribute("TEN_QUYEN", user.getTenQuyen());   // ví dụ: ADMIN / CUSTOMER
            session.setAttribute("userLogin", user);                 // nếu sau này cần tới

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
            resp.getWriter().write("Lỗi máy chủ: " + e.getMessage());
        }
    }
}
