package dao;

import java.sql.*;
import java.util.ArrayList;
import java.util.List;
import models.SystemLog;
import uril.DBConnect;

public class SystemLogDAO {

    // Ghi nhật ký vào DB
    public static void insertLog(int maNguoiDung, String hanhDong, String bangTacDong, String diaChiIP) {
        String sql = "INSERT INTO SystemLog (MaNguoiDung, HanhDong, BangTacDong, ThoiGian, DiaChiIP) VALUES (?, ?, ?, GETDATE(), ?)";
        try (Connection con = DBConnect.getConnection(); PreparedStatement ps = con.prepareStatement(sql)) {
            ps.setInt(1, maNguoiDung);
            ps.setString(2, hanhDong);
            ps.setString(3, bangTacDong);
            ps.setString(4, diaChiIP);
            ps.executeUpdate();
        } catch (Exception e) {
            e.printStackTrace();
        }
    }

    // Lấy danh sách nhật ký
    public List<SystemLog> getAllLogs() {
        List<SystemLog> list = new ArrayList<>();
        String sql = "SELECT * FROM SystemLog ORDER BY ThoiGian DESC";
        try (Connection con = DBConnect.getConnection(); PreparedStatement ps = con.prepareStatement(sql)) {
            ResultSet rs = ps.executeQuery();
            while (rs.next()) {
                list.add(new SystemLog(
                        rs.getInt("MaNhatKy"),
                        rs.getInt("MaNguoiDung"),
                        rs.getString("HanhDong"),
                        rs.getString("BangTacDong"),
                        rs.getTimestamp("ThoiGian").toLocalDateTime(),
                        rs.getString("DiaChiIP")
                ));
            }
        } catch (Exception e) {
            e.printStackTrace();
        }
        return list;
    }
}