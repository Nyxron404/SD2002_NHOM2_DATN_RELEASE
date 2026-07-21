package dao;

import java.sql.*;
import java.time.LocalDate;
import java.util.ArrayList;
import java.util.List;
import models.Task;
import uril.DBConnect;

public class TaskDAO {

    // Lấy danh sách tất cả công việc
    public List<Task> getAllTasks() {
        List<Task> list = new ArrayList<>();
        String sql = "SELECT * FROM Task";
        try (Connection con = DBConnect.getConnection(); PreparedStatement ps = con.prepareStatement(sql)) {
            ResultSet rs = ps.executeQuery();
            while (rs.next()) {
                Task t = new Task(
                    rs.getInt("MaCongViec"),
                    rs.getString("TenCongViec"),
                    rs.getString("MoTa"),
                    rs.getInt("MaQuyTrinh"),
                    rs.getInt("MaKhuVuc"),
                    rs.getInt("NguoiPhuTrach"),
                    rs.getObject("NgayBatDau", LocalDate.class),
                    rs.getObject("NgayKetThuc", LocalDate.class),
                    rs.getString("TrangThai")
                );
                list.add(t);
            }
        } catch (Exception e) {
            e.printStackTrace();
        }
        return list;
    }

    // Thêm mới một công việc và trả về MaCongViec vừa tạo
    public int insertTaskAndGetId(Task task) {
        String sql = "INSERT INTO Task (TenCongViec, MoTa, MaQuyTrinh, MaKhuVuc, NguoiPhuTrach, NgayBatDau, NgayKetThuc, TrangThai) VALUES (?, ?, ?, ?, ?, ?, ?, ?)";
        // Thêm Statement.RETURN_GENERATED_KEYS
        try (Connection con = DBConnect.getConnection(); PreparedStatement ps = con.prepareStatement(sql, Statement.RETURN_GENERATED_KEYS)) {
            ps.setString(1, task.getTenCongViec());
            ps.setString(2, task.getMoTa());
            ps.setInt(3, task.getMaQuyTrinh());
            ps.setInt(4, task.getMaKhuVuc());
            ps.setInt(5, task.getNguoiPhuTrach());
            ps.setDate(6, java.sql.Date.valueOf(task.getNgayBatDau()));
            ps.setDate(7, java.sql.Date.valueOf(task.getNgayKetThuc()));
            ps.setString(8, "Chưa thực hiện"); 

            int rows = ps.executeUpdate();
            if (rows > 0) {
                ResultSet rs = ps.getGeneratedKeys();
                if (rs.next()) {
                    return rs.getInt(1); // Trả về MaCongViec mới tạo
                }
            }
        } catch (Exception e) {
            e.printStackTrace();
        }
        return 0; // Trả về 0 nếu lỗi
    }
    
    // UC-9.1: Công nhân báo cáo hoàn thành nhiệm vụ và lưu chuỗi ảnh/ghi chú gọn gàng
    public boolean submitTaskReport(int maCongViec, String ghiChuVatTu, String anhHienTruong) {
        // Cập nhật mô tả kèm ghi chú vật tư thực tế và chuỗi văn bản ảnh trực tiếp vào Task
        String sql = "UPDATE Task SET MoTa = CONCAT(MoTa, ?, ?), TrangThai = N'Hoàn thành' WHERE MaCongViec = ?";
        try (Connection con = DBConnect.getConnection(); PreparedStatement ps = con.prepareStatement(sql)) {
            ps.setString(1, " | Ghi chú vật tư: " + ghiChuVatTu);
            ps.setString(2, " | Ảnh văn bản: " + anhHienTruong);
            ps.setInt(3, maCongViec);
            return ps.executeUpdate() > 0;
        } catch (Exception e) {
            e.printStackTrace();
        }
        return false;
    }
    
    // Đếm số công nhân đang có nhiệm vụ chưa hoàn thành (Dành cho Dashboard)
    public int getActiveWorkersCount() {
        String sql = "SELECT COUNT(DISTINCT NguoiPhuTrach) FROM Task WHERE TrangThai != N'Hoàn thành'";
        try (Connection con = DBConnect.getConnection(); PreparedStatement ps = con.prepareStatement(sql)) {
            ResultSet rs = ps.executeQuery();
            if (rs.next()) return rs.getInt(1);
        } catch (Exception e) { e.printStackTrace(); }
        return 0;
    }

    public List<models.Staff> getWorkers() {
        List<models.Staff> list = new ArrayList<>();
        
        String sql = "SELECT u.MaNguoiDung, s.HoTen " +
                     "FROM [User] u " +
                     "INNER JOIN Staff s ON u.MaNguoiDung = s.MaNguoiDung " +
                     "WHERE u.MaNhom = 6"; 
                     
        try (Connection con = DBConnect.getConnection(); PreparedStatement ps = con.prepareStatement(sql)) {
            ResultSet rs = ps.executeQuery();
            while (rs.next()) {
                models.Staff st = new models.Staff();
                st.setMaNguoiDung(rs.getInt("MaNguoiDung"));
                st.setHoTen(rs.getString("HoTen"));
                list.add(st);
            }
        } catch (Exception e) { 
            e.printStackTrace(); 
        }
        return list;
    }
}