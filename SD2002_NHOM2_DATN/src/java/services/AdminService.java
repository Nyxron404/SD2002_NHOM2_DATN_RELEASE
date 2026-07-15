/*
 * Click nbfs://nbhost/SystemFileSystem/Templates/Licenses/license-default.txt to change this license
 * Click nbfs://nbhost/SystemFileSystem/Templates/Classes/Class.java to edit this template
 */
package services;

import dao.PermissionDAO;
import dao.UserGroupDAO;
import dao.UserGroupPermissionDAO;
import java.util.List;
import models.Permission;
import models.UserGroup;

/**
 *
 * @author longd
 */
public class AdminService {
    private UserGroupDAO userGroupDAO = new UserGroupDAO();
    private PermissionDAO permissionDAO = new PermissionDAO();
    private UserGroupPermissionDAO userGroupPermissionDAO = new UserGroupPermissionDAO();
    public List<UserGroup> GetListUG(){
        List<UserGroup> listUserGroup = userGroupDAO.SelectUserGroups();
        return listUserGroup;
    }
    public List<Permission> GetListPS(){
        List<Permission> listPermission = permissionDAO.SelectPermission();
        return listPermission;
    }
    public int AddUG(String tenNhom, List<Integer> listMaQuyen, String moTa){
        int checkTenNhom = CheckTenNhom(tenNhom);
        if(checkTenNhom == 1){
            int checkInsertUG = userGroupDAO.InsertUG(tenNhom, moTa);
            int checkInsertUGPS = userGroupPermissionDAO.InsertUGPS(tenNhom, listMaQuyen);
            if(checkInsertUG == 1 && checkInsertUGPS == 1){
                return 1;
            }
            return 0;
        }else{
            return 2;
        }
    }
    public int CheckTenNhom(String tenNhom){
        List<UserGroup> listUserGroup = userGroupDAO.SelectUserGroups();
        for (UserGroup userGroup : listUserGroup) {
            if(userGroup.getTenNhom().equalsIgnoreCase(tenNhom)){
                return 0;
            }
        }
        return 1;
    }
}
