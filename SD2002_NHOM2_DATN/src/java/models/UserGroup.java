/*
 * Click nbfs://nbhost/SystemFileSystem/Templates/Licenses/license-default.txt to change this license
 * Click nbfs://nbhost/SystemFileSystem/Templates/Classes/Class.java to edit this template
 */
package models;
import java.time.LocalDateTime;
/**
 *
 * @author longd
 */
public class UserGroup {
    private int MaNhom;
    private String TenNhom;
    private String MoTa;
    private LocalDateTime NgayTao;
    private boolean TrangThai;

    public UserGroup() {
    }

    public UserGroup(int MaNhom, String TenNhom, String MoTa, LocalDateTime NgayTao, boolean TrangThai) {
        this.MaNhom = MaNhom;
        this.TenNhom = TenNhom;
        this.MoTa = MoTa;
        this.NgayTao = NgayTao;
        this.TrangThai = TrangThai;
    }

    public int getMaNhom() {
        return MaNhom;
    }

    public void setMaNhom(int MaNhom) {
        this.MaNhom = MaNhom;
    }

    public String getTenNhom() {
        return TenNhom;
    }

    public void setTenNhom(String TenNhom) {
        this.TenNhom = TenNhom;
    }

    public String getMoTa() {
        return MoTa;
    }

    public void setMoTa(String MoTa) {
        this.MoTa = MoTa;
    }

    public LocalDateTime getNgayTao() {
        return NgayTao;
    }

    public void setNgayTao(LocalDateTime NgayTao) {
        this.NgayTao = NgayTao;
    }

    public boolean isTrangThai() {
        return TrangThai;
    }

    public void setTrangThai(boolean TrangThai) {
        this.TrangThai = TrangThai;
    }
    
}
