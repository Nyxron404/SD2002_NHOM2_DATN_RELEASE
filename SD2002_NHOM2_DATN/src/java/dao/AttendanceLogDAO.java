package dao;

import java.sql.*;
import java.time.LocalDate;
import java.util.ArrayList;
import java.util.List;
import models.AttendanceLog;
import uril.DBConnect;

public class AttendanceLogDAO {

    public void autoCalculateAttendance() {
        String scanSql = "SELECT t.MaCongViec, t.NguoiPhuTrach, c.HeSoCong "
                + "FROM Task t INNER JOIN WorkEfficiencyConfig c ON t.MaQuyTrinh = c.MaQuyTrinh "
                + "WHERE t.TrangThai = N'Hoàn thành' AND t.MaCongViec NOT IN (SELECT MaCongViec FROM AttendanceLog)";

        String insertSql = "INSERT INTO AttendanceLog (MaNguoiDung, MaCongViec, NgayTíchLuy, SoCongTichLuy, TrangThaiDuyet) VALUES (?, ?, GETDATE(), ?, 0)";

        try (Connection con = DBConnect.getConnection(); PreparedStatement psScan = con.prepareStatement(scanSql); PreparedStatement psInsert = con.prepareStatement(insertSql)) {

            ResultSet rs = psScan.executeQuery();
            while (rs.next()) {
                psInsert.setInt(1, rs.getInt("NguoiPhuTrach"));
                psInsert.setInt(2, rs.getInt("MaCongViec"));
                psInsert.setDouble(3, rs.getDouble("HeSoCong"));
                psInsert.addBatch();
            }
            psInsert.executeBatch();
        } catch (Exception e) {
            e.printStackTrace();
        }
    }

    public List<AttendanceLog> getAttendanceByUser(int maNguoiDung) {
        List<AttendanceLog> list = new ArrayList<>();
        String sql = "SELECT * FROM AttendanceLog WHERE MaNguoiDung = ? ORDER BY NgayTíchLuy DESC";
        try (Connection con = DBConnect.getConnection(); PreparedStatement ps = con.prepareStatement(sql)) {
            ps.setInt(1, maNguoiDung);
            ResultSet rs = ps.executeQuery();
            while (rs.next()) {
                list.add(new AttendanceLog(
                        rs.getInt("MaChamCong"),
                        rs.getInt("MaNguoiDung"),
                        rs.getInt("MaCongViec"),
                        rs.getObject("NgayTíchLuy", LocalDate.class),
                        rs.getDouble("SoCongTichLuy"),
                        rs.getBoolean("TrangThaiDuyet")
                ));
            }
        } catch (Exception e) {
            e.printStackTrace();
        }
        return list;
    }
    
    public List<AttendanceLog> getAttendance() {
        List<AttendanceLog> list = new ArrayList<>();
        String sql = "SELECT * FROM AttendanceLog"; 
        try (Connection con = DBConnect.getConnection(); 
            PreparedStatement ps = con.prepareStatement(sql)) {
            ResultSet rs = ps.executeQuery();
            while (rs.next()) {
                list.add(new AttendanceLog(
                        rs.getInt("MaChamCong"),
                        rs.getInt("MaNguoiDung"),
                        rs.getInt("MaCongViec"),
                        rs.getObject("NgayTíchLuy", LocalDate.class),
                        rs.getDouble("SoCongTichLuy"),
                        rs.getBoolean("TrangThaiDuyet")
                ));
            }
        } catch (Exception e) {
            e.printStackTrace();
        }
        return list;
    }
    
    public boolean approveSalary(int maChamCong) {
        String sql = "UPDATE AttendanceLog SET TrangThaiDuyet = 1 WHERE MaChamCong = ?";
        try (Connection con = DBConnect.getConnection(); PreparedStatement ps = con.prepareStatement(sql)) {
            ps.setInt(1, maChamCong);
            return ps.executeUpdate() > 0;
        } catch (Exception e) {
            e.printStackTrace();
        }
        return false;
    }
    
    // Hàm mới: Tìm kiếm ngày công dựa trên một danh sách Mã Công Việc
    public List<AttendanceLog> searchAttendanceByTaskIds(List<Integer> taskIds) {
        List<AttendanceLog> list = new ArrayList<>();
        
        // Nếu không có mã công việc nào được truyền vào, trả về rỗng luôn
        if (taskIds == null || taskIds.isEmpty()) {
            return list;
        }

        // Tạo chuỗi các dấu hỏi chấm (?, ?, ?) tùy theo số lượng mã công việc
        StringBuilder placeholders = new StringBuilder();
        for (int i = 0; i < taskIds.size(); i++) {
            placeholders.append("?");
            if (i < taskIds.size() - 1) {
                placeholders.append(",");
            }
        }

        // Lọc bảng AttendanceLog xem có MaCongViec nào nằm trong danh sách không
        String sql = "SELECT * FROM AttendanceLog WHERE MaCongViec IN (" + placeholders.toString() + ")";
        
        try (Connection con = DBConnect.getConnection(); PreparedStatement ps = con.prepareStatement(sql)) {
            // Set giá trị cho các dấu hỏi chấm
            for (int i = 0; i < taskIds.size(); i++) {
                ps.setInt(i + 1, taskIds.get(i));
            }
            
            ResultSet rs = ps.executeQuery();
            while (rs.next()) {
                list.add(new AttendanceLog(
                        rs.getInt("MaChamCong"),
                        rs.getInt("MaNguoiDung"),
                        rs.getInt("MaCongViec"),
                        rs.getObject("NgayTíchLuy", LocalDate.class),
                        rs.getDouble("SoCongTichLuy"),
                        rs.getBoolean("TrangThaiDuyet")
                ));
            }
        } catch (Exception e) {
            e.printStackTrace();
        }
        return list;
    }
}
