package dao;

import model.ThuongHieu;
import java.sql.*;
import java.util.ArrayList;
import java.util.List;

public class ThuongHieuDAO {

    public List<ThuongHieu> findAll() throws Exception {
        List<ThuongHieu> list = new ArrayList<>();

        String sql = "SELECT MaThuongHieu, TenThuongHieu FROM ThuongHieu ORDER BY MaThuongHieu ASC";

        try (Connection c = DBHelper.getConnection();
             PreparedStatement ps = c.prepareStatement(sql);
             ResultSet rs = ps.executeQuery()) {

            while (rs.next()) {
                ThuongHieu th = new ThuongHieu();
                th.setMaThuongHieu(rs.getInt("MaThuongHieu"));
                th.setTenThuongHieu(rs.getString("TenThuongHieu"));
                list.add(th);
            }
        }

        return list;
    }
}
