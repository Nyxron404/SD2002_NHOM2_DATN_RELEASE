/*
 * Click nbfs://nbhost/SystemFileSystem/Templates/Licenses/license-default.txt to change this license
 * Click nbfs://nbhost/SystemFileSystem/Templates/Classes/Class.java to edit this template
 */
package models;

/**
 *
 * @author longd
 */
public class Permission {
    private int maQuyen;
    private String tenQuyen;
    private String moTa;
    private boolean trangThai;

    public Permission() {
    }

    public Permission(int maQuyen, String tenQuyen, String moTa, boolean trangThai) {
        this.maQuyen = maQuyen;
        this.tenQuyen = tenQuyen;
        this.moTa = moTa;
        this.trangThai = trangThai;
    }

    public int getMaQuyen() {
        return maQuyen;
    }

    public void setMaQuyen(int maQuyen) {
        this.maQuyen = maQuyen;
    }

    public String getTenQuyen() {
        return tenQuyen;
    }

    public void setTenQuyen(String tenQuyen) {
        this.tenQuyen = tenQuyen;
    }

    public String getMoTa() {
        return moTa;
    }

    public void setMoTa(String moTa) {
        this.moTa = moTa;
    }

    public boolean isTrangThai() {
        return trangThai;
    }

    public void setTrangThai(boolean trangThai) {
        this.trangThai = trangThai;
    }
    
}
