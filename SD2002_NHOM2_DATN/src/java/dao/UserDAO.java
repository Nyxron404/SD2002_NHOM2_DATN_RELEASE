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

    public UserDAO() {
        listUser = new ArrayList<>();
    }

    public List<User> SelectUser() {
        listUser.clear();
        String select = "SELECT * FROM [User]";
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

    public int CheckTenDangKy(String TenDangKy) {
        String checkTenDangKy = "SELECT 1 FROM [User] WHERE TenDangNhap = ?";
        try (Connection con = DBConnect.getConnection(); PreparedStatement pstmt = con.prepareStatement(checkTenDangKy)) {
            pstmt.setString(1, TenDangKy);
            ResultSet rs = pstmt.executeQuery();
            if (!rs.next()) {
                return 1;
            } else {
                return 3;
            }
        } catch (SQLException e) {
            return 0;
        }
    }

    public int InsertUser(String TenDangKy, String MatKhau, String Email) {
        String insert = ("EXEC SP_InsertUser ?,?,?");
        try (Connection con = DBConnect.getConnection(); PreparedStatement pstmt = con.prepareStatement(insert)) {
            pstmt.setString(1, TenDangKy);
            pstmt.setString(2, MatKhau);
            pstmt.setString(3, Email);
            pstmt.executeUpdate();
            return 1;
        } catch (SQLException e) {
            return 0;
        }
    }

    public int UpdateMaNguoiDung(int checkInsert, String TenDangKy, String Email) {
        String select = ("SELECT MaNguoiDung FROM [User] WHERE TenDangNhap = ?");
        String updateMaNguoiDung = ("EXEC SP_UpdateMaNguoiDung ?,?");
        try (Connection con = DBConnect.getConnection(); PreparedStatement pstmt = con.prepareStatement(select); PreparedStatement pstmt2 = con.prepareStatement(updateMaNguoiDung)) {
            if (checkInsert == 1) {
                pstmt.setString(1, TenDangKy);
                ResultSet rs = pstmt.executeQuery();
                if (rs.next()) {
                    int MaNguoiDung = rs.getInt("MaNguoiDung");
                    pstmt2.setString(1, Email);
                    pstmt2.setInt(2, MaNguoiDung);
                    pstmt2.executeUpdate();
                    return 1;
                }
            }
            return 0;
        } catch (SQLException e) {
            return 0;
        }
    }

    public List<String> GetLogin(String TenDangNhap, String MatKhau) {
        String select = "SELECT MaNhom FROM [User] WHERE TenDangNhap = ? AND MatKhau = ?";
        String select2 = "SELECT \n"
                + "	p.TenQuyen\n"
                + "FROM UserGroupPermission ugp INNER JOIN Permission p ON ugp.MaQuyen = p.MaQuyen\n"
                + "WHERE MaNhom = ?";
        List<String> QuyenHan = new ArrayList<>();
        try (Connection con = DBConnect.getConnection(); PreparedStatement pstmt = con.prepareStatement(select); PreparedStatement pstmt2 = con.prepareStatement(select2)) {
            pstmt.setString(1, TenDangNhap);
            pstmt.setString(2, MatKhau);
            ResultSet rs = pstmt.executeQuery();
            if(rs.next()){
                pstmt2.setInt(1, rs.getInt("MaNhom"));
                ResultSet rs2 = pstmt2.executeQuery();
                while (rs2.next()) {                    
                    QuyenHan.add(rs2.getString("TenQuyen"));
                }
                return QuyenHan;
            }
            return QuyenHan;
        } catch (SQLException e) {
            return QuyenHan;
        }
    }
}
