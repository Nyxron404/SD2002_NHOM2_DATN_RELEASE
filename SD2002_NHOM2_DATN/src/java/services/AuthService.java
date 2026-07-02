/*
 * Click nbfs://nbhost/SystemFileSystem/Templates/Licenses/license-default.txt to change this license
 * Click nbfs://nbhost/SystemFileSystem/Templates/Classes/Class.java to edit this template
 */
package services;

import dao.StaffDAO;
import dao.UserDAO;
import java.util.List;
import models.User;

/**
 *
 * @author longd
 */
public class AuthService {

    private StaffDAO staffDAO = new StaffDAO();
    private UserDAO userDAO = new UserDAO();

    public int Register(String TenDangKy, String Email, String MatKhau) {
        int checkFormatTenDangKy = CheckFormatTenTaiKhoan(TenDangKy);
        int checkFormatMatKhau = CheckFormatMatKhau(MatKhau);
        if (checkFormatTenDangKy == 1 && checkFormatMatKhau == 1) {
            int checkEmail = staffDAO.CheckEmail(Email);
            int checkTenDangKy = userDAO.CheckTenDangKy(TenDangKy);
            if (checkEmail == 1 && checkTenDangKy == 1) {
                int checkInsert = userDAO.InsertUser(TenDangKy, MatKhau, Email);
                if(checkInsert == 1){
                    int checkUpdate = userDAO.UpdateMaNguoiDung(checkInsert, TenDangKy, Email);
                    return checkUpdate;
                }else{
                    return checkInsert;
                }
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

    public int CheckFormatTenTaiKhoan(String TenDangKy) {
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
    
    public int CheckLogin(String TenDangNhap, String MatKhau){
        List<User> listUser = userDAO.SelectUser();
        for (User user : listUser) {
            if(user.getTenDangNhap().equals(TenDangNhap) && user.getMatKhau().equals(MatKhau)){
                return 1;
            }
        }
        return 2;
    }
    public List<String> Login(String TenDangNhap, String MatKhau){
        List<String> QuyenHan = userDAO.GetLogin(TenDangNhap, MatKhau);
        return QuyenHan;
    }
}
