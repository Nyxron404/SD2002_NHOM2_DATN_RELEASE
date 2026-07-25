package dao;

import java.sql.*;
import java.time.Duration;
import java.time.LocalDateTime;
import java.util.ArrayList;
import java.util.List;
import models.BorrowEquipment;
import uril.DBConnect;

/**
 * DAO thao tác bảng dbo.BorrowEquipment
 * UC-5.3: Ghi nhận lịch sử sử dụng thiết bị
 */
public class BorrowDAO {

    public static final String TT_DANG_SU_DUNG = "Đang sử dụng";
    public static final String TT_DA_TRA = "Đã trả";

    // UC-5.3 B1, B2: Lập phiếu sử dụng mới + ghi nhận thời điểm bắt đầu
    // Trả về MaMuonThietBi vừa tạo (0 nếu lỗi)
    public int createBorrowRecord(BorrowEquipment be) {
        String sql = "INSERT INTO BorrowEquipment (MaThietBi, MaNhanVien, MaKhuVuc, ThoiGianBatDau, "
                + "TinhTrangTruocKhiDung, TrangThai) VALUES (?, ?, ?, ?, ?, ?)";
        try (Connection con = DBConnect.getConnection();
                PreparedStatement ps = con.prepareStatement(sql, Statement.RETURN_GENERATED_KEYS)) {
            ps.setInt(1, be.getMaThietBi());
            ps.setInt(2, be.getMaNhanVien());
            ps.setInt(3, be.getMaKhuVuc());
            ps.setTimestamp(4, Timestamp.valueOf(LocalDateTime.now()));
            ps.setString(5, be.getTinhTrangTruocKhiDung());
            ps.setString(6, TT_DANG_SU_DUNG);

            int rows = ps.executeUpdate();
            if (rows > 0) {
                ResultSet rs = ps.getGeneratedKeys();
                if (rs.next()) {
                    return rs.getInt(1);
                }
            }
        } catch (Exception e) {
            e.printStackTrace();
        }
        return 0;
    }

    // UC-5.3 B3, B4: Xác nhận trả thiết bị, ghi nhận tình trạng sau dùng
    // và tính tổng thời gian sử dụng (đơn vị: giờ)
    public boolean returnEquipment(int maMuonThietBi, String tinhTrangSauKhiDung, String ghiChu) {
        BorrowEquipment be = getById(maMuonThietBi);
        if (be == null || be.getThoiGianBatDau() == null) {
            return false;
        }

        LocalDateTime ketThuc = LocalDateTime.now();
        double tongGio = Duration.between(be.getThoiGianBatDau(), ketThuc).toMinutes() / 60.0;

        String sql = "UPDATE BorrowEquipment SET ThoiGianKetThuc = ?, TinhTrangSauKhiDung = ?, "
                + "TongThoiGianSuDung = ?, GhiChu = ?, TrangThai = ? WHERE MaMuonThietBi = ?";
        try (Connection con = DBConnect.getConnection(); PreparedStatement ps = con.prepareStatement(sql)) {
            ps.setTimestamp(1, Timestamp.valueOf(ketThuc));
            ps.setString(2, tinhTrangSauKhiDung);
            ps.setDouble(3, tongGio);
            ps.setString(4, ghiChu);
            ps.setString(5, TT_DA_TRA);
            ps.setInt(6, maMuonThietBi);
            return ps.executeUpdate() > 0;
        } catch (Exception e) {
            e.printStackTrace();
        }
        return false;
    }

    // Lấy phiếu mượn theo mã
    public BorrowEquipment getById(int maMuonThietBi) {
        String sql = "SELECT * FROM BorrowEquipment WHERE MaMuonThietBi = ?";
        try (Connection con = DBConnect.getConnection(); PreparedStatement ps = con.prepareStatement(sql)) {
            ps.setInt(1, maMuonThietBi);
            ResultSet rs = ps.executeQuery();
            if (rs.next()) {
                return mapRow(rs);
            }
        } catch (Exception e) {
            e.printStackTrace();
        }
        return null;
    }

