/*
 * Click nbfs://nbhost/SystemFileSystem/Templates/Licenses/license-default.txt to change this license
 * Click nbfs://nbhost/SystemFileSystem/Templates/Classes/Class.java to edit this template
 */
package services;

import dao.StaffDAO;
import dao.UserDAO;
import java.util.List;
import models.Staff;
import models.User;

/**
 *
 * @author longd
 */
public class AuthService {

    private StaffDAO staffDAO = new StaffDAO();
    private UserDAO userDAO = new UserDAO();

    public int Register(String tenDangKy, String email, String matKhau) {
        int checkFormatTenDangKy = CheckFormatTenTaiKhoan(tenDangKy);
        int checkFormatMatKhau = CheckFormatMatKhau(matKhau);
        if (checkFormatTenDangKy == 1 && checkFormatMatKhau == 1) {
            int checkEmail = staffDAO.CheckEmail(email);
            int checkTenDangKy = userDAO.CheckTenDangKy(tenDangKy);
            if (checkEmail == 1 && checkTenDangKy == 1) {
                int checkInsert = userDAO.InsertUser(tenDangKy, matKhau, email);
                if (checkInsert == 1) {
                    int checkUpdate = userDAO.UpdateMaNguoiDung(checkInsert, tenDangKy, email);
                    return checkUpdate;
                } else {
                    return checkInsert;
                }
            } else if (checkEmail == 2) {
                return checkEmail;
            } else if (checkTenDangKy == 3) {
                return checkTenDangKy;
            } else {
                return 0;
            }
        } else if (checkFormatTenDangKy == 4) {
            return checkFormatTenDangKy;
        } else {
            return checkFormatMatKhau;
        }
    }

    public int CheckFormatTenTaiKhoan(String tenDangKy) {
        if (tenDangKy != null && !tenDangKy.trim().isEmpty() && tenDangKy.matches("^[A-Za-z0-9]+$")) {
            return 1;
        } else {
            return 4;
        }
    }

    public int CheckFormatMatKhau(String matKhau) {
        if (matKhau != null && !matKhau.trim().isEmpty() && matKhau.matches("^[A-Za-z0-9!@#$%^&*()_+\\-=\\[\\]{};:',.<>/?\\\\|]{8,}$")) {
            return 1;
        } else {
            return 5;
        }
    }

    public int CheckLogin(String tenDangNhap, String matKhau) {
        List<User> listUser = userDAO.SelectUser();
        for (User user : listUser) {
            if (user.getTenDangNhap().equals(tenDangNhap) && user.getMatKhau().equals(matKhau)) {
                return 1;
            }
        }
        return 2;
    }

    public List<String> Login(String tenDangNhap, String matKhau) {
        List<String> quyenHan = userDAO.GetLogin(tenDangNhap, matKhau);
        return quyenHan;
    }

    public int GetMaNguoiDung(String tenDangNhap) {
        List<User> listUser = userDAO.SelectUser();
        for (User user : listUser) {
            if (user.getTenDangNhap().equals(tenDangNhap)) {
                return user.getMaNguoiDung();
            }
        }
        return 0;
    }

    public int GetMaNhanVien(String tenDangNhap) {
        int maNguoiDung = GetMaNguoiDung(tenDangNhap);
        List<Staff> listStaff = staffDAO.SelectStaff();
        for (Staff staff : listStaff) {
            if (staff.getMaNguoiDung() == maNguoiDung) {
                return staff.getMaNhanVien();
            }
        }
        return 0;
    }

    // Kiểm tra xem TenDangNhap và Email có thuộc về cùng 1 người không
    public int checkUserEmailMatch(String tenDangNhap, String email) {
        List<User> users = userDAO.SelectUser();
        int targetUserId = -1;
        for (User u : users) {
            if (u.getTenDangNhap().equals(tenDangNhap)) {
                targetUserId = u.getMaNguoiDung();
                break;
            }
        }
        if (targetUserId == -1) {
            return -1;
        }

        List<Staff> staffs = staffDAO.SelectStaff();
        for (Staff s : staffs) {
            if (s.getMaNguoiDung() == targetUserId && s.getEmail().equals(email)) {
                return targetUserId;
            }
        }
        return -1;
    }

    // Tạo mã OTP Random 6 số và gửi qua Email
    public String generateAndSendOTP(String toEmail) {
        java.util.Random rnd = new java.util.Random();
        int number = 100000 + rnd.nextInt(900000);
        String otp = String.valueOf(number);

        final String fromEmail = "smartfarmmanage@gmail.com";
        final String appPassword = "grxhduafxftczxjm";

        java.util.Properties props = new java.util.Properties();
        props.put("mail.smtp.host", "smtp.gmail.com");
        props.put("mail.smtp.port", "587");
        props.put("mail.smtp.auth", "true");
        props.put("mail.smtp.starttls.enable", "true");

        jakarta.mail.Session session = jakarta.mail.Session.getInstance(props, new jakarta.mail.Authenticator() {
            @Override
            protected jakarta.mail.PasswordAuthentication getPasswordAuthentication() {
                return new jakarta.mail.PasswordAuthentication(fromEmail, appPassword);
            }
        });

        try {
            jakarta.mail.Message message = new jakarta.mail.internet.MimeMessage(session);
            message.setFrom(new jakarta.mail.internet.InternetAddress(fromEmail));
            message.setRecipients(jakarta.mail.Message.RecipientType.TO, jakarta.mail.internet.InternetAddress.parse(toEmail));
            message.setSubject("MÃ OTP KHÔI PHỤC MẬT KHẨU - SMART FARM");

            String noiDungHtml = "<div style='font-family: Arial, sans-serif; line-height: 1.6; color: #333;'>"
                    + "<h2 style='color: #2e7d32;'>Yêu cầu khôi phục mật khẩu</h2>"
                    + "<p>Chào bạn,</p>"
                    + "<p>Chúng tôi nhận được yêu cầu đặt lại mật khẩu cho tài khoản của bạn. Vui lòng sử dụng mã OTP gồm 6 chữ số dưới đây để tiếp tục:</p>"
                    + "<div style='background-color: #f9f9f9; padding: 15px; border-left: 5px solid #e74c3c; border-radius: 5px; font-size: 26px; font-weight: bold; letter-spacing: 10px; color: #e74c3c; text-align: center; margin: 20px 0;'>"
                    + otp
                    + "</div>"
                    + "<p style='color: #c0392b;'><strong>⚠️ Lưu ý bảo mật:</strong> Tuyệt đối không chia sẻ mã này với bất kỳ ai.</p>"
                    + "<p>Trân trọng,<br><b>Ban Quản Trị Smart Farm</b></p>"
                    + "</div>";

            message.setContent(noiDungHtml, "text/html; charset=UTF-8");
            jakarta.mail.Transport.send(message);
        } catch (Exception e) {
            e.printStackTrace();
        }
        return otp;
    }

    // Đổi mật khẩu mới
    public boolean updatePassword(int userId, String newPassword) {
        return userDAO.UpdatePassword(userId, newPassword);
    }
}
