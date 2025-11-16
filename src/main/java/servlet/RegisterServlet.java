package servlet;

import dao.UserDAO;
import model.User;
import org.mindrot.jbcrypt.BCrypt;

import javax.servlet.ServletException;
import javax.servlet.http.*;
import java.io.IOException;
import java.io.PrintWriter;

public class RegisterServlet extends HttpServlet {

    private UserDAO userDAO;

    @Override
    public void init() throws ServletException {
        super.init();
        userDAO = new UserDAO();
    }

    @Override
    protected void doPost(HttpServletRequest req, HttpServletResponse resp)
            throws ServletException, IOException {

        req.setCharacterEncoding("UTF-8");
        resp.setCharacterEncoding("UTF-8");
        resp.setContentType("text/plain; charset=UTF-8");

        String tenDangNhap = req.getParameter("username");
        String matKhau = req.getParameter("password");
        String matKhauNhapLai = req.getParameter("confirmPassword");
        String hoTen = req.getParameter("fullname");
        String email = req.getParameter("email");
        String soDienThoai = req.getParameter("phone"); // nếu form chưa có, có thể null

        try (PrintWriter out = resp.getWriter()) {

            /* ================= VALIDATION ================= */

            if (tenDangNhap == null || tenDangNhap.isEmpty() ||
                matKhau == null || matKhau.isEmpty() ||
                hoTen == null || hoTen.isEmpty()) {

                resp.setStatus(HttpServletResponse.SC_BAD_REQUEST);
                out.write("Vui lòng nhập đầy đủ thông tin bắt buộc!");
                return;
            }

            if (!matKhau.equals(matKhauNhapLai)) {
                resp.setStatus(HttpServletResponse.SC_BAD_REQUEST);
                out.write("Mật khẩu nhập lại không khớp!");
                return;
            }

            if (userDAO.exists(tenDangNhap)) {
                resp.setStatus(HttpServletResponse.SC_CONFLICT);
                out.write("Tên đăng nhập đã tồn tại!");
                return;
            }

            /* ================= HASH PASSWORD ================= */

            String hashed = BCrypt.hashpw(matKhau, BCrypt.gensalt(12));

            /* ================= CREATE USER OBJECT ================= */

            User u = new User();
            u.setTenDangNhap(tenDangNhap);
            u.setMatKhau(hashed);
            u.setHoTen(hoTen);
            u.setEmail(email);
            u.setSoDienThoai(soDienThoai);

            // Người đăng ký từ website luôn là CUSTOMER (MaQuyen = 2)
            u.setMaQuyen(2);

            /* ================= SAVE TO DATABASE ================= */

            boolean success = userDAO.createUser(u);

            if (success) {
                resp.setStatus(HttpServletResponse.SC_OK);
                out.write("Đăng ký thành công! Bạn có thể đăng nhập ngay.");
            } else {
                resp.setStatus(HttpServletResponse.SC_INTERNAL_SERVER_ERROR);
                out.write("Đã xảy ra lỗi, vui lòng thử lại sau.");
            }

        } catch (Exception ex) {
            ex.printStackTrace();
            resp.setStatus(HttpServletResponse.SC_INTERNAL_SERVER_ERROR);
            resp.getWriter().write("Lỗi hệ thống: " + ex.getMessage());
        }
    }
}
