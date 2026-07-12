/*
 * Click nbfs://nbhost/SystemFileSystem/Templates/Licenses/license-default.txt to change this license
 * Click nbfs://nbhost/SystemFileSystem/Templates/Classes/Class.java to edit this template
 */
package models;

/**
 *
 * @author User
 */
public class UserGroupPermission {
    private int MaNhom;
    private int MaQuyen;

    public UserGroupPermission() {
    }

    public UserGroupPermission(int MaNhom, int MaQuyen) {
        this.MaNhom = MaNhom;
        this.MaQuyen = MaQuyen;
    }

    public int getMaNhom() {
        return MaNhom;
    }

    public void setMaNhom(int MaNhom) {
        this.MaNhom = MaNhom;
    }

    public int getMaQuyen() {
        return MaQuyen;
    }

    public void setMaQuyen(int MaQuyen) {
        this.MaQuyen = MaQuyen;
    }
}