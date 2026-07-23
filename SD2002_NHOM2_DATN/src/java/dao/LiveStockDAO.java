package dao;

import java.sql.Connection;
import java.sql.Date;
import java.sql.PreparedStatement;
import java.sql.ResultSet;
import java.sql.SQLException;
import java.time.LocalDate;
import java.util.ArrayList;
import java.util.List;
import models.LiveStock;
import uril.DBConnect;

/**
 * DAO cho bảng LiveStock (quản lý vật nuôi).
 * Cột ChuongTrai đã bị xóa khỏi DB, không còn tồn tại nên không được nhắc tới trong các câu SQL.
 */
public class LiveStockDAO {

    private LiveStock mapRow(ResultSet rs) throws SQLException {
        LiveStock ls = new LiveStock();
        ls.setMaVatNuoi(rs.getInt("MaVatNuoi"));
        ls.setTenVatNuoi(rs.getString("TenVatNuoi"));
        ls.setLoaiVatNuoi(rs.getString("LoaiVatNuoi"));
        ls.setGiong(rs.getString("Giong"));
        ls.setNgayNhap(rs.getObject("NgayNhap", LocalDate.class));
        ls.setSoLuong(rs.getInt("SoLuong"));
        ls.setTrongLuongTrungBinh(rs.getDouble("TrongLuongTrungBinh"));
        ls.setMaKhuVuc(rs.getInt("MaKhuVuc"));
        ls.setTrangThai(rs.getString("TrangThai"));
        ls.setGhiChu(rs.getString("GhiChu"));
        ls.setTenKhuVuc(rs.getString("TenKhuVuc"));
        return ls;
    }

    private static final String BASE_SELECT =
            "SELECT ls.*, f.TenKhuVuc FROM LiveStock ls LEFT JOIN FarmArea f ON ls.MaKhuVuc = f.MaKhuVuc ";

