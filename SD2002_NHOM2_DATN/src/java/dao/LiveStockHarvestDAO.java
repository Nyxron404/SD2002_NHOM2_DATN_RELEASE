package dao;

import java.sql.Connection;
import java.sql.Date;
import java.sql.PreparedStatement;
import java.sql.ResultSet;
import java.sql.SQLException;
import java.sql.Statement;
import java.time.LocalDate;
import java.util.ArrayList;
import java.util.LinkedHashMap;
import java.util.List;
import java.util.Map;
import models.LiveStock;
import models.LiveStockHarvest;
import uril.DBConnect;

/**
 * DAO cho bảng LiveStockHarvest (phiếu thu hoạch vật nuôi).
 * Song song với VegetableHarvestDAO nhưng áp dụng cho LiveStock.
 * Mỗi lần ghi nhận thu hoạch sẽ trừ SoLuong tương ứng trong bảng LiveStock.
 */
public class LiveStockHarvestDAO {

    private static final String BASE_SELECT =
            "SELECT h.*, ls.TenVatNuoi, ls.LoaiVatNuoi, st.HoTen AS TenNguoiThuHoach "
            + "FROM LiveStockHarvest h "
            + "JOIN LiveStock ls ON h.MaVatNuoi = ls.MaVatNuoi "
            + "LEFT JOIN Staff st ON h.NguoiThuHoach = st.MaNhanVien ";

    private LiveStockHarvest mapRow(ResultSet rs) throws SQLException {
        LiveStockHarvest h = new LiveStockHarvest();
        h.setMaThuHoachVN(rs.getInt("MaThuHoachVN"));
        h.setMaVatNuoi(rs.getInt("MaVatNuoi"));
        h.setTenVatNuoi(rs.getString("TenVatNuoi"));
        h.setLoaiVatNuoi(rs.getString("LoaiVatNuoi"));
        h.setNgayThuHoach(rs.getObject("NgayThuHoach", LocalDate.class));
        h.setSoLuongThuHoach(rs.getInt("SoLuongThuHoach"));
        h.setChatLuong(rs.getString("ChatLuong"));
        h.setGiaTriUocTinh(rs.getDouble("GiaTriUocTinh"));
        h.setNguoiThuHoach(rs.getInt("NguoiThuHoach"));
        h.setTenNguoiThuHoach(rs.getString("TenNguoiThuHoach"));
        h.setGhiChu(rs.getString("GhiChu"));
        return h;
    }

