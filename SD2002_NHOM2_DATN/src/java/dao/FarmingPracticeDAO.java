package dao;

import java.sql.Connection;
import java.sql.PreparedStatement;
import java.sql.ResultSet;
import java.sql.Date;
import java.time.LocalDate;
import java.util.ArrayList;
import java.util.List;
import models.FarmingPractice;
import models.FarmingStage;
import models.User;
import uril.DBConnect;

public class FarmingPracticeDAO {
        List<User> worker = new ArrayList<>();

    public List<FarmingPractice> getAllFarmingPractices() {
        List<FarmingPractice> list = new ArrayList<>();
        String sql = "SELECT * FROM FarmingPractice";

        try (Connection conn = DBConnect.getConnection(); PreparedStatement ps = conn.prepareStatement(sql); ResultSet rs = ps.executeQuery()) {

            while (rs.next()) {
                FarmingPractice fp = new FarmingPractice();
                fp.setMaQuyTrinh(rs.getInt("MaQuyTrinh"));
                fp.setTenQuyTrinh(rs.getString("TenQuyTrinh"));
                fp.setMoTa(rs.getString("MoTa"));
                fp.setLoaiApDung(rs.getString("LoaiApDung"));

                Date sqlDate = rs.getDate("NgayTao");
                if (sqlDate != null) {
                    fp.setNgayTao(sqlDate.toLocalDate());
                }

                fp.setNguoiTao(rs.getInt("NguoiTao"));
                fp.setTrangThai(rs.getBoolean("TrangThai"));
                list.add(fp);
            }
        } catch (Exception e) {
            e.printStackTrace();
        }
        return list;
    }

    // === HÀM TÌM KIẾM ĐÃ NÂNG CẤP ===
    public List<FarmingPractice> searchFarmingPractices(String keyword) {
        List<FarmingPractice> list = new ArrayList<>();
        // Bổ sung thêm CAST(MaQuyTrinh AS VARCHAR) để tìm được cả ID
        String sql = "SELECT * FROM FarmingPractice WHERE TenQuyTrinh LIKE ? OR LoaiApDung LIKE ? OR CAST(MaQuyTrinh AS VARCHAR) LIKE ?";

        try (Connection conn = DBConnect.getConnection(); PreparedStatement ps = conn.prepareStatement(sql)) {

            ps.setString(1, "%" + keyword + "%");
            ps.setString(2, "%" + keyword + "%");
            ps.setString(3, "%" + keyword + "%"); // Dành cho ID

            try (ResultSet rs = ps.executeQuery()) {
                while (rs.next()) {
                    FarmingPractice fp = new FarmingPractice();
                    fp.setMaQuyTrinh(rs.getInt("MaQuyTrinh"));
                    fp.setTenQuyTrinh(rs.getString("TenQuyTrinh"));
                    fp.setMoTa(rs.getString("MoTa"));
                    fp.setLoaiApDung(rs.getString("LoaiApDung"));
                    Date sqlDate = rs.getDate("NgayTao");
                    if (sqlDate != null) {
                        fp.setNgayTao(sqlDate.toLocalDate());
                    }
                    fp.setNguoiTao(rs.getInt("NguoiTao"));
                    fp.setTrangThai(rs.getBoolean("TrangThai"));
                    list.add(fp);
                }
            }
        } catch (Exception e) {
            e.printStackTrace();
        }
        return list;
    }

    public boolean insertFarmingPractice(FarmingPractice fp) {
        String sql = "INSERT INTO FarmingPractice (TenQuyTrinh, MoTa, LoaiApDung, NgayTao, NguoiTao, TrangThai) VALUES (?, ?, ?, ?, ?, ?)";

        try (Connection conn = DBConnect.getConnection(); PreparedStatement ps = conn.prepareStatement(sql)) {

            ps.setString(1, fp.getTenQuyTrinh());
            ps.setString(2, fp.getMoTa());
            ps.setString(3, fp.getLoaiApDung());

            LocalDate ngayTao = fp.getNgayTao() != null ? fp.getNgayTao() : LocalDate.now();
            ps.setDate(4, Date.valueOf(ngayTao));

            ps.setInt(5, fp.getNguoiTao());
            ps.setBoolean(6, false); // Mặc định là bản nháp

            int rowAffected = ps.executeUpdate();
            return rowAffected > 0;
        } catch (Exception e) {
            e.printStackTrace();
        }
        return false;
    }

