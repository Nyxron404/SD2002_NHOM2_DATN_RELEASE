/*
 * Click nbfs://nbhost/SystemFileSystem/Templates/Licenses/license-default.txt to change this license
 * Click nbfs://nbhost/SystemFileSystem/Templates/Classes/Class.java to edit this template
 */
package dao;

import java.util.ArrayList;
import java.util.List;
import models.Supplie;
import uril.DBConnect;
import java.sql.*;
import java.time.LocalDateTime;

/**
 *
 * @author longd
 */
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

    /**
     * Lấy 1 vật tư theo mã. Dùng khi lập phiếu Nhập/Xuất để biết tồn kho hiện tại, đơn giá, tên...
     */
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

    public void addSupplie(Supplie s) {
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
            pstmt.executeUpdate();
        } catch (SQLException e) {
            e.printStackTrace();
        }
    }

    public void updateSupplie(Supplie s) {
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
            pstmt.executeUpdate();
        } catch (SQLException e) {
            e.printStackTrace();
        }
    }

    public void deleteSupplie(int maVatTu) {
        String delete = "DELETE FROM Supplie WHERE MaVatTu=?";
        try (Connection con = DBConnect.getConnection(); PreparedStatement pstmt = con.prepareStatement(delete)) {
            pstmt.setInt(1, maVatTu);
            pstmt.executeUpdate();
        } catch (SQLException e) {
            e.printStackTrace();
        }
    }

    /**
     * Cộng/trừ số lượng tồn kho, chạy TRONG 1 transaction có sẵn (dùng chung Connection với
     * WarehouseSlipDAO/DetailedWarehouseSlipDAO khi lập phiếu Nhập/Xuất kho).
     *
     * delta > 0  : Nhập kho (cộng tồn)
     * delta < 0  : Xuất kho (trừ tồn)
     *
     * Điều kiện "SoLuongTon + ? >= 0" ngay trong câu SQL đảm bảo tồn kho KHÔNG BAO GIỜ bị âm,
     * kể cả khi có nhiều người cùng thao tác một lúc (tránh race-condition).
     * Nếu không có dòng nào được cập nhật (rows == 0) nghĩa là vật tư không tồn tại
     * hoặc không đủ tồn kho để xuất -> ném SQLException để tầng Service rollback toàn bộ phiếu.
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
}
