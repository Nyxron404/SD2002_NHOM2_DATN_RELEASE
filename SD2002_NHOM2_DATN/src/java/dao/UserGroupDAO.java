package dao;

import java.sql.*;
import java.util.ArrayList;
import java.util.List;
import models.UserGroup;
import uril.DBConnect;
import java.time.LocalDateTime;
/**
 *
 * @author longd
 */
public class UserGroupDAO {
    private List<UserGroup> listUserGroup;
    public UserGroupDAO(){
        listUserGroup = new ArrayList<>();
    }
    public List<UserGroup> SelectUserGroups() {
        listUserGroup.clear();
        String select = "SELECT * FROM UserGroup";
        try (Connection con = DBConnect.getConnection(); Statement stmt = con.createStatement()) {
            ResultSet rs = stmt.executeQuery(select);
            while (rs.next()) {
                int maNhom = rs.getInt("MaNhom");
                String tenNhom = rs.getString("TenNhom");
                String moTa = rs.getString("MoTa");
                LocalDateTime ngayTao = rs.getObject("NgayTao", LocalDateTime.class);
                boolean trangThai = rs.getBoolean("TrangThai");
                listUserGroup.add(new UserGroup(maNhom, tenNhom, moTa, ngayTao, trangThai));
            }
            return listUserGroup;
        } catch (SQLException e) {
            return listUserGroup;
        }
    }

    public int InsertUG(String tenNhom,String moTa) {
        String insert = "EXEC SP_InsertUG ?,?";
        try (Connection con = DBConnect.getConnection(); PreparedStatement pstmt = con.prepareStatement(insert)) {
            pstmt.setString(1, tenNhom);
            pstmt.setString(2, moTa);
            pstmt.executeUpdate();
            return 1;
        } catch (SQLException e) {
            return 0;
        }
    }
}