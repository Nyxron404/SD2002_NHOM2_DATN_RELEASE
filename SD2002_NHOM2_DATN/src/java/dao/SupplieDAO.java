package dao;

import java.util.ArrayList;
import java.util.List;
import models.Supplie;
import uril.DBConnect;
import java.sql.*;

public class SupplieDAO {
    private List<Supplie> listSupplie;

    public SupplieDAO() {
        listSupplie = new ArrayList<>();
    }

    public List<Supplie> SelectSupplie() {
        listSupplie.clear();
        String select = "SELECT * FROM Supplie";
        try (Connection con = DBConnect.getConnection(); Statement stmt = con.createStatement()) {
            ResultSet rs = stmt.executeQuery(select);
            while (rs.next()) {
                listSupplie.add(new Supplie(
                    rs.getInt("MaVatTu"), rs.getString("TenVatTu"), rs.getString("LoaiVatTu"),
                    rs.getString("DonViTinh"), rs.getInt("SoLuongTon"), rs.getInt("SoLuongToiThieu"), rs.getDouble("DonGia"),
                    rs.getString("MoTa"), rs.getTimestamp("NgayNhapGanNhat").toLocalDateTime(), rs.getBoolean("TrangThai")
                ));
            }
        } catch (SQLException e) {
            e.printStackTrace();
        }
        return listSupplie;
    }

    public Supplie getSupplieById(int maVatTu) {
        String select = "SELECT * FROM Supplie WHERE MaVatTu=?";
        try (Connection con = DBConnect.getConnection(); PreparedStatement pstmt = con.prepareStatement(select)) {
            pstmt.setInt(1, maVatTu);
            try (ResultSet rs = pstmt.executeQuery()) {
                if (rs.next()) {
                    return new Supplie(
                        rs.getInt("MaVatTu"), rs.getString("TenVatTu"), rs.getString("LoaiVatTu"),
                        rs.getString("DonViTinh"), rs.getInt("SoLuongTon"), rs.getInt("SoLuongToiThieu"), rs.getDouble("DonGia"),
                        rs.getString("MoTa"), rs.getTimestamp("NgayNhapGanNhat").toLocalDateTime(), rs.getBoolean("TrangThai")
                    );
                }
            }
        } catch (SQLException e) {
            e.printStackTrace();
        }
        return null;
    }

    /**
     * Kiểm tra tên vật tư đã tồn tại chưa (không phân biệt hoa/thường, khoảng trắng đầu-cuối).
     * excludeMaVatTu: khi sửa, truyền mã đang sửa để loại trừ chính nó; khi thêm mới, truyền 0.
     */
    public boolean checkTenVatTuTrung(String tenVatTu, int excludeMaVatTu) throws SQLException {
        String sql = "SELECT 1 FROM Supplie WHERE LOWER(LTRIM(RTRIM(TenVatTu))) = LOWER(LTRIM(RTRIM(?))) AND MaVatTu <> ?";
        try (Connection con = DBConnect.getConnection(); PreparedStatement pstmt = con.prepareStatement(sql)) {
            pstmt.setString(1, tenVatTu);
            pstmt.setInt(2, excludeMaVatTu);
            try (ResultSet rs = pstmt.executeQuery()) {
                return rs.next();
            }
        }
    }

    /**
     * QUAN TRỌNG: không còn nuốt SQLException như trước — ném ra để tầng Service
     * biết chính xác thêm/sửa có thành công hay không, tránh báo "thành công" giả.
     */
    public boolean addSupplie(Supplie s) throws SQLException {
        String insert = "INSERT INTO Supplie (TenVatTu, LoaiVatTu, DonViTinh, SoLuongTon, SoLuongToiThieu, DonGia, MoTa, NgayNhapGanNhat, TrangThai) VALUES (?,?,?,?,?,?,?,?,?)";
        try (Connection con = DBConnect.getConnection(); PreparedStatement pstmt = con.prepareStatement(insert)) {
            pstmt.setString(1, s.getTenVatTu());
            pstmt.setString(2, s.getLoaiVatTu());
            pstmt.setString(3, s.getDonViTinh());
            pstmt.setInt(4, s.getSoLuongTon());
            pstmt.setInt(5, s.getSoLuongToiThieu());
            pstmt.setDouble(6, s.getDonGia());
            pstmt.setString(7, s.getMoTa());
            pstmt.setTimestamp(8, Timestamp.valueOf(s.getNgayNhapGanNhat()));
            pstmt.setBoolean(9, s.isTrangThai());
            return pstmt.executeUpdate() > 0;
        }
    }

    public boolean updateSupplie(Supplie s) throws SQLException {
        String update = "UPDATE Supplie SET TenVatTu=?, LoaiVatTu=?, DonViTinh=?, SoLuongTon=?, SoLuongToiThieu=?, DonGia=?, MoTa=?, NgayNhapGanNhat=?, TrangThai=? WHERE MaVatTu=?";
        try (Connection con = DBConnect.getConnection(); PreparedStatement pstmt = con.prepareStatement(update)) {
            pstmt.setString(1, s.getTenVatTu());
            pstmt.setString(2, s.getLoaiVatTu());
            pstmt.setString(3, s.getDonViTinh());
            pstmt.setInt(4, s.getSoLuongTon());
            pstmt.setInt(5, s.getSoLuongToiThieu());
            pstmt.setDouble(6, s.getDonGia());
            pstmt.setString(7, s.getMoTa());
            pstmt.setTimestamp(8, Timestamp.valueOf(s.getNgayNhapGanNhat()));
            pstmt.setBoolean(9, s.isTrangThai());
            pstmt.setInt(10, s.getMaVatTu());
            return pstmt.executeUpdate() > 0;
        }
    }

    public boolean deleteSupplie(int maVatTu) throws SQLException {
        String delete = "DELETE FROM Supplie WHERE MaVatTu=?";
        try (Connection con = DBConnect.getConnection(); PreparedStatement pstmt = con.prepareStatement(delete)) {
            pstmt.setInt(1, maVatTu);
            return pstmt.executeUpdate() > 0;
        }
    }

    /**
     * Cộng/trừ tồn kho trong transaction có sẵn (dùng khi lập phiếu Nhập/Xuất).
     */
    public void updateStock(Connection con, int maVatTu, int delta) throws SQLException {
        String update = "UPDATE Supplie SET SoLuongTon = SoLuongTon + ? WHERE MaVatTu = ? AND SoLuongTon + ? >= 0";
        try (PreparedStatement pstmt = con.prepareStatement(update)) {
            pstmt.setInt(1, delta);
            pstmt.setInt(2, maVatTu);
            pstmt.setInt(3, delta);
            int rows = pstmt.executeUpdate();
            if (rows == 0) {
                throw new SQLException("Không đủ tồn kho hoặc vật tư (mã " + maVatTu + ") không tồn tại.");
            }
        }
    }
    
    public int getLowStockCount() {
        String sql = "SELECT COUNT(*) FROM Supplie WHERE SoLuongTon <= 10"; 
        try (Connection con = DBConnect.getConnection(); PreparedStatement ps = con.prepareStatement(sql)) {
            ResultSet rs = ps.executeQuery();
            if (rs.next()) return rs.getInt(1);
        } catch (Exception e) { 
            e.printStackTrace(); 
        }
        return 0;
    }
}