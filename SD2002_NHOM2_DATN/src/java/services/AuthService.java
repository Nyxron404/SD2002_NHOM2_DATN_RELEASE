/*
 * Click nbfs://nbhost/SystemFileSystem/Templates/Licenses/license-default.txt to change this license
 * Click nbfs://nbhost/SystemFileSystem/Templates/Classes/Class.java to edit this template
 */
package services;

import dao.StaffDAO;
import java.util.List;
import models.Staff;

/**
 *
 * @author longd
 */
public class AuthService {
    public void register(String TenDangKy, String Email, String MatKhau){
        StaffDAO staffDAO = new StaffDAO();
        List<Staff> listStaff = staffDAO.selectStaff();
        for (Staff staff : listStaff) {
            if(Email.equals(staff.getEmail()) && staff.isDangKy() == false){
                
            }
        }
    }
}
