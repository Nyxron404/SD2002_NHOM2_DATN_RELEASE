package services;

import dao.StaffDAO;
import models.Staff;

public class HrManagerService {

    private StaffDAO staffDAO = new StaffDAO();

    public int AddStaff(Staff st) {
        int checkFormatSDT = CheckFormatSDT(st.getSDT());
        int checkFormatEmail = CheckFormatEmail(st.getEmail());

        if (checkFormatSDT == 1 && checkFormatEmail == 1) {
            
            int checkEmailExist = staffDAO.CheckEmail(st.getEmail());
            int checkSDTExist = staffDAO.CheckSDT(st.getSDT()); 
            
            if (checkEmailExist == 1) {
                return 4; // Mã 4: Trùng Email
            }
            if (checkSDTExist == 1) {
                return 5; // Mã 5: Trùng SĐT
            }
            
            // Nếu không trùng -> Thêm vào DB và LẤY MÃ NHÂN VIÊN MỚI
            int newMaNhanVien = staffDAO.InsertStaff(st);
            
            if (newMaNhanVien > 0) {
                // TỰ ĐỘNG GÁN QUYỀN MẶC ĐỊNH LÀ CÔNG NHÂN (Mã nhóm = 6)
                staffDAO.CreateDraftUser(newMaNhanVien, 6);
                
                return 1; // Mã 1: Thêm thành công
            } else {
                return 0; // Mã 0: Lỗi DB 
            }
            
        } else if (checkFormatSDT != 1) {
            return 2; // Mã 2: Sai định dạng SĐT
        } else {
            return 3; // Mã 3: Sai định dạng Email
        }
    }

    public int CheckFormatSDT(String SDT) {
        if (SDT != null && !SDT.trim().isEmpty() && SDT.matches("^0[0-9]{9}$")) {
            return 1;
        } else {
            return 2;
        }
    }

    public int CheckFormatEmail(String Email) {
        if (Email != null && !Email.trim().isEmpty() && Email.matches("^[A-Za-z0-9+_.-]+@[A-Za-z0-9.-]+$")) {
            return 1; 
        } else {
            return 3; 
        }
    }
}