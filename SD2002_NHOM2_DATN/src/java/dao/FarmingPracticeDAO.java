/*
 * Click nbfs://nbhost/SystemFileSystem/Templates/Licenses/license-default.txt to change this license
 * Click nbfs://nbhost/SystemFileSystem/Templates/Classes/Class.java to edit this template
 */
package dao;

import java.sql.Connection;
import java.sql.PreparedStatement;
import java.sql.ResultSet;
import java.sql.Date;
import java.time.LocalDate;
import java.util.ArrayList;
import java.util.List;
import models.FarmingPractice; 
import uril.DBConnect;       

public class FarmingPracticeDAO {

    // 1. Lấy toàn bộ danh sách quy trình về hiển thị lên bảng
    public List<FarmingPractice> getAllFarmingPractices() {
        List<FarmingPractice> list = new ArrayList<>();
        String sql = "SELECT * FROM FarmingPractice";
        
        try (Connection conn = DBConnect.getConnection(); 
             PreparedStatement ps = conn.prepareStatement(sql);
             ResultSet rs = ps.executeQuery()) {
            
            while (rs.next()) {
                FarmingPractice fp = new FarmingPractice();
                fp.setMaQuyTrinh(rs.getInt("MaQuyTrinh"));
                fp.setTenQuyTrinh(rs.getString("TenQuyTrinh"));
                fp.setMoTa(rs.getString("MoTa"));
                
                // Chuyển đổi từ sql.Date sang java.time.LocalDate
                Date sqlDate = rs.getDate("NgayTao");
                if (sqlDate != null) {
                    fp.setNgayTao(sqlDate.toLocalDate());
                }
                
                fp.setNguoiTao(rs.getInt("NguoiTao"));
                fp.setTrangThai(rs.getBoolean("TrangThai"));
                list.add(fp);
            }
        } catch (Exception e) {
            e.printStackTrace();
        }
        return list;
    }

    // 2. Thêm mới một quy trình canh tác bản nháp
    public boolean insertFarmingPractice(FarmingPractice fp) {
        String sql = "INSERT INTO FarmingPractice (TenQuyTrinh, MoTa, NgayTao, NguoiTao, TrangThai) VALUES (?, ?, ?, ?, ?)";
        
        try (Connection conn = DBConnect.getConnection();
             PreparedStatement ps = conn.prepareStatement(sql)) {
            
            ps.setString(1, fp.getTenQuyTrinh());
            ps.setString(2, fp.getMoTa());
            
            // Gán ngày tạo mặc định là ngày hôm nay nếu đối tượng truyền vào bị null
            LocalDate ngayTao = fp.getNgayTao() != null ? fp.getNgayTao() : LocalDate.now();
            ps.setDate(3, Date.valueOf(ngayTao));
            
            ps.setInt(4, fp.getNguoiTao());
            ps.setBoolean(5, false); // Mặc định false đại diện cho trạng thái "Bản nháp"
            
            int rowAffected = ps.executeUpdate();
            return rowAffected > 0;
        } catch (Exception e) {
            e.printStackTrace();
        }
        return false;
    }
    
    
    public boolean deleteFarmingPractice(int maQuyTrinh) {
    String sql = "DELETE FROM FarmingPractice WHERE MaQuyTrinh = ?";
    try (Connection conn = DBConnect.getConnection(); // Thay bằng cách lấy connection của dự án bạn
         PreparedStatement ps = conn.prepareStatement(sql)) {
        ps.setInt(1, maQuyTrinh);
        return ps.executeUpdate() > 0;
    } catch (Exception e) {
        e.printStackTrace();
    }
    return false;
    }
    
    public boolean updateFarmingPractice(int id, String tenQuyTrinh, String moTa, String trangThai) {
    String sql = "UPDATE FarmingPractice SET TenQuyTrinh = ?, MoTa = ?, TrangThai = ? WHERE MaQuyTrinh = ?";
    try (Connection conn = DBConnect.getConnection();
         PreparedStatement ps = conn.prepareStatement(sql)) {
        ps.setString(1, tenQuyTrinh);
        ps.setString(2, moTa);
        ps.setString(3, trangThai);
        ps.setInt(4, id);
        return ps.executeUpdate() > 0;
    } catch (Exception e) {
        e.printStackTrace();
    }
    return false;
    }
}