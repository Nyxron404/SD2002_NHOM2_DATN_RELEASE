package dao;

import java.sql.*;
import java.time.LocalDate;
import java.util.ArrayList;
import java.util.List;
import models.Equipment;
import uril.DBConnect;

/**
 * DAO thao tác bảng dbo.Equipment
 * UC-5.1: Thêm mới thiết bị, dụng cụ
 * UC-5.2: Cập nhật tình trạng thiết bị
 */
public class EquipmentDAO {

    // Các trạng thái chặn không cho mượn (UC-5.2 - Lưu ý)
    public static final String TT_SAN_SANG = "Sẵn sàng";
    public static final String TT_DANG_SU_DUNG = "Đang sử dụng";
    public static final String TT_BAO_TRI = "Bảo trì";
    public static final String TT_HONG = "Hỏng";

    // Lấy toàn bộ danh sách thiết bị
    public List<Equipment> getAllEquipment() {
        List<Equipment> list = new ArrayList<>();
        String sql = "SELECT * FROM Equipment ORDER BY MaThietBi DESC";
        try (Connection con = DBConnect.getConnection(); PreparedStatement ps = con.prepareStatement(sql)) {
            ResultSet rs = ps.executeQuery();
            while (rs.next()) {
                list.add(mapRow(rs));
            }
        } catch (Exception e) {
            e.printStackTrace();
        }
        return list;
    }

    // Lấy 1 thiết bị theo mã (dùng khi cập nhật trạng thái, kiểm tra trước khi mượn...)
    public Equipment getEquipmentById(int maThietBi) {
        String sql = "SELECT * FROM Equipment WHERE MaThietBi = ?";
        try (Connection con = DBConnect.getConnection(); PreparedStatement ps = con.prepareStatement(sql)) {
            ps.setInt(1, maThietBi);
            ResultSet rs = ps.executeQuery();
            if (rs.next()) {
                return mapRow(rs);
            }
        } catch (Exception e) {
            e.printStackTrace();
        }
        return null;
    }

    // UC-5.1 B3, B4: Thêm mới thiết bị, trả về MaThietBi vừa tạo (0 nếu lỗi)
    public int insertEquipment(Equipment eq) {
        String sql = "INSERT INTO Equipment (TenThietBi, LoaiThietBi, NgayMua, GiaTri, TinhTrang, MoTa, ChuKyBaoTriThang) "
                + "VALUES (?, ?, ?, ?, ?, ?, ?)";
        try (Connection con = DBConnect.getConnection();
                PreparedStatement ps = con.prepareStatement(sql, Statement.RETURN_GENERATED_KEYS)) {
            ps.setString(1, eq.getTenThietBi());
            ps.setString(2, eq.getLoaiThietBi());
            ps.setDate(3, java.sql.Date.valueOf(eq.getNgayMua()));
            ps.setDouble(4, eq.getGiaTri());
            ps.setString(5, eq.getTinhTrang());
            ps.setString(6, eq.getMoTa());
            ps.setInt(7, eq.getChuKyBaoTriThang());

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

    // UC-5.1: Kiểm tra trùng tên thiết bị (hợp lệ dữ liệu trước khi lưu)
    public boolean checkTenThietBiExists(String tenThietBi) {
        String sql = "SELECT 1 FROM Equipment WHERE TenThietBi = ?";
        try (Connection con = DBConnect.getConnection(); PreparedStatement ps = con.prepareStatement(sql)) {
            ps.setString(1, tenThietBi);
            ResultSet rs = ps.executeQuery();
            return rs.next();
        } catch (Exception e) {
            e.printStackTrace();
        }
        return false;
    }

    // UC-5.2 B3, B4: Cập nhật trạng thái thiết bị (Sẵn sàng / Đang sử dụng / Bảo trì / Hỏng)
    public boolean updateEquipmentStatus(int maThietBi, String tinhTrangMoi) {
        String sql = "UPDATE Equipment SET TinhTrang = ? WHERE MaThietBi = ?";
        try (Connection con = DBConnect.getConnection(); PreparedStatement ps = con.prepareStatement(sql)) {
            ps.setString(1, tinhTrangMoi);
            ps.setInt(2, maThietBi);
            return ps.executeUpdate() > 0;
        } catch (Exception e) {
            e.printStackTrace();
        }
        return false;
    }

    // Cập nhật đầy đủ thông tin thiết bị (không đổi trạng thái - dùng khi sửa thông tin chung)
    public boolean updateEquipment(Equipment eq) {
        String sql = "UPDATE Equipment SET TenThietBi=?, LoaiThietBi=?, NgayMua=?, GiaTri=?, MoTa=?, ChuKyBaoTriThang=? "
                + "WHERE MaThietBi=?";
        try (Connection con = DBConnect.getConnection(); PreparedStatement ps = con.prepareStatement(sql)) {
            ps.setString(1, eq.getTenThietBi());
            ps.setString(2, eq.getLoaiThietBi());
            ps.setDate(3, java.sql.Date.valueOf(eq.getNgayMua()));
            ps.setDouble(4, eq.getGiaTri());
            ps.setString(5, eq.getMoTa());
            ps.setInt(6, eq.getChuKyBaoTriThang());
            ps.setInt(7, eq.getMaThietBi());
            return ps.executeUpdate() > 0;
        } catch (Exception e) {
            e.printStackTrace();
        }
        return false;
    }

    // Tìm kiếm thiết bị theo tên hoặc mã
    public List<Equipment> searchEquipment(String keyword) {
        List<Equipment> list = new ArrayList<>();
        String sql = "SELECT * FROM Equipment WHERE TenThietBi LIKE ? OR CAST(MaThietBi AS VARCHAR) LIKE ? "
                + "ORDER BY MaThietBi DESC";
        try (Connection con = DBConnect.getConnection(); PreparedStatement ps = con.prepareStatement(sql)) {
            String q = "%" + keyword + "%";
            ps.setString(1, q);
            ps.setString(2, q);
            ResultSet rs = ps.executeQuery();
            while (rs.next()) {
                list.add(mapRow(rs));
            }
        } catch (Exception e) {
            e.printStackTrace();
        }
        return list;
    }

    // Xóa thiết bị (nếu cần - không có trong UC nhưng thường đi kèm CRUD)
    public boolean deleteEquipment(int maThietBi) {
        String sql = "DELETE FROM Equipment WHERE MaThietBi = ?";
        try (Connection con = DBConnect.getConnection(); PreparedStatement ps = con.prepareStatement(sql)) {
            ps.setInt(1, maThietBi);
            return ps.executeUpdate() > 0;
        } catch (Exception e) {
            e.printStackTrace();
        }
        return false;
    }

    private Equipment mapRow(ResultSet rs) throws SQLException {
        return new Equipment(
                rs.getInt("MaThietBi"),
                rs.getString("TenThietBi"),
                rs.getString("LoaiThietBi"),
                rs.getObject("NgayMua", LocalDate.class),
                rs.getDouble("GiaTri"),
                rs.getString("TinhTrang"),
                rs.getString("MoTa"),
                rs.getInt("ChuKyBaoTriThang")
        );
    }
}