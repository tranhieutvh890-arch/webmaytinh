package controller;
import javax.servlet.*;
import javax.servlet.annotation.WebFilter;
import javax.servlet.http.*;
import java.io.IOException;
@WebFilter("/admin/*")
public class AdminFilter implements Filter {
    @Override
    public void doFilter(ServletRequest request, ServletResponse response, FilterChain chain)
            throws IOException, ServletException {
        HttpServletRequest req  = (HttpServletRequest) request;
        HttpServletResponse resp = (HttpServletResponse) response;
        String uri = req.getRequestURI();
        if (uri.matches(".*/(css|js|images|img|fonts)/.*") || uri.matches(".+\\.(css|js|png|jpg|jpeg|gif|woff2?|svg)$")) {
            chain.doFilter(request, response);
            return;
        }
        HttpSession session = req.getSession(false);
        String role = null;
        if (session != null) {
            Object o = session.getAttribute("TEN_QUYEN");
            if (o != null) role = o.toString();
        }
        System.out.println(">>> AdminFilter BEFORE: role=" + role + " | URI=" + uri);
        if (role == null) {
            resp.sendRedirect(req.getContextPath() + "/login");
            return;
        }
        if (!"ADMIN".equalsIgnoreCase(role)) {
            resp.sendRedirect(req.getContextPath() + "/home");
            return;
        }
        chain.doFilter(request, response);
        System.out.println(">>> AdminFilter AFTER: allowed admin for URI=" + uri);
    }
}
