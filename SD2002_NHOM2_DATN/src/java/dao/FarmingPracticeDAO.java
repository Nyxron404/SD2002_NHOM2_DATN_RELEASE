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
                fp.setLoaiApDung(rs.getString("LoaiApDung"));
                
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

    public boolean insertFarmingPractice(FarmingPractice fp) {
        String sql = "INSERT INTO FarmingPractice (TenQuyTrinh, MoTa, LoaiApDung, NgayTao, NguoiTao, TrangThai) VALUES (?, ?, ?, ?, ?, ?)";
        
        try (Connection conn = DBConnect.getConnection();
             PreparedStatement ps = conn.prepareStatement(sql)) {
            
            ps.setString(1, fp.getTenQuyTrinh());
            ps.setString(2, fp.getMoTa());
            ps.setString(3, fp.getLoaiApDung());
            
            LocalDate ngayTao = fp.getNgayTao() != null ? fp.getNgayTao() : LocalDate.now();
            ps.setDate(4, Date.valueOf(ngayTao));
            
            ps.setInt(5, fp.getNguoiTao());
            ps.setBoolean(6, false);
            
            int rowAffected = ps.executeUpdate();
            return rowAffected > 0;
        } catch (Exception e) {
            e.printStackTrace();
        }
        return false;
    }
    
    public boolean deleteFarmingPractice(int maQuyTrinh) {
        String sql = "DELETE FROM FarmingPractice WHERE MaQuyTrinh = ?";
        try (Connection conn = DBConnect.getConnection();
             PreparedStatement ps = conn.prepareStatement(sql)) {
            ps.setInt(1, maQuyTrinh);
            return ps.executeUpdate() > 0;
        } catch (Exception e) {
            e.printStackTrace();
        }
        return false;
    }
    
    public boolean updateFarmingPractice(int id, String tenQuyTrinh, String moTa, String loaiApDung, String trangThai) {
        String sql = "UPDATE FarmingPractice SET TenQuyTrinh = ?, MoTa = ?, LoaiApDung = ?, TrangThai = ? WHERE MaQuyTrinh = ?";
        try (Connection conn = DBConnect.getConnection();
             PreparedStatement ps = conn.prepareStatement(sql)) {
            ps.setString(1, tenQuyTrinh);
            ps.setString(2, moTa);
            ps.setString(3, loaiApDung);
            ps.setString(4, trangThai);
            ps.setInt(5, id);
            return ps.executeUpdate() > 0;
        } catch (Exception e) {
            e.printStackTrace();
        }
        return false;
    }
}