    // Toàn bộ phiếu thu hoạch vật nuôi, mới nhất lên trước
    public List<LiveStockHarvest> getAllLiveStockHarvests() {
        List<LiveStockHarvest> list = new ArrayList<>();
        String sql = BASE_SELECT + " ORDER BY h.MaThuHoachVN DESC";
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

    // Danh sách vật nuôi có thể thu hoạch: còn số lượng VÀ đang ở trạng thái "Khỏe mạnh".
    // Vật nuôi "Bị bệnh" hoặc "Đã xuất chuồng" sẽ không xuất hiện ở đây.
    public List<LiveStock> getHarvestableLiveStock() {
        List<LiveStock> list = new ArrayList<>();
        String sql = "SELECT ls.*, f.TenKhuVuc FROM LiveStock ls "
                + "LEFT JOIN FarmArea f ON ls.MaKhuVuc = f.MaKhuVuc "
                + "WHERE ls.SoLuong > 0 AND ls.TrangThai = N'Khỏe mạnh' "
                + "ORDER BY ls.MaVatNuoi";
        try (Connection con = DBConnect.getConnection();
                PreparedStatement ps = con.prepareStatement(sql);
                ResultSet rs = ps.executeQuery()) {
            while (rs.next()) {
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
                list.add(ls);
            }
        } catch (Exception e) {
            e.printStackTrace();
        }
        return list;
    }

    // Ghi nhận phiếu thu hoạch vật nuôi + trừ SoLuong hiện có trong LiveStock (trong 1 transaction)
    public boolean insertHarvestAndUpdateLiveStock(LiveStockHarvest h) {
        if (h.getSoLuongThuHoach() <= 0) {
            return false;
        }
        String sqlCheck = "SELECT SoLuong, TrangThai FROM LiveStock WHERE MaVatNuoi = ?";
        String sqlInsert = "INSERT INTO LiveStockHarvest "
                + "(MaVatNuoi, NgayThuHoach, SoLuongThuHoach, ChatLuong, GiaTriUocTinh, NguoiThuHoach, GhiChu) "
                + "VALUES (?, ?, ?, ?, ?, ?, ?)";
        String sqlUpdate = "UPDATE LiveStock SET SoLuong = SoLuong - ? WHERE MaVatNuoi = ?";
        String sqlUpdateStatus = "UPDATE LiveStock SET TrangThai = 'Đã xuất chuồng' WHERE MaVatNuoi = ? AND SoLuong <= 0";

        Connection con = null;
        try {
            con = DBConnect.getConnection();
            con.setAutoCommit(false);

            int current;
            String trangThaiHienTai;
            try (PreparedStatement psCheck = con.prepareStatement(sqlCheck)) {
                psCheck.setInt(1, h.getMaVatNuoi());
                try (ResultSet rs = psCheck.executeQuery()) {
                    if (!rs.next()) {
                        con.rollback();
                        return false;
                    }
                    current = rs.getInt("SoLuong");
                    trangThaiHienTai = rs.getString("TrangThai");
                }
            }
            // Chỉ cho phép thu hoạch khi vật nuôi đang ở trạng thái "Khỏe mạnh"
            if (!"Khỏe mạnh".equals(trangThaiHienTai)) {
                con.rollback();
                return false;
            }
            if (h.getSoLuongThuHoach() > current) {
                con.rollback();
                return false;
            }

            try (PreparedStatement psIns = con.prepareStatement(sqlInsert)) {
                psIns.setInt(1, h.getMaVatNuoi());
                psIns.setDate(2, Date.valueOf(h.getNgayThuHoach() != null ? h.getNgayThuHoach() : LocalDate.now()));
                psIns.setInt(3, h.getSoLuongThuHoach());
                psIns.setString(4, h.getChatLuong());
                psIns.setDouble(5, h.getGiaTriUocTinh());
                psIns.setInt(6, h.getNguoiThuHoach());
                psIns.setString(7, h.getGhiChu());
                psIns.executeUpdate();
            }

            try (PreparedStatement psUp = con.prepareStatement(sqlUpdate)) {
                psUp.setInt(1, h.getSoLuongThuHoach());
                psUp.setInt(2, h.getMaVatNuoi());
                psUp.executeUpdate();
            }

            // Nếu thu hoạch hết sạch số lượng, tự động cập nhật trạng thái sang "Đã xuất chuồng"
            try (PreparedStatement psStatus = con.prepareStatement(sqlUpdateStatus)) {
                psStatus.setInt(1, h.getMaVatNuoi());
                psStatus.executeUpdate();
            }

            con.commit();
            return true;
        } catch (Exception e) {
            e.printStackTrace();
            if (con != null) {
                try {
                    con.rollback();
                } catch (SQLException ex) {
                    ex.printStackTrace();
                }
            }
            return false;
        } finally {
            if (con != null) {
                try {
                    con.setAutoCommit(true);
                    con.close();
                } catch (SQLException ex) {
                    ex.printStackTrace();
                }
            }
        }
    }

    // Dữ liệu cho biểu đồ cột: tổng sản lượng đã thu hoạch, gom nhóm theo Loại vật nuôi
    public Map<String, Integer> getChartDataByLiveStockType() {
        Map<String, Integer> data = new LinkedHashMap<>();
        String sql = "SELECT ls.LoaiVatNuoi AS Loai, SUM(h.SoLuongThuHoach) AS Tong "
                + "FROM LiveStockHarvest h "
                + "JOIN LiveStock ls ON h.MaVatNuoi = ls.MaVatNuoi "
                + "GROUP BY ls.LoaiVatNuoi "
                + "ORDER BY Tong DESC";
        try (Connection con = DBConnect.getConnection();
                PreparedStatement ps = con.prepareStatement(sql);
                ResultSet rs = ps.executeQuery()) {
            while (rs.next()) {
                data.put(rs.getString("Loai"), rs.getInt("Tong"));
            }
        } catch (Exception e) {
            e.printStackTrace();
        }
        return data;
    }
}