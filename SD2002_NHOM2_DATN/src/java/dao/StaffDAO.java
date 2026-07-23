/*
 * Click nbfs://nbhost/SystemFileSystem/Templates/Licenses/license-default.txt to change this license
 * Click nbfs://nbhost/SystemFileSystem/Templates/Classes/Class.java to edit this template
 */
package dao;

import java.util.Properties;
import java.util.Random;
import jakarta.mail.Authenticator;
import jakarta.mail.Message;
import jakarta.mail.PasswordAuthentication;
import jakarta.mail.Session;
import jakarta.mail.Transport;
import jakarta.mail.internet.InternetAddress;
import jakarta.mail.internet.MimeMessage;
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

    public StaffDAO() {
        listStaff = new ArrayList<>();
    }

    public List<Staff> SelectStaff() {
        listStaff.clear();
        String select = "SELECT * FROM Staff";
        try (Connection con = DBConnect.getConnection(); Statement stmt = con.createStatement()) {
            ResultSet rs = stmt.executeQuery(select);
            while (rs.next()) {
                int MaNhanVien = rs.getInt("MaNhanVien");
                String HoTen = rs.getString("HoTen");
                LocalDate NgaySinh = rs.getObject("NgaySinh", LocalDate.class);
                boolean GioiTinh = rs.getBoolean("GioiTinh");
                String SDT = rs.getString("SDT");
                String Email = rs.getString("Email");
                String DiaChi = rs.getString("DiaChi");
                LocalDate NgayVaoLam = rs.getObject("NgayVaoLam", LocalDate.class);
                double Luong = rs.getDouble("Luong");
                int MaNguoiDung = rs.getInt("MaNguoiDung");
                boolean DangKy = rs.getBoolean("DangKy");
                listStaff.add(new Staff(MaNhanVien, HoTen, NgaySinh, GioiTinh, SDT, Email, DiaChi, NgayVaoLam, Luong, MaNguoiDung, DangKy));
            }
            return listStaff;
        } catch (SQLException e) {
            return listStaff;
        }
    }

    // Viết thêm hàm mới: Chỉ nối 2 bảng Staff và User để lấy MaNhom
    public List<Staff> SelectStaffAndGroup() {
        List<Staff> newList = new ArrayList<>();

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

                st.setMaNhom(maNhom);

                st.setDanhSachQuyen(GetDanhSachQuyen(maNhom));

                newList.add(st);
            }
        } catch (SQLException e) {
            e.printStackTrace();
        }
        return newList;
    }

    public String GetDanhSachQuyen(int maNhom) {
        if (maNhom == 0) {
            return "Chưa phân quyền";
        }

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
            try (PreparedStatement pstmtDel = con.prepareStatement(delete)) {
                pstmtDel.setInt(1, maNhom);
                pstmtDel.executeUpdate();
            }

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

    public String removeAccents(String str) {
        if (str == null) {
            return "";
        }
        String temp = java.text.Normalizer.normalize(str, java.text.Normalizer.Form.NFD);
        java.util.regex.Pattern pattern = java.util.regex.Pattern.compile("\\p{InCombiningDiacriticalMarks}+");
        return pattern.matcher(temp).replaceAll("").replace("Đ", "D").replace("đ", "d");
    }

    public String generateUsername(String fullName) {
        if (fullName == null || fullName.trim().isEmpty()) {
            return "";
        }

        String unaccented = removeAccents(fullName.trim().toLowerCase());
        String[] words = unaccented.split("\\s+");

        if (words.length == 1) {
            return words[0].substring(0, 1).toUpperCase() + words[0].substring(1);
        }

        String firstName = words[words.length - 1];
        String capitalizedName = firstName.substring(0, 1).toUpperCase() + firstName.substring(1);

        StringBuilder username = new StringBuilder(capitalizedName);

        for (int i = 0; i < words.length - 1; i++) {
            username.append(words[i].charAt(0));
        }

        return username.toString();
    }

    private boolean checkUsernameExists(String username) {
        String sql = "SELECT 1 FROM [User] WHERE TenDangNhap = ?";
        try (Connection con = DBConnect.getConnection(); PreparedStatement ps = con.prepareStatement(sql)) {
            ps.setString(1, username);
            ResultSet rs = ps.executeQuery();
            return rs.next();
        } catch (Exception e) {
            e.printStackTrace();
        }
        return false;
    }

    public String generateRandomPassword() {
        Random rnd = new Random();
        int number = 100000000 + rnd.nextInt(900000000);
        return String.valueOf(number);
    }

    public void sendEmail(String toEmail, String username, String password) {
        final String fromEmail = "smartfarmmanage@gmail.com";
        final String appPassword = "grxhduafxftczxjm";

        Properties props = new Properties();
        props.put("mail.smtp.host", "smtp.gmail.com");
        props.put("mail.smtp.port", "587");
        props.put("mail.smtp.auth", "true");
        props.put("mail.smtp.starttls.enable", "true");

        Session session = Session.getInstance(props, new Authenticator() {
            @Override
            protected PasswordAuthentication getPasswordAuthentication() {
                return new PasswordAuthentication(fromEmail, appPassword);
            }
        });

        try {
            Message message = new MimeMessage(session);
            message.setFrom(new InternetAddress(fromEmail));
            message.setRecipients(Message.RecipientType.TO, InternetAddress.parse(toEmail));
            message.setSubject("THÔNG TIN TÀI KHOẢN SMART FARM");

            String noiDungHtml = "<div style='font-family: Arial, sans-serif; line-height: 1.6; color: #333;'>"
                    + "<h2 style='color: #2e7d32;'>Chào mừng bạn gia nhập Smart Farm!</h2>"
                    + "<p>Chào bạn, tài khoản làm việc của bạn trên hệ thống đã được thiết lập thành công.</p>"
                    + "<div style='background-color: #f9f9f9; padding: 15px; border-left: 5px solid #2e7d32; border-radius: 5px;'>"
                    + "<strong>Tên đăng nhập:</strong> <span style='color: #d35400; font-size: 18px;'>" + username + "</span><br>"
                    + "<strong>Mật khẩu:</strong> <span style='color: #d35400; font-size: 18px;'>" + password + "</span>"
                    + "</div>"
                    + "<p>Vui lòng đăng nhập và <b>đổi mật khẩu ngay</b> trong lần đầu tiên sử dụng.</p>"
                    + "<p style='color: #c0392b;'><strong>⚠️ Lưu ý bảo mật:</strong> Tuyệt đối không chia sẻ mật khẩu này với bất kỳ ai để đảm bảo an toàn cho tài khoản cá nhân của bạn.</p>"
                    + "<hr style='border: 0; border-top: 1px solid #eee;'>"
                    + "<p>Nếu bạn cần hỗ trợ, vui lòng liên hệ bộ phận Kỹ thuật qua email: "
                    + "<a href='mailto:longdazng@gmail.com'>longdazng@gmail.com</a> hoặc "
                    + "<a href='mailto:linhhqth08598@gmail.com'>linhhqth08598@gmail.com</a>.</p>"
                    + "<p style='font-size: 12px; color: #777;'><i>Lưu ý: Đây là email tự động, vui lòng không phản hồi thư này.</i></p>"
                    + "<p>Trân trọng,<br><b>Ban Quản Trị Smart Farm</b></p>"
                    + "</div>";

            message.setContent(noiDungHtml, "text/html; charset=UTF-8");

            Transport.send(message);
            System.out.println("Đã gửi email thành công tới: " + toEmail);
        } catch (Exception e) {
            e.printStackTrace();
        }
    }

    public void CreateDraftUser(int maNhanVien, int maNhom) {
        String hoTen = "";
        String email = "";

        String getInfoSql = "SELECT HoTen, Email FROM Staff WHERE MaNhanVien = ?";
        try (Connection con = DBConnect.getConnection(); PreparedStatement ps = con.prepareStatement(getInfoSql)) {
            ps.setInt(1, maNhanVien);
            ResultSet rs = ps.executeQuery();
            if (rs.next()) {
                hoTen = rs.getString("HoTen");
                email = rs.getString("Email");
            }
        } catch (Exception e) {
            e.printStackTrace();
        }

        String baseUsername = generateUsername(hoTen);
        String finalUsername = baseUsername;
        int counter = 1;
        while (checkUsernameExists(finalUsername)) {
            finalUsername = baseUsername + counter;
            counter++;
        }

        String randomPassword = generateRandomPassword();

        String insertUser = "INSERT INTO [User] (TenDangNhap, MatKhau, MaNhom, TrangThai) VALUES (?, ?, ?, 1)";
        String updateStaff = "UPDATE Staff SET MaNguoiDung = ? WHERE MaNhanVien = ?";

        try (Connection con = DBConnect.getConnection()) {
            PreparedStatement pstmt1 = con.prepareStatement(insertUser, Statement.RETURN_GENERATED_KEYS);
            pstmt1.setString(1, finalUsername);
            pstmt1.setString(2, randomPassword);
            pstmt1.setInt(3, maNhom);
            pstmt1.executeUpdate();

            ResultSet rs = pstmt1.getGeneratedKeys();
            if (rs.next()) {
                int newMaNguoiDung = rs.getInt(1);

                PreparedStatement pstmt2 = con.prepareStatement(updateStaff);
                pstmt2.setInt(1, newMaNguoiDung);
                pstmt2.setInt(2, maNhanVien);

                int rowUpdated = pstmt2.executeUpdate();
                if (rowUpdated > 0 && email != null && !email.trim().isEmpty()) {
                    sendEmail(email, finalUsername, randomPassword); // Gọi trực tiếp, không dùng Thread nếu đang test
                }
            }
        } catch (SQLException e) {
            e.printStackTrace();
        }
    }

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
        } catch (Exception e) {
            e.printStackTrace();
        }
    }

    public void UpdateStaffStatus(int maNguoiDung, boolean trangThai) {
        String sql = "UPDATE [User] SET TrangThai = ? WHERE MaNguoiDung = ?";
        try (Connection con = DBConnect.getConnection(); PreparedStatement pstmt = con.prepareStatement(sql)) {
            pstmt.setBoolean(1, trangThai); // true: bình thường, false: khóa
            pstmt.setInt(2, maNguoiDung);
            pstmt.executeUpdate();
        } catch (Exception e) {
            e.printStackTrace();
        }
    }

    public int InsertStaff(Staff st) {
        String insert = "INSERT INTO Staff (HoTen, NgaySinh, GioiTinh, SDT, Email, DiaChi, Luong, DangKy) VALUES (?, ?, ?, ?, ?, ?, ?, 1);";
        
        try (Connection con = DBConnect.getConnection(); PreparedStatement pstmt = con.prepareStatement(insert, Statement.RETURN_GENERATED_KEYS)) {

            pstmt.setString(1, st.getHoTen());
            pstmt.setDate(2, java.sql.Date.valueOf(st.getNgaySinh()));
            pstmt.setBoolean(3, st.isGioiTinh());
            pstmt.setString(4, st.getSDT());
            pstmt.setString(5, st.getEmail());
            pstmt.setString(6, st.getDiaChi());
            pstmt.setDouble(7, st.getLuong());

            int rows = pstmt.executeUpdate();
            if (rows > 0) {
                // Lấy Mã Nhân Viên vừa được tự động tăng trong SQL
                ResultSet rs = pstmt.getGeneratedKeys();
                if (rs.next()) {
                    return rs.getInt(1); // Trả về MaNhanVien mới
                }
            }
            return 0; // Thất bại
        } catch (Exception e) {
            e.printStackTrace();
            return 0; // Thất bại
        }
    }

    public int CheckEmail(String Email) {
        String checkEmail = "SELECT 1 FROM Staff WHERE Email = ?";
        try (Connection con = DBConnect.getConnection(); PreparedStatement pstmt = con.prepareStatement(checkEmail)) {
            pstmt.setString(1, Email);
            ResultSet rs = pstmt.executeQuery();
            if (rs.next()) {
                return 1;
            } else {
                return 2;
            }
        } catch (SQLException e) {
            e.printStackTrace();
            return 0;
        }
    }

    public int CheckSDT(String SDT) {
        String checkSDT = "SELECT 1 FROM Staff WHERE SDT = ?";
        try (Connection con = DBConnect.getConnection(); PreparedStatement pstmt = con.prepareStatement(checkSDT)) {
            pstmt.setString(1, SDT);
            ResultSet rs = pstmt.executeQuery();
            if (rs.next()) {
                return 1;
            } else {
                return 2;
            }
        } catch (SQLException e) {
            e.printStackTrace();
            return 0;
        }
    }

    public boolean DeleteStaff(int maNhanVien, int maNguoiDung) {
        String deleteStaff = "DELETE FROM Staff WHERE MaNhanVien = ?";
        String deleteUser = "DELETE FROM [User] WHERE MaNguoiDung = ?";

        try (Connection con = DBConnect.getConnection()) {
            con.setAutoCommit(false);
            try {
                try (PreparedStatement psStaff = con.prepareStatement(deleteStaff)) {
                    psStaff.setInt(1, maNhanVien);
                    psStaff.executeUpdate();
                }

                if (maNguoiDung > 0) {
                    try (PreparedStatement psUser = con.prepareStatement(deleteUser)) {
                        psUser.setInt(1, maNguoiDung);
                        psUser.executeUpdate();
                    }
                }

                con.commit();
                return true;
            } catch (Exception ex) {
                con.rollback();
                ex.printStackTrace();
                return false;
            }
        } catch (SQLException e) {
            e.printStackTrace();
            return false;
        }
    }

    public int GetMaNhanVienByEmail(String email) {
        String sql = "SELECT MaNhanVien FROM Staff WHERE Email = ?";
        try (Connection con = DBConnect.getConnection(); PreparedStatement ps = con.prepareStatement(sql)) {
            ps.setString(1, email);
            ResultSet rs = ps.executeQuery();
            if (rs.next()) {
                return rs.getInt("MaNhanVien");
            }
        } catch (Exception e) {
            e.printStackTrace();
        }
        return 0;
    }

    public List<Staff> SearchStaff(String keyword) {
        List<Staff> list = new ArrayList<>();
        // Thêm JOIN với bảng UserGroup để lấy TenNhom và tìm kiếm theo đó
        String sql = "SELECT s.*, u.MaNhom, u.TrangThai, ug.TenNhom FROM Staff s "
                + "LEFT JOIN [User] u ON s.MaNguoiDung = u.MaNguoiDung "
                + "LEFT JOIN UserGroup ug ON u.MaNhom = ug.MaNhom "
                + "WHERE s.HoTen LIKE ? OR CAST(s.MaNhanVien AS VARCHAR) LIKE ? OR ug.TenNhom LIKE ?";

        try (Connection con = DBConnect.getConnection(); PreparedStatement ps = con.prepareStatement(sql)) {
            String query = "%" + keyword + "%";
            ps.setString(1, query);
            ps.setString(2, query);
            ps.setString(3, query); 
            ResultSet rs = ps.executeQuery();

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
                int maNhom = rs.getInt("MaNhom");
                Staff st = new Staff(rs.getInt("MaNhanVien"), rs.getString("HoTen"),
                        rs.getObject("NgaySinh", LocalDate.class), rs.getBoolean("GioiTinh"),
                        rs.getString("SDT"), rs.getString("Email"), rs.getString("DiaChi"),
                        rs.getObject("NgayVaoLam", LocalDate.class), rs.getDouble("Luong"),
                        rs.getInt("MaNguoiDung"), rs.getBoolean("DangKy"));

                st.setMaNhom(rs.getInt("MaNhom"));
                st.setDanhSachQuyen(GetDanhSachQuyen(rs.getInt("MaNhom")));

                list.add(st);
            }
        } catch (SQLException e) {
            e.printStackTrace();
        }
        return list;
    }
}
