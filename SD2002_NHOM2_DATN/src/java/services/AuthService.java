/*
 * Click nbfs://nbhost/SystemFileSystem/Templates/Licenses/license-default.txt to change this license
 * Click nbfs://nbhost/SystemFileSystem/Templates/Classes/Class.java to edit this template
 */
package services;

import dao.StaffDAO;
import dao.UserDAO;

/**
 *
 * @author longd
 */
public class AuthService {

    private StaffDAO staffDAO = new StaffDAO();
    private UserDAO userDAO = new UserDAO();

    public int Register(String TenDangKy, String Email, String MatKhau) {
        int checkFormatTenDangKy = CheckFormatTenDangKy(TenDangKy);
        int checkFormatMatKhau = CheckFormatMatKhau(MatKhau);
        if (checkFormatTenDangKy == 1 && checkFormatMatKhau == 1) {
            int checkEmail = staffDAO.CheckEmail(Email);
            int checkTenDangKy = userDAO.CheckTenDangKy(TenDangKy);
            if (checkEmail == 1 && checkTenDangKy == 1) {
                int checkInsert = userDAO.InsertUser(TenDangKy, MatKhau);
                return checkInsert;
            } else if (checkEmail == 2) {
                return checkEmail;
            } else if (checkTenDangKy == 3) {
                return checkTenDangKy;
            } else {
                return 0;
            }
        }else if(checkFormatTenDangKy == 4){
            return checkFormatTenDangKy;
        }else{
            return checkFormatMatKhau;
        }
    }

    public int CheckFormatTenDangKy(String TenDangKy) {
        if (TenDangKy != null && !TenDangKy.trim().isEmpty() && TenDangKy.matches("^[A-Za-z0-9]+$")) {
            return 1;
        } else {
            return 4;
        }
    }

    public int CheckFormatMatKhau(String MatKhau) {
        if (MatKhau != null && !MatKhau.trim().isEmpty() && MatKhau.matches("^[A-Za-z0-9!@#$%^&*()_+\\-=\\[\\]{};:',.<>/?\\\\|]{8,}$")) {
            return 1;
        } else {
            return 5;
        }
    }
}
