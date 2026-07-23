package dao;

import java.sql.Connection;
import java.sql.Date;
import java.sql.PreparedStatement;
import java.sql.ResultSet;
import java.sql.SQLException;
import java.time.LocalDate;
import java.util.ArrayList;
import java.util.List;
import models.Vegetable;
import uril.DBConnect;

/**
 * DAO cho bảng Vegetable (quản lý rau trồng).
 *
 * 5 trạng thái cố định: "Đang trồng", "Bị bệnh", "Chết", "Có thể thu hoạch", "Đã thu hoạch hết".
 * Quy tắc tự động (chạy trước mỗi lần truy vấn danh sách):
 *  - SoLuong <= 0  -> "Đã thu hoạch hết" (trừ khi đang là "Chết")
 *  - NgayThuHoachDuKien đã tới hạn & đang "Đang trồng" -> "Có thể thu hoạch"
 * Thứ tự ưu tiên hiển thị: Bị bệnh (đỏ) > Có thể thu hoạch (xanh) > còn lại.
 */
public class VegetableDAO {

    private static final String ORDER_CLAUSE =
            " ORDER BY CASE v.TrangThai "
            + " WHEN N'Bị bệnh' THEN 0 "
            + " WHEN N'Có thể thu hoạch' THEN 1 "
            + " ELSE 2 END, v.MaRau";

    // Trạng thái mặc định hiển thị khi KHÔNG dùng bộ lọc
    private static final String DEFAULT_STATUS_FILTER =
            " AND v.TrangThai IN (N'Đang trồng', N'Bị bệnh', N'Có thể thu hoạch') ";

    private void autoUpdateStatus() {
        String sqlHetHang = "UPDATE Vegetable SET TrangThai = N'Đã thu hoạch hết' "
                + "WHERE SoLuong <= 0 AND TrangThai NOT IN (N'Đã thu hoạch hết', N'Chết')";
        String sqlDenHan = "UPDATE Vegetable SET TrangThai = N'Có thể thu hoạch' "
                + "WHERE NgayThuHoachDuKien <= CAST(GETDATE() AS DATE) "
                + "AND TrangThai = N'Đang trồng' AND SoLuong > 0";
        try (Connection con = DBConnect.getConnection();
                PreparedStatement ps1 = con.prepareStatement(sqlHetHang);
                PreparedStatement ps2 = con.prepareStatement(sqlDenHan)) {
            ps1.executeUpdate();
            ps2.executeUpdate();
        } catch (Exception e) {
            e.printStackTrace();
        }
    }

    private Vegetable mapRow(ResultSet rs) throws SQLException {
        Vegetable v = new Vegetable();
        v.setMaRau(rs.getInt("MaRau"));
        v.setTenRau(rs.getString("TenRau"));
        v.setLoaiRau(rs.getString("LoaiRau"));
        v.setGiong(rs.getString("Giong"));
        v.setMaKhuVuc(rs.getInt("MaKhuVuc"));
        v.setNgayGieo(rs.getObject("NgayGieo", LocalDate.class));
        v.setNgayThuHoachDuKien(rs.getObject("NgayThuHoachDuKien", LocalDate.class));
        v.setDienTich(rs.getDouble("DienTich"));
        v.setSoLuong(rs.getInt("SoLuong"));
        v.setTrangThai(rs.getString("TrangThai"));
        v.setGhiChu(rs.getString("GhiChu"));
        v.setTenKhuVuc(rs.getString("TenKhuVuc"));
        return v;
    }

    private static final String BASE_SELECT =
            "SELECT v.*, f.TenKhuVuc FROM Vegetable v LEFT JOIN FarmArea f ON v.MaKhuVuc = f.MaKhuVuc ";

    // Danh sách mặc định (Đang trồng / Bị bệnh / Có thể thu hoạch), ưu tiên hiển thị Bị bệnh, Có thể thu hoạch lên đầu
    public List<Vegetable> getDefaultVegetableList() {
        autoUpdateStatus();
        List<Vegetable> list = new ArrayList<>();
        String sql = BASE_SELECT + " WHERE 1=1 " + DEFAULT_STATUS_FILTER + ORDER_CLAUSE;
        try (Connection con = DBConnect.getConnection();
                PreparedStatement ps = con.prepareStatement(sql);
                ResultSet rs = ps.executeQuery()) {
            while (rs.next()) {
                list.add(mapRow(rs));
            }
        } catch (Exception e) {
            e.printStackTrace();
        }
        return list;
    }

    public Vegetable getVegetableById(int maRau) {
        autoUpdateStatus();
        String sql = BASE_SELECT + " WHERE v.MaRau = ?";
        try (Connection con = DBConnect.getConnection(); PreparedStatement ps = con.prepareStatement(sql)) {
            ps.setInt(1, maRau);
            ResultSet rs = ps.executeQuery();
            if (rs.next()) {
                return mapRow(rs);
            }
        } catch (Exception e) {
            e.printStackTrace();
        }
        return null;
    }

