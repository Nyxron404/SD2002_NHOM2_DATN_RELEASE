package dao;

import java.sql.*;
import java.time.LocalDate;
import java.util.ArrayList;
import java.util.List;
import models.Equipment;
import models.MaintenanceSchedule;
import uril.DBConnect;

/**
 * DAO thao tác bảng dbo.MaintenanceSchedule
 * UC-6.1: Lập lịch bảo trì định kỳ
 * UC-6.2: Ghi nhận kết quả bảo trì
 */
public class MaintenanceScheduleDAO {

    public static final String TT_CHUA_THUC_HIEN = "Chưa thực hiện";
    public static final String TT_DEN_HAN = "Đến hạn";
    public static final String TT_DANG_THUC_HIEN = "Đang thực hiện";
    public static final String TT_DA_HOAN_THANH = "Đã hoàn thành";

    // Toàn bộ lịch bảo trì, kèm tên thiết bị (JOIN Equipment)
    public List<MaintenanceSchedule> getAllSchedules() {
        List<MaintenanceSchedule> list = new ArrayList<>();
        String sql = "SELECT m.*, e.TenThietBi FROM MaintenanceSchedule m "
                + "LEFT JOIN Equipment e ON m.MaThietBi = e.MaThietBi "
                + "ORDER BY m.NgayDuKien DESC";
        try (Connection con = DBConnect.getConnection(); PreparedStatement ps = con.prepareStatement(sql)) {
            ResultSet rs = ps.executeQuery();
            while (rs.next()) {
                list.add(mapRowWithEquipmentName(rs));
            }
        } catch (Exception e) {
            e.printStackTrace();
        }
        return list;
    }

    // Lịch bảo trì của riêng 1 thiết bị
    public List<MaintenanceSchedule> getSchedulesByEquipment(int maThietBi) {
        List<MaintenanceSchedule> list = new ArrayList<>();
        String sql = "SELECT * FROM MaintenanceSchedule WHERE MaThietBi = ? ORDER BY NgayDuKien DESC";
        try (Connection con = DBConnect.getConnection(); PreparedStatement ps = con.prepareStatement(sql)) {
            ps.setInt(1, maThietBi);
            ResultSet rs = ps.executeQuery();
            while (rs.next()) {
                list.add(mapRow(rs));
            }
        } catch (Exception e) {
            e.printStackTrace();
        }
        return list;
    }

    // Các lịch đang ở trạng thái "Đến hạn" hoặc "Đang thực hiện" (UC-6.2 B1)
    public List<MaintenanceSchedule> getSchedulesDueOrInProgress() {
        List<MaintenanceSchedule> list = new ArrayList<>();
        String sql = "SELECT m.*, e.TenThietBi FROM MaintenanceSchedule m "
                + "LEFT JOIN Equipment e ON m.MaThietBi = e.MaThietBi "
                + "WHERE m.TrangThai = ? OR m.TrangThai = ? "
                + "ORDER BY m.NgayDuKien ASC";
        try (Connection con = DBConnect.getConnection(); PreparedStatement ps = con.prepareStatement(sql)) {
            ps.setString(1, TT_DEN_HAN);
            ps.setString(2, TT_DANG_THUC_HIEN);
            ResultSet rs = ps.executeQuery();
            while (rs.next()) {
                list.add(mapRowWithEquipmentName(rs));
            }
        } catch (Exception e) {
            e.printStackTrace();
        }
        return list;
    }

    public MaintenanceSchedule getById(int maBaoTri) {
        String sql = "SELECT m.*, e.TenThietBi FROM MaintenanceSchedule m "
                + "LEFT JOIN Equipment e ON m.MaThietBi = e.MaThietBi "
                + "WHERE m.MaBaoTri = ?";
        try (Connection con = DBConnect.getConnection(); PreparedStatement ps = con.prepareStatement(sql)) {
            ps.setInt(1, maBaoTri);
            ResultSet rs = ps.executeQuery();
            if (rs.next()) {
                return mapRowWithEquipmentName(rs);
            }
        } catch (Exception e) {
            e.printStackTrace();
        }
        return null;
    }

