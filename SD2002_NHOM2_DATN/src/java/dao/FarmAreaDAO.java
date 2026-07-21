package dao;

import java.sql.Connection;
import java.sql.PreparedStatement;
import java.sql.ResultSet;
import java.util.ArrayList;
import java.util.List;
import uril.DBConnect;
import models.FarmArea;

public class FarmAreaDAO {

    public List<FarmArea> getAllFarmAreas() {
        List<FarmArea> list = new ArrayList<>();
        String sql = "SELECT MaKhuVuc, TenKhuVuc FROM FarmArea";
        try (Connection con = DBConnect.getConnection(); PreparedStatement ps = con.prepareStatement(sql)) {
            ResultSet rs = ps.executeQuery();
            while (rs.next()) {
                FarmArea fa = new FarmArea();
                fa.setMaKhuVuc(rs.getInt("MaKhuVuc"));
                fa.setTenKhuVuc(rs.getString("TenKhuVuc"));
                list.add(fa);
            }
        } catch (Exception e) {
            e.printStackTrace();
        }
        return list;
    }
}