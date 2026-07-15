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
    public List<UserGroup> SelectAllGroups() {
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

    public int InsertNewGroup(String tenNhom, String moTa) {
        String sql = "INSERT INTO UserGroup (TenNhom, MoTa, NgayTao, TrangThai) VALUES (?, ?, GETDATE(), 1)";
        try (Connection con = DBConnect.getConnection(); 
             PreparedStatement pstmt = con.prepareStatement(sql, Statement.RETURN_GENERATED_KEYS)) {
            
            pstmt.setString(1, tenNhom);
            pstmt.setString(2, moTa);
            pstmt.executeUpdate();
            
            // Lấy ID của Nhóm vừa tạo ra để gán luôn cho Nhân viên
            ResultSet rs = pstmt.getGeneratedKeys();
            if (rs.next()) {
                return rs.getInt(1); 
            }
        } catch (SQLException e) {
            e.printStackTrace();
        }
        return 0; // Thất bại
    }
}