    public List<LiveStock> getAllLiveStock() {
        List<LiveStock> list = new ArrayList<>();
        String sql = BASE_SELECT + " ORDER BY ls.MaVatNuoi";
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

    public LiveStock getLiveStockById(int maVatNuoi) {
        String sql = BASE_SELECT + " WHERE ls.MaVatNuoi = ?";
        try (Connection con = DBConnect.getConnection(); PreparedStatement ps = con.prepareStatement(sql)) {
            ps.setInt(1, maVatNuoi);
            ResultSet rs = ps.executeQuery();
            if (rs.next()) {
                return mapRow(rs);
            }
        } catch (Exception e) {
            e.printStackTrace();
        }
        return null;
    }

    public List<LiveStock> searchLiveStock(String keyword) {
        List<LiveStock> list = new ArrayList<>();
        String sql = BASE_SELECT + " WHERE ls.TenVatNuoi LIKE ? ORDER BY ls.MaVatNuoi";
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

    // Lọc theo ngày nhập / khu vực / mốc số lượng
    public List<LiveStock> filterLiveStock(LocalDate ngayNhap, Integer maKhuVuc, String soLuongMoc) {
        List<LiveStock> list = new ArrayList<>();
        StringBuilder sql = new StringBuilder(BASE_SELECT).append(" WHERE 1=1 ");
        List<Object> params = new ArrayList<>();

        if (ngayNhap != null) {
            sql.append(" AND ls.NgayNhap = ? ");
            params.add(Date.valueOf(ngayNhap));
        }
        if (maKhuVuc != null && maKhuVuc > 0) {
            sql.append(" AND ls.MaKhuVuc = ? ");
            params.add(maKhuVuc);
        }
        if (soLuongMoc != null) {
            switch (soLuongMoc) {
                case "duoi10":
                    sql.append(" AND ls.SoLuong < 10 ");
                    break;
                case "10-50":
                    sql.append(" AND ls.SoLuong BETWEEN 10 AND 50 ");
                    break;
                case "50-100":
                    sql.append(" AND ls.SoLuong BETWEEN 50 AND 100 ");
                    break;
                case "tren100":
                    sql.append(" AND ls.SoLuong > 100 ");
                    break;
                default:
                    break;
            }
        }
        sql.append(" ORDER BY ls.MaVatNuoi");

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

    public boolean insertLiveStock(LiveStock ls) {
        String sql = "INSERT INTO LiveStock (TenVatNuoi, LoaiVatNuoi, Giong, NgayNhap, SoLuong, "
                + "TrongLuongTrungBinh, MaKhuVuc, TrangThai, GhiChu) "
                + "VALUES (?, ?, ?, ?, ?, ?, ?, ?, ?)";
        try (Connection con = DBConnect.getConnection(); PreparedStatement ps = con.prepareStatement(sql)) {
            ps.setString(1, ls.getTenVatNuoi());
            ps.setString(2, ls.getLoaiVatNuoi());
            ps.setString(3, ls.getGiong());
            ps.setDate(4, Date.valueOf(ls.getNgayNhap()));
            ps.setInt(5, ls.getSoLuong());
            ps.setDouble(6, ls.getTrongLuongTrungBinh());
            ps.setInt(7, ls.getMaKhuVuc());
            ps.setString(8, ls.getTrangThai());
            ps.setString(9, ls.getGhiChu());
            return ps.executeUpdate() > 0;
        } catch (Exception e) {
            e.printStackTrace();
        }
        return false;
    }

    public boolean updateLiveStock(LiveStock ls) {
        String sql = "UPDATE LiveStock SET TenVatNuoi=?, LoaiVatNuoi=?, Giong=?, NgayNhap=?, SoLuong=?, "
                + "TrongLuongTrungBinh=?, MaKhuVuc=?, TrangThai=?, GhiChu=? WHERE MaVatNuoi=?";
        try (Connection con = DBConnect.getConnection(); PreparedStatement ps = con.prepareStatement(sql)) {
            ps.setString(1, ls.getTenVatNuoi());
            ps.setString(2, ls.getLoaiVatNuoi());
            ps.setString(3, ls.getGiong());
            ps.setDate(4, Date.valueOf(ls.getNgayNhap()));
            ps.setInt(5, ls.getSoLuong());
            ps.setDouble(6, ls.getTrongLuongTrungBinh());
            ps.setInt(7, ls.getMaKhuVuc());
            ps.setString(8, ls.getTrangThai());
            ps.setString(9, ls.getGhiChu());
            ps.setInt(10, ls.getMaVatNuoi());
            return ps.executeUpdate() > 0;
        } catch (Exception e) {
            e.printStackTrace();
        }
        return false;
    }

    // Nhập thêm số lượng (cộng dồn vào SoLuong hiện có)
    public boolean importQuantity(int maVatNuoi, int soLuong) {
        if (soLuong <= 0) {
            return false;
        }
        String sql = "UPDATE LiveStock SET SoLuong = SoLuong + ? WHERE MaVatNuoi = ?";
        try (Connection con = DBConnect.getConnection(); PreparedStatement ps = con.prepareStatement(sql)) {
            ps.setInt(1, soLuong);
            ps.setInt(2, maVatNuoi);
            return ps.executeUpdate() > 0;
        } catch (Exception e) {
            e.printStackTrace();
        }
        return false;
    }

    // Xuất bớt số lượng (chỉ khi đủ số lượng hiện có)
    public boolean exportQuantity(int maVatNuoi, int soLuong) {
        String sqlCheck = "SELECT SoLuong FROM LiveStock WHERE MaVatNuoi = ?";
        String sqlUpdate = "UPDATE LiveStock SET SoLuong = SoLuong - ? WHERE MaVatNuoi = ?";
        try (Connection con = DBConnect.getConnection()) {
            int current;
            try (PreparedStatement psCheck = con.prepareStatement(sqlCheck)) {
                psCheck.setInt(1, maVatNuoi);
                ResultSet rs = psCheck.executeQuery();
                if (!rs.next()) {
                    return false;
                }
                current = rs.getInt("SoLuong");
            }
            if (soLuong <= 0 || soLuong > current) {
                return false;
            }
            try (PreparedStatement psUp = con.prepareStatement(sqlUpdate)) {
                psUp.setInt(1, soLuong);
                psUp.setInt(2, maVatNuoi);
                return psUp.executeUpdate() > 0;
            }
        } catch (SQLException e) {
            e.printStackTrace();
        }
        return false;
    }
}