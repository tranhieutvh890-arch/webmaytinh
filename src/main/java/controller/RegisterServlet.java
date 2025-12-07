package controller;
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
        String soDienThoai = req.getParameter("phone");
        try (PrintWriter out = resp.getWriter()) {
            /* ================= VALIDATION ================= */
            if (tenDangNhap == null || tenDangNhap.isEmpty() ||
                matKhau == null || matKhau.isEmpty() ||
                hoTen == null || hoTen.isEmpty()) {
                resp.setStatus(HttpServletResponse.SC_BAD_REQUEST);
                out.write("Vui lÃ²ng nháº­p Ä‘áº§y Ä‘á»§ thÃ´ng tin báº¯t buá»™c!");
                return;
            }
            if (!matKhau.equals(matKhauNhapLai)) {
                resp.setStatus(HttpServletResponse.SC_BAD_REQUEST);
                out.write("Máº­t kháº©u nháº­p láº¡i khÃ´ng khá»›p!");
                return;
            }
            if (userDAO.exists(tenDangNhap)) {
                resp.setStatus(HttpServletResponse.SC_CONFLICT);
                out.write("TÃªn Ä‘Äƒng nháº­p Ä‘Ã£ tá»“n táº¡i!");
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
            u.setMaQuyen(2);
            /* ================= SAVE TO DATABASE ================= */
            boolean success = userDAO.createUser(u);
            if (success) {
                resp.setStatus(HttpServletResponse.SC_OK);
                out.write("ÄÄƒng kÃ½ thÃ nh cÃ´ng! Báº¡n cÃ³ thá»ƒ Ä‘Äƒng nháº­p ngay.");
            } else {
                resp.setStatus(HttpServletResponse.SC_INTERNAL_SERVER_ERROR);
                out.write("ÄÃ£ xáº£y ra lá»—i, vui lÃ²ng thá»­ láº¡i sau.");
            }
        } catch (Exception ex) {
            ex.printStackTrace();
            resp.setStatus(HttpServletResponse.SC_INTERNAL_SERVER_ERROR);
            resp.getWriter().write("Lá»—i há»‡ thá»‘ng: " + ex.getMessage());
        }
    }
}
