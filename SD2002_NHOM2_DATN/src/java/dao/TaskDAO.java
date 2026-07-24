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
        String sql = "SELECT * FROM Task ORDER BY MaCongViec DESC";
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
    
    // Cập nhật trạng thái Task (dùng chung, ví dụ: hủy việc -> "Đã hủy")
    public boolean updateTaskStatus(int maCongViec, String trangThai) {
        String sql = "UPDATE Task SET TrangThai = ? WHERE MaCongViec = ?";
        try (Connection con = DBConnect.getConnection(); PreparedStatement ps = con.prepareStatement(sql)) {
            ps.setString(1, trangThai);
            ps.setInt(2, maCongViec);
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
    
    // Lấy danh sách công việc của riêng 1 người phụ trách (dùng cho giao diện Công nhân)
    public List<Task> getTasksByUser(int nguoiPhuTrach) {
        List<Task> list = new ArrayList<>();
        String sql = "SELECT * FROM Task WHERE NguoiPhuTrach = ? ORDER BY MaCongViec DESC";
        try (Connection con = DBConnect.getConnection(); PreparedStatement ps = con.prepareStatement(sql)) {
            ps.setInt(1, nguoiPhuTrach);
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

    // Hàm tìm kiếm công việc theo Tên, Mã công việc, hoặc Người Phụ Trách
    public List<Task> searchTasks(String keyword) {
        List<Task> list = new ArrayList<>();
        // Tìm kiếm theo Tên công việc hoặc ép kiểu Mã công việc, Người Phụ Trách sang chuỗi để tìm
        String sql = "SELECT * FROM Task WHERE TenCongViec LIKE ? OR CAST(MaCongViec AS VARCHAR) LIKE ? OR CAST(NguoiPhuTrach AS VARCHAR) LIKE ? ORDER BY MaCongViec DESC";
        
        try (Connection con = DBConnect.getConnection(); PreparedStatement ps = con.prepareStatement(sql)) {
            String query = "%" + keyword + "%";
            ps.setString(1, query);
            ps.setString(2, query);
            ps.setString(3, query); // Thêm tham số thứ 3
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
    
    // Dành cho Admin: Lọc công việc theo khoảng thời gian hạn chót
    public List<Task> getTasksByDateRange(LocalDate fromDate, LocalDate toDate) {
        List<Task> list = new ArrayList<>();
        String sql = "SELECT * FROM Task WHERE NgayKetThuc >= ? AND NgayKetThuc <= ? ORDER BY MaCongViec DESC";
        try (Connection con = DBConnect.getConnection(); PreparedStatement ps = con.prepareStatement(sql)) {
            ps.setDate(1, java.sql.Date.valueOf(fromDate));
            ps.setDate(2, java.sql.Date.valueOf(toDate));
            ResultSet rs = ps.executeQuery();
            while (rs.next()) {
                list.add(new Task(
                    rs.getInt("MaCongViec"),
                    rs.getString("TenCongViec"),
                    rs.getString("MoTa"),
                    rs.getInt("MaQuyTrinh"),
                    rs.getInt("MaKhuVuc"),
                    rs.getInt("NguoiPhuTrach"),
                    rs.getObject("NgayBatDau", LocalDate.class),
                    rs.getObject("NgayKetThuc", LocalDate.class),
                    rs.getString("TrangThai")
                ));
            }
        } catch (Exception e) {
            e.printStackTrace();
        }
        return list;
    }

    // Dành cho Công nhân: Lấy công việc của riêng họ theo khoảng thời gian hạn chót
    public List<Task> getTasksByUserAndDateRange(int maNguoiDung, LocalDate fromDate, LocalDate toDate) {
        List<Task> list = new ArrayList<>();
        String sql = "SELECT * FROM Task WHERE NguoiPhuTrach = ? AND NgayKetThuc >= ? AND NgayKetThuc <= ? ORDER BY MaCongViec DESC";
        try (Connection con = DBConnect.getConnection(); PreparedStatement ps = con.prepareStatement(sql)) {
            ps.setInt(1, maNguoiDung);
            ps.setDate(2, java.sql.Date.valueOf(fromDate));
            ps.setDate(3, java.sql.Date.valueOf(toDate));
            ResultSet rs = ps.executeQuery();
            while (rs.next()) {
                list.add(new Task(
                    rs.getInt("MaCongViec"),
                    rs.getString("TenCongViec"),
                    rs.getString("MoTa"),
                    rs.getInt("MaQuyTrinh"),
                    rs.getInt("MaKhuVuc"),
                    rs.getInt("NguoiPhuTrach"),
                    rs.getObject("NgayBatDau", LocalDate.class),
                    rs.getObject("NgayKetThuc", LocalDate.class),
                    rs.getString("TrangThai")
                ));
            }
        } catch (Exception e) {
            e.printStackTrace();
        }
        return list;
    }
}