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

    // Lấy toàn bộ dữ liệu khu vực
    public List<FarmArea> getAllFarmAreas() {
        List<FarmArea> list = new ArrayList<>();
        String sql = "SELECT * FROM FarmArea ORDER BY MaKhuVuc DESC";
        try (Connection con = DBConnect.getConnection(); PreparedStatement ps = con.prepareStatement(sql)) {
            ResultSet rs = ps.executeQuery();
            while (rs.next()) {
                FarmArea fa = new FarmArea();
                fa.setMaKhuVuc(rs.getInt("MaKhuVuc"));
                fa.setTenKhuVuc(rs.getString("TenKhuVuc"));
                fa.setLoaiKhuVuc(rs.getString("LoaiKhuVuc"));
                fa.setDienTich(rs.getDouble("DienTich"));
                fa.setMoTa(rs.getString("MoTa"));
                list.add(fa);
            }
        } catch (Exception e) {
            e.printStackTrace();
        }
        return list;
    }

    // Thêm khu vực mới
    public boolean insertFarmArea(FarmArea fa) {
        String sql = "INSERT INTO FarmArea (TenKhuVuc, LoaiKhuVuc, DienTich, MoTa) VALUES (?, ?, ?, ?)";
        try (Connection con = DBConnect.getConnection(); PreparedStatement ps = con.prepareStatement(sql)) {
            ps.setString(1, fa.getTenKhuVuc());
            ps.setString(2, fa.getLoaiKhuVuc());
            ps.setDouble(3, fa.getDienTich());
            ps.setString(4, fa.getMoTa());
            return ps.executeUpdate() > 0;
        } catch (Exception e) {
            e.printStackTrace();
        }
        return false;
    }

    // Cập nhật khu vực
    public boolean updateFarmArea(FarmArea fa) {
        String sql = "UPDATE FarmArea SET TenKhuVuc = ?, LoaiKhuVuc = ?, DienTich = ?, MoTa = ? WHERE MaKhuVuc = ?";
        try (Connection con = DBConnect.getConnection(); PreparedStatement ps = con.prepareStatement(sql)) {
            ps.setString(1, fa.getTenKhuVuc());
            ps.setString(2, fa.getLoaiKhuVuc());
            ps.setDouble(3, fa.getDienTich());
            ps.setString(4, fa.getMoTa());
            ps.setInt(5, fa.getMaKhuVuc());
            return ps.executeUpdate() > 0;
        } catch (Exception e) {
            e.printStackTrace();
        }
        return false;
    }

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

    public Map<Integer, String> getFarmAreaMap() {
        Map<Integer, String> map = new HashMap<>();
        for (FarmArea fa : getAllFarmAreas()) {
            map.put(fa.getMaKhuVuc(), fa.getTenKhuVuc());
        }
        return map;
    }
}