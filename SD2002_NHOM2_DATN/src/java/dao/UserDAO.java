/*
 * Click nbfs://nbhost/SystemFileSystem/Templates/Licenses/license-default.txt to change this license
 * Click nbfs://nbhost/SystemFileSystem/Templates/Classes/Class.java to edit this template
 */
package dao;

import java.sql.*;
import java.util.ArrayList;
import java.util.List;
import models.User;
import uril.DBConnect;
import java.time.LocalDateTime;
/**
 *
 * @author longd
 */
public class UserDAO {
    private List<User> listUser;
    public UserDAO(){
        listUser = new ArrayList<>();
    }
    public List<User> SelectUser(){
        String select = "SELECT * FROM User";
        try (Connection con = DBConnect.getConnection(); Statement stmt = con.createStatement()) {
            ResultSet rs = stmt.executeQuery(select);
            while (rs.next()) {                
                int MaNguoiDung = rs.getInt("MaNguoiDung");
                String TenDangNhap = rs.getString("TenDangNhap");
                String MatKhau = rs.getString("MatKhau");
                int MaNhom = rs.getInt("MaNhom");
                boolean TrangThai = rs.getBoolean("TrangThai");
                LocalDateTime NgayTao = rs.getObject("NgayTao", LocalDateTime.class);
                listUser.add(new User(MaNguoiDung, TenDangNhap, MatKhau, MaNhom, TrangThai, NgayTao));
            }
            return listUser;
        } catch (SQLException e) {
            return listUser;
        }
    }
    
    public int CheckTenDangKy(String TenDangKy){
        String checkTenDangKy = "SELECT 1 FROM User WHERE TenDangNhap = ?";
        try(Connection con = DBConnect.getConnection();PreparedStatement pstmt = con.prepareStatement(checkTenDangKy)) {
            pstmt.setString(1, TenDangKy);
            ResultSet rs = pstmt.executeQuery();
            if(!rs.next()){
                return 1;
            }else{
                return 3;
            }
        } catch (SQLException e) {
            return 0;
        }
    }
    
    public void InsertUser(String TenDangKy, String MatKhau){
        String insert = ("EXEC SP_InsertUser ?,?");
        try(Connection con = DBConnect.getConnection();PreparedStatement pstmt = con.prepareStatement(insert)) {
            pstmt.setString(1, TenDangKy);
            pstmt.setString(2, MatKhau);
            pstmt.executeUpdate();
            return;
        } catch (SQLException e) {
            return;
        }
    }
}
