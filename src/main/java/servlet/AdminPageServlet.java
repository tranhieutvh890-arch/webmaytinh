package servlet;

import model.User;

import javax.servlet.ServletException;
import javax.servlet.annotation.WebServlet;
import javax.servlet.http.HttpServlet;
import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;
import javax.servlet.http.HttpSession;
import java.io.IOException;
    // URL: /admin → sẽ tự mở trang quản trị
public class AdminPageServlet extends HttpServlet {

    @Override
    protected void doGet(HttpServletRequest req, HttpServletResponse resp)
            throws ServletException, IOException {

        HttpSession session = req.getSession(false);

        // Chưa đăng nhập → về trang chủ
        if (session == null) {
            resp.sendRedirect(req.getContextPath() + "/home");
            return;
        }

        // Lấy user lưu trong session
        User user = (User) session.getAttribute("userLogin");

        // Không có user hoặc không phải ADMIN → cấm truy cập
        if (user == null || !user.isAdmin()) {
            resp.sendRedirect(req.getContextPath() + "/home");
            return;
        }

        // Admin hợp lệ → mở trang quản trị
        req.getRequestDispatcher("/WEB-INF/views/admin/products.jsp").forward(req, resp);
    }
}
