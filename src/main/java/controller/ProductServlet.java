package controller;
import dao.ProductDAO;
import model.Product;
import com.google.gson.Gson;
import com.google.gson.GsonBuilder;
import javax.servlet.ServletException;
import javax.servlet.http.HttpServlet;
import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;
import java.io.IOException;
import java.io.PrintWriter;
import java.util.List;
public class ProductServlet extends HttpServlet {
    private ProductDAO dao;
    private final Gson gson = new GsonBuilder().serializeNulls().create();
    @Override
    public void init() throws ServletException {
        super.init();
        dao = new ProductDAO();
    }
    private void setUtf8NoCache(HttpServletRequest req, HttpServletResponse resp) throws IOException {
        req.setCharacterEncoding("UTF-8");
        resp.setCharacterEncoding("UTF-8");
        resp.setContentType("application/json;charset=UTF-8");
        resp.setHeader("Cache-Control", "no-store, no-cache, must-revalidate, max-age=0");
        resp.setHeader("Pragma", "no-cache");
    }
    @Override
    protected void doGet(HttpServletRequest req, HttpServletResponse resp) throws IOException {
        setUtf8NoCache(req, resp);
        String idParam = req.getParameter("id");
        try (PrintWriter out = resp.getWriter()) {
            if (idParam == null || idParam.isEmpty()) {
                List<Product> list = dao.findAll();
                out.print(gson.toJson(list));
            } else {
                int id;
                try {
                    id = Integer.parseInt(idParam);
                } catch (NumberFormatException nfe) {
                    resp.setStatus(HttpServletResponse.SC_BAD_REQUEST);
                    out.print("{\"error\":\"Invalid id\"}");
                    return;
                }
                Product p = dao.findById(id);
                if (p == null) {
                    resp.setStatus(HttpServletResponse.SC_NOT_FOUND);
                    out.print("{\"error\":\"Not found\"}");
                } else {
                    out.print(gson.toJson(p));
                }
            }
        } catch (Exception e) {
            resp.setStatus(HttpServletResponse.SC_INTERNAL_SERVER_ERROR);
            resp.getWriter().print("{\"error\":\"" + e.getMessage().replace("\"","\\\"") + "\"}");
        }
    }
}
