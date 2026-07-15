/*
 * Click nbfs://nbhost/SystemFileSystem/Templates/Licenses/license-default.txt to change this license
 * Click nbfs://nbhost/SystemFileSystem/Templates/Classes/Class.java to edit this template
 */
package dao;

import java.sql.*;
import java.util.ArrayList;
import java.util.List;
import models.Permission;
import uril.DBConnect;

/**
 *
 * @author longd
 */
public class PermissionDAO {
    private List<Permission> listPermission;
    public PermissionDAO(){
        listPermission = new ArrayList<>();
    }
    public List<Permission> SelectPermission(){
        listPermission.clear();
        String select = "SELECT * FROM Permission";
        try(Connection con = DBConnect.getConnection(); Statement stmt = con.createStatement()) {
            ResultSet rs = stmt.executeQuery(select);
            while(rs.next()){
                int maQuyen = rs.getInt("MaQuyen");
                String tenQuyen = rs.getString("TenQuyen");
                String moTa = rs.getString("MoTa");
                boolean trangThai = rs.getBoolean("TrangThai");
                listPermission.add(new Permission(maQuyen, tenQuyen, moTa, trangThai));
            }
            return listPermission;
        } catch (SQLException e) {
            return listPermission;
        }
    }
}