    // Tìm theo tên rau - vẫn chỉ trong tập trạng thái mặc định (Đang trồng/Bị bệnh/Có thể thu hoạch)
    public List<Vegetable> searchVegetables(String keyword) {
        autoUpdateStatus();
        List<Vegetable> list = new ArrayList<>();
        String sql = BASE_SELECT + " WHERE v.TenRau LIKE ? " + DEFAULT_STATUS_FILTER + ORDER_CLAUSE;
        try (Connection con = DBConnect.getConnection(); PreparedStatement ps = con.prepareStatement(sql)) {
            ps.setString(1, "%" + keyword + "%");
            ResultSet rs = ps.executeQuery();
            while (rs.next()) {
                list.add(mapRow(rs));
            }
        } catch (Exception e) {
            e.printStackTrace();
        }
        return list;
    }

    /**
     * Bộ lọc theo khu vực / ngày gieo / trạng thái.
     * Nếu người dùng CHỌN trạng thái cụ thể (kể cả "Chết", "Đã thu hoạch hết") -> hiển thị đúng trạng thái đó.
     * Nếu KHÔNG chọn trạng thái -> áp dụng bộ lọc mặc định (ẩn Chết / Đã thu hoạch hết).
     */
    public List<Vegetable> filterVegetables(Integer maKhuVuc, LocalDate ngayGieo, String trangThai) {
        autoUpdateStatus();
        List<Vegetable> list = new ArrayList<>();
        StringBuilder sql = new StringBuilder(BASE_SELECT).append(" WHERE 1=1 ");
        List<Object> params = new ArrayList<>();

        if (maKhuVuc != null && maKhuVuc > 0) {
            sql.append(" AND v.MaKhuVuc = ? ");
            params.add(maKhuVuc);
        }
        if (ngayGieo != null) {
            sql.append(" AND v.NgayGieo = ? ");
            params.add(Date.valueOf(ngayGieo));
        }
        if (trangThai != null && !trangThai.trim().isEmpty()) {
            sql.append(" AND v.TrangThai = ? ");
            params.add(trangThai);
        } else {
            sql.append(DEFAULT_STATUS_FILTER);
        }
        sql.append(ORDER_CLAUSE);

        try (Connection con = DBConnect.getConnection(); PreparedStatement ps = con.prepareStatement(sql.toString())) {
            for (int i = 0; i < params.size(); i++) {
                ps.setObject(i + 1, params.get(i));
            }
            ResultSet rs = ps.executeQuery();
            while (rs.next()) {
                list.add(mapRow(rs));
            }
        } catch (Exception e) {
            e.printStackTrace();
        }
        return list;
    }

    // Thêm rau mới - trạng thái mặc định luôn là "Đang trồng"
    public boolean insertVegetable(Vegetable v) {
        String sql = "INSERT INTO Vegetable (TenRau, LoaiRau, Giong, MaKhuVuc, NgayGieo, "
                + "NgayThuHoachDuKien, DienTich, SoLuong, TrangThai, GhiChu) "
                + "VALUES (?, ?, ?, ?, ?, ?, ?, ?, N'Đang trồng', ?)";
        try (Connection con = DBConnect.getConnection(); PreparedStatement ps = con.prepareStatement(sql)) {
            ps.setString(1, v.getTenRau());
            ps.setString(2, v.getLoaiRau());
            ps.setString(3, v.getGiong());
            ps.setInt(4, v.getMaKhuVuc());
            ps.setDate(5, Date.valueOf(v.getNgayGieo()));
            ps.setDate(6, Date.valueOf(v.getNgayThuHoachDuKien()));
            ps.setDouble(7, v.getDienTich());
            ps.setInt(8, v.getSoLuong());
            ps.setString(9, v.getGhiChu());
            return ps.executeUpdate() > 0;
        } catch (Exception e) {
            e.printStackTrace();
        }
        return false;
    }

    // Cập nhật đầy đủ thông tin rau (dùng khi bấm "Chỉnh sửa" trong form chi tiết)
    public boolean updateVegetable(Vegetable v) {
        String sql = "UPDATE Vegetable SET TenRau=?, LoaiRau=?, Giong=?, MaKhuVuc=?, NgayGieo=?, "
                + "NgayThuHoachDuKien=?, DienTich=?, SoLuong=?, TrangThai=?, GhiChu=? WHERE MaRau=?";
        try (Connection con = DBConnect.getConnection(); PreparedStatement ps = con.prepareStatement(sql)) {
            ps.setString(1, v.getTenRau());
            ps.setString(2, v.getLoaiRau());
            ps.setString(3, v.getGiong());
            ps.setInt(4, v.getMaKhuVuc());
            ps.setDate(5, Date.valueOf(v.getNgayGieo()));
            ps.setDate(6, Date.valueOf(v.getNgayThuHoachDuKien()));
            ps.setDouble(7, v.getDienTich());
            ps.setInt(8, v.getSoLuong());
            ps.setString(9, v.getTrangThai());
            ps.setString(10, v.getGhiChu());
            ps.setInt(11, v.getMaRau());
            return ps.executeUpdate() > 0;
        } catch (Exception e) {
            e.printStackTrace();
        }
        return false;
    }
}