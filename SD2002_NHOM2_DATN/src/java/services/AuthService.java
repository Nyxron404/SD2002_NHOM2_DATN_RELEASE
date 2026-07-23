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
                if(checkInsert == 1){
                    int checkUpdate = userDAO.UpdateMaNguoiDung(checkInsert, tenDangKy, email);
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
    
    public int CheckLogin(String tenDangNhap, String matKhau){
        List<User> listUser = userDAO.SelectUser();
        for (User user : listUser) {
            if(user.getTenDangNhap().equals(tenDangNhap) && user.getMatKhau().equals(matKhau)){
                return 1;
            }
        }
        return 2;
    }
    public List<String> Login(String tenDangNhap, String matKhau){
        List<String> quyenHan = userDAO.GetLogin(tenDangNhap, matKhau);
        return quyenHan;
    }
    public int GetMaNguoiDung(String tenDangNhap){
        List<User> listUser =userDAO.SelectUser();
        for (User user : listUser) {
            if(user.getTenDangNhap().equals(tenDangNhap)){
                return user.getMaNguoiDung();
            }
        }
        return 0;
    }
    public int GetMaNhanVien(String tenDangNhap){
        int maNguoiDung = GetMaNguoiDung(tenDangNhap);
        List<Staff> listStaff = staffDAO.SelectStaff();
        for (Staff staff : listStaff) {
            if(staff.getMaNguoiDung() == maNguoiDung){
                return staff.getMaNhanVien();
            }
        }
        return 0;
    }
}
