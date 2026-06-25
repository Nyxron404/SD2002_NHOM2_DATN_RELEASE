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

    StaffDAO staffDAO = new StaffDAO();
    List<Staff> listStaff = staffDAO.selectStaff();
    UserDAO userDAO = new UserDAO();
    List<User> listUser = userDAO.selectUser();
    
    public int checkEmail(String Email, String MatKhau) {
        for (Staff staff : listStaff) {
            if (Email.equals(staff.getEmail()) && staff.isDangKy() == false) {
                return 1;
            }else if(Email.equals(staff.getEmail()) && staff.isDangKy() == true){
                return 2;
            }
        }
        return 0;
    }
    
    public int checkTenDangKy(String TenDangKy){
        for (User user : listUser) {
            if(TenDangKy.equals(user.getTenDangNhap())){
                return 4;
            }
        }
        return 3;
    }
    
    public int register(String TenDangKy, String Email, String MatKhau) {
        int checkEmail = checkEmail(Email, MatKhau);
        int checkTenDangKy = checkTenDangKy(TenDangKy);
        if(checkEmail == 1 && checkTenDangKy == 3){
            
        }else if(checkEmail == 0 || checkEmail == 2){
            return checkEmail;
        }else{
            return checkTenDangKy;
        }
    }
}
