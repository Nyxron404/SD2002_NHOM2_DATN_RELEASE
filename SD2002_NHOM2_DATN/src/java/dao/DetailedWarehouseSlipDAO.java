/*
 * Click nbfs://nbhost/SystemFileSystem/Templates/Licenses/license-default.txt to change this license
 * Click nbfs://nbhost/SystemFileSystem/Templates/Classes/Class.java to edit this template
 */
package dao;

import java.sql.Connection;
import java.sql.PreparedStatement;
import java.sql.ResultSet;
import java.sql.SQLException;
import java.sql.Statement;
import java.util.ArrayList;
import java.util.List;
import models.DetailedWarehouseSlip;
import uril.DBConnect;

/**
 * DAO cho bảng DetailedWarehouseSlip (chi tiết từng dòng vật tư trong 1 phiếu Nhập/Xuất kho).
 *
 * @author longd
 */
public class DetailedWarehouseSlipDAO {

    /**
     * Thêm 1 dòng chi tiết phiếu kho, chạy TRONG 1 transaction có sẵn (do WarehouseSlipService quản lý).
     */
    public void insertDetail(Connection con, DetailedWarehouseSlip d) throws SQLException {
        String insert = "INSERT INTO DetailedWarehouseSlip (MaPhieuKho, MaVatTu, SoLuong, DonGia, ThanhTien) VALUES (?,?,?,?,?)";
        try (PreparedStatement pstmt = con.prepareStatement(insert, Statement.RETURN_GENERATED_KEYS)) {
            pstmt.setInt(1, d.getMaPhieuKho());
            pstmt.setInt(2, d.getMaVatTu());
            pstmt.setInt(3, d.getSoLuong());
            pstmt.setDouble(4, d.getDonGia());
            pstmt.setDouble(5, d.getThanhTien());
            pstmt.executeUpdate();

            try (ResultSet rs = pstmt.getGeneratedKeys()) {
                if (rs.next()) {
                    d.setMaChiTiet(rs.getInt(1));
                }
            }
        }
    }

    /**
     * Lấy toàn bộ chi tiết của 1 phiếu kho (để xem lại phiếu đã lập, hoặc in phiếu).
     */
    public List<DetailedWarehouseSlip> getDetailsByPhieuKho(int maPhieuKho) {
        List<DetailedWarehouseSlip> list = new ArrayList<>();
        String select = "SELECT * FROM DetailedWarehouseSlip WHERE MaPhieuKho=?";
        try (Connection con = DBConnect.getConnection(); PreparedStatement pstmt = con.prepareStatement(select)) {
            pstmt.setInt(1, maPhieuKho);
            try (ResultSet rs = pstmt.executeQuery()) {
                while (rs.next()) {
                    list.add(new DetailedWarehouseSlip(
                        rs.getInt("MaChiTiet"), rs.getInt("MaPhieuKho"), rs.getInt("MaVatTu"),
                        rs.getInt("SoLuong"), rs.getDouble("DonGia"), rs.getDouble("ThanhTien")
                    ));
                }
            }
        } catch (SQLException e) {
            e.printStackTrace();
        }
        return list;
    }
}
