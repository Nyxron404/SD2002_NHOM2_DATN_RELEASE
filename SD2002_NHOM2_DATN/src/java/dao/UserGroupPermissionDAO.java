/*
 * Click nbfs://nbhost/SystemFileSystem/Templates/Licenses/license-default.txt to change this license
 * Click nbfs://nbhost/SystemFileSystem/Templates/Classes/Class.java to edit this template
 */
package dao;

import java.util.List;
import java.sql.*;
import java.util.ArrayList;
import uril.DBConnect;

/**
 *
 * @author longd
 */
public class UserGroupPermissionDAO {

    public int InsertUGPS(String tenNhom, List<Integer> listMaQuyen) {
        String select = "SELECT MaNhom FROM UserGroup WHERE TenNhom = ?";
        String insert = "EXEC SP_InsertUGPS ?,?";
        try (Connection con = DBConnect.getConnection(); PreparedStatement pstmt = con.prepareStatement(select); PreparedStatement pstmt2 = con.prepareStatement(insert)) {
            pstmt.setString(1, tenNhom);
            ResultSet rs = pstmt.executeQuery();
            if (rs.next()) {
                int maNhom = rs.getInt("MaNhom");
                if (listMaQuyen.get(0) == 1) {
                    pstmt2.setInt(1, maNhom);
                    pstmt2.setInt(2, listMaQuyen.get(0));
                    pstmt2.executeUpdate();
                    return 1;
                } else {
                    for (Integer maQuyen : listMaQuyen) {
                        pstmt2.setInt(1, maNhom);
                        pstmt2.setInt(2, maQuyen);
                        pstmt2.executeUpdate();
                    }
                    return 1;
                }
            }
            return 0;
        } catch (SQLException e) {
            return 0;
        }
    }
    public List<Integer> SelectUGPS(int maNhom){
        String select = "SELECT MaQuyen FROM UserGroupPermission WHERE MaNhom = ?";
        List<Integer> listMaQuyen = new ArrayList<>();
        try(Connection con = DBConnect.getConnection(); PreparedStatement pstmt = con.prepareStatement(select)) {
            pstmt.setInt(1, maNhom);
            ResultSet rs = pstmt.executeQuery();
            while(rs.next()){
                int maQuyen = rs.getInt("MaQuyen");
                listMaQuyen.add(maQuyen);
            }
            return listMaQuyen;
        } catch (SQLException e) {
            return listMaQuyen;
        }
    }
    public int UpdateUGPS(int maNhom, List<Integer> listMaQuyen){
        String delete = "DELETE FROM UserGroupPermission WHERE MaNhom = ?";
        String update = "INSERT INTO UserGroupPermission VALUES (?,?);";
        try(Connection con = DBConnect.getConnection(); PreparedStatement pstmt = con.prepareStatement(delete);PreparedStatement pstmt2 = con.prepareStatement(update)) {
            pstmt.setInt(1, maNhom);
            pstmt.executeUpdate();
            pstmt2.setInt(1, maNhom);
            for (Integer maQuyen : listMaQuyen) {
                pstmt2.setInt(2, maQuyen);
                pstmt2.executeUpdate();
            }
            return 1;
        } catch (Exception e) {
            return 0;
        }
    }
}
