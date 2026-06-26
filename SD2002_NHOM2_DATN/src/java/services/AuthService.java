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
        int checkEmail = staffDAO.CheckEmail(Email);
        int checkTenDangKy = userDAO.CheckTenDangKy(TenDangKy);
        if(checkEmail == 1 && checkTenDangKy == 1){
            int checkInsert = userDAO.InsertUser(TenDangKy, MatKhau);
            return checkInsert;
        }else if(checkEmail == 2){
            return checkEmail;
        }else if(checkTenDangKy == 3){
            return checkTenDangKy;
        }else{
            return 0;
        }
    }
}
