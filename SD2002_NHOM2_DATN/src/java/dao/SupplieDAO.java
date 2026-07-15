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
                    rs.getString("DonViTinh"), rs.getInt("SoLuongTon"), rs.getDouble("DonGia"),
                    rs.getString("MoTa"), rs.getTimestamp("NgayNhapGanNhat").toLocalDateTime(), rs.getBoolean("TrangThai")
                ));
            }
        } catch (SQLException e) {
            e.printStackTrace();
        }
        return listSupplie;
    }

    public void addSupplie(Supplie s) {
        String insert = "INSERT INTO Supplie (TenVatTu, LoaiVatTu, DonViTinh, SoLuongTon, DonGia, MoTa, NgayNhapGanNhat, TrangThai) VALUES (?,?,?,?,?,?,?,?)";
        try (Connection con = DBConnect.getConnection(); PreparedStatement pstmt = con.prepareStatement(insert)) {
            pstmt.setString(1, s.getTenVatTu());
            pstmt.setString(2, s.getLoaiVatTu());
            pstmt.setString(3, s.getDonViTinh());
            pstmt.setInt(4, s.getSoLuongTon());
            pstmt.setDouble(5, s.getDonGia());
            pstmt.setString(6, s.getMoTa());
            pstmt.setTimestamp(7, Timestamp.valueOf(s.getNgayNhapGanNhat()));
            pstmt.setBoolean(8, s.isTrangThai());
            pstmt.executeUpdate();
        } catch (SQLException e) {
            e.printStackTrace();
        }
    }

    public void updateSupplie(Supplie s) {
        String update = "UPDATE Supplie SET TenVatTu=?, LoaiVatTu=?, DonViTinh=?, SoLuongTon=?, DonGia=?, MoTa=?, NgayNhapGanNhat=?, TrangThai=? WHERE MaVatTu=?";
        try (Connection con = DBConnect.getConnection(); PreparedStatement pstmt = con.prepareStatement(update)) {
            pstmt.setString(1, s.getTenVatTu());
            pstmt.setString(2, s.getLoaiVatTu());
            pstmt.setString(3, s.getDonViTinh());
            pstmt.setInt(4, s.getSoLuongTon());
            pstmt.setDouble(5, s.getDonGia());
            pstmt.setString(6, s.getMoTa());
            pstmt.setTimestamp(7, Timestamp.valueOf(s.getNgayNhapGanNhat()));
            pstmt.setBoolean(8, s.isTrangThai());
            pstmt.setInt(9, s.getMaVatTu());
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
}
