/*
 * Click nbfs://nbhost/SystemFileSystem/Templates/Licenses/license-default.txt to change this license
 * Click nbfs://nbhost/SystemFileSystem/Templates/Classes/Class.java to edit this template
 */
package dao;

import java.util.ArrayList;
import java.util.List;
import models.Staff;
import uril.DBConnect;
import java.sql.*;
import java.time.LocalDate;
/**
 *
 * @author longd
 */
public class StaffDAO {
    private List<Staff> listStaff;
    public StaffDAO(){
        listStaff = new ArrayList<>();
    }
    public List<Staff> SelectStaff(){
        String select = "SELECT * FROM Staff";
        try (Connection con = DBConnect.getConnection(); Statement stmt = con.createStatement()) {
            ResultSet rs = stmt.executeQuery(select);
            while (rs.next()) {                
                int MaNhanVien = rs.getInt("MaNhanVien");
                String HoTen = rs.getString("HoTen");
                LocalDate NgaySinh = rs.getObject("NgaySinh",LocalDate.class);
                boolean GioiTinh = rs.getBoolean("GioiTinh");
                String SDT = rs.getString("SDT");
                String Email = rs.getString("Email");
                String DiaChi = rs.getString("DiaChi");
                LocalDate NgayVaoLam = rs.getObject("NgayVaoLam",LocalDate.class);
                double Luong = rs.getDouble("Luong");
                int MaNguoiDung = rs.getInt("MaNguoiDung");
                boolean DangKy = rs.getBoolean("DangKy");
                listStaff.add(new Staff(MaNhanVien, HoTen, NgaySinh, GioiTinh, SDT, Email, DiaChi, NgayVaoLam, Luong, MaNguoiDung,DangKy));
            }
            return listStaff;
        } catch (SQLException e) {
            e.printStackTrace();
            return listStaff;
        }
    }
    
    public static void main(String[] args) {
        StaffDAO dao = new StaffDAO();
        
        System.out.println("--- ĐANG KẾT NỐI VÀ LẤY DỮ LIỆU ---");
        
        List<Staff> list = dao.SelectStaff();
        
        if (list.isEmpty()) {
            System.out.println("Kết quả: Danh sách trống! Kiểm tra lại kết nối hoặc câu query SQL.");
        } else {
            System.out.println("Kết quả: Tìm thấy " + list.size() + " nhân viên.");
            for (Staff st : list) {
                System.out.println("ID: " + st.getMaNhanVien() + " | Tên: " + st.getHoTen() + " | Email: " + st.getEmail());
            }
        }
        
        System.out.println("--- KẾT THÚC TEST ---");
    }
    
    public List<Staff> SelectStaff2(){
        String select = "SELECT * FROM Staff";
        try (Connection con = DBConnect.getConnection(); Statement stmt = con.createStatement()) {
            ResultSet rs = stmt.executeQuery(select);
            while (rs.next()) {                
                int MaNhanVien = rs.getInt("MaNhanVien");
                String HoTen = rs.getString("HoTen");
                boolean GioiTinh = rs.getBoolean("GioiTinh");
                String SDT = rs.getString("SDT");
                String Email = rs.getString("Email");
                listStaff.add(new Staff(MaNhanVien, HoTen, GioiTinh, SDT, Email));
            }
            return listStaff;
        } catch (SQLException e) {
            e.printStackTrace();
            return listStaff;
        }
    }
    
    public void InsertStaff(Staff st) {
        String insert = "INSERT INTO Staff (HoTen, NgaySinh, GioiTinh, SDT, Email, DiaChi, Luong) VALUES (?, ?, ?, ?, ?, ?, ?);";
        try (Connection con = DBConnect.getConnection(); 
            PreparedStatement pstmt = con.prepareStatement(insert)) {
            pstmt.setString(1, st.getHoTen());
            pstmt.setDate(2, java.sql.Date.valueOf(st.getNgaySinh()));
            pstmt.setBoolean(3, st.isGioiTinh());
            pstmt.setString(4, st.getSDT());
            pstmt.setString(5, st.getEmail());
            pstmt.setString(6, st.getDiaChi());
            pstmt.setDouble(7, st.getLuong());
            pstmt.executeUpdate();
        } catch (Exception e) {
            e.printStackTrace();
        }
    }
    
    public int CheckEmail(String Email){
        String checkEmail = "SELECT 1 FROM Staff WHERE Email = ? AND DangKy = 0";
        try(Connection con = DBConnect.getConnection();PreparedStatement pstmt = con.prepareStatement(checkEmail)) {
            pstmt.setString(1, Email);
            ResultSet rs = pstmt.executeQuery();
            if(rs.next()){
                return 1;
            }else{
                return 2;
            }
        } catch (SQLException e) {
            e.printStackTrace();
            return 0;
        }
    }
}
