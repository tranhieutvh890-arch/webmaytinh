package dao;

import model.DanhMuc;
import java.sql.*;
import java.util.ArrayList;
import java.util.List;

public class DanhMucDAO {

    public List<DanhMuc> findAll() throws Exception {
        List<DanhMuc> list = new ArrayList<>();

        String sql = "SELECT MaDanhMuc, TenDanhMuc, DuongDan FROM DanhMuc ORDER BY MaDanhMuc ASC";

        try (Connection c = DBHelper.getConnection();
             PreparedStatement ps = c.prepareStatement(sql);
             ResultSet rs = ps.executeQuery()) {

            while (rs.next()) {
                DanhMuc dm = new DanhMuc();
                dm.setMaDanhMuc(rs.getInt("MaDanhMuc"));
                dm.setTenDanhMuc(rs.getString("TenDanhMuc"));
                dm.setDuongDan(rs.getString("DuongDan"));
                list.add(dm);
            }
        }
        return list;
    }
}
