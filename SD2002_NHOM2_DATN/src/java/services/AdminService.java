/*
 * Click nbfs://nbhost/SystemFileSystem/Templates/Licenses/license-default.txt to change this license
 * Click nbfs://nbhost/SystemFileSystem/Templates/Classes/Class.java to edit this template
 */
package services;

import dao.UserGroupDAO;
import java.util.List;
import models.UserGroup;

/**
 *
 * @author longd
 */
public class AdminService {
    private UserGroupDAO userGroupDAO = new UserGroupDAO();
    
    public List<UserGroup> GetListUG(){
        List<UserGroup> listUserGroup = userGroupDAO.SelectUserGroups();
        return listUserGroup;
    }
}
