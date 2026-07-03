package services;

import dao.StaffDAO;
import models.Staff;

public class HrManagerService {

    private StaffDAO staffDAO = new StaffDAO();

    public int AddStaff(Staff st) {
        int checkFormatSDT = CheckFormatSDT(st.getSDT());
        int checkFormatEmail = CheckFormatEmail(st.getEmail());

        // Kiểm tra định dạng SĐT và Email trước
        if (checkFormatSDT == 1 && checkFormatEmail == 1) {
            
            // Gọi DAO check xem Email đã tồn tại trong DB chưa
            int checkEmailExist = staffDAO.CheckEmail(st.getEmail());
            
            if (checkEmailExist == 2) { // 2 nghĩa là Email chưa ai dùng -> An toàn để thêm
                try {
                    staffDAO.InsertStaff(st);
                    return 1; // 1: Thêm nhân viên thành công
                } catch (Exception e) {
                    e.printStackTrace();
                    return 0; // 0: Lỗi hệ thống/SQL Exception
                }
            } else {
                return 4; // 4: Lỗi Email đã tồn tại trong hệ thống
            }
            
        } else if (checkFormatSDT != 1) {
            return checkFormatSDT; // Trả về 2: Lỗi định dạng SĐT
        } else {
            return checkFormatEmail; // Trả về 3: Lỗi định dạng Email
        }
    }

    public int CheckFormatSDT(String SDT) {
        // Regex: Bắt buộc bắt đầu bằng số 0 (^0), theo sau là đúng 9 chữ số ([0-9]{9}$) -> Tổng 10 số
        if (SDT != null && !SDT.trim().isEmpty() && SDT.matches("^0[0-9]{9}$")) {
            return 1; // Hợp lệ
        } else {
            return 2; // Sai định dạng SĐT
        }
    }

    public int CheckFormatEmail(String Email) {
        // Regex kiểm tra cấu trúc email cơ bản
        if (Email != null && !Email.trim().isEmpty() && Email.matches("^[A-Za-z0-9+_.-]+@[A-Za-z0-9.-]+$")) {
            return 1; // Hợp lệ
        } else {
            return 3; // Sai định dạng Email
        }
    }
}