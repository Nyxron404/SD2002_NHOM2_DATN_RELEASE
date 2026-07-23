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
import models.Staff;
import models.Vegetable;
import models.VegetableHarvest;
import uril.DBConnect;

/**
 * DAO cho bảng VegetableHarvest (quản lý thu hoạch rau).
 * Lưu ý: MaThuHoach KHÔNG phải cột IDENTITY trong DB nên DAO tự sinh giá trị kế tiếp (MAX + 1).
 */
public class VegetableHarvestDAO {

    private VegetableHarvest mapRow(ResultSet rs) throws SQLException {
        VegetableHarvest h = new VegetableHarvest();
        h.setMaThuHoach(rs.getInt("MaThuHoach"));
        h.setMaRau(rs.getInt("MaRau"));
        h.setNgayThuHoach(rs.getObject("NgayThuHoach", LocalDate.class));
        h.setSoLuongThuHoach(rs.getInt("SoLuongThuHoach"));
        h.setChatLuong(rs.getString("ChatLuong"));
        h.setGiaTriUocTinh(rs.getDouble("GiaTriUocTinh"));
        h.setNguoiThuHoach(rs.getInt("NguoiThuHoach"));
        h.setGhiChu(rs.getString("GhiChu"));
        h.setTenRau(rs.getString("TenRau"));
        h.setTenNguoiThuHoach(rs.getString("HoTen"));
        return h;
    }

    private static final String BASE_SELECT =
            "SELECT vh.*, v.TenRau, s.HoTen FROM VegetableHarvest vh "
            + "JOIN Vegetable v ON vh.MaRau = v.MaRau "
            + "JOIN Staff s ON vh.NguoiThuHoach = s.MaNhanVien ";

