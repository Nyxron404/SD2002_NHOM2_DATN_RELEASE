/*
 * Click nbfs://nbhost/SystemFileSystem/Templates/Licenses/license-default.txt to change this license
 * Click nbfs://nbhost/SystemFileSystem/Templates/Classes/Class.java to edit this template
 */
package dao;

import java.util.List;
import java.sql.*;
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

}
