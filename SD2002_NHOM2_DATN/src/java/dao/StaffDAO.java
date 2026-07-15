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
        listStaff.clear();
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
            return listStaff;
        }
    }
    
    // Viết thêm hàm mới: Chỉ nối 2 bảng Staff và User để lấy MaNhom
    public List<Staff> SelectStaffAndGroup() {
        // Tạo hẳn 1 cái list mới như bạn muốn
        List<Staff> newList = new ArrayList<>(); 
        
        // Câu SELECT ngắn gọn nối đúng 2 bảng
        String select = "SELECT s.*, u.MaNhom, u.TrangThai FROM Staff s LEFT JOIN [User] u ON s.MaNguoiDung = u.MaNguoiDung";
        
        try (Connection con = DBConnect.getConnection(); Statement stmt = con.createStatement()) {
            ResultSet rs = stmt.executeQuery(select);
            while (rs.next()) {                
                int maNhanVien = rs.getInt("MaNhanVien");
                String hoTen = rs.getString("HoTen");
                LocalDate ngaySinh = rs.getObject("NgaySinh", LocalDate.class);
                boolean gioiTinh = rs.getBoolean("GioiTinh");
                String sdt = rs.getString("SDT");
                String email = rs.getString("Email");
                String diaChi = rs.getString("DiaChi");
                LocalDate ngayVaoLam = rs.getObject("NgayVaoLam", LocalDate.class);
                double luong = rs.getDouble("Luong");
                int maNguoiDung = rs.getInt("MaNguoiDung");
                boolean dangKy = rs.getBoolean("DangKy");
                boolean trangThai = rs.getBoolean("TrangThai");
                
                // Lấy thẳng Mã nhóm từ câu JOIN
                int maNhom = rs.getInt("MaNhom"); 
                
                // Khởi tạo Staff với data gốc
                Staff st = new Staff(maNhanVien, hoTen, ngaySinh, gioiTinh, sdt, email, diaChi, ngayVaoLam, luong, maNguoiDung, dangKy);
                
                // Nhét thêm Mã nhóm vào (Bạn nhớ thêm biến MaNhom và setMaNhom() trong file Model Staff nhé)
                st.setMaNhom(maNhom);
                
                st.setDanhSachQuyen(GetDanhSachQuyen(maNhom));
                
                st.setDangKy(trangThai);
                
                newList.add(st);
            }
        } catch (SQLException e) {
            e.printStackTrace();
        }
        return newList;
    }
    
    // Hàm phụ: Lấy tất cả quyền gộp thành 1 chuỗi (VD: "Admin, HR") dựa vào Mã Nhóm
    public String GetDanhSachQuyen(int maNhom) {
        if (maNhom == 0) return "Chưa phân quyền";
        
        String sql = "SELECT p.TenQuyen FROM UserGroupPermission ugp "
                   + "INNER JOIN Permission p ON ugp.MaQuyen = p.MaQuyen "
                   + "WHERE ugp.MaNhom = ?";
                   
        List<String> listQuyen = new ArrayList<>();
        try (Connection con = DBConnect.getConnection(); PreparedStatement pstmt = con.prepareStatement(sql)) {
            pstmt.setInt(1, maNhom);
            ResultSet rs = pstmt.executeQuery();
            while (rs.next()) {
                listQuyen.add(rs.getString("TenQuyen"));
            }
        } catch (SQLException e) {
            e.printStackTrace();
        }
        
        if (listQuyen.isEmpty()) {
            return "Chưa phân quyền";
        }
        return String.join(", ", listQuyen); 
    }
    
    // Hàm cập nhật danh sách quyền từ Web xuống SQL
    public void UpdateGroupPermissions(int maNhom, String[] maQuyenList) {
        String delete = "DELETE FROM UserGroupPermission WHERE MaNhom = ?";
        String insert = "INSERT INTO UserGroupPermission (MaNhom, MaQuyen) VALUES (?, ?)";

        try (Connection con = DBConnect.getConnection()) {
            // Bước 1: Xóa trắng tất cả quyền cũ của Nhóm này
            try (PreparedStatement pstmtDel = con.prepareStatement(delete)) {
                pstmtDel.setInt(1, maNhom);
                pstmtDel.executeUpdate();
            }

            // Bước 2: Duyệt vòng lặp để Insert từng quyền mới (nếu có tick chọn)
            if (maQuyenList != null && maQuyenList.length > 0) {
                try (PreparedStatement pstmtIns = con.prepareStatement(insert)) {
                    for (String quyen : maQuyenList) {
                        pstmtIns.setInt(1, maNhom);
                        pstmtIns.setInt(2, Integer.parseInt(quyen)); // MaQuyen gửi từ Checkbox
                        pstmtIns.executeUpdate();
                    }
                }
            }
        } catch (Exception e) {
            e.printStackTrace();
        }
    }
    
    // Hàm tạo tài khoản nháp và gán nhóm cho nhân viên mới
    public void CreateDraftUser(int maNhanVien, int maNhom) {
        // Tạo User nháp (TenDangNhap là DRAFT_ID để không bị trùng, chờ đăng ký)
        String insertUser = "INSERT INTO [User] (TenDangNhap, MatKhau, MaNhom, TrangThai) VALUES (?, 'DRAFT', ?, 1)";
        String updateStaff = "UPDATE Staff SET MaNguoiDung = ? WHERE MaNhanVien = ?";
        
        try (Connection con = DBConnect.getConnection()) {
            // Thêm User và lấy ID tự tăng (MaNguoiDung)
            PreparedStatement pstmt1 = con.prepareStatement(insertUser, Statement.RETURN_GENERATED_KEYS);
            pstmt1.setString(1, "DRAFT_" + maNhanVien);
            pstmt1.setInt(2, maNhom);
            pstmt1.executeUpdate();
            
            ResultSet rs = pstmt1.getGeneratedKeys();
            if (rs.next()) {
                int newMaNguoiDung = rs.getInt(1); // Lấy Mã Người Dùng vừa sinh ra
                
                // Gắn MaNguoiDung đó ngược lại cho bảng Staff
                PreparedStatement pstmt2 = con.prepareStatement(updateStaff);
                pstmt2.setInt(1, newMaNguoiDung);
                pstmt2.setInt(2, maNhanVien);
                pstmt2.executeUpdate();
            }
        } catch (SQLException e) {
            e.printStackTrace();
        }
    }
    
    // Thêm hàm này để cập nhật Mã Nhóm mới cho nhân viên đã có tài khoản
    public void UpdateStaffGroup(int maNguoiDung, int newMaNhom) {
        String sql = "UPDATE [User] SET MaNhom = ? WHERE MaNguoiDung = ?";
        try (Connection con = DBConnect.getConnection(); PreparedStatement pstmt = con.prepareStatement(sql)) {
            pstmt.setInt(1, newMaNhom);
            pstmt.setInt(2, maNguoiDung);
            pstmt.executeUpdate();
        } catch (Exception e) {
            e.printStackTrace();
        }
    }
    
    // Hàm sửa thông tin nhân viên
    public void UpdateStaff(Staff st) {
        String sql = "UPDATE Staff SET HoTen=?, NgaySinh=?, GioiTinh=?, SDT=?, Email=?, DiaChi=?, Luong=? WHERE MaNhanVien=?";
        try (Connection con = DBConnect.getConnection(); PreparedStatement pstmt = con.prepareStatement(sql)) {
            pstmt.setString(1, st.getHoTen());
            pstmt.setDate(2, java.sql.Date.valueOf(st.getNgaySinh()));
            pstmt.setBoolean(3, st.isGioiTinh());
            pstmt.setString(4, st.getSDT());
            pstmt.setString(5, st.getEmail());
            pstmt.setString(6, st.getDiaChi());
            pstmt.setDouble(7, st.getLuong());
            pstmt.setInt(8, st.getMaNhanVien());
            pstmt.executeUpdate();
        } catch (Exception e) { e.printStackTrace(); }
    }

    // Hàm Khóa/Mở khóa dựa vào cột TrangThai (Boolean) trong bảng [User]
    public void UpdateStaffStatus(int maNguoiDung, boolean trangThai) {
        String sql = "UPDATE [User] SET TrangThai = ? WHERE MaNguoiDung = ?";
        try (Connection con = DBConnect.getConnection(); PreparedStatement pstmt = con.prepareStatement(sql)) {
            pstmt.setBoolean(1, trangThai); // true: bình thường, false: khóa
            pstmt.setInt(2, maNguoiDung);
            pstmt.executeUpdate();
        } catch (Exception e) { e.printStackTrace(); }
    }
    
    // 1. Sửa lại hàm InsertStaff: Trả về boolean (true/false) và in lỗi ra log
    public boolean InsertStaff(Staff st) {
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
            
            int rows = pstmt.executeUpdate();
            return rows > 0; // Trả về true nếu có dữ liệu thêm vào DB
        } catch (Exception e) {
            e.printStackTrace(); // In lỗi đỏ ra NetBeans để bạn biết sai chỗ nào
            return false; // Trả về false để báo cho hệ thống biết là THẤT BẠI
        }
    }
    
    // 2. Sửa lại hàm CheckEmail: Bỏ cái "AND DangKy = 0" đi để quét toàn bộ hệ thống
    public int CheckEmail(String Email){
        String checkEmail = "SELECT 1 FROM Staff WHERE Email = ?";
        try(Connection con = DBConnect.getConnection();PreparedStatement pstmt = con.prepareStatement(checkEmail)) {
            pstmt.setString(1, Email);
            ResultSet rs = pstmt.executeQuery();
            if(rs.next()){
                return 1; // Đã tồn tại
            }else{
                return 2; // Hợp lệ
            }
        } catch (SQLException e) {
            e.printStackTrace();
            return 0;
        }
    }

    // 3. Thêm hàm CheckSDT hoàn toàn mới
    public int CheckSDT(String SDT){
        String checkSDT = "SELECT 1 FROM Staff WHERE SDT = ?";
        try(Connection con = DBConnect.getConnection(); PreparedStatement pstmt = con.prepareStatement(checkSDT)) {
            pstmt.setString(1, SDT);
            ResultSet rs = pstmt.executeQuery();
            if(rs.next()){
                return 1; // Đã tồn tại
            }else{
                return 2; // Hợp lệ
            }
        } catch (SQLException e) {
            e.printStackTrace();
            return 0;
        }
    }
}
