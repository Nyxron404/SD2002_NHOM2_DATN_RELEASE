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
import java.sql.Timestamp;
import java.util.ArrayList;
import java.util.List;
import models.WarehouseSlip;
import uril.DBConnect;

/**
 * DAO cho bảng WarehouseSlip (Phiếu kho - dùng chung cho cả phiếu Nhập và phiếu Xuất,
 * phân biệt bởi cột LoaiPhieu: "Nhập" / "Xuất").
 *
 * @author longd
 */
public class WarehouseSlipDAO {

    /**
     * Thêm 1 phiếu kho, chạy TRONG 1 transaction có sẵn (do WarehouseSlipService quản lý
     * cùng với việc thêm chi tiết phiếu và cập nhật tồn kho).
     * Trả về MaPhieuKho vừa được sinh ra (khóa tự tăng).
     */
    public int insertWarehouseSlip(Connection con, WarehouseSlip ws) throws SQLException {
        String insert = "INSERT INTO WarehouseSlip (LoaiPhieu, NgayLap, NguoiLap, GhiChu) VALUES (?,?,?,?)";
        try (PreparedStatement pstmt = con.prepareStatement(insert, Statement.RETURN_GENERATED_KEYS)) {
            pstmt.setString(1, ws.getLoaiPhieu());
            pstmt.setTimestamp(2, Timestamp.valueOf(ws.getNgayLap()));
            pstmt.setInt(3, ws.getNguoiLap());
            pstmt.setString(4, ws.getGhiChu());
            pstmt.executeUpdate();

            try (ResultSet rs = pstmt.getGeneratedKeys()) {
                if (rs.next()) {
                    return rs.getInt(1);
                }
            }
        }
        throw new SQLException("Không lấy được MaPhieuKho vừa tạo.");
    }

    /**
     * Lấy toàn bộ lịch sử phiếu kho (mới nhất lên trước), dùng cho màn hình lịch sử Nhập/Xuất kho.
     */
    public List<WarehouseSlip> getAllWarehouseSlips() {
        List<WarehouseSlip> list = new ArrayList<>();
        String select = "SELECT * FROM WarehouseSlip ORDER BY NgayLap DESC";
        try (Connection con = DBConnect.getConnection(); Statement stmt = con.createStatement()) {
            ResultSet rs = stmt.executeQuery(select);
            while (rs.next()) {
                list.add(new WarehouseSlip(
                    rs.getInt("MaPhieuKho"), rs.getString("LoaiPhieu"),
                    rs.getTimestamp("NgayLap").toLocalDateTime(),
                    rs.getInt("NguoiLap"), rs.getString("GhiChu")
                ));
            }
        } catch (SQLException e) {
            e.printStackTrace();
        }
        return list;
    }

    /**
     * Lấy phiếu kho theo loại phiếu ("Nhập" hoặc "Xuất").
     */
    public List<WarehouseSlip> getWarehouseSlipsByType(String loaiPhieu) {
        List<WarehouseSlip> list = new ArrayList<>();
        String select = "SELECT * FROM WarehouseSlip WHERE LoaiPhieu=? ORDER BY NgayLap DESC";
        try (Connection con = DBConnect.getConnection(); PreparedStatement pstmt = con.prepareStatement(select)) {
            pstmt.setString(1, loaiPhieu);
            try (ResultSet rs = pstmt.executeQuery()) {
                while (rs.next()) {
                    list.add(new WarehouseSlip(
                        rs.getInt("MaPhieuKho"), rs.getString("LoaiPhieu"),
                        rs.getTimestamp("NgayLap").toLocalDateTime(),
                        rs.getInt("NguoiLap"), rs.getString("GhiChu")
                    ));
                }
            }
        } catch (SQLException e) {
            e.printStackTrace();
        }
        return list;
    }

    public WarehouseSlip getWarehouseSlipById(int maPhieuKho) {
        String select = "SELECT * FROM WarehouseSlip WHERE MaPhieuKho=?";
        try (Connection con = DBConnect.getConnection(); PreparedStatement pstmt = con.prepareStatement(select)) {
            pstmt.setInt(1, maPhieuKho);
            try (ResultSet rs = pstmt.executeQuery()) {
                if (rs.next()) {
                    return new WarehouseSlip(
                        rs.getInt("MaPhieuKho"), rs.getString("LoaiPhieu"),
                        rs.getTimestamp("NgayLap").toLocalDateTime(),
                        rs.getInt("NguoiLap"), rs.getString("GhiChu")
                    );
                }
            }
        } catch (SQLException e) {
            e.printStackTrace();
        }
        return null;
    }
}
