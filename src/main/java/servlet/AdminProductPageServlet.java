package servlet;

import javax.servlet.ServletException;
import javax.servlet.http.*;
import java.io.IOException;

public class AdminProductPageServlet extends HttpServlet {

    @Override
    protected void doGet(HttpServletRequest req, HttpServletResponse resp)
            throws ServletException, IOException {

        // Lúc này AdminFilter đã check ADMIN rồi,
        // nên ở đây không cần check lại cũng được.
        req.getRequestDispatcher("/WEB-INF/views/admin/products.jsp").forward(req, resp);
    }
}
