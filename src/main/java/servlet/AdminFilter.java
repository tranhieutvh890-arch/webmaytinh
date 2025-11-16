package servlet;

import javax.servlet.*;
import javax.servlet.http.*;
import java.io.IOException;

public class AdminFilter implements Filter {

    @Override
    public void doFilter(ServletRequest request, ServletResponse response, FilterChain chain)
            throws IOException, ServletException {

        HttpServletRequest req  = (HttpServletRequest) request;
        HttpServletResponse resp = (HttpServletResponse) response;

        HttpSession session = req.getSession(false);
        String role = null;
        if (session != null) {
            Object o = session.getAttribute("TEN_QUYEN");
            if (o != null) role = o.toString();
        }

        System.out.println(">>> AdminFilter: role=" + role + " | URI=" + req.getRequestURI());

        if (!"ADMIN".equalsIgnoreCase(role)) {
            resp.sendRedirect(req.getContextPath() + "/home");
            return;
        }

        chain.doFilter(request, response);
    }
}
