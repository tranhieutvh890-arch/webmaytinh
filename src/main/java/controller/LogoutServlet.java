package controller;
import javax.servlet.ServletException;
import javax.servlet.http.*;
import java.io.IOException;
public class LogoutServlet extends HttpServlet {
    @Override
    protected void doGet(HttpServletRequest req, HttpServletResponse resp)
            throws IOException {
        HttpSession session = req.getSession(false);
        if (session != null) {
            session.invalidate();
        }
        Cookie jsid = new Cookie("JSESSIONID", "");
        jsid.setHttpOnly(true);
        jsid.setMaxAge(0);
        jsid.setPath(req.getContextPath().isEmpty() ? "/" : req.getContextPath());
        resp.addCookie(jsid);
        resp.sendRedirect(req.getContextPath() + "/home");
    }
    @Override
    protected void doPost(HttpServletRequest req, HttpServletResponse resp)
            throws IOException {
        doGet(req, resp);
    }
}
