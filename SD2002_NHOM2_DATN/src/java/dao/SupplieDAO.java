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
        String select = "SELECT * FROM Supplie";
        listSupplie.clear();
        try (Connection con = DBConnect.getConnection(); Statement stmt = con.createStatement()) {
            ResultSet rs = stmt.executeQuery(select);
            while (rs.next()) {
                int MaVatTu = rs.getInt("MaVatTu");
                String TenVatTu = rs.getString("TenVatTu");
                String LoaiVatTu = rs.getString("LoaiVatTu");
                String DonViTinh = rs.getString("DonViTinh");
                int SoLuongTon = rs.getInt("SoLuongTon");
                double DonGia = rs.getDouble("DonGia");
                String MoTa = rs.getString("MoTa");
                LocalDateTime NgayNhapGanNhat = rs.getTimestamp("NgayNhapGanNhat").toLocalDateTime();
                boolean TrangThai = rs.getBoolean("TrangThai");

                listSupplie.add(new Supplie(MaVatTu, TenVatTu, LoaiVatTu, DonViTinh, SoLuongTon, DonGia, MoTa, NgayNhapGanNhat, TrangThai));
            }
            return listSupplie;
        } catch (SQLException e) {
            e.printStackTrace();
            return listSupplie;
        }
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
}