    // Kiểm tra thiết bị có đang được mượn (chưa trả) hay không
    public BorrowEquipment getActiveBorrowByEquipment(int maThietBi) {
        String sql = "SELECT * FROM BorrowEquipment WHERE MaThietBi = ? AND TrangThai = ?";
        try (Connection con = DBConnect.getConnection(); PreparedStatement ps = con.prepareStatement(sql)) {
            ps.setInt(1, maThietBi);
            ps.setString(2, TT_DANG_SU_DUNG);
            ResultSet rs = ps.executeQuery();
            if (rs.next()) {
                return mapRow(rs);
            }
        } catch (Exception e) {
            e.printStackTrace();
        }
        return null;
    }

    // Lịch sử sử dụng của 1 thiết bị (kèm tên nhân viên, tên khu vực) - phục vụ UC-5.3 Lưu ý
    public List<BorrowEquipment> getHistoryByEquipment(int maThietBi) {
        List<BorrowEquipment> list = new ArrayList<>();
        String sql = "SELECT b.*, s.HoTen AS HoTenNhanVien, f.TenKhuVuc "
                + "FROM BorrowEquipment b "
                + "LEFT JOIN Staff s ON b.MaNhanVien = s.MaNhanVien "
                + "LEFT JOIN FarmArea f ON b.MaKhuVuc = f.MaKhuVuc "
                + "WHERE b.MaThietBi = ? ORDER BY b.ThoiGianBatDau DESC";
        try (Connection con = DBConnect.getConnection(); PreparedStatement ps = con.prepareStatement(sql)) {
            ps.setInt(1, maThietBi);
            ResultSet rs = ps.executeQuery();
            while (rs.next()) {
                BorrowEquipment be = mapRow(rs);
                be.setHoTenNhanVien(rs.getString("HoTenNhanVien"));
                be.setTenKhuVuc(rs.getString("TenKhuVuc"));
                list.add(be);
            }
        } catch (Exception e) {
            e.printStackTrace();
        }
        return list;
    }

    // Toàn bộ lịch sử sử dụng (kèm tên thiết bị) - dùng cho màn hình danh sách chung
    public List<BorrowEquipment> getAllHistory() {
        List<BorrowEquipment> list = new ArrayList<>();
        String sql = "SELECT b.*, e.TenThietBi, s.HoTen AS HoTenNhanVien, f.TenKhuVuc "
                + "FROM BorrowEquipment b "
                + "LEFT JOIN Equipment e ON b.MaThietBi = e.MaThietBi "
                + "LEFT JOIN Staff s ON b.MaNhanVien = s.MaNhanVien "
                + "LEFT JOIN FarmArea f ON b.MaKhuVuc = f.MaKhuVuc "
                + "ORDER BY b.ThoiGianBatDau DESC";
        try (Connection con = DBConnect.getConnection(); PreparedStatement ps = con.prepareStatement(sql)) {
            ResultSet rs = ps.executeQuery();
            while (rs.next()) {
                BorrowEquipment be = mapRow(rs);
                be.setTenThietBi(rs.getString("TenThietBi"));
                be.setHoTenNhanVien(rs.getString("HoTenNhanVien"));
                be.setTenKhuVuc(rs.getString("TenKhuVuc"));
                list.add(be);
            }
        } catch (Exception e) {
            e.printStackTrace();
        }
        return list;
    }

    private BorrowEquipment mapRow(ResultSet rs) throws SQLException {
        Timestamp batDau = rs.getTimestamp("ThoiGianBatDau");
        Timestamp ketThuc = rs.getTimestamp("ThoiGianKetThuc");
        return new BorrowEquipment(
                rs.getInt("MaMuonThietBi"),
                rs.getInt("MaThietBi"),
                rs.getInt("MaNhanVien"),
                rs.getInt("MaKhuVuc"),
                batDau != null ? batDau.toLocalDateTime() : null,
                ketThuc != null ? ketThuc.toLocalDateTime() : null,
                rs.getString("TinhTrangTruocKhiDung"),
                rs.getString("TinhTrangSauKhiDung"),
                rs.getDouble("TongThoiGianSuDung"),
                rs.getString("GhiChu"),
                rs.getString("TrangThai")
        );
    }
}