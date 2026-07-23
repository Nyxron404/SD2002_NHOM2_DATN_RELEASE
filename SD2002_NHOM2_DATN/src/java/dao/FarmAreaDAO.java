package dao;

import java.sql.Connection;
import java.sql.PreparedStatement;
import java.sql.ResultSet;
import java.util.ArrayList;
import java.util.HashMap;
import java.util.List;
import java.util.Map;
import uril.DBConnect;
import models.FarmArea;

public class FarmAreaDAO {

    public List<FarmArea> getAllFarmAreas() {
        List<FarmArea> list = new ArrayList<>();
        String sql = "SELECT MaKhuVuc, TenKhuVuc FROM FarmArea";
        try (Connection con = DBConnect.getConnection(); PreparedStatement ps = con.prepareStatement(sql)) {
            ResultSet rs = ps.executeQuery();
            while (rs.next()) {
                FarmArea fa = new FarmArea();
                fa.setMaKhuVuc(rs.getInt("MaKhuVuc"));
                fa.setTenKhuVuc(rs.getString("TenKhuVuc"));
                list.add(fa);
            }
        } catch (Exception e) {
            e.printStackTrace();
        }
        return list;
    }

    // Tra tên khu vực theo mã - dùng để hiển thị "Mã (Tên)" trong các form chi tiết
    public String getTenKhuVucById(int maKhuVuc) {
        String sql = "SELECT TenKhuVuc FROM FarmArea WHERE MaKhuVuc = ?";
        try (Connection con = DBConnect.getConnection(); PreparedStatement ps = con.prepareStatement(sql)) {
            ps.setInt(1, maKhuVuc);
            ResultSet rs = ps.executeQuery();
            if (rs.next()) {
                return rs.getString("TenKhuVuc");
            }
        } catch (Exception e) {
            e.printStackTrace();
        }
        return "";
    }

    // Map MaKhuVuc -> TenKhuVuc, tiện dùng trong JSP/servlet khi cần tra cứu nhiều lần
    public Map<Integer, String> getFarmAreaMap() {
        Map<Integer, String> map = new HashMap<>();
        for (FarmArea fa : getAllFarmAreas()) {
            map.put(fa.getMaKhuVuc(), fa.getTenKhuVuc());
        }
        return map;
    }
}