    public List<VegetableHarvest> getAllHarvests() {
        List<VegetableHarvest> list = new ArrayList<>();
        String sql = BASE_SELECT + " ORDER BY vh.NgayThuHoach DESC, vh.MaThuHoach DESC";
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

    public VegetableHarvest getHarvestById(int maThuHoach) {
        String sql = BASE_SELECT + " WHERE vh.MaThuHoach = ?";
        try (Connection con = DBConnect.getConnection(); PreparedStatement ps = con.prepareStatement(sql)) {
            ps.setInt(1, maThuHoach);
            ResultSet rs = ps.executeQuery();
            if (rs.next()) {
                return mapRow(rs);
            }
        } catch (Exception e) {
            e.printStackTrace();
        }
        return null;
    }

    /**
     * Lọc theo khoảng ngày thu hoạch + mốc số lượng + mốc giá trị ước tính.
     * soLuongMoc: "duoi50" | "50-200" | "200-500" | "tren500"
     * giaTriMoc : "duoi1tr" | "1-5tr" | "5-10tr" | "tren10tr"
     */
    public List<VegetableHarvest> filterHarvests(LocalDate tuNgay, LocalDate denNgay, String soLuongMoc, String giaTriMoc) {
        List<VegetableHarvest> list = new ArrayList<>();
        StringBuilder sql = new StringBuilder(BASE_SELECT).append(" WHERE 1=1 ");
        List<Object> params = new ArrayList<>();

        if (tuNgay != null) {
            sql.append(" AND vh.NgayThuHoach >= ? ");
            params.add(Date.valueOf(tuNgay));
        }
        if (denNgay != null) {
            sql.append(" AND vh.NgayThuHoach <= ? ");
            params.add(Date.valueOf(denNgay));
        }
        if (soLuongMoc != null) {
            switch (soLuongMoc) {
                case "duoi50":
                    sql.append(" AND vh.SoLuongThuHoach < 50 ");
                    break;
                case "50-200":
                    sql.append(" AND vh.SoLuongThuHoach BETWEEN 50 AND 200 ");
                    break;
                case "200-500":
                    sql.append(" AND vh.SoLuongThuHoach BETWEEN 200 AND 500 ");
                    break;
                case "tren500":
                    sql.append(" AND vh.SoLuongThuHoach > 500 ");
                    break;
                default:
                    break;
            }
        }
        if (giaTriMoc != null) {
            switch (giaTriMoc) {
                case "duoi1tr":
                    sql.append(" AND vh.GiaTriUocTinh < 1000000 ");
                    break;
                case "1-5tr":
                    sql.append(" AND vh.GiaTriUocTinh BETWEEN 1000000 AND 5000000 ");
                    break;
                case "5-10tr":
                    sql.append(" AND vh.GiaTriUocTinh BETWEEN 5000000 AND 10000000 ");
                    break;
                case "tren10tr":
                    sql.append(" AND vh.GiaTriUocTinh > 10000000 ");
                    break;
                default:
                    break;
            }
        }
        sql.append(" ORDER BY vh.NgayThuHoach DESC, vh.MaThuHoach DESC");

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

    // Danh sách rau đang ở trạng thái "Có thể thu hoạch" - dùng cho form chọn rau để thu hoạch
    public List<Vegetable> getHarvestableVegetables() {
        List<Vegetable> list = new ArrayList<>();
        String sql = "SELECT v.*, f.TenKhuVuc FROM Vegetable v "
                + "LEFT JOIN FarmArea f ON v.MaKhuVuc = f.MaKhuVuc "
                + "WHERE v.TrangThai = N'Có thể thu hoạch' ORDER BY v.MaRau";
        try (Connection con = DBConnect.getConnection();
                PreparedStatement ps = con.prepareStatement(sql);
                ResultSet rs = ps.executeQuery()) {
            while (rs.next()) {
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
                list.add(v);
            }
        } catch (Exception e) {
            e.printStackTrace();
        }
        return list;
    }

    // Danh sách công nhân (MaNhom = 6, giống quy ước đang dùng trong FarmingPracticeDAO.WorkerList())
    public List<Staff> getWorkerStaffList() {
        List<Staff> list = new ArrayList<>();
        String sql = "SELECT s.MaNhanVien, s.HoTen FROM Staff s "
                + "JOIN [User] u ON s.MaNguoiDung = u.MaNguoiDung WHERE u.MaNhom = 6";
        try (Connection con = DBConnect.getConnection();
                PreparedStatement ps = con.prepareStatement(sql);
                ResultSet rs = ps.executeQuery()) {
            while (rs.next()) {
                Staff st = new Staff();
                st.setMaNhanVien(rs.getInt("MaNhanVien"));
                st.setHoTen(rs.getString("HoTen"));
                list.add(st);
            }
        } catch (Exception e) {
            e.printStackTrace();
        }
        return list;
    }

    /**
     * Thêm phiếu thu hoạch + trừ số lượng rau tương ứng (transaction).
     * Chỉ cho phép thu hoạch số lượng > 0 và <= số lượng gốc hiện có.
     * Nếu sau khi trừ, SoLuong <= 0 -> tự động chuyển trạng thái rau thành "Đã thu hoạch hết".
     */
    public boolean insertHarvestAndUpdateVegetable(VegetableHarvest h) {
        String getSoLuong = "SELECT SoLuong FROM Vegetable WHERE MaRau = ?";
        String getMax = "SELECT ISNULL(MAX(MaThuHoach), 0) + 1 AS NextId FROM VegetableHarvest";
        String insert = "INSERT INTO VegetableHarvest (MaThuHoach, MaRau, NgayThuHoach, SoLuongThuHoach, "
                + "ChatLuong, GiaTriUocTinh, NguoiThuHoach, GhiChu) VALUES (?, ?, ?, ?, ?, ?, ?, ?)";
        String updateVegetable = "UPDATE Vegetable SET SoLuong = SoLuong - ?, "
                + "TrangThai = CASE WHEN (SoLuong - ?) <= 0 THEN N'Đã thu hoạch hết' ELSE TrangThai END "
                + "WHERE MaRau = ?";

        try (Connection con = DBConnect.getConnection()) {
            con.setAutoCommit(false);
            try {
                int soLuongHienCo;
                try (PreparedStatement psCheck = con.prepareStatement(getSoLuong)) {
                    psCheck.setInt(1, h.getMaRau());
                    ResultSet rs = psCheck.executeQuery();
                    if (!rs.next()) {
                        con.rollback();
                        return false;
                    }
                    soLuongHienCo = rs.getInt("SoLuong");
                }

                if (h.getSoLuongThuHoach() <= 0 || h.getSoLuongThuHoach() > soLuongHienCo) {
                    con.rollback();
                    return false; // Số lượng thu hoạch không hợp lệ / vượt quá số lượng gốc
                }

                int nextId;
                try (PreparedStatement psId = con.prepareStatement(getMax); ResultSet rs = psId.executeQuery()) {
                    rs.next();
                    nextId = rs.getInt("NextId");
                }

                try (PreparedStatement psIns = con.prepareStatement(insert)) {
                    psIns.setInt(1, nextId);
                    psIns.setInt(2, h.getMaRau());
                    psIns.setDate(3, Date.valueOf(h.getNgayThuHoach()));
                    psIns.setInt(4, h.getSoLuongThuHoach());
                    psIns.setString(5, h.getChatLuong());
                    psIns.setDouble(6, h.getGiaTriUocTinh());
                    psIns.setInt(7, h.getNguoiThuHoach());
                    psIns.setString(8, h.getGhiChu());
                    psIns.executeUpdate();
                }

                try (PreparedStatement psUp = con.prepareStatement(updateVegetable)) {
                    psUp.setInt(1, h.getSoLuongThuHoach());
                    psUp.setInt(2, h.getSoLuongThuHoach());
                    psUp.setInt(3, h.getMaRau());
                    psUp.executeUpdate();
                }

                con.commit();
                return true;
            } catch (Exception ex) {
                con.rollback();
                ex.printStackTrace();
                return false;
            }
        } catch (SQLException e) {
            e.printStackTrace();
            return false;
        }
    }

    // Dữ liệu cho biểu đồ cột: gộp tổng số lượng đã thu hoạch theo TÊN rau (các rau trùng tên sẽ cộng dồn)
    public Map<String, Integer> getChartDataByVegetableName() {
        Map<String, Integer> map = new LinkedHashMap<>();
        String sql = "SELECT v.TenRau, SUM(vh.SoLuongThuHoach) AS Tong FROM VegetableHarvest vh "
                + "JOIN Vegetable v ON vh.MaRau = v.MaRau "
                + "GROUP BY v.TenRau ORDER BY v.TenRau";
        try (Connection con = DBConnect.getConnection();
                PreparedStatement ps = con.prepareStatement(sql);
                ResultSet rs = ps.executeQuery()) {
            while (rs.next()) {
                map.put(rs.getString("TenRau"), rs.getInt("Tong"));
            }
        } catch (Exception e) {
            e.printStackTrace();
        }
        return map;
    }
}