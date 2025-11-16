package servlet;

import dao.DBHelper;

import javax.servlet.ServletException;
import javax.servlet.http.*;
import java.io.IOException;
import java.io.PrintWriter;
import java.sql.Connection;
import java.sql.ResultSet;
import java.sql.Statement;

public class TestDBServlet extends HttpServlet {

    @Override
    protected void doGet(HttpServletRequest req, HttpServletResponse resp)
            throws ServletException, IOException {

        resp.setContentType("text/plain;charset=UTF-8");
        try (PrintWriter out = resp.getWriter()) {
            out.println("Testing DB connection...");

            try (Connection conn = DBHelper.getConnection();
                 Statement st = conn.createStatement();
                 ResultSet rs = st.executeQuery("SELECT COUNT(*) AS cnt FROM SanPham")) {

                if (rs.next()) {
                    int count = rs.getInt("cnt");
                    out.println("OK! SanPham count = " + count);
                } else {
                    out.println("Query chạy được nhưng không trả về gì.");
                }
            } catch (Exception e) {
                e.printStackTrace(out);
            }
        }
    }
}
