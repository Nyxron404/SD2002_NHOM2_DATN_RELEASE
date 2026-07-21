package dao;

import java.sql.*;
import java.time.LocalDateTime;
import java.util.ArrayList;
import java.util.List;
import models.AssignmentTask;
import uril.DBConnect;

public class AssignmentTaskDAO {

    // Lấy danh sách toàn bộ các phân công
    public List<AssignmentTask> getAllAssignments() {
        List<AssignmentTask> list = new ArrayList<>();
        String sql = "SELECT * FROM AssignmentTask";
        
        try (Connection con = DBConnect.getConnection(); PreparedStatement ps = con.prepareStatement(sql)) {
            ResultSet rs = ps.executeQuery();
            while (rs.next()) {
                AssignmentTask at = new AssignmentTask(
                        rs.getInt("MaPhanCong"),
                        rs.getInt("MaCongViec"),
                        rs.getInt("MaNguoiDung"),
                        rs.getObject("NgayPhanCong", LocalDateTime.class),
                        rs.getString("TrangThai")
                );
                list.add(at);
            }
        } catch (Exception e) {
            e.printStackTrace();
        }
        return list;
    }

    public boolean insertAssignmentTask(AssignmentTask at) {
        String sql = "INSERT INTO AssignmentTask (MaCongViec, MaNguoiDung, NgayPhanCong, TrangThai) VALUES (?, ?, ?, ?)";
        
        try (Connection con = DBConnect.getConnection(); PreparedStatement ps = con.prepareStatement(sql)) {
            ps.setInt(1, at.getMaCongViec());
            ps.setInt(2, at.getMaNguoiDung());
            ps.setTimestamp(3, Timestamp.valueOf(at.getNgayPhanCong()));
            ps.setString(4, at.getTrangThai());

            return ps.executeUpdate() > 0;
        } catch (Exception e) {
            e.printStackTrace();
        }
        return false;
    }
    
    // Thêm hàm cập nhật trạng thái phân công
    public boolean updateAssignmentStatus(int maCongViec, String trangThai) {
        String sql = "UPDATE AssignmentTask SET TrangThai = ? WHERE MaCongViec = ?";
        try (Connection con = DBConnect.getConnection(); PreparedStatement ps = con.prepareStatement(sql)) {
            ps.setString(1, trangThai);
            ps.setInt(2, maCongViec);
            return ps.executeUpdate() > 0;
        } catch (Exception e) {
            e.printStackTrace();
        }
        return false;
    }
}