    public boolean deleteFarmingPractice(int maQuyTrinh) {
        String sql = "DELETE FROM FarmingPractice WHERE MaQuyTrinh = ?";
        try (Connection conn = DBConnect.getConnection(); PreparedStatement ps = conn.prepareStatement(sql)) {
            ps.setInt(1, maQuyTrinh);
            return ps.executeUpdate() > 0;
        } catch (Exception e) {
            e.printStackTrace();
        }
        return false;
    }

    public boolean updateFarmingPractice(int id, String tenQuyTrinh, String moTa, String loaiApDung, String trangThai) {
        String sql = "UPDATE FarmingPractice SET TenQuyTrinh = ?, MoTa = ?, LoaiApDung = ?, TrangThai = ? WHERE MaQuyTrinh = ?";
        try (Connection conn = DBConnect.getConnection(); PreparedStatement ps = conn.prepareStatement(sql)) {
            ps.setString(1, tenQuyTrinh);
            ps.setString(2, moTa);
            ps.setString(3, loaiApDung);
            // Đã fix lỗi kiểu dữ liệu String -> Boolean ở đây
            ps.setBoolean(4, Boolean.parseBoolean(trangThai));
            ps.setInt(5, id);
            return ps.executeUpdate() > 0;
        } catch (Exception e) {
            e.printStackTrace();
        }
        return false;
    }

    // Hàm chuyển trạng thái Quy trình sang Ban hành
    public boolean publishPractice(int practiceId) {
        String sql = "UPDATE farming_practice SET status = ? WHERE id = ?";
        try (Connection conn = DBConnect.getConnection(); PreparedStatement ps = conn.prepareStatement(sql)) {
            ps.setString(1, "Ban hành");
            ps.setInt(2, practiceId);
            return ps.executeUpdate() > 0;
        } catch (Exception e) {
        }
        return false;
    }

    public List<User> WorkerList() {
        worker.clear();
        String sql = "  Select us.MaNguoiDung, us.MaNhom, st.HoTen from [User] us join Staff st on us.MaNguoiDung = st.MaNguoiDung where us.MaNhom=6";
        try (Connection con = DBConnect.getConnection();
            PreparedStatement pstmt = con.prepareStatement(sql)){
            ResultSet rs = pstmt.executeQuery();
            while (rs.next()) {
                int MaNguoiDung = rs.getInt("MaNguoiDung");
                int MaNhom = rs.getInt("MaNhom");
                String HoTen = rs.getString("HoTen");
                worker.add(new User(MaNguoiDung, MaNhom, HoTen));
            }
        } catch (Exception e) {
        }
        return worker;
    }
    
    // Khớp với cấu trúc bảng FarmingStage mới nhất:
    // ID (identity), MaQuyTrinh (FK), stageName, startDay, endDay, MaVatTu (FK int), dinhLuong, donVi, moTa
    public boolean saveFarmingStage(int maQuyTrinh, String stageName, Date startDay, Date endDay, int maVatTu, double dinhLuong, String donVi, String moTa) {
        String sql = "INSERT INTO FarmingStage (MaQuyTrinh, stageName, startDay, endDay, MaVatTu, dinhLuong, donVi, moTa) VALUES (?, ?, ?, ?, ?, ?, ?, ?)";
        try (Connection conn = DBConnect.getConnection(); PreparedStatement ps = conn.prepareStatement(sql)) {
            ps.setInt(1, maQuyTrinh);
            ps.setString(2, stageName);
            ps.setDate(3, startDay);
            ps.setDate(4, endDay);
            ps.setInt(5, maVatTu);
            ps.setDouble(6, dinhLuong);
            ps.setString(7, donVi);
            ps.setString(8, moTa);
            return ps.executeUpdate() > 0;
        } catch (Exception e) {
            e.printStackTrace();
        }
        return false;
    }

    public void publishProcess(int farmingPracticeId) {
        String sql = "UPDATE FarmingPractice SET TrangThai = 1 WHERE MaQuyTrinh = ?";
        try (Connection conn = DBConnect.getConnection(); PreparedStatement ps = conn.prepareStatement(sql)) {
            ps.setInt(1, farmingPracticeId);
            ps.executeUpdate();
        } catch (Exception e) {
            e.printStackTrace();
        }
    }
}