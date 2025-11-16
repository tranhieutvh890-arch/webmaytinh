package servlet;

import javax.servlet.ServletException;
import javax.servlet.http.*;
import java.io.IOException;

public class LogoutServlet extends HttpServlet {

    @Override
    protected void doGet(HttpServletRequest req, HttpServletResponse resp)
            throws IOException {

        // Hủy session nếu tồn tại
        HttpSession session = req.getSession(false);
        if (session != null) {
            session.invalidate();
        }

        // Xoá JSESSIONID cookie (nếu tồn tại)
        Cookie jsid = new Cookie("JSESSIONID", "");
        jsid.setHttpOnly(true);
        jsid.setMaxAge(0); // expire ngay
        jsid.setPath(req.getContextPath().isEmpty() ? "/" : req.getContextPath());
        resp.addCookie(jsid);

        // Chuyển về trang chủ
        resp.sendRedirect(req.getContextPath() + "/home");
    }

    @Override
    protected void doPost(HttpServletRequest req, HttpServletResponse resp)
            throws IOException {
        doGet(req, resp);
    }
}
