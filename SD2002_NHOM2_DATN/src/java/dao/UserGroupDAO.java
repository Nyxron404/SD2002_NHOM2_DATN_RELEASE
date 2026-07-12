package dao;

import java.sql.*;
import java.util.ArrayList;
import java.util.List;
import models.UserGroup;
import uril.DBConnect;

/**
 *
 * @author longd
 */
public class UserGroupDAO {
    
    // 1. Lấy toàn bộ danh sách Nhóm người dùng để in ra web (thay vì code cứng Option 1, 2, 3)
    public List<UserGroup> SelectAllGroups() {
        List<UserGroup> listGroup = new ArrayList<>();
        String sql = "SELECT * FROM UserGroup";
        try (Connection con = DBConnect.getConnection(); Statement stmt = con.createStatement()) {
            ResultSet rs = stmt.executeQuery(sql);
            while (rs.next()) {
                UserGroup ug = new UserGroup();
                ug.setMaNhom(rs.getInt("MaNhom"));
                ug.setTenNhom(rs.getString("TenNhom"));
                ug.setMoTa(rs.getString("MoTa"));
                ug.setTrangThai(rs.getBoolean("TrangThai"));
                listGroup.add(ug);
            }
        } catch (SQLException e) {
            e.printStackTrace();
        }
        return listGroup;
    }

    // 2. Tạo một Nhóm mới toanh (Ví dụ: "Nhóm của Linh") và trả về Mã Nhóm vừa tạo
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