    // UC-6.1 B3, B4, B5: Lập lịch bảo trì mới, trả về MaBaoTri vừa tạo (0 nếu lỗi)
    public int insertSchedule(MaintenanceSchedule ms) {
        String sql = "INSERT INTO MaintenanceSchedule (MaThietBi, NgayDuKien, NoiDungDuKien, TrangThai, ChiPhi, NguoiThucHien) "
                + "VALUES (?, ?, ?, ?, ?, ?)";
        try (Connection con = DBConnect.getConnection();
                PreparedStatement ps = con.prepareStatement(sql, Statement.RETURN_GENERATED_KEYS)) {
            ps.setInt(1, ms.getMaThietBi());
            ps.setDate(2, java.sql.Date.valueOf(ms.getNgayDuKien()));
            ps.setString(3, ms.getNoiDungDuKien());
            ps.setString(4, TT_CHUA_THUC_HIEN);
            ps.setDouble(5, ms.getChiPhi());
            ps.setInt(6, ms.getNguoiThucHien());

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

    // UC-6.2 B3, B4, B5: Ghi nhận kết quả bảo trì đã hoàn thành
    // Đồng thời tự tính và tạo lịch bảo trì kế tiếp dựa trên ChuKyBaoTriThang của thiết bị
    public boolean completeSchedule(int maBaoTri, LocalDate ngayThucTe, String noiDungThucTe,
            double chiPhiThucTe, String ketQua) {
        MaintenanceSchedule ms = getById(maBaoTri);
        if (ms == null) {
            return false;
        }

        String sql = "UPDATE MaintenanceSchedule SET NgayThucTe = ?, NoiDungThucTe = ?, ChiPhi = ?, "
                + "KetQua = ?, TrangThai = ? WHERE MaBaoTri = ?";
        try (Connection con = DBConnect.getConnection(); PreparedStatement ps = con.prepareStatement(sql)) {
            ps.setDate(1, java.sql.Date.valueOf(ngayThucTe));
            ps.setString(2, noiDungThucTe);
            ps.setDouble(3, chiPhiThucTe);
            ps.setString(4, ketQua);
            ps.setString(5, TT_DA_HOAN_THANH);
            ps.setInt(6, maBaoTri);

            boolean ok = ps.executeUpdate() > 0;
            if (ok) {
                // Chuyển thiết bị về trạng thái "Đang sử dụng" sau khi bảo trì xong
                new EquipmentDAO().updateEquipmentStatus(ms.getMaThietBi(), EquipmentDAO.TT_DANG_SU_DUNG);

                // Tự động tính và tạo lịch bảo trì tiếp theo dựa trên chu kỳ của thiết bị
                Equipment eqTmp = new EquipmentDAO().getEquipmentById(ms.getMaThietBi());
                if (eqTmp != null && eqTmp.getChuKyBaoTriThang() > 0) {
                    LocalDate ngayTiepTheo = ngayThucTe.plusMonths(eqTmp.getChuKyBaoTriThang());
                    MaintenanceSchedule next = new MaintenanceSchedule(
                            ms.getMaThietBi(), ngayTiepTheo, ms.getNoiDungDuKien(), TT_CHUA_THUC_HIEN,
                            0, ms.getNguoiThucHien());
                    insertSchedule(next);
                }
            }
            return ok;
        } catch (Exception e) {
            e.printStackTrace();
        }
        return false;
    }

    // Đánh dấu các lịch đã tới NgayDuKien nhưng vẫn "Chưa thực hiện" thành "Đến hạn"
    // (dùng để phục vụ UC-6.3 quét lịch bảo trì)
    public int markSchedulesDue() {
        String sql = "UPDATE MaintenanceSchedule SET TrangThai = ? WHERE TrangThai = ? AND NgayDuKien <= ?";
        try (Connection con = DBConnect.getConnection(); PreparedStatement ps = con.prepareStatement(sql)) {
            ps.setString(1, TT_DEN_HAN);
            ps.setString(2, TT_CHUA_THUC_HIEN);
            ps.setDate(3, java.sql.Date.valueOf(LocalDate.now()));
            return ps.executeUpdate();
        } catch (Exception e) {
            e.printStackTrace();
        }
        return 0;
    }

    private MaintenanceSchedule mapRow(ResultSet rs) throws SQLException {
        return new MaintenanceSchedule(
                rs.getInt("MaBaoTri"),
                rs.getInt("MaThietBi"),
                rs.getObject("NgayDuKien", LocalDate.class),
                rs.getString("NoiDungDuKien"),
                rs.getString("TrangThai"),
                rs.getObject("NgayThucTe", LocalDate.class),
                rs.getString("NoiDungThucTe"),
                rs.getDouble("ChiPhi"),
                rs.getString("KetQua"),
                rs.getInt("NguoiThucHien")
        );
    }

    private MaintenanceSchedule mapRowWithEquipmentName(ResultSet rs) throws SQLException {
        MaintenanceSchedule ms = mapRow(rs);
        ms.setTenThietBi(rs.getString("TenThietBi"));
        return ms;
    }
}